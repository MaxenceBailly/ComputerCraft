import mido


midi_notes = {
    0: "C", 1: "C#", 2: "D", 3: "D#", 4: "E", 5: "F", 6: "F#", 7: "G", 8: "G#", 9: "A", 10: "A#", 11: "B",
    12: "C", 13: "C#", 14: "D", 15: "D#", 16: "E", 17: "F", 18: "F#", 19: "G", 20: "G#", 21: "A", 22: "A#", 23: "B",
    24: "C", 25: "C#", 26: "D", 27: "D#", 28: "E", 29: "F", 30: "F#", 31: "G", 32: "G#", 33: "A", 34: "A#", 35: "B",
    36: "C", 37: "C#", 38: "D", 39: "D#", 40: "E", 41: "F", 42: "F#", 43: "G", 44: "G#", 45: "A", 46: "A#", 47: "B",
    48: "C", 49: "C#", 50: "D", 51: "D#", 52: "E", 53: "F", 54: "F#", 55: "G", 56: "G#", 57: "A", 58: "A#", 59: "B",
    60: "C", 61: "C#", 62: "D", 63: "D#", 64: "E", 65: "F", 66: "F#", 67: "G", 68: "G#", 69: "A", 70: "A#", 71: "B",
    72: "C", 73: "C#", 74: "D", 75: "D#", 76: "E", 77: "F", 78: "F#", 79: "G", 80: "G#", 81: "A", 82: "A#", 83: "B",
    84: "C", 85: "C#", 86: "D", 87: "D#", 88: "E", 89: "F", 90: "F#", 91: "G", 92: "G#", 93: "A", 94: "A#", 95: "B",
    96: "C", 97: "C#", 98: "D", 99: "D#", 100: "E", 101: "F", 102: "F", 103: "G", 104: "G#", 105: "A", 106: "A#", 107: "B",
    108: "C", 109: "C#", 110: "D", 111: "D#", 112: "E", 113: "F", 114: "F#", 115: "G", 116: "G#", 117: "A", 118: "A#", 119: "B",
    120: "C", 121: "C#", 122: "D", 123: "D#", 124: "E", 125: "F", 126: "F#", 127: "G"
}

mc_list_notes = {"F#": [0, 12, 24], "G": [1, 13], "G#": [2, 14], "A": [3, 15], "A#": [4, 16],
                "B": [5, 17], "C": [6, 18], "C#": [7, 19], "D": [8, 20], "D#": [9, 21], "E": [10, 22],
                "F": [11, 23]}

percussion = {
    35: 'basedrum', 36: 'basedrum', 37: 'hat', 38: 'snare', 39: 'snare',
    40: 'snare', 41: 'basedrum', 42: 'hat', 43: 'basedrum', 44: 'hat', 45: 'basedrum', 46: 'hat',  47: 'basedrum', 48: 'basedrum', 49: 'snare',
    50: 'basedrum', 51: 'snare', 52: 'snare', 53: 'snare', 54: 'snare', 55: 'snare', 56: 'cow_bell', 57: 'snare', 58: 'hat', 59: 'snare',
    60: 'basedrum', 61: 'basedrum', 62: 'basedrum', 63: 'basedrum', 64: 'basedrum', 65: 'snare', 66: 'snare', 67: 'bell', 68: 'bell', 69: 'hat',
    72: 'flute', 77: 'cow_bell',
    82: 'cow_bell'
}

not_percussion = {
    0: 'harp', 1:'harp',
    27: 'guitar', 28:'guitar', 29:'guitar', 30: 'guitar', 31: 'guitar', 32: 'bass', 33: 'harp',
    40: 'guitar', 48: 'harp',
    52: 'flute',
    68: 'flute',
    80: 'harp', 81: 'harp', 82: 'harp', 87: 'harp'
}

def get_instrument(msg, program):
    if msg.channel == 9 and msg.type == 'note_on':
        return percussion.get(msg.note, None)
    return not_percussion.get(program, None)

def midi_to_minecraft(midi_note, threshold):
    return min(mc_list_notes[midi_notes[midi_note]]) if midi_note <= threshold else max(mc_list_notes[midi_notes[midi_note]])

def convert_to_minecraft_notes(filename, output_file):
    notes_by_time = {}
    mid = mido.MidiFile(filename)
    
    duree = mid.length

    current_time = 0
    error = False

    program = None
    for msg in mid.play():
        if msg.type == 'program_change':
            program = msg.program
        elif msg.type == 'note_on':
            time = round(current_time, 2)

            print(f"Lecture de {filename} à {round(time*100/duree, 2)}%", end='\r')


            instrument = get_instrument(msg, program)
            if instrument == None:
                print(f"note : {msg.note}, program : {program}, channel : {msg.channel} not found at time {time}                      ")
                error = True
                break
            
            note = ((midi_to_minecraft(msg.note, 65)), instrument)
            if time in notes_by_time:
                if not note in notes_by_time[time]:
                    notes_by_time[time].append(note)
            else:
                notes_by_time[time] = [note]
        current_time += msg.time

    if not error:
        print(f"Lecture terminé de {filename}        ")
        print('Ecriture en cours...', end='\r')

        with open(output_file, 'w') as file:
            for time, notes in sorted(notes_by_time.items()):
                notes_str = ",".join([f"({note[1]}, {note[0]})" for note in notes])
                file.write(f"{time},[{notes_str}]\n")
        print('Ecriture terminé')
        __import__('winsound').Beep(1500, 500)

if __name__ == "__main__":
    to_convert = "megalovania.mid"
    convert_to_minecraft_notes(f"music/mid/{to_convert}", f"music/all/{to_convert.replace('.mid', '')}.txt")