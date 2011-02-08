Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1BHW2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:28:09 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:46421 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab1BHW2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:28:08 -0500
Subject: [PATCH] [TRIVIAL] Fix printk typo WARING
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 23:27:36 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.5 (2.91.5-4.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1297204087.1748.17.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 697dc34..303be81 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4026,7 +4026,7 @@ int mp_find_ioapic_pin(int ioapic, u32 gsi)
 static int bad_ioapic(unsigned long address)
 {
 	if (nr_ioapics >= MAX_IO_APICS) {
-		printk(KERN_WARNING "WARING: Max # of I/O APICs (%d) exceeded "
+		printk(KERN_WARNING "WARNING: Max # of I/O APICs (%d) exceeded "
 		       "(found %d), skipping\n", MAX_IO_APICS, nr_ioapics);
 		return 1;
 	}
-- 
1.7.4



