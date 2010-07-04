Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0GDKJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 06:09:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47451 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab0GDKJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 06:09:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=FD1dMFmnyPjVgqFAsr3I8v1b23UO7rQuJV0o0FQ6P7r0aUx/NxlzIcGR5r+1pCS6mV
         DV+DkQvbkDW4m/E0FoGjzjMBAuomtMotP1lFth0xKevxUaxceSIekr56WbfcsihEuXqD
         fFmpuFpFLLd9iyAznqp0MiOVA1dQhVH/LMckA=
Subject: [PATCH] Staging: cx25821: fix brace coding style issue in
 cx25821-audio-upstream.c
From: Joe Eloff <kagen101@gmail.com>
Reply-To: kagen101@gmail.com
To: gregkh@suse.de, mchehab@redhat.com, olimpiu.pascariu@gmail.com,
       julia@diku.dk, tj@kernel.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Jul 2010 12:09:34 +0200
Message-ID: <1278238174.17566.4.camel@dermezel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b7f34cd4bf14c07f64a95f70410f34e2c843fd3b Mon Sep 17 00:00:00 2001
From: Joe Eloff <kagen101@gmail.com>
Date: Sun, 4 Jul 2010 11:37:03 +0200
Subject: [PATCH] Staging: cx25821: fix brace coding style issue in cx25821-audio-upstream.c
 This is a patch to the cx25821.c file that fixes up a brace warning found by the checkpatch.pl tool
 Signed-off-by: Joe Eloff <kagen101@gmail.com>

---
 drivers/staging/cx25821/cx25821-audio-upstream.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index eb39d13..e7346ec 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -762,9 +762,9 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 		       str_length + 1);
 
 		/* Default if filename is empty string */
-		if (strcmp(dev->input_audiofilename, "") == 0) {
+		if (strcmp(dev->input_audiofilename, "") == 0)
 			dev->_audiofilename = "/root/audioGOOD.wav";
-		}
+
 	} else {
 		str_length = strlen(_defaultAudioName);
 		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
-- 
1.6.3.3



