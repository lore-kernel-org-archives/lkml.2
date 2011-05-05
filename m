Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1EEMeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:34:01 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33901 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab1EEMd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:33:59 -0400
From: Frank Arnold <farnold@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, amd-nb: Convert spaces to tabs in amd_nb.c
Date: Thu,  5 May 2011 14:33:52 +0200
Message-Id: <1304598832-30704-1-git-send-email-farnold@amd64.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Arnold <frank.arnold@amd.com>

Commit 9653a5c76c8677b05b45b3b999d3b39988d2a064 introduced some
changes using spaces instead of tabs for indention. Clean this up.

Signed-off-by: Frank Arnold <frank.arnold@amd.com>
---
 arch/x86/kernel/amd_nb.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 4c39baa..993e185 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -75,7 +75,7 @@ int amd_cache_northbridges(void)
 			next_northbridge(misc, amd_nb_misc_ids);
 		node_to_amd_nb(i)->link = link =
 			next_northbridge(link, amd_nb_link_ids);
-        }
+	}
 
 	/* some CPU families (e.g. family 0x11) do not support GART */
 	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
@@ -182,20 +182,20 @@ static int amd_cache_gart(void)
 {
 	u16 i;
 
-       if (!amd_nb_has_feature(AMD_NB_GART))
-               return 0;
+	if (!amd_nb_has_feature(AMD_NB_GART))
+		return 0;
 
-       flush_words = kmalloc(amd_nb_num() * sizeof(u32), GFP_KERNEL);
-       if (!flush_words) {
-               amd_northbridges.flags &= ~AMD_NB_GART;
-               return -ENOMEM;
-       }
+	flush_words = kmalloc(amd_nb_num() * sizeof(u32), GFP_KERNEL);
+	if (!flush_words) {
+		amd_northbridges.flags &= ~AMD_NB_GART;
+		return -ENOMEM;
+	}
 
-       for (i = 0; i != amd_nb_num(); i++)
-               pci_read_config_dword(node_to_amd_nb(i)->misc, 0x9c,
-                                     &flush_words[i]);
+	for (i = 0; i != amd_nb_num(); i++)
+		pci_read_config_dword(node_to_amd_nb(i)->misc, 0x9c,
+				      &flush_words[i]);
 
-       return 0;
+	return 0;
 }
 
 void amd_flush_garts(void)
-- 
1.7.3.4

