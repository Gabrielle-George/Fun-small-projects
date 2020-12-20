from graphics import *
import numpy as np
from numpy.random import choice
import matplotlib.pyplot as plt

debug = True


#upper_left is a Point
def draw_Pixel(Pix_coord, win, color, width):
    upper_left = Pixel_to_Point(Pix_coord, width)
    lower_right = Point(upper_left.x +width , upper_left.y + width)
    r = Rectangle(upper_left, lower_right)
    r.setFill(color)
    r.draw(win)

#transforms the upper-right Point in raw space 
#to a corrdinagte in Pixel space
#Pixel_corrd is a Point representing its location in the backing matrix
def Pixel_to_Point(Pixel_coord, pixel_width):
    return Point(Pixel_coord.getX()*pixel_width, Pixel_coord.getY()*pixel_width)



#pixel_space_y is the "y" coordinagte transformed to 
#Pixel space rather than point space
def draw_matrix(M, win, width=50, color_dict = {0:"white", 1:"black"}):
    M = [[color_dict[M[y][x]] for x in range(len(M[y]))] for y in range(len(M))] 
    for y in range(len(M)):
        for x in range(len(M[y])):
            draw_Pixel(Point(x,y), win, M[y][x], width)

def rule_110(x_len, y_len, color_dict = {0:"white", 1:"black"}, color_proba = None, start = None):
    if not color_proba:
        color_proba = [1/len(color_dict.keys())]*len(color_dict.keys())
    M=np.zeros((y_len,x_len))

    if not start:
        M[0] = list(choice(list(color_dict.keys()), x_len,color_proba) )
    else:
        M[0] = start
    #M[0] = [0]*(x_len-2) + [1]*2
    #this throws an error for 1D arrays

    rule_110 = {(1,1,1): 0,
                (1,1,0): 1,
                (1,0,1): 1,
                (1,0,0): 0,
                (0,1,1): 1,
                (0,1,0): 1,
                (0,0,1): 1, 
                (0,0,0): 0}

                #1101110


    for i in range(y_len-1):
        for j in range(x_len-1):

            next_val = 0

            #TODO: handle the wraparound
            M_flat = np.reshape(M,-1)

            cur_window = M_flat[i*x_len+j], M_flat[i*x_len+j+1], M_flat[i*x_len+j+2]
            #TODO: improve this
            next_val =  rule_110[cur_window]

            M[i+1][j+1] = next_val
    return M

def draw_automata():

    #plt.imshow(np.array(rule_110(60, 100)))
    
    win = GraphWin("Rule 110", 1000, 1000)
    width= 20
    M = np.array([[0,1,0],
     [0,0,1],
     [1,1,1]])


    draw_matrix(rule_110(60, 100),win, width = 8)
 
    
    #start = [0,1,1,0,0]*12
    
    win.getMouse() # Pause to view result
    win.close()    # Close window when done

    #returns a x_len, y_len matrix of 0s and 1s resulting from a randomized first row and rule 110



def main():
    #draw_Pixel(40,Point(50,50))
    draw_automata()


main()








