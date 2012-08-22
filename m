Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab2HVXkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:40:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47500 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2HVXko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:40:44 -0400
Date: Wed, 22 Aug 2012 16:40:26 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-e43f6e67ec1c142550860bbe0b51166c5ee4cac8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <1344361461-10076-6-git-send-email-bp@amd64.org>
References: <1344361461-10076-6-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode: Straighten out Kconfig text
Git-Commit-ID: e43f6e67ec1c142550860bbe0b51166c5ee4cac8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 16:40:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e43f6e67ec1c142550860bbe0b51166c5ee4cac8
Gitweb:     http://git.kernel.org/tip/e43f6e67ec1c142550860bbe0b51166c5ee4cac8
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 1 Aug 2012 19:17:01 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Aug 2012 16:15:16 -0700

x86, microcode: Straighten out Kconfig text

Update and clarify Kconfig help text along with menu names.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1344361461-10076-6-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ec3a1a..1ccccc6 100644
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
