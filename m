Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2DWOiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 10:38:23 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:52635 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab2DWOiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 10:38:21 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: Jiang Liu <liuj97@gmail.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v1 0/3] enhance DCA core to support DCA device hotplug
Date: Mon, 23 Apr 2012 22:33:59 +0800
Message-Id: <1335191642-6869-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

When hot-removing PCI host bridges on Intel platforms, all endpoint devices
built in the PCI host bridge (IOH) should be removed too. This patchset
enhances the DCA core logic to support hotplug of Intel Crystall Beach PCI
devices built in the IOH. It also enhances the core to support multiple
PCI root complexes (domains).

The patchset applies to the mainline kernel at
cdd5983 Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost
and it has been tested on an IBM x3850 system.

Jiang Liu (3):
  DCA, x86: fix invalid memory access in DCA core
  DCA, x86: restart DCA operations in unregister_dca_provider()
  DCA, x86: support mutitple PCI root complexes in DCA core logic

 drivers/dca/dca-core.c |  152 ++++++++++++++++++++++++------------------------
 1 files changed, 77 insertions(+), 75 deletions(-)

-- 
1.7.5.4

