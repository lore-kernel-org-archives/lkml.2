Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab0IXXbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:31:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55484 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558Ab0IXX2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EsFVwUdRje3n2WOEHO792XTyLyyyKVG9INMfqHvQas679DHlBHm797qURcTJhMlHQo
         p7qFCuM1SMf0c50G9e7Mypm5OPC0PbBS89MpG0gtjipPAdeEDiKVHNWQlv8rBQZodNs5
         VJ5F2rF2L5oKop5f/qlS1Oi98Q5jK4vpHUDes=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 11/22] Staging: rtl8187se: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:27:59 -0400
Message-Id: <1285370890-8984-11-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8187se/Makefile |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8187se/Makefile b/drivers/staging/rtl8187se/Makefile
index e6adf91..51fbd24 100644
--- a/drivers/staging/rtl8187se/Makefile
+++ b/drivers/staging/rtl8187se/Makefile
@@ -1,20 +1,20 @@
 
-#EXTRA_CFLAGS += -DCONFIG_IEEE80211_NOWEP=y
-#EXTRA_CFLAGS += -std=gnu89
-#EXTRA_CFLAGS += -O2
+#ccflags-y := -DCONFIG_IEEE80211_NOWEP=y
+#ccflags-y := -std=gnu89
+#ccflags-y := -O2
 #CC            = gcc
 
-EXTRA_CFLAGS += -DSW_ANTE
-EXTRA_CFLAGS += -DTX_TRACK
-EXTRA_CFLAGS += -DHIGH_POWER
-EXTRA_CFLAGS += -DSW_DIG
-EXTRA_CFLAGS += -DRATE_ADAPT
+ccflags-y := -DSW_ANTE
+ccflags-y := -DTX_TRACK
+ccflags-y := -DHIGH_POWER
+ccflags-y := -DSW_DIG
+ccflags-y := -DRATE_ADAPT
 
 #enable it for legacy power save, disable it for leisure  power save
-EXTRA_CFLAGS += -DENABLE_LPS
+ccflags-y := -DENABLE_LPS
 
 
-#EXTRA_CFLAGS += -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
+#ccflags-y := -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
 
 r8187se-objs :=			\
 		r8180_core.o		\
-- 
1.7.3

