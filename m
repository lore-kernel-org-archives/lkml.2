Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967288Ab2ERBsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 21:48:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:10798 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762496Ab2ERBsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 21:48:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145376651"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>, Zheng Yan <zheng.z.yan@intel.com>
Subject: [PATCH -v4 0/2] PCIe: Add PCIe runtime D3cold support
Date: Fri, 18 May 2012 09:48:43 +0800
Message-Id: <1337305725-10482-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is based on the following patch:

[PATCH -v2] ACPI, PM, Specify lowest allowed state for device sleep state

Changelog:

v4:

- Minors fixes based on comments from Rafael

v3:

- Drop device.power.power_must_be_on, use pci_dev.no_d3cold instead
- Drop device.power.power_off_user, use pci_dev.d3cold_allowed instead
- Use black list instead of white list in pcie port runtime support per request from Bjorn
- Various fixes based on comments from Rafael

v2:

- Refreshed based on comments from Rafael

[PATCH -v4 1/2] PCIe: Add runtime PM support to PCIe port
[PATCH -v4 2/2] PCIe: Add PCIe runtime D3cold support

Best Regards,
Huang Ying
