Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab2DRKWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:22:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2DRKWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:22:43 -0400
From: Benedikt Bergenthal <bbergenthal@cern.ch>
To: jkosina@suse.cz
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benedikt <bbergenthal@cern.ch>,
        Benedikt Bergenthal <benedikt@kdrennert.de>
Subject: [PATCH] Driver: HID: hid-apple: Fixed a tab width style issue
Date: Wed, 18 Apr 2012 12:22:40 +0200
Message-Id: <1334744560-28985-1-git-send-email-bbergenthal@cern.ch>
X-Mailer: git-send-email 1.7.5.4
X-Provags-ID: V02:K0:Y/WpGz3qto+TF5JrvMfFvGkg2AqyY1HcQ/Ep7GDzOOA
 tjE2ur0O9qeyw9RJ16jZjpO2Wo+akQ5pIIcOV5zbwUyhI+GTUO
 tG3BbHydw6eKjLJbt0gbepoUgc/QQbO/7d1/VQGsksmE2HyFB7
 K+NxALIszqEX6FI/enKaQxqpSfu8UgbkQ18QnrCgfIRnMR8ThM
 iumB59SC8RR6+xfzKknkMFGOoHBJ4cAkKaoBg7jAcqueophZiN
 PUf07zVDaQ9ZHtpLAnfkDokvXjYGnaRHPomA2nmUJ0IMmDQzMA
 ARsZcnzpxyW7BBDydtGBMY31ZzS4LYauxL2Lzlad2Lc30CKwji
 x9hf9p638xT/vuTlwZrjdTreUWfqkZHQOpP6kPwnOwyfelfihU
 QKza4CMbObW/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benedikt <bbergenthal@cern.ch>

Fixed a style issue.

Signed-off-by: Benedikt Bergenthal <benedikt@kdrennert.de>
---
 drivers/hid/hid-apple.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 299d238..7a79e39 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -234,7 +234,7 @@ static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
 		}
 	}
 
-        if (iso_layout) {
+	if (iso_layout) {
 		if (asc->quirks & APPLE_ISO_KEYBOARD) {
 			trans = apple_find_translation(apple_iso_keyboard, usage->code);
 			if (trans) {
-- 
1.7.5.4

