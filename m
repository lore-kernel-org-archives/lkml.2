Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab3AHQwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:52:40 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:53203 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab3AHQwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:52:37 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 0/6] Update PCI notification patchset to latest kernel version
Date: Wed,  9 Jan 2013 00:52:19 +0800
Message-Id: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CAErSpo4G9FQxh1vPjDDnjYrkfV8MNFvBK-ECMeiPnCVGA5Lgjg@mail.gmail.com>
References: <CAErSpo4G9FQxh1vPjDDnjYrkfV8MNFvBK-ECMeiPnCVGA5Lgjg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,
	Rafael has developed a patchset targetting 3.9 merging window 
which outdates the fourth and fifth patches in my previous version,
so I have just drop those two patches and updated the others to the
latest code from your pci-next branch.
	Thanks!

Jiang Liu (5):
  PCI: make PCI device create/destroy logic symmetric
  PCI: split registration of PCI bus devices into two stages
  ACPI/pci_slot: update PCI slot information when PCI hotplug event
    happens
  PCI/acpiphp: update ACPI hotplug slot information when PCI hotplug
    happens
  PCI/acpiphp: serialize access to the bridge_list list

Yijing Wang (1):
  PCI/AER: update AER configuration when PCI hotplug event happens

 drivers/acpi/pci_slot.c            |   86 ++++++++++++++++++++++++++++++++----
 drivers/pci/bus.c                  |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c |   73 +++++++++++++++++++++++++++++-
 drivers/pci/pcie/aer/aerdrv.c      |   63 +++++++++++++++++++++++++-
 drivers/pci/probe.c                |    5 ++-
 drivers/pci/remove.c               |   14 +++---
 6 files changed, 222 insertions(+), 21 deletions(-)

-- 
1.7.9.5

