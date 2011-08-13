Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1HMTgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 15:36:35 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:49174 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751847Ab1HMTfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 15:35:18 -0400
Date: Sat, 13 Aug 2011 12:34:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 3/8] Documentation: add ARM user_debug to
 kernel-parameters.txt
Message-Id: <20110813123450.754f68b5.rdunlap@xenotime.net>
In-Reply-To: <20110813122200.8e2fc879.rdunlap@xenotime.net>
References: <20110813122200.8e2fc879.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Usually kernel parameters are documented in kernel-parameters.txt
but user_debug is only documented in the Kconfig. Document the
option and point to the Kconfig help text for more info.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/kernel-parameters.txt |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- lnx-31-rc1-git7.orig/Documentation/kernel-parameters.txt
+++ lnx-31-rc1-git7/Documentation/kernel-parameters.txt
@@ -2635,6 +2635,16 @@ bytes respectively. Such letter suffixes
 					medium is write-protected).
 			Example: quirks=0419:aaf5:rl,0421:0433:rc
 
+	user_debug=	[KNL,ARM]
+			Format: <int>
+			See arch/arm/Kconfig.debug help text.
+				 1 - undefined instruction events
+				 2 - system calls
+				 4 - invalid data aborts
+				 8 - SIGSEGV faults
+				16 - SIGBUS faults
+			Example: user_debug=31
+
 	userpte=
 			[X86] Flags controlling user PTE allocations.
 
