Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab0IXSVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:21:00 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51072 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab0IXSTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=v2Fc5QqL5QpjzTZ+I8wPj8NkuXXtPpoQC3l86HS5YIIaMnSd+OMVAnRa2Ak7LVBhPx
         lxFUqx5w0qWcI8KLZ3x48a0oaJneiH+l9tLY3XkUq2BsuollU0s+PozePmMmC9u2bBY+
         kTA2L9dUBOFbyZYp69IJJDDHIwkdr8cNCxME8=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 16/21] Staging: tm6000: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 14:18:29 -0400
Message-Id: <1285352314-5939-16-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/tm6000/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tm6000/Makefile b/drivers/staging/tm6000/Makefile
index 77e06bf..f69a4fc 100644
--- a/drivers/staging/tm6000/Makefile
+++ b/drivers/staging/tm6000/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_VIDEO_TM6000) += tm6000.o
 obj-$(CONFIG_VIDEO_TM6000_ALSA) += tm6000-alsa.o
 obj-$(CONFIG_VIDEO_TM6000_DVB) += tm6000-dvb.o
 
-EXTRA_CFLAGS = -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y = -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
-- 
1.7.3

