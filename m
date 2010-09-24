Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab0IXX2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:28:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58363 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab0IXX2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wnP3ZQBoUwzF4CQ7kbb64LRX7RgJdz71xzbKYgFmRx1jPkMQPRmuczA+LkZsbvmDGJ
         jrYenfk4Tpxct6dWwFm/C2qlIAY21YqfVG0B/h3OUFdx28yrHF/RmHV9HRwq+t4wbl6u
         xIL72BqSTss+fQw3EE9uB7G6wWHDAD9Ddx9Wo=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 02/22] Staging: cxlel: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:27:50 -0400
Message-Id: <1285370890-8984-2-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/cxt1e1/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/cxt1e1/Makefile b/drivers/staging/cxt1e1/Makefile
index 10020d7..451f59f 100644
--- a/drivers/staging/cxt1e1/Makefile
+++ b/drivers/staging/cxt1e1/Makefile
@@ -1,8 +1,8 @@
 obj-$(CONFIG_CXT1E1)	+= cxt1e1.o
 
-EXTRA_CFLAGS += -DSBE_PMCC4_ENABLE
-EXTRA_CFLAGS += -DSBE_ISR_TASKLET
-EXTRA_CFLAGS += -DSBE_INCLUDE_SYMBOLS
+ccflags-y := -DSBE_PMCC4_ENABLE
+ccflags-y := -DSBE_ISR_TASKLET
+ccflags-y := -DSBE_INCLUDE_SYMBOLS
 
 cxt1e1-objs += 	\
   ossiRelease.o 	\
-- 
1.7.3

