Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab1BKD2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 22:28:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36469 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab1BKD2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 22:28:43 -0500
Date: Fri, 11 Feb 2011 14:28:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the edac-amd tree with the tip tree
Message-Id: <20110211142835.5ef24abe.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

Today's linux-next merge of the edac-amd tree got a conflict in
include/linux/pci_ids.h between commit
41b2610c3443e6c4760e61fc10eef73f96f9f6a5 ("x86, amd: Extend AMD
northbridge caching code to support "Link Control" devices") from the tip
tree and commit 3d019f87099415f5f0a2f75b6f828db17e6e9445 ("PCI: Rename
CPU PCI id define") from the edac-amd tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/pci_ids.h
index 5aaf45e,5411e7b..0000000
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@@ -517,8 -517,7 +517,8 @@@
  #define PCI_DEVICE_ID_AMD_11H_NB_DRAM	0x1302
  #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
  #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
- #define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
+ #define PCI_DEVICE_ID_AMD_15H_NB_F3	0x1603
 +#define PCI_DEVICE_ID_AMD_15H_NB_LINK	0x1604
  #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
  #define PCI_DEVICE_ID_AMD_LANCE		0x2000
  #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
