Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab0JBQiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:38:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab0JBQiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=d0HMUW652AGp7QkVmZ9icXwp3ixT6+QHpGq1ZkIdwbyZjkWJfYO26YYSzL7KZjWEVi
         RVr1+oeMiAaqFS45oTkK85ISXX8ta3LHPySZ5nN23Si6AXMT7glLIADEAr4udfGqV9Nj
         VeT/ySErPCT0q+C0CcHtPl2t9gAza3U3ThBME=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 01/20] Staging: cx25821: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:37:50 -0400
Message-Id: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/cx25821/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cx25821/Makefile b/drivers/staging/cx25821/Makefile
index d0eb16e..6448364 100644
--- a/drivers/staging/cx25821/Makefile
+++ b/drivers/staging/cx25821/Makefile
@@ -7,7 +7,7 @@ cx25821-objs   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
 obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
 obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
 
-EXTRA_CFLAGS += -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y := -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
-- 
1.7.3.1.50.g1e633

