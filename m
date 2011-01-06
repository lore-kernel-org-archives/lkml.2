Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1AFQvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:51:16 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:21647
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032Ab1AFQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:51:14 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2cK1432N98dN4015Lzz1202hzz8275bhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEM1H6-01-BO9-02
X-M-MSG: 
Date: Thu, 6 Jan 2011 17:51:07 +0100
From: Robert Richter <robert.richter@amd.com>
To: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Keir Fraser <keir@xen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, AMD, PCI: Add AMD northbridge PCI device id for CPU
 families 12h and 14h
Message-ID: <20110106165107.GL4739@erda.amd.com>
References: <4D25A43A020000780002AAD0@vpn.id2.novell.com>
 <C94B4C38.112E5%keir@xen.org>
 <20110106114748.GE4739@erda.amd.com>
 <4D25C54D020000780002AB2B@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D25C54D020000780002AB2B@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.01.11 07:36:13, Jan Beulich wrote:
> >>> On 06.01.11 at 12:47, Robert Richter <robert.richter@amd.com> wrote:

> > But I am fine with a setup with pci access for some nb devices, but
> > would rather leave the setup via msrs as a fallback.
> 
> Okay, I'll craft something long those lines.

Jan,

the patch below implements the PCI nb device id for AMD cpu families
12h and 14h.

Ingo,

please apply to tip. There are some future use cases that use this PCI
device and we would like to clarify its naming.

Thanks,

-Robert

--

>From f791e16fbbf30d1ab6c66ebb8daa77a6c86bda0b Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Thu, 6 Jan 2011 15:01:11 +0100
Subject: [PATCH] x86, AMD, PCI: Add AMD northbridge PCI device id for CPU families 12h and 14h

This patch adds the PCI northbridge device id for AMD CPU families 12h
and 14h. Both families have implemented the same PCI northbridge
device.

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
-- 
1.7.3.4




-- 
Advanced Micro Devices, Inc.
Operating System Research Center

