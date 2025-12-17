import pygame
import sys

# Initialisierung
pygame.init()

# Farben
WHITE = (255, 255, 255)
BLUE = (0, 100, 255)

# Fenster erstellen (640x480)
screen = pygame.display.set_mode((640, 480))
pygame.display.set_caption("Unser erstes Spiel - NixOS & WSL Test")

clock = pygame.time.Clock()

print("Spiel gestartet! Drücke ESC oder schließe das Fenster zum Beenden.")

running = True
while running:
    # Event Loop (Eingaben verarbeiten)
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                running = False

    # Hintergrund füllen
    screen.fill(WHITE)

    # Ein blaues Rechteck zeichnen (Test für Grafik)
    pygame.draw.rect(screen, BLUE, pygame.Rect(270, 190, 100, 100))

    # Display aktualisieren
    pygame.display.flip()
    
    # 60 FPS
    clock.tick(60)

pygame.quit()
sys.exit()
