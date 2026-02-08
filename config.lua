Config = {}

---------------------------------
-- ITEM SETTINGS
---------------------------------
Config.ItemName = 'ouijaboard'
---------------------------------
-- COOLDOWN SETTINGS
---------------------------------
Config.Cooldown = {
    enabled = true,
    duration = 600, -- Cooldown in seconds (600 = 10 minutes)
}
---------------------------------
-- SÉANCE SETTINGS
---------------------------------
Config.SeanceDuration = 120000 -- Total séance time in ms (2 minutes)
Config.FreezePlayer = false
Config.CanBeDamaged = false

-- Nearby players within this radius will also experience the séance
Config.GroupSeanceRadius = 20.0
Config.EnableGroupSeance = true

---------------------------------
-- TIMING SETTINGS
---------------------------------
Config.Timing = {
    initialDelay = 5000, -- Delay before spirit contact begins
    messageDuration = 18000, -- How long each spirit message displays
    pauseBetweenMessages = 4000, -- Silence between messages
    flickerDuringMessage = false, -- Lights flicker when spirit speaks
}

---------------------------------
-- ANIMATION SETTINGS (FIXED)
---------------------------------
Config.Animation = {
    dict = 'amb_camp@world_camp_fire_sit_ground@male_c@idle_a',
    anim = 'idle_b', 
    flag = 1,
    blendIn = 8.0,
    blendOut = -8.0
}

---------------------------------
-- LIGHT FLICKER SETTINGS
---------------------------------
Config.Flicker = {
    enabled = true,
    onStart = false, 
    onSpiritSpeak = false, 
    onEnd = true, 
    
    
    patterns = {
        gentle = { {1500, 1300}, {1500, 1300}, {1000, 1500} },
        aggressive = { {1500, 1300}, {1500, 1300}, {1000, 1500} },
        chaotic = { {1500, 1300}, {1500, 1300}, {1000, 1500} },
        slow = { {1500, 1300}, {1500, 1300}, {1000, 1500} },
        rapid = { {1500, 1300}, {1500, 1300}, {1000, 1500} }
    }
}


Config.Effects = {
    useTimecycle = true,
    defaultTimecycle = 'NG_filmic15',  
    defaultStrength = 0.5
}

---------------------------------
-- WEATHER SETTINGS
---------------------------------
Config.Weather = {
    enabled = true,
    type = 'thunderstorm',
    useWeatherSync = true,
    restoreAfter = true,
    setDuringContact = true,
    transitionDelay = 2000,
    
    changeTime = false,  
}


Config.SpiritEffects = {
    friendly = {
        timecycle = 'NG_filmic03',
        strength = 0.5,
        flickerPattern = 'gentle'
    },
    angry = {
        timecycle = 'NG_filmic25',
        strength = 0.8,
        flickerPattern = 'aggressive'
    },
    trickster = {
        timecycle = 'NG_filmic21',
        strength = 0.6,
        flickerPattern = 'chaotic'
    },
    mysterious = {
        timecycle = 'NG_filmic10',
        strength = 0.5,
        flickerPattern = 'slow'
    },
    prophetic = {
        timecycle = 'NG_filmic02',
        strength = 0.4,
        flickerPattern = 'gentle'
    },
    demonic = {
        timecycle = 'NG_filmic25',
        strength = 1.0,
        flickerPattern = 'chaotic'
    },
    child = {
        timecycle = 'NG_filmic05',
        strength = 0.3,
        flickerPattern = 'gentle'
    },
    ancient = {
        timecycle = 'NG_filmic15',
        strength = 0.6,
        flickerPattern = 'slow'
    }
}

---------------------------------
-- CANCEL SETTINGS
---------------------------------
Config.AllowCancel = true
Config.CancelKey = 0x156F7119 -- Backspace
Config.MinTimeBeforeCancel = 20000

