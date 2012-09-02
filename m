Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2IBVry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:47:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:32859 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab2IBVrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:47:52 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH part1 0/4] PCI: pci root bus hotplug support - part1
Date: Sun,  2 Sep 2012 14:47:34 -0700
Message-Id: <1346622458-30595-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is based on pci/next

Add back some functions for pci remove.

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug-part1

Yinghai Lu (4):
  PCI, pciehp: Turn on link again after power off the slot
  PCI, acpiphp: Add is_hotplug_bridge detection
  PCI: Add root bus children dev's res to fail list
  PCI: Split out stop_bus_device and remove_bus_dev again.

 drivers/pci/hotplug/acpiphp_glue.c |   27 ++++++++++++-
 drivers/pci/hotplug/pciehp_hpc.c   |    2 +
 drivers/pci/remove.c               |   77 ++++++++++++++++++++++++++++-------
 drivers/pci/setup-bus.c            |    2 +-
 include/linux/pci.h                |    2 +
 5 files changed, 92 insertions(+), 18 deletions(-)

-- 
1.7.7

