Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2BZXdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:33:46 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:21136 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2BZXdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:33:45 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/8] PCI: pci_host_bridge related cleanup
Date: Sun, 26 Feb 2012 15:33:14 -0800
Message-Id: <1330299202-3838-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F4AC156.004A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/8] PCI: Separate host_bridge code out from probe.c
[PATCH 2/8] x86, PCI: have own version for pcibios_bus_to_resource
[PATCH 3/8] x86, PCI: Fix memleak with get_current_resources
[PATCH 4/8] PCI: make pci_host_bridge more robust
[PATCH 5/8] PCI: add generic device into pci_host_bridge struct
[PATCH 6/8] PCI: add host bridge release support
[PATCH 7/8] x86, PCI: break down get_current_resource()
[PATCH 8/8] x86, PCI: add host bridge resource release for using _CRS

will add struct device dev into host_bridge struct.

also will add release support to make sure allocated resource get
freed during root bus removal.

Thanks

Yinghai Lu

