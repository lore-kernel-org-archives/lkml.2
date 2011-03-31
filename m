Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab1CaHFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:05:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:57474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885Ab1CaHFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:05:01 -0400
Date: Thu, 31 Mar 2011 07:04:41 GMT
From: tip-bot for Borislav Petkov <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        bp@amd64.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bp@amd64.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <20110330183447.GA3668@aftab>
References: <20110330183447.GA3668@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, amd-nb: Rename CPU PCI id define for F4
Message-ID: <tip-cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6@git.kernel.org>
Git-Commit-ID: cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 31 Mar 2011 07:04:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6
Gitweb:     http://git.kernel.org/tip/cb6c8520f6f6bba7b7e1a6de3360a8edfd8243b6
Author:     Borislav Petkov <bp@amd64.org>
AuthorDate: Wed, 30 Mar 2011 20:34:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 31 Mar 2011 08:51:38 +0200

x86, amd-nb: Rename CPU PCI id define for F4

With increasing number of PCI function ids, add the PCI function
id in the define name instead of its symbolic name in the BKDG
for more clarity. This renames function 4 define.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <20110330183447.GA3668@aftab>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/amd_nb.c |    2 +-
 include/linux/pci_ids.h  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 6801959..4c39baa 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -21,7 +21,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
 static struct pci_device_id amd_nb_link_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_LINK) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
 	{}
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 11fd381..4e2c915 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,7 +518,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_NB_F3	0x1603
-#define PCI_DEVICE_ID_AMD_15H_NB_LINK	0x1604
+#define PCI_DEVICE_ID_AMD_15H_NB_F4	0x1604
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
