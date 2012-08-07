Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2HGRsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:48:11 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35591 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab2HGRo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:27 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v0 05/12] x86, microcode: Straighten out Kconfig text
Date: Tue,  7 Aug 2012 19:44:14 +0200
Message-Id: <1344361461-10076-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344361461-10076-1-git-send-email-bp@amd64.org>
References: <1344361461-10076-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Update and clarify Kconfig help text along with menu names.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/Kconfig | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1aa4abd..1ccccc6efb37 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -982,25 +982,25 @@ config X86_REBOOTFIXUPS
 	  Say N otherwise.
 
 config MICROCODE
-	tristate "/dev/cpu/microcode - microcode support"
+	tristate "CPU microcode loading support"
 	select FW_LOADER
 	---help---
+
 	  If you say Y here, you will be able to update the microcode on
 	  certain Intel and AMD processors. The Intel support is for the
-	  IA32 family, e.g. Pentium Pro, Pentium II, Pentium III,
-	  Pentium 4, Xeon etc. The AMD support is for family 0x10 and
-	  0x11 processors, e.g. Opteron, Phenom and Turion 64 Ultra.
-	  You will obviously need the actual microcode binary data itself
-	  which is not shipped with the Linux kernel.
+	  IA32 family, e.g. Pentium Pro, Pentium II, Pentium III, Pentium 4,
+	  Xeon etc. The AMD support is for families 0x10 and later. You will
+	  obviously need the actual microcode binary data itself which is not
+	  shipped with the Linux kernel.
 
 	  This option selects the general module only, you need to select
 	  at least one vendor specific module as well.
 
-	  To compile this driver as a module, choose M here: the
-	  module will be called microcode.
+	  To compile this driver as a module, choose M here: the module
+	  will be called microcode.
 
 config MICROCODE_INTEL
-	bool "Intel microcode patch loading support"
+	bool "Intel microcode loading support"
 	depends on MICROCODE
 	default MICROCODE
 	select FW_LOADER
@@ -1013,7 +1013,7 @@ config MICROCODE_INTEL
 	  <http://www.urbanmyth.org/microcode/>.
 
 config MICROCODE_AMD
-	bool "AMD microcode patch loading support"
+	bool "AMD microcode loading support"
 	depends on MICROCODE
 	select FW_LOADER
 	---help---
-- 
1.7.11.rc1

