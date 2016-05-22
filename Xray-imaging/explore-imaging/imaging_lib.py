from astropy import  wcs
import numpy as np

def hdrfromevt(hdr,col1,col2,Xcolnum,Ycolnum):
    """
    Read an XMM event list and get the corresponding keywords
    for column col1,col2 (e.g. X,Y)
    then creates a standard header with CRVAL, CRPIX, etc
    instead of TCRPX6, TCDLT6, etc
    Need to provide the column number wher X and Y columns are found.
    Automatic matching not currently working.
    """
    #Get the number of the column containing the X, Y columns
    # colvals=hdr.values()
    # Xcol_idx=colvals.index(col1)
    # Xcolnum=(hdr.keys()[Xcol_idx]).replace('TTYPE','')
    # Ycol_idx=colvals.index(col2)
    # Ycolnum=(hdr.keys()[Ycol_idx]).replace('TTYPE','')
    #WARNING automatic Xcolumn finding is not working properly. Need a way to search for X value in TTYPE. There are several 'X' in hdr
    #Xcolnum='6' ; Ycolnum='7'
    # Create a new WCS object from the keywords corresponding to the column X,Y
    Xcolnum=str(Xcolnum) ; Ycolnum=str(Ycolnum)

    w = wcs.WCS(naxis=2)
    w.wcs.crpix = [hdr['TCRPX'+Xcolnum], hdr['TCRPX'+Ycolnum]]
    w.wcs.cdelt = [hdr['TCDLT'+Xcolnum], hdr['TCDLT'+Ycolnum]]
    w.wcs.crval = [hdr['TCRVL'+Xcolnum], hdr['TCRVL'+Ycolnum]]
    w.wcs.ctype = [hdr['TCTYP'+Xcolnum], hdr['TCTYP'+Ycolnum]]

    # write the HDU object WITH THE HEADER
    hdr2 = w.to_header()
    #print w.printwcs()
    return hdr2

def dist_circle(nx,ny,xcen,ycen):
    " Create a 2D numpy array where each value is its distance to a given center. "
    import numpy as np
    mask=np.zeros([nx,ny])
    x = np.linspace(0, nx-1, nx)
    y = np.linspace(0, ny-1, ny)
    x,y = np.meshgrid(x, y)
    x,y = x.transpose(), y.transpose()
    xcen, ycen = ycen, xcen #transpose centers well

    mask = np.sqrt((x-xcen)**2 + (y-ycen)**2 )
    return mask
    
def ds9box(regfile):
    """
    Reads in a ds9 box region file in ds9 format and coord in degrees.
    Returns the values : xc, yc, length, thick, angle in degrees
    """
    f1 = open (regfile, "r")
    text = f1.read()
    box_ =  text.split('box')

    box = (box_[1].split(' #') )[0] #in case there are ds9 comments
    xc, yc, length, thick, angle = box.replace('(','').replace(')','').replace('"','').split(',')

    print 'ds9 region file: ', regfile
    print 'Coordinates read: ', float(xc), float(yc), float(length)/3600, float(thick)/3600, float(angle)
    print

    return float(xc), float(yc), float(length)/3600, float(thick)/3600, float(angle)
