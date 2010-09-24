Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab0IXSW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:22:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51363 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab0IXSSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MXP4/FMxDH0s8qCFIkCKVEzLBbI5rrRPy2ZdQvO8FDa9EndaYy7ASlZFmkdrqe/Tti
         NzcZ/ETEac1deq1d8wwBFM6i1dNSpFyYRwp9o5PVLXUcp9ExG4s7FQbULsqCUkbX6UOm
         peGa0eiy3G0cjsmwYhv0nfldlHL7ntmnZzdvY=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 06/21] Staging: easycap: Makefile: cleaned up makefile cflags lines
Date: Fri, 24 Sep 2010 14:18:19 -0400
Message-Id: <1285352314-5939-6-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/easycap/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/easycap/Makefile b/drivers/staging/easycap/Makefile
index d93bd6b..0746ad0 100644
--- a/drivers/staging/easycap/Makefile
+++ b/drivers/staging/easycap/Makefile
@@ -5,9 +5,9 @@ easycap-objs	:= easycap_main.o easycap_low.o easycap_sound.o
 easycap-objs	+= easycap_ioctl.o easycap_settings.o
 easycap-objs	+= easycap_testcard.o
 
-EXTRA_CFLAGS += -Wall
+ccflags-y += -Wall
 # Impose all or none of the following:
-EXTRA_CFLAGS += -DEASYCAP_IS_VIDEODEV_CLIENT
-EXTRA_CFLAGS += -DEASYCAP_NEEDS_V4L2_DEVICE_H
-EXTRA_CFLAGS += -DEASYCAP_NEEDS_V4L2_FOPS
+ccflags-y += -DEASYCAP_IS_VIDEODEV_CLIENT
+ccflags-y += -DEASYCAP_NEEDS_V4L2_DEVICE_H
+ccflags-y += -DEASYCAP_NEEDS_V4L2_FOPS
 
-- 
1.7.3

