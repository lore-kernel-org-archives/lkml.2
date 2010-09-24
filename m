Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab0IXX3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:29:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58363 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567Ab0IXX25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:28:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MkJi34qEVrJ90V+otzNNYJq7ObQ058cVY53F0prw4RfHaQUp0wM9aa2nxYaXzm50zd
         OHv5AcVV2I0Bhw3evNo3ShX9Q10w+M4HjjuiqW2u7ZUpeNjJ5I2qbqCctiP/8vdPDckP
         2SjT65zi+4PFqtUxz+NCkBWE9sSQwRF0Ryx0M=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v2 12/22] Staging: rt8192e: Makefile: cleaned up makefile cflag lines
Date: Fri, 24 Sep 2010 19:28:00 -0400
Message-Id: <1285370890-8984-12-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8192e/Makefile |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8192e/Makefile b/drivers/staging/rtl8192e/Makefile
index 41cb4d3..96e7abf 100644
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
+ccflags-y := -std=gnu89
+ccflags-y := -O2
+ccflags-y := -DTHOMAS_TURBO
+ccflags-y := -DENABLE_DOT11D
 
-EXTRA_CFLAGS += -DENABLE_IPS
-EXTRA_CFLAGS += -DENABLE_LPS
+ccflags-y := -DENABLE_IPS
+ccflags-y := -DENABLE_LPS
 
 r8192e_pci-objs :=		\
 	r8192E_core.o		\
-- 
1.7.3

