Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2DUVMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 17:12:30 -0400
Received: from nm20.bullet.mail.bf1.yahoo.com ([98.139.212.179]:36118 "HELO
	nm20.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751553Ab2DUVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 17:12:29 -0400
X-Yahoo-Newman-Id: 409934.97998.bm@smtp201.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: btnHzOkVM1lSI_Lb578JdMMFt6Qo043Hrqm7w0aPm2NY1kW
 25XjdL5OTT9rwUnqvfC6jM7qTsbsmT_ULmuBJVwkwzdTaiRV3ywLiWe5rvSu
 6.cqjVLtN2gY2.2BcqqhgA6t8iOVYfvsoSyd9nrCmsWCnL0G1ypIr5v7uEmB
 M.oA61.W5hKY3lnFzmhiHur9ZHxAyYyDhlmcDOKVZrJev74d_KQ6bDTNJy5r
 ak.lqgUtbcURqlkg_LpqY3a_F2GyFKaJhZDD7JVIsDEDfZH6WREjnFnyY55O
 M29J4tATfxqYAbwr8AQIW4jd2UAaXRfPiCRiV_9XUY.wZT4yIZOqPj9a0ol5
 9wgOW8DLr5Ftb0Elias2pcRxEh5x6Kz43acGkwR0VQgQxfuioZ0sDfRdnh5e
 dB7LA7m7PrwrYTvzMUSqSLCRMjb3cMFbOBeRvAsgiID182lAywigGGrUAsYi
 cjw--
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
Date: Sun, 22 Apr 2012 02:44:56 +0530
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH] Fixed atleast coding style issues relating spaces
Message-ID: <20120421211455.GA8179@debian.Jeff>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hello 

I have fixed atleast coding style issues relating
spaces in file sound/usb/card.c

Please see attachment.

/Jeffrin
-- 
software engineer
Bohr Lab
department of computer science
Rajagiri school of engineering and technology.

--Q68bSM7Ycu6FN28Q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0007-sound-Fixed-atleast-coding-style-issue-relating-spac.patch"

>From 62fffec818ecc3df83f6c6a274512ab85579dfde Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Sun, 22 Apr 2012 02:31:38 +0530
Subject: [PATCH 7/7] sound:Fixed atleast coding style issue relating spaces.

Fixed atleast coding style issues relating spaces
in the file sound/usb/card.c
Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
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


--Q68bSM7Ycu6FN28Q--
