Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2DOVpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 17:45:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50298 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2DOVpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 17:45:39 -0400
Message-ID: <4F8B417F.6030204@kdrennert.de>
Date: Sun, 15 Apr 2012 23:45:35 +0200
From: Benedikt Bergenthal <benedikt@kdrennert.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: jkosina@suse.cz
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Style issue in Driver/hid/hid-apple
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:vjMD/kc3DIZBkQ1kfkUqBLQ86zHzIKeMXO1taUMlvuw
 MZgPRX4MC7Z9xd9Q4VgMlzShYF9V8IQV7xIufo32AmpLXahC1m
 tHsvxUSEAbmR8PU68BTLam57Rm5dmB5D2wBb1mn1ua81El1iMK
 w5hW4CkefG/+2Kb2Pk8kelFuo7UX8iu5J7/HZdhqqQn7BA/nZQ
 DVKkL9p2uNaBwiMLPRbBkNxbAhSnhxHeNSDVukfCibmyz/zg5Z
 bDn/ka2DtzIKIJh6MkjaL+0BAZsbUr57Woc+YcdO0cs0PMnK3V
 W/+nqlslHw+vCBF2iE0k2nqD3IdC3xY4Iseeuts+aK6+dXtLgv
 rFP4m8+iDfvCeAn9fSQCesxZeOvTVWVtTgjGsPXlu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6e3e0130d7b9b39e114aeb55b1626f3070e22239 Mon Sep 17 00:00:00 2001
From: Benedikt <bbergenthal@cern.ch>
Date: Sun, 15 Apr 2012 23:29:57 +0200
Subject: [PATCH] Driver: HID: hid-apple: Fixed a tab width style issue

Fixed a style issue.

Signed-off-by: Benedikt Bergenthal <benedikt@kdrennert.de>
---
 drivers/hid/hid-apple.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 299d238..7a79e39 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -234,7 +234,7 @@ static int hidinput_apple_event(struct hid_device
*hid, struct input_dev *input,
         }
     }
 
-        if (iso_layout) {
+    if (iso_layout) {
         if (asc->quirks & APPLE_ISO_KEYBOARD) {
             trans = apple_find_translation(apple_iso_keyboard,
usage->code);
             if (trans) {
-- 
1.7.5.4

