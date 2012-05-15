Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2EOHAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:00:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:1227 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab2EOHAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:00:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="140728156"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>, Zheng Yan <zheng.z.yan@intel.com>
Subject: [PATCH -v3 0/2] PCIe: Add PCIe runtime D3cold support
Date: Tue, 15 May 2012 15:00:09 +0800
Message-Id: <1337065211-19525-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is based on the following patch:

[PATCH 1/5] ACPI, PM, Specify lowest allowed state for device sleep state

Changelog:

v3:

- Drop device.power.power_must_be_on, use pci_dev.no_d3cold instead
- Drop device.power.power_off_user, use pci_dev.d3cold_allowed instead
- Use black list instead of white list in pcie port runtime support per request from Bjorn
- Various fixes based on comments from Rafael


v2:

- Refreshed based on comments from Rafael

[PATCH -v3 1/2] PCIe: Add runtime PM support to PCIe port
[PATCH -v3 2/2] PCIe: Add PCIe runtime D3cold support

Best Regards,
Huang Ying
