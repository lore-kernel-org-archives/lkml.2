Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab2CLAtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:49:06 -0400
Received: from 1wt.eu ([62.212.114.60]:63036 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab2CLAsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:15 -0400
Message-Id: <20120312002046.041448832@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:20:47 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Hutchings <ben@decadent.org.uk>
Subject: [ 02/12] Remove COMPAT_IA32 support
In-Reply-To: <feb44625a10a45049eddf27890e95d54@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 32974ad4907cdde6c9de612cd1b2ee0568fb9409 upstream

This just changes Kconfig rather than touching all the other files the
original commit did.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/ia64/Kconfig |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 1ee596c..20fc9c5 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -502,23 +502,6 @@ config ARCH_PROC_KCORE_TEXT
 	def_bool y
 	depends on PROC_KCORE
 
-config IA32_SUPPORT
-	bool "Support for Linux/x86 binaries"
-	help
-	  IA-64 processors can execute IA-32 (X86) instructions.  By
-	  saying Y here, the kernel will include IA-32 system call
-	  emulation support which makes it possible to transparently
-	  run IA-32 Linux binaries on an IA-64 Linux system.
-	  If in doubt, say Y.
-
-config COMPAT
-	bool
-	depends on IA32_SUPPORT
-	default y
-
-config COMPAT_FOR_U64_ALIGNMENT
-	def_bool COMPAT
-
 config IA64_MCA_RECOVERY
 	tristate "MCA recovery from errors other than TLB."
 
-- 
1.7.2.1.45.g54fbc



