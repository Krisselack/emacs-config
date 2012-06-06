
(defface helm-selection
  '((((class color) (background light))
      (:background "#ddddff" :bold t))
     (t (:background "#000040" :foreground "white")))
  "")

;; (defface helm-ff-executable
;;   '((((class color) (background light))
;;       (:foreground "#206020"))
;;      (t (:foreground "green")))
;;   "")

(require 'helm-config)
(require 'helm-files)
(require 'helm-buffers)
(require 'helm-misc) ;; enables C-r in minibuffer

;; Added to helm-locate.el
;;     (define-key map (kbd "M-]")     'helm-ff-run-toggle-basename)
(if (eq system-type 'windows-nt)
  (setq helm-c-locate-command "c:/tools/Locate32/Locate.exe %s"))
(setq helm-ff-transformer-show-only-basename nil)
(global-set-key (kbd "M-h") 'vj-helm)


(defvar vj-helm-list '(helm-c-source-buffers-list
			helm-c-source-recentf
			helm-c-source-locate))

(defun vj-helm ()
  (interactive)
  (if current-prefix-arg
    (if (eq system-type 'windows-nt)
      (vj-helm-wdsgrep)
      (vj-helm-local-locate))
    (helm-other-buffer vj-helm-list "*vj-helm*")))



;; Desktop search for windows
(defvar helm-source-wdsgrep
  '((name . "Desktop Search")
     (candidates . (lambda ()
                     (start-process "wdsgrep-process" nil
                       "c:\\tools\\wdsgrep\\wdsgrep.exe" helm-pattern)))
     (type . file)
     (requires-pattern . 4)
     (delayed))
  "Source for retrieving files via W. Desktop Search.")



(if (eq system-type 'windows-nt)

  ;; Windows
  (defun vj-helm-wdsgrep ()
    (interactive)
    (helm-other-buffer '(helm-source-wdsgrep) "*helm Desktop Search*"))

  ;; else
  (defun vj-helm-local-locate ()
    (interactive)
    (when (not (file-exists-p "~/.vj-locate.db"))
      (message
        (propertize "Run: updatedb -l 0 -o ~/.vj-locate.db -U ~"
          'face 'compilation-info))
      (sit-for 2.0))
    (let ((helm-c-locate-command "locate -d ~/.vj-locate.db -i -r %s"))
      (helm-other-buffer
        '(helm-c-source-locate)
        "*vj-helm-local-locate*"))))
