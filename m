Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734Ab1CDPwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:52:39 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:35133 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab1CDPwi convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Fri, 4 Mar 2011 10:52:38 -0500
Message-Id: <4D7118D30200007800034F79@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 04 Mar 2011 15:52:35 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <davej@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: really print supported CPUs if PROCESSOR_SELECT=y
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sure it was a mere oversight that the CONFIG_ prefixes are missing.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Dave Jones <davej@redhat.com>

---
 arch/x86/kernel/cpu/common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 2.6.38-rc7/arch/x86/kernel/cpu/common.c
+++ 2.6.38-rc7-x86-show-supported-cpus/arch/x86/kernel/cpu/common.c
@@ -675,7 +675,7 @@ void __init early_cpu_init(void)
 	const struct cpu_dev *const *cdev;
 	int count = 0;
 
-#ifdef PROCESSOR_SELECT
+#ifdef CONFIG_PROCESSOR_SELECT
 	printk(KERN_INFO "KERNEL supported cpus:\n");
 #endif
 
@@ -687,7 +687,7 @@ void __init early_cpu_init(void)
 		cpu_devs[count] = cpudev;
 		count++;
 
-#ifdef PROCESSOR_SELECT
+#ifdef CONFIG_PROCESSOR_SELECT
 		{
 			unsigned int j;
 



