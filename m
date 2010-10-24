Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab0JXBEc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:04:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48121 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737Ab0JXBEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:04:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/15] x86, visws: Set_fixmap in find_smp_config
Date: Sat, 23 Oct 2010 18:02:22 -0700
Message-Id: <1287882149-29275-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/visws_quirks.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 3371bd0..a70bc71 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -211,6 +211,7 @@ static void __init visws_find_smp_config(void)
 		MP_processor_info(mp++);
 
 	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+	set_fixmap(FIX_APIC_BASE, APIC_DEFAULT_PHYS_BASE);
 }
 
 static void visws_trap_init(void);
-- 
1.7.1

