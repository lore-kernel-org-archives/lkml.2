Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab0IXSSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:18:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40226 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab0IXSSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=srxze49wBYypb2nXD+6LXMSm4bF5BItXqcja72VGF9bx7FTpzXUNPstzAs5qJgnkrf
         lNnAM3E4JOeHa8ZZVjg6ezzMp3NlMoOWEKGzZzcVpOUEQOF1dLyqO7saZAMBs/8kRUjR
         ji8CNmzEet4F8J1cclXwXvNstLI6A+2cLP5ZE=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>, Tracey Dent <tdent48227@gamil.com>
Subject: [PATCH 01/21] Staging: cx25821: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 14:18:14 -0400
Message-Id: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option.

Signed-off-by: Tracey Dent <tdent48227@gamil.com>
---
 drivers/staging/cx25821/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cx25821/Makefile b/drivers/staging/cx25821/Makefile
index d0eb16e..77cbb83 100644
--- a/drivers/staging/cx25821/Makefile
+++ b/drivers/staging/cx25821/Makefile
@@ -7,7 +7,7 @@ cx25821-objs   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
 obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
 obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y += -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
-- 
1.7.3

