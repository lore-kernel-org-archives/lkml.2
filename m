Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2FRKa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:30:27 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51278 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab2FRKaZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 18 Jun 2012 06:30:25 -0400
Message-Id: <4FDF1F5C020000780008A661@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 18 Jun 2012 11:30:20 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: free_initrd_mem() can be __init
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... matching various other architectures.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.5-rc3/arch/x86/mm/init.c
+++ 3.5-rc3-x86-mm-init-sections/arch/x86/mm/init.c
@@ -385,7 +385,7 @@ void free_initmem(void)
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
-void free_initrd_mem(unsigned long start, unsigned long end)
+void __init free_initrd_mem(unsigned long start, unsigned long end)
 {
 	/*
 	 * end could be not aligned, and We can not align that,