---------------------------------
-- MESSAGES
---------------------------------
Config.Messages = {
    -- Starting séance
    preparing = 'You place the Ouija board on the ground...',
    lighting = 'You light the candles around the board...',
    beginning = 'You place your fingers on the planchette...',
    calling = 'You call out to the spirits...',
    
    -- Spirit contact
    presence = 'You feel a presence in the room...',
    contact = 'Something is here...',
    speaking = 'The spirit begins to communicate...',
    
    -- Ending
    spiritLeaves = 'The presence begins to fade...',
    seanceEnd = 'The candles flicker out... The séance has ended.',
    forcedEnd = 'You break the connection abruptly.',
    
    -- Warnings
    alreadyInSeance = 'You are already conducting a séance!',
    cannotHere = 'This place does not feel right for a séance...',
    
    -- Cancel
    cancelHint = 'Press BACKSPACE to end the séance early',
    
    -- Transitions
    spiritChanges = 'The presence shifts... Something else is here now...',
    interference = 'Static fills your mind... The connection wavers...'
}

---------------------------------
-- NOTIFICATION SETTINGS
---------------------------------
Config.Notification = {
    title = '🔮 Séance',
    spiritTitle = '👻 Spirit',
    position = 'top',
    
    icons = {
        board = 'book-skull',
        candle = 'fire',
        spirit = 'ghost',
        warning = 'triangle-exclamation',
        end_icon = 'circle-xmark',
        contact = 'comment-dots'
    },
    
    colors = {
        board = '#4a4a4a',
        candle = '#f39c12',
        spirit = '#9b59b6',
        warning = '#e74c3c',
        end_icon = '#7f8c8d',
        contact = '#3498db'
    }
}

---------------------------------
-- GLOBAL NOTIFICATION SETTINGS
---------------------------------
Config.GlobalNotification = {
    enabled = true,
    onStart = true,
    onEnd = true,
    
    messages = {
        start = 'A dark presence stirs... Someone has opened a portal to the spirit world.',
        ended = 'The veil between worlds has closed once more...',
    },
    
    icon = 'ghost',
    iconColor = '#8b0000',
    duration = 8000,
    title = '🌙 The Spirit World',
}

