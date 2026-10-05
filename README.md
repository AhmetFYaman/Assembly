# Assembly projects

Small programs I wrote while learning MIPS assembly. The turn-based game is the largest one; the others are shorter exercises in input, arithmetic, and branching.

## Projects

- [Turn-Based RPG](Assembly%20Projects/Turn%20Based%20RPG): a text game where you choose to attack or heal while fighting three monsters. Health and attack values use random numbers.
- [Guessing game](Assembly%20Projects/Simple%20Guessing%20Game%20from%20C%2B%2B): a small guessing-game exercise translated into assembly.
- [Triple subtraction](Assembly%20Projects/Simple%20Triple%20Subtraction): arithmetic and input/output practice.

## Running them

These are MIPS programs, not executables for a normal Windows or macOS terminal. Open an `.asm` file in the MARS MIPS simulator, assemble it, and run it using the simulator's console.

Start with `Assembly Projects/Turn Based RPG/mips1.asm` for the game. It uses MARS-specific random-number syscalls, so another simulator may need changes. The PDF in that folder contains the original project notes.

Each folder is a separate exercise. There is no shared build or extra package setup.
