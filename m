Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab2DUWMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 18:12:18 -0400
Received: from nm2.bullet.mail.sp2.yahoo.com ([98.139.91.72]:42551 "HELO
	nm2.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752556Ab2DUWMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 18:12:16 -0400
X-Yahoo-Newman-Id: 539667.72714.bm@smtp202.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YKAHHdUVM1mvrJBmad8f_Xf0BkAYLkEJiNZeO5iEfzIfaVr
 AEmoqEC.4kwTEuYBHiJBcOYi2iWneh_Dx9FqQT.G7gW2M.zsZf0cjnTak9T6
 l0Gnty7z5zviT5vIDkJyRmsuB4q9alBl9XjqXWepMYQrLnbBzpkOPFPq6cdX
 4NeJdXIqET7faiYt1kZsAd2pTuWrMctbqBWDqKAz_tesIAgdD2zvWCniO71V
 ZUX6WsDJr53l_SWH6BlOiQi8gye8DGvo2wINQ7J8c8N2BoqH2Q0CfI0BLnVc
 SfGjPOyzohotYaOFCnBbcGCIgovc572DMBfyiuewt2iBFzbitk0nVPd5AXTo
 zjOKkU46nErVa2E9MVO7CA9lgL..N7bMDwJ0dQ4er7BNrB2OI0cnJA268HDJ
 ptWjGCcsjlokfkCqGqxq8j2DDscMcJmN2xnsGW9bcr6qiV8sRiK.4
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
Date: Sun, 22 Apr 2012 03:43:44 +0530
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, jj@chaosbits.net, ahiliation@yahoo.co.in
Subject: [PATCH] fixed coding style issues relating to spaces
Message-ID: <20120421221344.GA8651@debian.Jeff>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello

I have fixed coding style issues relating to
spaces in sound/usb/card.c

>From 62fffec818ecc3df83f6c6a274512ab85579dfde Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Sun, 22 Apr 2012 02:31:38 +0530
Subject: [PATCH 7/7] sound:Fixed coding style issue relating spaces.

Fixed coding style issues relating to spaces
in the file sound/usb/card.c
Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
Acked-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/usb/card.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 4a7be7b..b664eb8 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -186,7 +186,7 @@ static int snd_usb_create_stream(struct snd_usb_audio *chip, int ctrlif, int int
 		return -EINVAL;
 	}
 
-	if (! snd_usb_parse_audio_interface(chip, interface)) {
+	if (!snd_usb_parse_audio_interface(chip, interface)) {
 		usb_set_interface(dev, interface, 0); /* reset the current interface */
 		usb_driver_claim_interface(&usb_audio_driver, iface, (void *)-1L);
 		return -EINVAL;
@@ -331,7 +331,7 @@ static int snd_usb_audio_create(struct usb_device *dev, int idx,
 	}
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-	if (! chip) {
+	if (!chip) {
 		snd_card_free(card);
 		return -ENOMEM;
 	}
@@ -474,12 +474,12 @@ snd_usb_audio_probe(struct usb_device *dev,
 			break;
 		}
 	}
-	if (! chip) {
+	if (!chip) {
 		/* it's a fresh one.
 		 * now look for an empty slot and create a new card instance
 		 */
 		for (i = 0; i < SNDRV_CARDS; i++)
-			if (enable[i] && ! usb_chip[i] &&
+			if (enable[i] && !usb_chip[i] &&
 			    (vid[i] == -1 || vid[i] == USB_ID_VENDOR(id)) &&
 			    (pid[i] == -1 || pid[i] == USB_ID_PRODUCT(id))) {
 				if (snd_usb_audio_create(dev, i, quirk, &chip) < 0) {
@@ -687,7 +687,7 @@ err_out:
 #define usb_audio_resume	NULL
 #endif		/* CONFIG_PM */
 
-static struct usb_device_id usb_audio_ids [] = {
+static struct usb_device_id usb_audio_ids[] = {
 #include "quirks-table.h"
     { .match_flags = (USB_DEVICE_ID_MATCH_INT_CLASS | USB_DEVICE_ID_MATCH_INT_SUBCLASS),
       .bInterfaceClass = USB_CLASS_AUDIO,
-- 
1.7.9




/Jeffrin.



-- 
software engineer
Bohr Lab
department of computer science
Rajagiri school of engineering and technology.
