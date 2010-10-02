Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab0JBQky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:40:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab0JBQiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mhyyBVXOFhefwjcZSA1SlY4df7EmLMphozj1alL5gHgLOTzwBic3tCque0eM12FeU5
         OF7uF3djQ5vWjdh9gP5xv7vBJGB2gJlZGyxdiTEZZlaBEI7z0Qs9SqFJZtDbr/pv/rJr
         KOC6qmSs0METR5qjJHt6gQPbN68rZ292f1fW8=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 08/20] Staging: rt2870: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:37:57 -0400
Message-Id: <1286037489-28439-8-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rt2870/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rt2870/Makefile b/drivers/staging/rt2870/Makefile
index 523e7e7..7b29493 100644
--- a/drivers/staging/rt2870/Makefile
+++ b/drivers/staging/rt2870/Makefile
@@ -2,10 +2,10 @@
 obj-$(CONFIG_RT2870)	+= rt2870sta.o
 
 # TODO: all of these should be removed
-EXTRA_CFLAGS += -DLINUX -DAGGREGATION_SUPPORT -DPIGGYBACK_SUPPORT -DWMM_SUPPORT
-EXTRA_CFLAGS += -DRTMP_MAC_USB -DRTMP_USB_SUPPORT -DRT2870 -DRTMP_TIMER_TASK_SUPPORT
-EXTRA_CFLAGS += -DRTMP_RF_RW_SUPPORT -DRTMP_EFUSE_SUPPORT -DRT30xx -DRT3070
-EXTRA_CFLAGS += -DDBG
+ccflags-y := -DLINUX -DAGGREGATION_SUPPORT -DPIGGYBACK_SUPPORT -DWMM_SUPPORT
+ccflags-y += -DRTMP_MAC_USB -DRTMP_USB_SUPPORT -DRT2870 -DRTMP_TIMER_TASK_SUPPORT
+ccflags-y += -DRTMP_RF_RW_SUPPORT -DRTMP_EFUSE_SUPPORT -DRT30xx -DRT3070
+ccflags-y += -DDBG
 
 rt2870sta-objs :=		\
 	common/crypt_md5.o	\
-- 
1.7.3.1.50.g1e633

