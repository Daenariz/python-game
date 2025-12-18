import pygame

pygame.init()

font20 = pygame.font.Font('freesansbold.ttf',20)

BLACK = (0,0,0)
WHITE = (255,255,255)
GREEN = (0,255,0)

WIDTH, HEIGHT = 900, 600
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Pong")
clock = pygame.time.Clock()
FPS = 30
pygame.display.update()
clock.tick(FPS)

running = True

while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