---------------------------------
-- SPIRIT TYPES AND MESSAGES
---------------------------------
Config.Spirits = {
    ---------------------------------
    -- FRIENDLY SPIRITS
    ---------------------------------
    {
        name = 'Elizabeth',
        type = 'friendly',
        title = '👻  - A Gentle Soul',
        icon = 'heart',
        iconColor = '#e91e63',
        introduction = 'A warmth spreads through the room as the planchette begins to move with surprising gentleness... You sense a feminine presence, soft and sorrowful, reaching across the veil with delicate fingers of light... She means you no harm... She simply wishes to be remembered...',
        messages = {
            'The planchette glides slowly across the board... "I... have... waited... so... long..." The words form with patient deliberation, each letter chosen with care... You feel a profound sadness wash over you, not threatening, but achingly human... This spirit carries the weight of years spent in silence, desperate to speak to anyone who would listen...',
            'A gentle breeze stirs the candle flames, though no window is open... "My... children... did... they... live... good... lives?" The question hangs in the air like morning mist... You sense this spirit has been trapped between worlds, unable to move on without knowing the fate of those she loved... Her concern for them transcends even death itself...',
            'The temperature drops slightly, but it feels more like a cool embrace than a threatening chill... "Tell... them... I... never... left... I... watched... them... grow..." Tears prick at your eyes though you cannot say why... This spirit has spent decades as a silent guardian, unable to touch or speak to the children who became adults who became elderly who became spirits themselves...',
            'The planchette moves to spell out a name... someone you know, or perhaps will know... "Protect... them... danger... comes... with... the... spring... thaw..." A warning given with love, not malice... Elizabeth uses her limited strength to shield the living from harm she can sense but not prevent... Her love persists beyond the grave...',
            'The presence begins to fade, but not before one final message... "Thank... you... for... listening... I... can... rest... now..." The candles flare briefly with warm, golden light... You have given this spirit something precious - acknowledgment, connection, peace... As she departs, you feel lighter somehow, as if her gratitude has blessed you...'
        }
    },
    {
        name = 'Thomas',
        type = 'friendly',
        title = '👻  - The Helpful Guide',
        icon = 'hand-holding-heart',
        iconColor = '#4caf50',
        introduction = 'The planchette begins to move with purposeful, steady motions... You sense an older presence, weathered by time but wise beyond measure... This spirit does not seek anything for itself... It has remained to guide those who seek answers in the darkness between worlds...',
        messages = {
            'The board trembles slightly as letters form with practiced ease... "I... was... a... preacher... in... life... I... guide... lost... souls... still..." The presence feels ancient yet kind, like a grandfather speaking to children gathered at his feet... He has helped countless spirits find their way to the light, and now he offers to help you...',
            '"You... carry... guilt... that... is... not... yours... to... carry..." The words strike deep, touching something you have long tried to bury... This spirit sees into your soul with compassion, not judgment... "Forgive... yourself... as... God... forgives... all..." The advice is simple but profound, offered freely without expectation...',
            'The candles burn steadier now, as if Thomas\' presence brings order to the chaos between worlds... "There... is... one... who... waits... for... you... beyond... when... your... time... comes... they... will... be... first... to... greet... you..." A loved one, long departed, has not moved on completely... They linger near the light, waiting to welcome you home when your journey ends...',
            '"The... path... you... consider... leads... to... sorrow... but... also... to... growth..." Thomas does not tell you what to do, only illuminates what lies ahead... "Choose... with... your... heart... the... mind... deceives... but... the... heart... knows... truth..." His wisdom feels earned through centuries of watching the living stumble and rise...',
            'The presence begins to withdraw, but leaves behind a warmth that persists... "I... must... guide... others... now... but... call... again... and... I... will... answer..." Thomas is not gone, merely attending to his eternal duty... The veil between worlds feels thinner now, less frightening... You have made a friend in the afterlife...'
        }
    },
    ---------------------------------
    -- ANGRY SPIRITS
    ---------------------------------
    {
        name = 'Cornelius',
        type = 'angry',
        title = '💀 Cornelius - The Betrayed',
        icon = 'skull',
        iconColor = '#e74c3c',
        introduction = 'The temperature plummets so suddenly you can see your breath... The planchette SLAMS to the letters with violent force, nearly flying off the board... Something terrible has answered your call... Something that remembers every wrong done to it in life, and has had eternity to nurture its rage...',
        messages = {
            'The planchette moves with furious speed, spelling out words faster than you can read... "THEY... BURIED... ME... ALIVE... MY... PARTNERS... MY... FRIENDS... FOR... GOLD... FOR... WORTHLESS... GOLD..." The candles flare red for a moment, and you feel hands around your throat that aren\'t there... This spirit\'s rage is a physical force that threatens to overwhelm you...',
            '"I... FELT... THE... DIRT... FILL... MY... MOUTH... HEARD... THEIR... LAUGHTER... ABOVE..." The board shakes violently, and you struggle to maintain contact... "THIRTY... YEARS... I... SCREAMED... IN... THE... DARKNESS... NO... ONE... CAME..." His suffering is unimaginable, his fury entirely justified... But fury this intense threatens everything it touches...',
            'Blood seems to seep from the edges of the board, though when you blink it vanishes... "THEIR... DESCENDANTS... STILL... LIVE... STILL... SPEND... MY... GOLD... STILL... LAUGH..." The spirit\'s focus shifts from you to something distant, something it has watched for generations... "THEY... WILL... KNOW... MY... PAIN... I... WILL... TEACH... THEM..."',
            '"YOU... DISTURBED... MY... TORMENT... NOW... YOU... ARE... PART... OF... IT..." The candles go out entirely, plunging you into darkness... For a moment you feel the crushing weight of earth on your chest, dirt in your lungs, the horror of being buried alive... Then the vision passes, leaving you gasping... This spirit wants you to understand, to share its eternal nightmare...',
            'The presence does not fade gently - it TEARS away, leaving scratches on your soul... "I... WILL... REMEMBER... YOU... WHEN... YOUR... TIME... COMES... WE... WILL... SPEAK... AGAIN... IN... THE... DARK..." The candles relight with normal flames, but you know something has marked you... Cornelius will wait... Cornelius has nothing but time...'
        }
    },
    {
        name = 'Mary',
        type = 'angry',
        title = '💀 The Wronged spirit',
        icon = 'fire',
        iconColor = '#ff5722',
        introduction = 'A woman\'s scream echoes from nowhere and everywhere at once... The planchette spins wildly before settling into jerky, aggressive movements... You have awoken something that died in agony, something that was never given justice, something that has festered in the dark places between life and death...',
        messages = {
            '"WITCH... THEY... CALLED... ME... WITCH..." The words drip with centuries of accumulated rage... "I... WAS... A... HEALER... I... HELPED... THEIR... SICK... CHILDREN... AND... THEY... BURNED... ME... FOR... IT..." The flames of the candles dance with unnatural fury, and you swear you can smell smoke that isn\'t there... The smoke of a pyre, of burning flesh, of injustice made manifest...',
            'The board grows hot beneath your fingers, almost too hot to touch... "THE... PRIEST... WHO... CONDEMNED... ME... HE... KNEW... THE... TRUTH... HE... WANTED... MY... LAND... MY... HOME... HIS... CHURCH... STANDS... ON... MY... GRAVE..." Her fury is not random - it is focused, patient, waiting for the right moment to strike at those who wronged her...',
            '"I... CURSED... THEM... AS... I... BURNED... I... CURSED... THEIR... SONS... AND... THEIR... SONS\'... SONS..." The planchette moves so fast it blurs... "HAVE... YOU... NOTICED... HOW... MANY... DIE... YOUNG... IN... THIS... TOWN?... HOW... MANY... ACCIDENTS?... THAT... IS... ME... THAT... IS... JUSTICE..." A chill runs down your spine as you realize this spirit has been actively punishing the descendants of her killers...',
            'Phantom flames lick at the edges of your vision, gone when you look directly at them... "YOU... SEEK... ANSWERS... HERE... IS... ONE... THE... MAN... YOU... TRUST... CARRIES... HIS... ANCESTOR\'S... GUILT... HIS... BLOOD... CONDEMNED... ME..." Mary offers information, but it comes with a price - the knowledge that someone you know is marked for her vengeance...',
            'The presence retreats like a wildfire running out of fuel, but its heat lingers... "I... WILL... BURN... UNTIL... JUSTICE... IS... DONE... UNTIL... THE... LAST... OF... THEM... JOINS... ME... IN... THE... FLAMES..." The candles gutter and nearly die, then return to normal... But you know Mary is still there, in the walls, in the floor, in the very bones of this land, waiting to burn again...'
        }
    },
    ---------------------------------
    -- TRICKSTER SPIRITS
    ---------------------------------
    {
        name = 'Jack',
        type = 'trickster',
        title = '🃏 The Deceiver',
        icon = 'masks-theater',
        iconColor = '#ff9800',
        introduction = 'The planchette begins to move in playful circles, almost dancing across the board... Laughter echoes from the shadows - or is it just your imagination? Something has answered your call, but its intentions are unclear... It seems amused by your attempt to pierce the veil, like a cat toying with a mouse...',
        messages = {
            'The board spells out words that shift and change as you read them... "HELLO... FRIEND... OR... SHOULD... I... SAY... FOOL?" More laughter, definitely real this time... "YOU... OPENED... A... DOOR... BUT... DO... YOU... KNOW... WHAT... WALKS... THROUGH... DOORS?" The question is rhetorical - this spirit knows far more than it tells, and tells far more than is true...',
            '"I... COULD... TELL... YOU... WHERE... THE... GOLD... IS... BURIED..." The planchette moves eagerly now... "UNDER... THE... OLD... OAK... BY... THE... RIVER... NO... WAIT... IN... THE... CHURCH... BASEMENT... NO... THAT\'S... NOT... RIGHT... EITHER..." It\'s toying with you, dangling prizes it may or may not actually offer... Truth and lies are the same thing to this spirit...',
            'The candles flicker in a pattern that almost seems like Morse code... "YOUR... FRIEND... SPEAKS... ILL... OF... YOU... WHEN... YOU... ARE... GONE..." Is it true? Or is Jack planting seeds of doubt for his own amusement? "THEN... AGAIN... PERHAPS... THEY... DON\'T... PERHAPS... I... SIMPLY... LIKE... WATCHING... YOU... SQUIRM..." The spirit\'s laughter echoes again...',
            '"I... KNOW... A... SECRET... ABOUT... YOU... SOMETHING... YOU\'VE... NEVER... TOLD... ANYONE..." The planchette pauses dramatically... "BUT... WHY... WOULD... I... REVEAL... IT?... SECRETS... HAVE... POWER... ESPECIALLY... ONES... THAT... COULD... DESTROY... A... LIFE..." Is it bluffing? Can it really see into your past? You have no way of knowing what this trickster truly knows...',
            'The presence withdraws with a final, echoing cackle... "THIS... WAS... FUN... LET\'S... PLAY... AGAIN... SOON... I\'LL... BE... WATCHING... WAITING... FOR... YOU... TO... MAKE... A... MISTAKE..." The planchette spins one final time and stops, pointing directly at you... Jack is gone, but his games are just beginning... Every shadow might hide his grinning face, every whisper might be his voice...'
        }
    },
    ---------------------------------
    -- MYSTERIOUS SPIRITS
    ---------------------------------
    {
        name = 'Unknown',
        type = 'mysterious',
        title = '❓ Unknown Presence',
        icon = 'question',
        iconColor = '#607d8b',
        introduction = 'The planchette does not move for a long moment... Then, slowly, it begins to glide in patterns that aren\'t letters, aren\'t words, but somehow convey meaning... Something vast and incomprehensible has noticed your séance, something so alien that human language cannot contain it...',
        messages = {
            'The planchette traces symbols that hurt to look at directly... They seem to shift and writhe at the edge of your vision... You understand nothing, yet somehow know that you are being evaluated, measured, judged by standards utterly inhuman... Time feels strange - has seconds passed, or hours? The candles have not burned down, but feel ancient...',
            'Images flash through your mind unbidden - stars dying in the void, cities rising and crumbling in the space between heartbeats, creatures that are not alive yet not dead swimming through dimensions you never knew existed... This is not a ghost... This is something older, something that was never human, something that regards humanity the way you regard insects...',
            'Words finally form, but they feel translated from a language that predates speech... "WE... HAVE... WATCHED... SINCE... BEFORE... YOUR... SPECIES... CRAWLED... FROM... THE... WATERS... WE... WILL... WATCH... LONG... AFTER... YOUR... BONES... ARE... DUST..." The vastness of this presence threatens to overwhelm your sanity... You are an ant addressing the universe...',
            '"YOU... ASK... ABOUT... THE... DEAD... THE... DEAD... ARE... NOTHING... WE... HAVE... SEEN... ETERNITY... BIRTH... AND... DIE... AND... BIRTH... AGAIN..." The candles burn with colors that shouldn\'t exist... "YOUR... QUESTIONS... ARE... MEANINGLESS... YOUR... ANSWERS... WILL... NOT... MATTER... IN... THE... END... NOTHING... MATTERS..." Yet even as it speaks of meaninglessness, you sense curiosity in this entity... Why would something so vast speak to something so small?',
            'The presence does not leave - you simply become too small for it to notice... Like a whale passing by a single drop of water, it moves on to concerns beyond human comprehension... The symbols traced on the board remain for a moment, burned into the wood, then fade as if they never were... You are left with a profound sense of your own insignificance, yet strangely, peace... If nothing matters, then nothing can truly harm you...'
        }
    },
    ---------------------------------
    -- PROPHETIC SPIRITS
    ---------------------------------
    {
        name = 'The Oracle',
        type = 'prophetic',
        title = '🔮 The Oracle - Seer of Fates',
        icon = 'eye',
        iconColor = '#9c27b0',
        introduction = 'The planchette begins to move before you even touch it fully... A presence fills the room that feels less like a ghost and more like a window into time itself... The candles burn with steady, pure flames, and you sense that whatever speaks through this board sees past, present, and future as one continuous moment...',
        messages = {
            '"I... HAVE... SEEN... YOUR... DEATH..." The words should terrify, but they are spoken with such gentle certainty that you feel only curiosity... "IT... IS... NOT... TODAY... NOT... FOR... MANY... YEARS... YOU... WILL... DIE... SURROUNDED... BY... THOSE... WHO... LOVE... YOU... THERE... ARE... WORSE... FATES..." The Oracle speaks of your death as one might speak of tomorrow\'s weather - inevitable, unremarkable, nothing to fear...',
            'The planchette moves to reveal events yet to come... "A... STRANGER... WILL... ARRIVE... WITH... THE... AUTUMN... LEAVES... THEY... CARRY... AN... OPPORTUNITY... THAT... WILL... CHANGE... EVERYTHING..." Is this prophecy or merely possibility? "ALL... FUTURES... EXIST... SIMULTANEOUSLY... I... MERELY... TELL... YOU... WHICH... IS... MOST... LIKELY... CHOICES... CAN... CHANGE... THE... PATTERN..."',
            '"SOMEONE... YOU... CONSIDER... AN... ENEMY... WILL... BECOME... YOUR... GREATEST... ALLY..." The Oracle\'s visions twist expectations... "AND... SOMEONE... YOU... TRUST... WILL... BETRAY... THAT... TRUST... FOR... REASONS... YOU... WILL... EVENTUALLY... UNDERSTAND... AND... FORGIVE..." The future is a tapestry of joy and sorrow, intertwined so tightly they cannot be separated...',
            '"I... SEE... A... CROSSROADS... APPROACHING... THREE... PATHS... LIE... BEFORE... YOU..." The candles flare as the Oracle reveals your choices... "ONE... LEADS... TO... WEALTH... BUT... SOLITUDE... ONE... TO... LOVE... BUT... POVERTY... ONE... TO... SOMETHING... I... CANNOT... SEE... A... MYSTERY... EVEN... TO... ME..." That third path intrigues and terrifies - what could be hidden even from a spirit that sees all futures?',
            'The presence begins to fade, but leaves behind one final truth... "THE... FUTURE... IS... NOT... FIXED... PROPHECY... IS... A... GUIDE... NOT... A... CHAIN... YOU... HAVE... MORE... POWER... THAN... YOU... KNOW... USE... IT... WISELY..." The Oracle departs, leaving you with knowledge both burden and gift... You have glimpsed the shape of things to come, but the final form is yours to sculpt...'
        }
    },
    ---------------------------------
    -- DEMONIC SPIRITS
    ---------------------------------
    {
        name = 'Malphas',
        type = 'demonic',
        title = '😈 Malphas - The Dark Bargainer',
        icon = 'fire-flame-curved',
        iconColor = '#b71c1c',
        introduction = 'The room grows COLD, colder than should be possible... The candle flames turn a sickly green, then black - flames that consume light rather than create it... Something has answered your call that should never have been disturbed... Something ancient, malevolent, and hungry... You have made a terrible mistake, but it is far too late to turn back now...',
        messages = {
            'The planchette moves with silky, predatory grace... "AT... LAST... A... CALLER... WITH... AMBITION..." The voice in your head is like honey poured over broken glass, sweet and cutting all at once... "I... AM... MALPHAS... I... OFFER... WHAT... OTHERS... CANNOT... POWER... WEALTH... REVENGE... NAME... YOUR... DESIRE... AND... WE... SHALL... DISCUSS... TERMS..."',
            '"DO... NOT... PRETEND... YOU... HAVE... NO... DARK... WISHES..." The demon\'s presence wraps around you like chains made of shadow... "I... SEE... INTO... YOUR... HEART... I... SEE... WHAT... YOU... WANT... BUT... DARE... NOT... SPEAK... THE... ENEMY... YOU... WISH... DESTROYED... THE... FORTUNE... YOU... BELIEVE... YOU... DESERVE... THE... POWER... TO... MAKE... OTHERS... KNEEL..." Its words find the darkness within you and nurture it...',
            '"THE... PRICE... IS... SIMPLE... A... PORTION... OF... YOUR... SOUL... SUCH... A... SMALL... THING... YOU... BARELY... USE... IT... ANYWAY..." The offer sounds reasonable, which makes it infinitely more dangerous... "THINK... OF... ALL... YOU... COULD... ACCOMPLISH... FREE... OF... MORTAL... LIMITATIONS... I... HAVE... MADE... KINGS... OF... BEGGARS... LEGENDS... OF... NOBODIES..."',
            'Visions flood your mind of everything you ever wanted, everything you ever feared, twisted together into a tapestry of temptation... "JUST... SAY... YES... THAT\'S... ALL... IT... TAKES... ONE... LITTLE... WORD... AND... EVERYTHING... CHANGES..." The word forms on your lips unbidden, and you have to physically clamp your mouth shut to stop it... This thing\'s power is not in violence, but in offering exactly what you want most...',
            'The demon\'s laughter echoes as it withdraws, having planted its seeds... "I... WILL... BE... WAITING... YOU... WILL... CALL... AGAIN... THEY... ALWAYS... DO... WHEN... LIFE... BECOMES... UNBEARABLE... WHEN... YOUR... HOPE... RUNS... OUT... I... WILL... BE... LISTENING..." The candles return to normal, but something has changed in you... A door has been opened that can never quite be closed, and behind it, Malphas waits with endless patience...'
        }
    },
    ---------------------------------
    -- CHILD SPIRITS
    ---------------------------------
    {
        name = 'Emily',
        type = 'child',
        title = '🧸 The Lost Child',
        icon = 'child',
        iconColor = '#ffb6c1',
        introduction = 'The planchette begins to move with small, uncertain motions, like a child learning to write... A presence fills the room that feels innocent, confused, and desperately lonely... This spirit does not fully understand what has happened to it, only that it has been alone for a very, very long time...',
        messages = {
            'The letters form slowly, with childish uncertainty... "HELLO?... IS... SOMEONE... THERE?... I... CAN... HEAR... YOU... BUT... I... CAN\'T... SEE... YOU..." The words break your heart with their simple longing... This child died alone and afraid, and death has not ended her fear... "MOMMY... SAID... WAIT... HERE... BUT... SHE... NEVER... CAME... BACK..."',
            '"I\'VE... BEEN... WAITING... SO... LONG... HOW... LONG... HAS... IT... BEEN?... IT... FEELS... LIKE... FOREVER..." You try to calculate - from the feel of the presence, decades at least, perhaps a century... "IS... MOMMY... OKAY?... IS... SHE... LOOKING... FOR... ME?... TELL... HER... I\'M... BEING... GOOD... I\'M... WAITING... LIKE... SHE... SAID..."',
            'The candles flicker rapidly, like a child\'s excited heartbeat... "WILL... YOU... PLAY... WITH... ME?... NO... ONE... PLAYS... WITH... ME... ANYMORE..." A cold breeze stirs, carrying the faint scent of wildflowers and something older, earthier... "I... HAVE... A... DOLL... BUT... SHE... DOESN\'T... TALK... BACK... SHE... USED... TO... BUT... NOW... SHE\'S... QUIET... LIKE... EVERYONE..."',
            '"SOMETIMES... I... SEE... OTHER... PEOPLE... WALKING... BY... BUT... THEY... DON\'T... HEAR... ME... WHEN... I... CALL..." Emily\'s loneliness is a weight you can feel pressing against your chest... "WHY... WON\'T... ANYONE... TALK... TO... ME?... DID... I... DO... SOMETHING... BAD?... I... PROMISE... I\'LL... BE... GOOD... PLEASE... DON\'T... LEAVE..."',
            'The presence clings to you desperately as the séance ends... "PLEASE... COME... BACK... PLEASE... DON\'T... LEAVE... ME... ALONE... AGAIN..." The final words cut deep, leaving you with profound sorrow and an unexplainable urge to return, to speak to this lost child again, to somehow help her find the peace she has been denied for so long... Emily remains in the dark, waiting, as she has waited for generations...'
        }
    },
    ---------------------------------
    -- ANCIENT SPIRITS
    ---------------------------------
    {
        name = 'The Elder',
        type = 'ancient',
        title = '🏛️ The Elder - Voice of Ages',
        icon = 'hourglass',
        iconColor = '#795548',
        introduction = 'The planchette does not move with letters at first - instead, it traces symbols older than any alphabet, shapes that your ancestors might have painted on cave walls when the world was young... Something impossibly ancient has answered your call, something that remembers when this land was ice, when different stars ruled the sky...',
        messages = {
            'Words form slowly, filtered through countless generations of language... "I... WAS... HERE... BEFORE... YOUR... PEOPLE... I... WILL... REMAIN... LONG... AFTER..." The presence feels like standing stones and buried bones, like the very earth given voice... "YOUR... LANGUAGE... IS... SO... YOUNG... SO... LIMITED... BUT... I... WILL... TRY... TO... SPEAK... IN... WAYS... YOU... UNDERSTAND..."',
            '"I... HAVE... SEEN... EMPIRES... RISE... LIKE... MORNING... MIST... AND... DISSOLVE... JUST... AS... QUICKLY..." The Elder\'s perspective is humbling beyond measure... "YOUR... WARS... YOUR... LOVES... YOUR... GREAT... ACHIEVEMENTS... THEY... ARE... RIPPLES... IN... AN... OCEAN... HERE... AND... GONE... BUT... THE... OCEAN... REMAINS..."',
            '"ONCE... THIS... LAND... KNEW... DIFFERENT... GODS... DIFFERENT... NAMES... FOR... THE... SAME... SUN... AND... MOON..." The candles burn low but steady, as if time itself has slowed... "WE... BURIED... OUR... DEAD... WHERE... YOUR... TOWN... NOW... STANDS... OUR... BONES... ARE... YOUR... FOUNDATIONS... OUR... SPIRITS... YOUR... NEIGHBORS..."',
            '"YOU... SEEK... WISDOM... FROM... THE... DEAD... HERE... IS... TRUTH... THAT... SPANS... MILLENNIA..." The planchette moves with ancient authority... "THE... YOUNG... ALWAYS... BELIEVE... THEIR... PROBLEMS... ARE... NEW... THEY... ARE... NOT... EVERY... QUESTION... YOU... ASK... WE... ASKED... EVERY... ANSWER... YOU... SEEK... WE... SOUGHT... THE... QUESTIONS... MATTER... MORE... THAN... ANSWERS..."',
            'The Elder begins to sink back into the deep time from which it came... "WE... WILL... STILL... BE... HERE... WHEN... YOUR... GRANDCHILDREN\'S... GRANDCHILDREN... ARE... DUST... CALL... AGAIN... IF... YOU... WISH... TIME... MEANS... NOTHING... TO... US..." The presence fades, leaving behind a profound sense of continuity - you are part of a chain stretching back to the first humans and forward to the last, one link among millions, briefly lit by consciousness before returning to the eternal dark...'
        }
    }
}

---------------------------------
-- PROP SETTINGS (OPTIONAL)
---------------------------------
Config.Props = {
    enabled = true,
    
    
    board = {
        model = 'p_bookbible01x', 
        offset = {x = 0.0, y = 0.5, z = -0.9},
        rotation = {x = -90.0, y = 0.0, z = 0.0}
    },
    
    -- Candle props
    candles = {
        enabled = true,
        model = 'p_candlegroup03x',
        count = 4,
        radius = 0.8
    }
}
