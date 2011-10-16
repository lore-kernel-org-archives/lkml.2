Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab1JPBb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 21:31:27 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17136 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1JPBb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 21:31:26 -0400
Message-ID: <4E9A33D5.2040307@oracle.com>
Date: Sat, 15 Oct 2011 18:31:01 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8] pci: hotplug and rescan related patches
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E9A33ED.0098:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most are to make hotplug and rescan path to use optional resource add_size too.

[PATCH 1/8] pci: Make sriov work with hotplug removal
[PATCH 2/8] pci: Calculate right add_size
[PATCH 3/8] pci: Try to assign required+option size at first
[PATCH 4/8] PCI: Using add_list in pcie hotplug path
[PATCH 5/8] PCI: Make rescan bus could increase bridge resource size if needed
[PATCH 6/8] PCI: Make pci_rescan_bus handle add_list
[PATCH 7/8] PCI, sysfs: merge dev and bus cpuaffinity show handling
[PATCH 8/8] PCI, sys: only create rescan under /sys/.../pci/devices/... for pci bridges

last 5 are resending.

Thanks

Yinghai Lu




