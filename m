Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761563Ab2COWWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 18:22:21 -0400
Received: from ozlabs.org ([203.10.76.45]:44385 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab2COWWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 18:22:20 -0400
From: Tony Breeds <tony@bakeyournoodle.com>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com, Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mn10300: Remove -mmemfuncs from KBUILD_CFLAGS
Date: Fri, 16 Mar 2012 09:22:10 +1100
Message-Id: <1331850130-32085-1-git-send-email-tony@bakeyournoodle.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems the current (gcc 4.6.3) no longer provide this so remove it.

With this patch the mn10300 architecture cross-compiles with gcc-4.6.3

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 arch/mn10300/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/Makefile b/arch/mn10300/Makefile
index 7120282..d6116c5 100644
--- a/arch/mn10300/Makefile
+++ b/arch/mn10300/Makefile
@@ -26,7 +26,7 @@ CHECKFLAGS	+=
 PROCESSOR	:= unset
 UNIT		:= unset
 
-KBUILD_CFLAGS	+= -mam33 -mmem-funcs -DCPU=AM33
+KBUILD_CFLAGS	+= -mam33 -DCPU=AM33
 KBUILD_AFLAGS	+= -mam33 -DCPU=AM33
 
 ifeq ($(CONFIG_MN10300_CURRENT_IN_E2),y)
-- 
1.7.7.6

