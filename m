Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab1BJRQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:16:17 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44681 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab1BJRQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:16:10 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 27/30] PCI: Rename CPU PCI id define
Date: Thu, 10 Feb 2011 18:15:30 +0100
Message-Id: <1297358133-14320-28-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

With increasing number of PCI function ids, add the PCI function id
in the define name instead of its symbolic name in the BKDG for more
clarity.

Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/amd_nb.c |    2 +-
 include/linux/pci_ids.h  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 0a99f71..863e062 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -15,7 +15,7 @@ static u32 *flush_words;
 struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{}
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3adb06e..5411e7b 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -517,7 +517,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_DRAM	0x1302
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
-#define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
+#define PCI_DEVICE_ID_AMD_15H_NB_F3	0x1603
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
-- 
1.7.4.rc2

