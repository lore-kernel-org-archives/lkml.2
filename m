Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1I0N6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:58:55 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:17994
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964Ab1I0N6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:58:53 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LS6PFM-01-27K-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 0/4 v2] PCI: Add support for PASID capability
Date: Tue, 27 Sep 2011 15:57:12 +0200
Message-ID: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the second version of the patch-set implementing support for the
PRI and PASID capabilities into the Linux kernel.  These capabilities of
a PCIe device are tightly coupled with ATS, but not with IOV. So these
patches start by moving the ATS code into its own file: ats.c.

Support for the other two capabilities is based on that change.

Regards,

	Joerg

Changes to v1:

	* Improved Kconfig help-text for PASID
	* Some editing in the commit messages

Diffstat:

 drivers/pci/Kconfig      |   26 +++
 drivers/pci/Makefile     |    1 +
 drivers/pci/ats.c        |  438 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/iov.c        |  142 ---------------
 include/linux/pci-ats.h  |   75 ++++++++
 include/linux/pci_regs.h |   20 ++
 6 files changed, 560 insertions(+), 142 deletions(-)


