Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713Ab1CDO5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:57:54 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:41307 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab1CDO5x convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Fri, 4 Mar 2011 09:57:53 -0500
Message-Id: <4D710BFC0200007800034F3A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 04 Mar 2011 14:57:48 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: remove dead config option X86_CPU
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't being referenced anywhere, and the selects done from it can
be easily done together with all the other X86 ones

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig     |    2 ++
 arch/x86/Kconfig.cpu |    5 -----
 2 files changed, 2 insertions(+), 5 deletions(-)

--- 2.6.38-rc7/arch/x86/Kconfig
+++ 2.6.38-rc7-x86-remove-X86_CPU/arch/x86/Kconfig
@@ -64,6 +64,8 @@ config X86
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_FIND_NEXT_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select USE_GENERIC_SMP_HELPERS if SMP
--- 2.6.38-rc7/arch/x86/Kconfig.cpu
+++ 2.6.38-rc7-x86-remove-X86_CPU/arch/x86/Kconfig.cpu
@@ -294,11 +294,6 @@ config X86_GENERIC
 
 endif
 
-config X86_CPU
-	def_bool y
-	select GENERIC_FIND_FIRST_BIT
-	select GENERIC_FIND_NEXT_BIT
-
 #
 # Define implied options from the CPU selection here
 config X86_INTERNODE_CACHE_SHIFT



