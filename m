Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab0DUPT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:19:58 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:49647 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab0DUPT5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 21 Apr 2010 11:19:57 -0400
Message-Id: <4BCF33BD020000780003B3E4@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 21 Apr 2010 16:19:57 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: don't export init_level4_pgt
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not used by any module, and ix86 (as well as some other arches)
also doesn't export its equivalent (swapper_pg_dir).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/x8664_ksyms_64.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.34-rc5/arch/x86/kernel/x8664_ksyms_64.c	2010-04-20 16:07:32.000000000 +0200
+++ 2.6.34-rc5-x86_64-unexport-init_level4_pgt/arch/x86/kernel/x8664_ksyms_64.c	2010-04-15 11:55:40.000000000 +0200
@@ -54,7 +54,6 @@ EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(__memcpy);
 
 EXPORT_SYMBOL(empty_zero_page);
-EXPORT_SYMBOL(init_level4_pgt);
 #ifndef CONFIG_PARAVIRT
 EXPORT_SYMBOL(native_load_gs_index);
 #endif



