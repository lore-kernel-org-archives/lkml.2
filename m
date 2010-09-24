Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab0IXX3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:29:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58363 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab0IXX3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:29:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U2wC2CGpEW3orInD2xXwghnlwglicdnJpvm+88Fy+cA/nVmGmTS+9Zv/J0cH+OVTqQ
         qwxS5sFFjZb5doo2dLWU7OmoXC82JhxO0g7LA4ua9CikBCsplXZXyCXYAblMklhTuFGu
         w3efWU0RMixD+0ishqSQ9a9OCEmnot8hGHyk8=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 14/22] Staging: rtl8192su: ieee80211: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:28:02 -0400
Message-Id: <1285370890-8984-14-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192su/ieee80211/Makefile |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192su/ieee80211/Makefile b/drivers/staging/rtl8192su/ieee80211/Makefile
index a500bfa..0df57eb 100644
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
+ccflags-y := -DRTL8192S_DISABLE_FW_DM=0
+ccflags-y := -DRTL8192SU
+#ccflags-y := -DJOHN_NOCPY
+ccflags-y := -DTHOMAS_TURBO
 
 ieee80211-rsl-objs := ieee80211_rx.o \
 		      ieee80211_softmac.o \
-- 
1.7.3

