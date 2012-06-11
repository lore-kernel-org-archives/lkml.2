Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab2FKCrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 22:47:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:54842 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab2FKCrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 22:47:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="151117056"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        Zheng Yan <zheng.z.yan@intel.com>
Subject: [PATCH -v5 0/3] PCIe, PM, Add PCIe runtime D3cold support
Date: Mon, 11 Jun 2012 10:47:10 +0800
Message-Id: <1339382833-7928-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:

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

[PATCH -v5 1/3] ACPI, PM, Specify lowest allowed state for device sleep
[PATCH -v5 2/3] PCIe, PM, Add runtime PM support to PCIe port
[PATCH -v5 3/3] PCIe, PM, Add PCIe runtime D3cold support
