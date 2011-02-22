Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1BVOjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:39:06 -0500
Received: from server103.greatnet.de ([83.133.97.6]:58831 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab1BVOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:38:15 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 2/5] x86: add dummy mp_save_irq()
Date: Tue, 22 Feb 2011 15:38:04 +0100
Message-Id: <1298385487-4708-2-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298385487-4708-1-git-send-email-henne@nachtwindheim.de>
References: <1298385487-4708-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a dummy function, used when no IOAPIC is compiled in.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/include/asm/io_apic.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index e1a9b0e..b24915f 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -188,6 +188,7 @@ static inline int mp_find_ioapic(u32 gsi) { return 0; }
 struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr) { return 0; }
+static inline void mp_save_irq(struct mpc_intsrc *m) { };
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
-- 
1.7.2.3

