Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1IOIce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 04:32:34 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:2844 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1IOIcd convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:3:1>);
	Thu, 15 Sep 2011 04:32:33 -0400
Message-Id: <4E71D43D02000078000563BE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 15 Sep 2011 09:32:29 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: probe_roms.c should include probe_roms.h
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Source files defining global symbols should include the header(s)
declaring them to ensure they aren't (and won't get) out of sync.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/probe_roms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.1-rc6/arch/x86/kernel/probe_roms.c
+++ 3.1-rc6-x86-probe-ROMs/arch/x86/kernel/probe_roms.c
@@ -11,7 +11,7 @@
 #include <linux/pfn.h>
 #include <linux/pci.h>
 #include <asm/pci-direct.h>
-
+#include <asm/probe_roms.h>
 
 #include <asm/e820.h>
 #include <asm/mmzone.h>



