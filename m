Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab1HRS7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:59:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49877 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1HRS7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:59:10 -0400
Date: Thu, 18 Aug 2011 19:59:09 +0100
To: richard@nod.at
Subject: Subject: [PATCH 01/91] um: fix strrchr problems
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7o5-0007Oj-3g@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several years old patch, originally by jdike, I think...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index fab8121..c0f712c 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -41,7 +41,7 @@ KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
 KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\" \
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
 	-Din6addr_loopback=kernel_in6addr_loopback \
-	-Din6addr_any=kernel_in6addr_any
+	-Din6addr_any=kernel_in6addr_any -Dstrrchr=kernel_strrchr
 
 KBUILD_AFLAGS += $(ARCH_INCLUDE)
 
-- 
1.7.2.5


