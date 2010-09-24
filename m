Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab0IXSSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:18:50 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51072 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab0IXSSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:18:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=H5r0Fr4lcA5cDmjgLo8Hi/SoDXdiRPG14STPa0nni9lj5Nr8D6ZQPJIJP/y25nt7CG
         SNT0nboHnJ86AMfZXKfML6AO3BUODZ32bAxgDv+SN0ivB+yJUfGdXUYgvRsz6o7w80cd
         W3MMRXKZPVKZyKYQPaynsBBdkeGUQwSgJceNo=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 02/21] Staging: cxlel: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 14:18:15 -0400
Message-Id: <1285352314-5939-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
References: <1285352314-5939-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/cxt1e1/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/cxt1e1/Makefile b/drivers/staging/cxt1e1/Makefile
index 10020d7..f946b91 100644
--- a/drivers/staging/cxt1e1/Makefile
+++ b/drivers/staging/cxt1e1/Makefile
@@ -1,8 +1,8 @@
 obj-$(CONFIG_CXT1E1)	+= cxt1e1.o
 
-EXTRA_CFLAGS += -DSBE_PMCC4_ENABLE
-EXTRA_CFLAGS += -DSBE_ISR_TASKLET
-EXTRA_CFLAGS += -DSBE_INCLUDE_SYMBOLS
+ccflags-y += -DSBE_PMCC4_ENABLE
+ccflags-y += -DSBE_ISR_TASKLET
+ccflags-y += -DSBE_INCLUDE_SYMBOLS
 
 cxt1e1-objs += 	\
   ossiRelease.o 	\
-- 
1.7.3

