Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2CHJYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:24:19 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:15740 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab2CHJYK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 8 Mar 2012 04:24:10 -0500
Message-Id: <4F5888F902000078000770F1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 08 Mar 2012 09:24:57 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] x86: probe_roms.c should include probe_roms.h
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... to ensure that declarations and definitions are in sync.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/probe_roms.c |    1 +
 1 file changed, 1 insertion(+)

--- 3.3-rc6/arch/x86/kernel/probe_roms.c
+++ 3.3-rc6-x86-probe-ROMs/arch/x86/kernel/probe_roms.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/export.h>
 
+#include <asm/probe_roms.h>
 #include <asm/pci-direct.h>
 #include <asm/e820.h>
 #include <asm/mmzone.h>



