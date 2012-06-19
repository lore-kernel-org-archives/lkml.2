Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab2FSFUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 01:20:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:34603 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab2FSFUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 01:20:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="157978572"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Zheng Yan <zheng.z.yan@intel.com>
Subject: [PATCH -v6 0/4] PCIe, PM, Add PCIe runtime D3cold support
Date: Tue, 19 Jun 2012 13:20:45 +0800
Message-Id: <1340083249-16266-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:

v6:

- Disable device D3cold during system suspend/hibernate with a new method per Rafeal's comments

v5:

- Disable device D3cold during system suspend/hibernate per Rafael's comments

v4:

- Minors fixes based on comments from Rafael

v3:

- Drop device.power.power_must_be_on, use pci_dev.no_d3cold instead
- Drop device.power.power_off_user, use pci_dev.d3cold_allowed instead
- Use black list instead of white list in pcie port runtime support per request from Bjorn
- Various fixes based on comments from Rafael

v2:

- Refreshed based on comments from Rafael

[PATCH -v6 1/4] ACPI, PM, Specify lowest allowed state for device sleep
[PATCH -v6 2/4] PCIe, PM, Add runtime PM support to PCIe port
[PATCH -v6 3/4] PCI, PM, Do not call pci_set_power_state with PCI_D3cold
[PATCH -v6 4/4] PCIe, PM, Add PCIe runtime D3cold support

Best Regards,
Huang Ying
