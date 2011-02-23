Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1BWMII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:08:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:56577 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab1BWMIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:08:06 -0500
Date: Wed, 23 Feb 2011 12:07:40 GMT
From: tip-bot for Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, henne@nachtwindheim.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, henne@nachtwindheim.de, mingo@elte.hu
In-Reply-To: <1298385487-4708-2-git-send-email-henne@nachtwindheim.de>
References: <1298385487-4708-2-git-send-email-henne@nachtwindheim.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Add dummy mp_save_irq()
Message-ID: <tip-b6a1432da81fa387d76215108dc9f6ea6d343aed@git.kernel.org>
Git-Commit-ID: b6a1432da81fa387d76215108dc9f6ea6d343aed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:07:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b6a1432da81fa387d76215108dc9f6ea6d343aed
Gitweb:     http://git.kernel.org/tip/b6a1432da81fa387d76215108dc9f6ea6d343aed
Author:     Henrik Kretzschmar <henne@nachtwindheim.de>
AuthorDate: Tue, 22 Feb 2011 15:38:04 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:38:45 +0100

x86: Add dummy mp_save_irq()

This is a dummy function, used when no IOAPIC is compiled in.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
LKML-Reference: <1298385487-4708-2-git-send-email-henne@nachtwindheim.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
