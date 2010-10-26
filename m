Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab0JZCqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:46:33 -0400
Received: from mail.perches.com ([173.55.12.10]:3561 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab0JZCod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:44:33 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] arch/x86/kernel/apic/io_apic.c: Typo fix WARNING
Date: Mon, 25 Oct 2010 19:44:19 -0700
Message-Id: <d6f06d6b469fb345ff7738cebae1dc556ed22dbc.1288059486.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.90.gd4c43
In-Reply-To: <cover.1288059486.git.joe@perches.com>
References: <cover.1288059486.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8ae808d..4640f72 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4037,7 +4037,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 static int bad_ioapic(unsigned long address)
 {
 	if (nr_ioapics >= MAX_IO_APICS) {
-		printk(KERN_WARNING "WARING: Max # of I/O APICs (%d) exceeded "
+		printk(KERN_WARNING "WARNING: Max # of I/O APICs (%d) exceeded "
 		       "(found %d), skipping\n", MAX_IO_APICS, nr_ioapics);
 		return 1;
 	}
-- 
1.7.3.dirty

