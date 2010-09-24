Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab0IXSWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:22:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40226 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab0IXSSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:18:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ik+xRp1brMeMRHR5/tmHP3M3A7emXNx48dL8RuEv2H3foTAaAGnp7Za4NJD5IrkrlN
         gA1tnDGh/wu1lldGplT3cIPUw7/Q2mLm0I5TQAoJGnVCC+tDCs0oLWppfPeTMVCdXWeV
         N/dv0YzKwFVdSgxFbCfkOoXBxC3G/B0v/novU=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 07/21] Staging: go7007: Makefile: cleaned up makefile cflags lines
Date: Fri, 24 Sep 2010 14:18:20 -0400
Message-Id: <1285352314-5939-7-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/go7007/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/go7007/Makefile b/drivers/staging/go7007/Makefile
index d37b7ed..618e526e 100644
--- a/drivers/staging/go7007/Makefile
+++ b/drivers/staging/go7007/Makefile
@@ -22,13 +22,13 @@ s2250-objs += s2250-board.o
 # Uncomment when the saa7134 patches get into upstream
 #ifneq ($(CONFIG_VIDEO_SAA7134),)
 #obj-$(CONFIG_VIDEO_SAA7134) += saa7134-go7007.o
-#EXTRA_CFLAGS += -Idrivers/media/video/saa7134 -DSAA7134_MPEG_GO7007=3
+#ccflags-y += -Idrivers/media/video/saa7134 -DSAA7134_MPEG_GO7007=3
 #endif
 
 # S2250 needs cypress ezusb loader from dvb-usb
 ifneq ($(CONFIG_VIDEO_GO7007_USB_S2250_BOARD),)
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-usb
+ccflags-y += -Idrivers/media/dvb/dvb-usb
 endif
 
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/dvb/dvb-core
-- 
1.7.3

