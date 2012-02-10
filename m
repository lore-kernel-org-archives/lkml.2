Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050Ab2BJXeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:34:21 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:56267 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab2BJXeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 18:34:18 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3 0/7] PCI : bridge resource reallocation patchset -- followup
Date: Fri, 10 Feb 2012 15:33:45 -0800
Message-Id: <1328916832-6588-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F35A972.001D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1663c18: PCI: only enable pci realloc when SRIOV bar is not assigned
fee9a73: PCI: print out suggestion about using pci=realloc
29266b2: PCI: Make pci bridge reallocating enabled/disabled
9d5e126: PCI: Retry on type IORESOURCE_IO allocation.
837e4eb: PCI: Skip reset cardbus assigned resource during pci bus rescan
fcd3462: PCI: Fix cardbus bridge resources as optional size handling
da81f2e: PCI: Disable cardbus bridge MEM1 pref CTL

are left over after Jesse pickup more of them.
it will try to auto detect if need to use pci=realloc, and print out suggestion.

including fixing some pci carbus handling.

could get from

	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci4


-v3: Resend according to Jesse. Update ack and etc.
     last one add CONFIG_PCI_REALLOC_ENABLE_DETECT according to Jesse.

Thanks

Yinghai

 Documentation/kernel-parameters.txt |    9 ++-
 drivers/pci/Kconfig                 |   10 ++
 drivers/pci/pci.c                   |    4 +-
 drivers/pci/pci.h                   |    2 +-
 drivers/pci/setup-bus.c             |  159 +++++++++++++++++++++++++----------
 5 files changed, 136 insertions(+), 48 deletions(-)

