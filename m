Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2DENvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 09:51:15 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:38342 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775Ab2DENtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 09:49:41 -0400
X-Greylist: delayed 1206 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2012 09:49:40 EDT
Message-ID: <1333632606.4159.12.camel@localhost>
Subject: [PATCH 2/6] sound/pci/hda: Rename capture sources of CX20549 to
 match common conventions
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Date: Thu, 05 Apr 2012 15:30:06 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Originating-IP: 89.247.230.181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 8c6523b..7d92aac 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -687,18 +687,18 @@ static const struct hda_channel_mode cxt5045_modes[1] = {
 static const struct hda_input_mux cxt5045_capture_source = {
 	.num_items = 2,
 	.items = {
-		{ "IntMic", 0x1 },
-		{ "ExtMic", 0x2 },
+		{ "Internal Mic", 0x1 },
+		{ "Mic", 0x2 },
 	}
 };
 
 static const struct hda_input_mux cxt5045_capture_source_benq = {
 	.num_items = 5,
 	.items = {
-		{ "IntMic", 0x1 },
-		{ "ExtMic", 0x2 },
-		{ "LineIn", 0x3 },
 		{ "CD",     0x4 },
+		{ "Internal Mic", 0x1 },
+		{ "Mic", 0x2 },
+		{ "Line In", 0x3 },
 		{ "Mixer",  0x0 },
 	}
 };
@@ -706,8 +706,8 @@ static const struct hda_input_mux cxt5045_capture_source_benq = {
 static const struct hda_input_mux cxt5045_capture_source_hp530 = {
 	.num_items = 2,
 	.items = {
-		{ "ExtMic", 0x1 },
-		{ "IntMic", 0x2 },
+		{ "Mic", 0x1 },
+		{ "Internal Mic", 0x2 },
 	}
 };
 
-- 
1.7.9.1



