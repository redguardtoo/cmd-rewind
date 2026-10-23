;;; cmd-rewind-tests.el ---  unit tests for cmd-rewind -*- coding: utf-8 -*-

;; Author: Chen Bin

;;; License:

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:
;;; Code:

(require 'ert)
(require 'cmd-rewind)

(defun cmd-rewind-test-command ()
  "Test commands that call `completing-read' once."
  (interactive)
  (completing-read "Choose: " '("apple" "banana" "cherry")))

(ert-deftest cmd-rewind-test-record-initial-input ()
  (let ((cmd-rewind-last-session nil)
        (cmd-rewind-excluded-commands nil)
        (cmd-rewind-debug t))
    (cl-letf (((symbol-function 'completing-read)
               (lambda (&rest _args) "banana")))
      (let ((this-command 'cmd-rewind-test-command))
        (apply #'cmd-rewind-around-completing-read
               (lambda (&rest _args) "banana")
               '("Choose: " ("apple" "banana" "cherry") nil nil "ban"))))
    (message "Recorded session: %S" cmd-rewind-last-session)
    (should (equal
             (plist-get cmd-rewind-last-session :completing-read-input)
             "ban"))))
(ert-run-tests-batch-and-exit)
;;; cmd-rewind-tests.el ends here