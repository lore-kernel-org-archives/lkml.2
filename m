Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0IXX2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:28:40 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58363 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab0IXX2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xHgq3PGz0PiX7JgMl+A4QBVInqk+c6alVF0TPRX2JzCZxcYxYb/Rts+r0uVwHu73+H
         r6+Xcfmi8TdUlsBv+6uhy7QDqLmLQX5g7l9oSsq/Ifpf0dEEx2ad2pHOPm897JENdb7M
         aQ1Gy86q7OzZekCPPGdMgvV/eF9Pdx9hCY0ls=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 01/22] Staging: cx25821: Makefile:cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:27:49 -0400
Message-Id: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/cx25821/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cx25821/Makefile b/drivers/staging/cx25821/Makefile
index d0eb16e..2f1c73e 100644
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
+ccflags-y := -Idrivers/media/common/tuners
+ccflags-y := -Idrivers/media/dvb/dvb-core
+ccflags-y := -Idrivers/media/dvb/frontends
-- 
1.7.3

