Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab0IIMWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 08:22:34 -0400
Received: from lechat.rtp-net.org ([88.191.19.38]:39084 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab0IIMWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 08:22:30 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Sep 2010 08:22:30 EDT
Message-Id: <20100909121040.781762033@rtp-net.org>
User-Agent: quilt/0.48-1
Date: Thu, 09 Sep 2010 14:10:33 +0200
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Arnaud Patard <apatard@mandriva.com>
Subject: [patch 1/1] Change my mail address
References: <20100909121032.713581987@rtp-net.org>
Content-Disposition: inline; filename=mail_change.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like other coworkers, I'm about leave Mandriva/Edge-It so I'm changing
my mail address to use my personal one.

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Signed-off-by: Arnaud Patard <apatard@mandriva.com>
Index: sound-2.6/drivers/staging/xgifb/TODO
===================================================================
--- sound-2.6.orig/drivers/staging/xgifb/TODO	2010-09-08 16:11:56.000000000 +0200
+++ sound-2.6/drivers/staging/xgifb/TODO	2010-09-08 16:12:08.000000000 +0200
@@ -12,4 +12,4 @@
 - get rid of non-linux related stuff
 
 Please send patches to:
-Arnaud Patard <apatard@mandriva.com>
+Arnaud Patard <arnaud.patard@rtp-net.org>
Index: sound-2.6/sound/soc/codecs/cs42l51.c
===================================================================
--- sound-2.6.orig/sound/soc/codecs/cs42l51.c	2010-09-08 16:08:37.000000000 +0200
+++ sound-2.6/sound/soc/codecs/cs42l51.c	2010-09-08 16:08:56.000000000 +0200
@@ -649,6 +649,6 @@
 }
 module_exit(cs42l51_exit);
 
-MODULE_AUTHOR("Arnaud Patard <apatard@mandriva.com>");
+MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
 MODULE_DESCRIPTION("Cirrus Logic CS42L51 ALSA SoC Codec Driver");
 MODULE_LICENSE("GPL");
Index: sound-2.6/sound/soc/kirkwood/kirkwood-dma.c
===================================================================
--- sound-2.6.orig/sound/soc/kirkwood/kirkwood-dma.c	2010-09-08 16:10:19.000000000 +0200
+++ sound-2.6/sound/soc/kirkwood/kirkwood-dma.c	2010-09-08 16:10:50.000000000 +0200
@@ -2,6 +2,7 @@
  * kirkwood-dma.c
  *
  * (c) 2010 Arnaud Patard <apatard@mandriva.com>
+ * (c) 2010 Arnaud Patard <arnaud.patard@rtp-net.org>
  *
  *  This program is free software; you can redistribute  it and/or modify it
  *  under  the terms of  the GNU General  Public License as published by the
@@ -397,7 +398,7 @@
 }
 module_exit(kirkwood_pcm_exit);
 
-MODULE_AUTHOR("Arnaud Patard <apatard@mandriva.com>");
+MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
 MODULE_DESCRIPTION("Marvell Kirkwood Audio DMA module");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:kirkwood-pcm-audio");
Index: sound-2.6/sound/soc/kirkwood/kirkwood-i2s.c
===================================================================
--- sound-2.6.orig/sound/soc/kirkwood/kirkwood-i2s.c	2010-09-08 16:09:07.000000000 +0200
+++ sound-2.6/sound/soc/kirkwood/kirkwood-i2s.c	2010-09-08 16:10:11.000000000 +0200
@@ -2,6 +2,7 @@
  * kirkwood-i2s.c
  *
  * (c) 2010 Arnaud Patard <apatard@mandriva.com>
+ * (c) 2010 Arnaud Patard <arnaud.patard@rtp-net.org>
  *
  *  This program is free software; you can redistribute  it and/or modify it
  *  under  the terms of  the GNU General  Public License as published by the
@@ -495,7 +496,7 @@
 module_exit(kirkwood_i2s_exit);
 
 /* Module information */
-MODULE_AUTHOR("Arnaud Patard, <apatard@mandriva.com>");
+MODULE_AUTHOR("Arnaud Patard, <arnaud.patard@rtp-net.org>");
 MODULE_DESCRIPTION("Kirkwood I2S SoC Interface");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:kirkwood-i2s");
Index: sound-2.6/sound/soc/kirkwood/kirkwood-openrd.c
===================================================================
--- sound-2.6.orig/sound/soc/kirkwood/kirkwood-openrd.c	2010-09-08 16:10:58.000000000 +0200
+++ sound-2.6/sound/soc/kirkwood/kirkwood-openrd.c	2010-09-08 16:11:28.000000000 +0200
@@ -2,6 +2,7 @@
  * kirkwood-openrd.c
  *
  * (c) 2010 Arnaud Patard <apatard@mandriva.com>
+ * (c) 2010 Arnaud Patard <arnaud.patard@rtp-net.org>
  *
  *  This program is free software; you can redistribute  it and/or modify it
  *  under  the terms of  the GNU General  Public License as published by the
@@ -113,7 +114,7 @@
 module_exit(openrd_client_exit);
 
 /* Module information */
-MODULE_AUTHOR("Arnaud Patard <apatard@mandriva.com>");
+MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
 MODULE_DESCRIPTION("ALSA SoC OpenRD Client");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:soc-audio");


