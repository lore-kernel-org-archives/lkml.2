Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab0JBQi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:38:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55732 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0JBQiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qZPAVKAnDl8L4UqF1tIrMCIhdZXGzLSbVibGzG8yWerOp+2GFydBVyf5H91Sj/HsZJ
         RR7NQb6eiKHq0BpRMZVb1QwRDNKLiW6ENzMjxDp41oPfNySLsNGFqgCw4rTTATIsO2u3
         LwKLb+GmdkDN9OhBlQmR5P1zb5ZDDAGsgAWjQ=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 12/20] Staging: rtl8192su: ieee80211: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:38:01 -0400
Message-Id: <1286037489-28439-12-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192su/ieee80211/Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192su/ieee80211/Makefile b/drivers/staging/rtl8192su/ieee80211/Makefile
index a500bfa..5bee643 100644
--- a/drivers/staging/rtl8192su/ieee80211/Makefile
+++ b/drivers/staging/rtl8192su/ieee80211/Makefile
@@ -1,10 +1,10 @@
 NIC_SELECT = RTL8192SU
 
-EXTRA_CFLAGS += -O2
-EXTRA_CFLAGS += -DRTL8192S_DISABLE_FW_DM=0
-EXTRA_CFLAGS += -DRTL8192SU
-#EXTRA_CFLAGS += -DJOHN_NOCPY
-EXTRA_CFLAGS += -DTHOMAS_TURBO
+ccflags-y := -O2
+ccflags-y += -DRTL8192S_DISABLE_FW_DM=0
+ccflags-y += -DRTL8192SU
+#ccflags-y += -DJOHN_NOCPY
+ccflags-y += -DTHOMAS_TURBO
 
 ieee80211-rsl-objs := ieee80211_rx.o \
 		      ieee80211_softmac.o \
-- 
1.7.3.1.50.g1e633

