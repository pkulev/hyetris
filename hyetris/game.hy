(require [hy.contrib.walk [let]])

(import [eaf [State Vec3]]
        [xo1 [Application]]
        [xo1.color [Palette]]
        [xo1.render [Renderable]]
        [xo1.surface [Surface]])


(defclass Hyetris [Application]
  "Hyetris game application class."

  (defn __init__ [self x y]
    (.__init__ (super) x y :title "Hyetris")))


(defclass Block [Renderable]

  (defn __init__ [self pos]
    (setv self.pos pos)
    (setv self.image (Surface "WELL")))

  (defn update [self]))


(defclass GameState [State]
  (defn postinit [self]
    (self.add (Block (Vec3 10 10))))

  (defn update [self dt])

  (defn events [self]))


(defmain [&rest args]
  (let [app (Hyetris 40 40)]
    (app.register GameState)
    (app.start)))
