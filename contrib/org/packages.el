;;; packages.el --- Org Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq org-packages
  '(
    evil-org
    org
    org-bullets
    org-pomodoro
    org-repo-todo
    ox-gfm
    ))

(setq org-excluded-packages
  '(
    ;; seems to be problematic, to investigate
    ox-gfm
    ))

(defun org/init-evil-org ()
  (use-package evil-org
    :commands evil-org-mode
    :init
    (add-hook 'org-mode-hook 'evil-org-mode)
    :config
    (progn
      (evil-leader/set-key-for-mode 'org-mode
           "a" nil "ma" 'org-agenda
           "c" nil "mA" 'org-archive-subtree
           "o" nil "mC" 'evil-org-recompute-clocks
           "l" nil "m <RET>" 'evil-org-open-links
           "t" nil "mT" 'org-show-todo-tree)
      (evil-define-key 'normal evil-org-mode-map
        "O" 'evil-open-above
        )
      (spacemacs|diminish evil-org-mode " ⓔ" " e"))))

(defun org/init-org ()
  (use-package org
    :mode ("\\.org$" . org-mode)
    :defer t
    :init
    (progn
      (setq org-log-done t)

      (eval-after-load 'org-indent
        '(spacemacs|hide-lighter org-indent-mode))
      (setq org-startup-indented t)

      (defmacro spacemacs|org-emphasize (fname char)
        "Make function for setting the emphasize in org mode"
        `(defun ,fname () (interactive)
                (org-emphasize ,char))
        )
      (evil-leader/set-key-for-mode 'org-mode
        "mc" 'org-capture
        "md" 'org-deadline
        "me" 'org-export-dispatch
        "mf" 'org-set-effort
        "mI" 'org-clock-in
        "mj" 'helm-org-in-buffer-headings
        "mm" 'org-ctrl-c-ctrl-c
        (concat "m" dotspacemacs-major-mode-leader-key) 'org-ctrl-c-ctrl-c
        "mn" 'org-narrow-to-subtree
        "mN" 'widen
        "mO" 'org-clock-out
        "mq" 'org-clock-cancel
        "mr" 'org-refile
        "mS" 'org-schedule
        ;; headings
        "mhh" 'org-insert-heading-after-current
        "mhH" 'org-insert-heading
        ;; insertion of common elements
        "mil" 'org-insert-link
        "mif" 'org-footnote-new
        ;; images and other link types have no commands in org mode-line
        ;; could be inserted using yasnippet?
        ;; text manipulation
        "mtb" (spacemacs|org-emphasize spacemacs/org-bold ?*)
        "mti" (spacemacs|org-emphasize spacemacs/org-italic ?/)
        "mtc" (spacemacs|org-emphasize spacemacs/org-code ?~)
        "mtu" (spacemacs|org-emphasize spacemacs/org-underline ?_)
        "mtv" (spacemacs|org-emphasize spacemacs/org-verbose ?=)
        "mts" (spacemacs|org-emphasize spacemacs/org-strike-through ?+)
        "mt <SPC>" (spacemacs|org-emphasize spacemacs/org-clear ? )
        )

      (eval-after-load "org-agenda"
        '(progn
           (define-key org-agenda-mode-map "j" 'org-agenda-next-line)
           (define-key org-agenda-mode-map "k" 'org-agenda-previous-line)
           ;; Since we override SPC, let's make RET do that functionality
           (define-key org-agenda-mode-map
             (kbd "RET") 'org-agenda-show-and-scroll-up)
           (define-key org-agenda-mode-map
             (kbd "SPC") evil-leader--default-map))))
    :config
    (progn
      (require 'org-indent)
      (define-key global-map "\C-cl" 'org-store-link)
      (define-key global-map "\C-ca" 'org-agenda)
      (evil-leader/set-key
        "Cc" 'org-capture
        )
      ))

  )

(defun org/init-org-bullets ()
  (use-package org-bullets
    :defer t
    :init (add-hook 'org-mode-hook 'org-bullets-mode)))

(defun org/init-org-pomodoro ()
  (use-package org-pomodoro
    :defer t
    :init
    (progn
      (when (system-is-mac)
        (setq org-pomodoro-audio-player "/usr/bin/afplay"))
      (evil-leader/set-key-for-mode 'org-mode
        "mp" 'org-pomodoro))))

(defun org/init-org-repo-todo ()
  (use-package org-repo-todo
    :commands (ort/capture-todo
               ort/capture-todo-check
               ort/goto-todos)
    :init
    (progn
      (evil-leader/set-key
        "Ct"  'ort/capture-todo
        "CT"  'ort/capture-todo-check)
      (evil-leader/set-key-for-mode 'org-mode
        "mgt" 'ort/goto-todos))))

(defun org/init-ox-gfm ()
  (use-package ox-gfm
    :defer t))