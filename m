Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab1DLHo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:44:26 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.182]:39082
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755575Ab1DLHoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:44:13 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJJ45I-01-G4R-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
Subject: [PATCH 0/2] AMD IOMMU Extended feature base support v2
Date: Tue, 12 Apr 2011 09:44:00 +0200
Message-ID: <1302594242-25402-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the updated version of the patch-set to add detection for
extended features to the AMD IOMMU driver. This version addresses the
review comments I received on the last version of this patch-set.

Any further feedback appreciated.

Regards,

	Joerg

Diffstat:

 arch/x86/include/asm/amd_iommu_proto.h |   10 +++++++++-
 arch/x86/include/asm/amd_iommu_types.h |   18 ++++++++++++++++++
 arch/x86/kernel/amd_iommu.c            |   24 ++++++++++++++++++++++--
 arch/x86/kernel/amd_iommu_init.c       |   24 ++++++++++++++++++++++--
 4 files changed, 71 insertions(+), 5 deletions(-)

Shortlog:

Joerg Roedel (2):
      x86/amd-iommu: Add extended feature detection
      x86/amd-iommu: Add support for invalidate_all command


