Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1GGVAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:00:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1GGVAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:00:37 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH] PCI: Assign values to 'pci_obff_signal_type' enumeration
	constants
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Jul 2011 15:00:36 -0600
Message-ID: <20110707210036.696.13836.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <mstowe@redhat.com>

'pci_obff_signal_type' is passed between drivers and the kernel API.
This patch explicitly assigns values to the enumeration type's constants
which aids in detecting any future changes or additions that would break
the kernel's ABI.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 include/linux/pci.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index c446b5c..6e96015 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -843,8 +843,8 @@ void pci_enable_ido(struct pci_dev *dev, unsigned long type);
 void pci_disable_ido(struct pci_dev *dev, unsigned long type);
 
 enum pci_obff_signal_type {
-	PCI_EXP_OBFF_SIGNAL_L0,
-	PCI_EXP_OBFF_SIGNAL_ALWAYS,
+	PCI_EXP_OBFF_SIGNAL_L0 = 0,
+	PCI_EXP_OBFF_SIGNAL_ALWAYS = 1,
 };
 int pci_enable_obff(struct pci_dev *dev, enum pci_obff_signal_type);
 void pci_disable_obff(struct pci_dev *dev);

