Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0IWGwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:52:19 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:57073 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054Ab0IWGwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:52:16 -0400
From: matt mooney <mfm@muteddisk.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 15/20] sparc: change to new flag variable
Date: Wed, 22 Sep 2010 23:51:26 -0700
Message-Id: <1285224686-29967-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_LDFLAGS with ldflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 arch/sparc/boot/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/boot/Makefile b/arch/sparc/boot/Makefile
index 97e3feb..9a22b4a 100644
--- a/arch/sparc/boot/Makefile
+++ b/arch/sparc/boot/Makefile
@@ -21,7 +21,7 @@ quiet_cmd_btfix		= BTFIX   $@
 quiet_cmd_sysmap        = SYSMAP  $(obj)/System.map
       cmd_sysmap        = $(CONFIG_SHELL) $(srctree)/scripts/mksysmap
 quiet_cmd_image = LD      $@
-      cmd_image = $(LD) $(LDFLAGS) $(EXTRA_LDFLAGS) $(LDFLAGS_$(@F)) -o $@
+      cmd_image = $(LD) $(LDFLAGS) $(ldflags-y) $(LDFLAGS_$(@F)) -o $@
 quiet_cmd_strip = STRIP   $@
       cmd_strip = $(STRIP) -R .comment -R .note -K sun4u_init -K _end -K _start $(obj)/image -o $@
 
-- 
1.7.2.1

