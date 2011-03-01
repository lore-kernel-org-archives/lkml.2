Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1CALPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 06:15:01 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:59730 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab1CALPA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Tue, 1 Mar 2011 06:15:00 -0500
Message-Id: <4D6CE3400200007800034498@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 01 Mar 2011 11:14:55 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Jeff Dike" <jdike@addtoit.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix UML build after adding CFI annotations to
	 lib/rwsem_64.S
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeff Dike <jdike@addtoit.com>

---
 arch/um/Kconfig.x86     |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

--- 2.6.38-rc6/arch/um/Kconfig.x86
+++ 2.6.38-rc6-x86_64-cfi-annotate-rwsem-UML/arch/um/Kconfig.x86
@@ -19,6 +19,9 @@ config X86_32
 	def_bool !64BIT
 	select HAVE_AOUT
 
+config X86_64
+	def_bool 64BIT
+
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool X86_XADD
 



