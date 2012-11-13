Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2KMJHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:07:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53096 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2KMJHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:07:46 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc: tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, andi@firstfloor.org, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de, yinghai@kernel.org,
        mingo@redhat.com, Takao Indoh <indou.takao@jp.fujitsu.com>,
        khalid@gonehiking.org
Message-Id: <20121113090231.1180.67284.sendpatchset@indoh>
In-Reply-To: <20121113090212.1180.12233.sendpatchset@indoh>
References: <20121113090212.1180.12233.sendpatchset@indoh>
Subject: [PATCH v6 2/5] PCI: Define the maximum number of PCI function
Date: Tue, 13 Nov 2012 18:07:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the maximum number of PCI function so that PCI functions can be
enumerated without using "8".

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
---
 include/linux/pci.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index ee21795..eca3231 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -35,6 +35,8 @@
 /* Include the ID list */
 #include <linux/pci_ids.h>
 
+#define PCI_MAX_FUNCTIONS 8
+
 /* pci_slot represents a physical slot */
 struct pci_slot {
 	struct pci_bus *bus;		/* The bus this slot is on */
-- 
1.7.1


