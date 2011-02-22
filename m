Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1BVWWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:22:15 -0500
Received: from kroah.org ([198.145.64.141]:46827 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab1BVWWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:41 2011
Message-Id: <20110222221841.682518876@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robert Richter <robert.richter@amd.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Keir Fraser <keir@xen.org>, Jan Beulich <JBeulich@novell.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [47/70] x86, AMD, PCI: Add AMD northbridge PCI device id for CPU families 12h and 14h
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robert Richter <robert.richter@amd.com>

commit ca86828ccd3128513f6d4e200b437deac95408db upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/pci_ids.h |    1 +
 1 file changed, 1 insertion(+)

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


