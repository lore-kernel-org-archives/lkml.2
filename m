Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab2CJXmH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 18:42:07 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62294 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab2CJXmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 18:42:04 -0500
From: Alan Ott <alan@signal11.us>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v2] kbuild: export INSTALL_MOD_PATH to the environment used by depmod
Date: Sat, 10 Mar 2012 18:41:46 -0500
Message-Id: <1331422906-24503-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331330522-15129-1-git-send-email-alan@signal11.us>
References: <1331330522-15129-1-git-send-email-alan@signal11.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export INSTALL_MOD_PATH explicitly to the environment given to depmod.  This
way putting an INSTALL_MOD_PATH line into a GNUmakefile (with things
like CROSS_COMPILE and ARCH) will work properly.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 5f1739b..c4a238a 100644
--- a/Makefile
+++ b/Makefile
@@ -385,6 +385,7 @@ export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP
 export MAKE AWK GENKSYMS INSTALLKERNEL PERL UTS_MACHINE
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
+export INSTALL_MOD_PATH
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS LDFLAGS
 export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
-- 
1.7.0.4

