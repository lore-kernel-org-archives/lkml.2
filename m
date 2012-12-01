Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101Ab2LAAnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 19:43:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39354 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2LAAnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 19:43:21 -0500
Date: Fri, 30 Nov 2012 16:42:58 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-11af32b69ef7ee64c7d8848cad71a6f3749d9e37@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20121128205203.05868eab@pyramind.ukuu.org.uk>
References: <20121128205203.05868eab@pyramind.ukuu.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/nuke386] x86, 386 removal:
  Document Nx586 as a 386 and thus unsupported
Git-Commit-ID: 11af32b69ef7ee64c7d8848cad71a6f3749d9e37
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 30 Nov 2012 16:43:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11af32b69ef7ee64c7d8848cad71a6f3749d9e37
Gitweb:     http://git.kernel.org/tip/11af32b69ef7ee64c7d8848cad71a6f3749d9e37
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 29 Nov 2012 13:28:39 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 Nov 2012 13:28:39 -0800

x86, 386 removal: Document Nx586 as a 386 and thus unsupported

Per Alan Cox, Nx586 did not support WP in supervisor mode, making it a
386 by Linux kernel standards.  As such, it is too unsupported now.

Reported-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Link: http://lkml.kernel.org/r/20121128205203.05868eab@pyramind.ukuu.org.uk
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig.cpu | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 423db71..c026cca 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -15,7 +15,7 @@ config M486
 
 	  Note that the 386 is no longer supported, this includes
 	  AMD/Cyrix/Intel 386DX/DXL/SL/SLC/SX, Cyrix/TI 486DLC/DLC2,
-	  and UMC 486SX-S.
+	  UMC 486SX-S and the NexGen Nx586.
 
 	  The kernel will not necessarily run on earlier architectures than
 	  the one you have chosen, e.g. a Pentium optimized kernel will run on
