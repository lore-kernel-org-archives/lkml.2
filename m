Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab0JBQkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:40:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab0JBQiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HsvVRiUCwQHclp0eWu9kvGHharIQOht5e6gmUh8c1ryVTheYM/oibZSKUG3K/2x/nm
         AXz3DcTuk5EHIkww/2O749TBBwKd+r/2OIka/mdOUay6xQRQE+tz2aLDgTYoT1YG8qqk
         n56lmJpXDwyqaPonsZe38kM9rpljj/aaOQ4fQ=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 10/20] Staging: rtl8192e: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:37:59 -0400
Message-Id: <1286037489-28439-10-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192e/Makefile |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8192e/Makefile b/drivers/staging/rtl8192e/Makefile
index 41cb4d3..6e41067 100644
--- a/drivers/staging/rtl8192e/Makefile
+++ b/drivers/staging/rtl8192e/Makefile
@@ -1,13 +1,13 @@
 NIC_SELECT = RTL8192E
 
-EXTRA_CFLAGS += -DRTL8192E
-EXTRA_CFLAGS += -std=gnu89
-EXTRA_CFLAGS += -O2
-EXTRA_CFLAGS += -DTHOMAS_TURBO
-EXTRA_CFLAGS += -DENABLE_DOT11D
+ccflags-y := -DRTL8192E
+ccflags-y += -std=gnu89
+ccflags-y += -O2
+ccflags-y += -DTHOMAS_TURBO
+ccflags-y += -DENABLE_DOT11D
 
-EXTRA_CFLAGS += -DENABLE_IPS
-EXTRA_CFLAGS += -DENABLE_LPS
+ccflags-y += -DENABLE_IPS
+ccflags-y += -DENABLE_LPS
 
 r8192e_pci-objs :=		\
 	r8192E_core.o		\
-- 
1.7.3.1.50.g1e633

