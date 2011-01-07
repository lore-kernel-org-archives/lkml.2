Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab1AGPcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:32:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:54869 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1AGPcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:32:13 -0500
Date: Fri, 7 Jan 2011 15:31:53 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        keir@xen.org, robert.richter@amd.com, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu, xen-devel@lists.xensource.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keir@xen.org, robert.richter@amd.com, JBeulich@novell.com,
        tglx@linutronix.de, xen-devel@lists.xensource.com, mingo@elte.hu
In-Reply-To: <20110106165107.GL4739@erda.amd.com>
References: <20110106165107.GL4739@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, AMD, PCI: Add AMD northbridge PCI device id for CPU families 12h and 14h
Message-ID: <tip-ca86828ccd3128513f6d4e200b437deac95408db@git.kernel.org>
Git-Commit-ID: ca86828ccd3128513f6d4e200b437deac95408db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:31:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ca86828ccd3128513f6d4e200b437deac95408db
Gitweb:     http://git.kernel.org/tip/ca86828ccd3128513f6d4e200b437deac95408db
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Thu, 6 Jan 2011 17:51:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Jan 2011 14:00:14 +0100

x86, AMD, PCI: Add AMD northbridge PCI device id for CPU families 12h and 14h

This patch adds the PCI northbridge device id for AMD CPU
families 12h and 14h. Both families have implemented the same
PCI northbridge device.

There are some future use cases that use this PCI device and
we would like to clarify its naming.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: xen-devel@lists.xensource.com <xen-devel@lists.xensource.com>
Cc: Keir Fraser <keir@xen.org>
Cc: Jan Beulich <JBeulich@novell.com>
LKML-Reference: <20110106165107.GL4739@erda.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/pci_ids.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index cb845c1..dd7d4e2 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,6 +518,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
+#define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
 #define PCI_DEVICE_ID_AMD_SCSI		0x2020
