Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab2BFOYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:24:04 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:35532
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753428Ab2BFOYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:24:02 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] microblaze: Fix typo in early_printk.c
Date: Mon,  6 Feb 2012 23:23:37 +0900
Message-Id: <1328538217-2010-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "remaping" to "remapping" in
arch/microblaze/kernel/early_printk.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/microblaze/kernel/early_printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/early_printk.c b/arch/microblaze/kernel/early_printk.c
index 8356e47..742c247 100644
--- a/arch/microblaze/kernel/early_printk.c
+++ b/arch/microblaze/kernel/early_printk.c
@@ -171,7 +171,7 @@ void __init remap_early_printk(void)
 {
 	if (!early_console_initialized || !early_console)
 		return;
-	printk(KERN_INFO "early_printk_console remaping from 0x%x to ",
+	printk(KERN_INFO "early_printk_console remapping from 0x%x to ",
 								base_addr);
 	base_addr = (u32) ioremap(base_addr, PAGE_SIZE);
 	printk(KERN_CONT "0x%x\n", base_addr);
-- 
1.7.6.5

