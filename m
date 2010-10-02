Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab0JBQiY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:38:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0JBQiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VPTcZJ7U6AsbPOiuXXHTPQNA/3REExvutwt+UeLoFKkrTJToPQnJQFc/+G72c+UmvY
         7fjHM97b2kN/gnbf4iWA+bHOmROYUi9YlTDqhQ+sXq5lGtqYAdSXLiNu/IIJmOwCAscE
         ILsPYOK6np3MLsFYbb3MHMT6jEUtC1kvrR04s=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 09/20] Staging: rtl8187se: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:37:58 -0400
Message-Id: <1286037489-28439-9-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8187se/Makefile |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8187se/Makefile b/drivers/staging/rtl8187se/Makefile
index e6adf91..adc3849 100644
--- a/drivers/staging/rtl8187se/Makefile
+++ b/drivers/staging/rtl8187se/Makefile
@@ -4,17 +4,17 @@
 #EXTRA_CFLAGS += -O2
 #CC            = gcc
 
-EXTRA_CFLAGS += -DSW_ANTE
-EXTRA_CFLAGS += -DTX_TRACK
-EXTRA_CFLAGS += -DHIGH_POWER
-EXTRA_CFLAGS += -DSW_DIG
-EXTRA_CFLAGS += -DRATE_ADAPT
+ccflags-y := -DSW_ANTE
+ccflags-y += -DTX_TRACK
+ccflags-y += -DHIGH_POWER
+ccflags-y += -DSW_DIG
+ccflags-y += -DRATE_ADAPT
 
 #enable it for legacy power save, disable it for leisure  power save
-EXTRA_CFLAGS += -DENABLE_LPS
+ccflags-y += -DENABLE_LPS
 
 
-#EXTRA_CFLAGS += -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
+#ccflags-y := -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
 
 r8187se-objs :=			\
 		r8180_core.o		\
-- 
1.7.3.1.50.g1e633

