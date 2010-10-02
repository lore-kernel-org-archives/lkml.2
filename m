Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab0JBQid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:38:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55732 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab0JBQi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kMgIUV5mspi/XzQsLkv3RoRiV0uv3NzyR91H02suAYqNG8fz3H9FQPGNxWRynDTtra
         kOKZH91HypMZDMIV1bbdmoigQnBlqeanBQ1+VaoX9u29zOGbaNlsL+K3VumiW/2QDlvE
         XHJesERRMx2TSi6eJIHCX1BvJg8e7pBVb/Xi8=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 15/20] Staging: tm6000: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:38:04 -0400
Message-Id: <1286037489-28439-15-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/tm6000/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tm6000/Makefile b/drivers/staging/tm6000/Makefile
index 77e06bf..d8ccdaa 100644
--- a/drivers/staging/tm6000/Makefile
+++ b/drivers/staging/tm6000/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_VIDEO_TM6000) += tm6000.o
 obj-$(CONFIG_VIDEO_TM6000_ALSA) += tm6000-alsa.o
 obj-$(CONFIG_VIDEO_TM6000_DVB) += tm6000-dvb.o
 
-EXTRA_CFLAGS = -Idrivers/media/video
-EXTRA_CFLAGS += -Idrivers/media/common/tuners
-EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
-EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+ccflags-y := -Idrivers/media/video
+ccflags-y += -Idrivers/media/common/tuners
+ccflags-y += -Idrivers/media/dvb/dvb-core
+ccflags-y += -Idrivers/media/dvb/frontends
-- 
1.7.3.1.50.g1e633

