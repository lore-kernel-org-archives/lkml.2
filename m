Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1I2CCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 22:02:43 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48540 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab1I2CCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 22:02:42 -0400
Date: Thu, 29 Sep 2011 10:01:27 +0800
From: wangyanqing <udknight@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH][TRIVIAL] arch:x86:pci:pcbios Fix misspelling of area in a
 printk
Message-ID: <20110929020127.GA3129@udknight.homenetwork>
Mail-Followup-To: wangyanqing <Udknight@gmail.com>,
	Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
	trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/x86/pci/pcbios.c, the word 'area' is misspelled as                                                                                       
'aera' in a comment. Fix that.  

Signed-off-by: wang yanqing <udknight@gmail.com>
---
 arch/x86/pci/pcbios.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index f685535..5494b90 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -44,7 +44,7 @@ static inline void set_bios_x(void)
 	pcibios_enabled = 1;
 	set_memory_x(PAGE_OFFSET + BIOS_BEGIN, (BIOS_END - BIOS_BEGIN) >> PAGE_SHIFT);
 	if (__supported_pte_mask & _PAGE_NX)
-		printk(KERN_INFO "PCI : PCI BIOS aera is rw and x. Use pci=nobios if you want it NX.\n");
+		printk(KERN_INFO "PCI : PCI BIOS area is rw and x. Use pci=nobios if you want it NX.\n");
 }
 
 /*
-- 
1.7.3.4
