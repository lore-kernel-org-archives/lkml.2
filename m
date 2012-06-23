Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2FWCX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 22:23:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:11162 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab2FWCXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 22:23:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169147090"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Zheng Yan <zheng.z.yan@intel.com>
Subject: [PATCH -v7 0/4] PCIe, PM, Add PCIe runtime D3cold support
Date: Sat, 23 Jun 2012 10:23:47 +0800
Message-Id: <1340418231-10134-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:

v7:

- Rebased on pci.git next branch

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

[PATCH -v7 1/4] ACPI, PM, Specify lowest allowed state for device sleep
[PATCH -v7 2/4] PCIe, PM, Add runtime PM support to PCIe port
[PATCH -v7 3/4] PCI, do not call pci_set_power_state with PCI_D3cold
[PATCH -v7 4/4] PCIe, PM, Add PCIe runtime D3cold support

Best Regards,
Huang Ying
