Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab2AUJws (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 04:52:48 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:42681 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab2AUJwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 04:52:45 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/7] PCI: pcie hotplug related patch
Date: Sat, 21 Jan 2012 01:52:12 -0800
Message-Id: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F1A8AE7.0004,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

b40c9ef: pciehp: Disable/enable link during slot power off/on
fe877ae: pciehp: Add Disable/enable link functions
292e286: pciehp: Add pcie_wait_link_not_active()
186b3fd: pciehp: print out link status when dlla get active.
2781df4: pciehp: Checking pci conf reading to new added device instead of sleep 1s
bf1c4ac: PCI: Separate pci_bus_read_dev_vendor_id from pci_scan_device
601c6f1: PCI: Make sriov work with hotplug remove

 drivers/pci/hotplug/pciehp_hpc.c |  133 +++++++++++++++++++++++++++++++-------
 drivers/pci/pci.h                |    2 +
 drivers/pci/probe.c              |   48 +++++++++-----
 drivers/pci/remove.c             |   28 ++++++++-
 4 files changed, 169 insertions(+), 42 deletions(-)

First one is for hotplug with sriov under bridge.
following two are for hotplug probing with pci conf reading.
Last four are for pcie link disable when power off slots.

Thanks

Yinghai Lu
