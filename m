Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab2HCGam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 02:30:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:48832 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab2HCGaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 02:30:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="192770845"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>
Subject: [PATCH 0/4] PCI/PM: PCI D3cold support fixes for 3.6-rc1
Date: Fri,  3 Aug 2012 14:30:31 +0800
Message-Id: <1343975435-25469-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[BUGFIX 1/4] PCI/PM: enable D3/D3cold by default for most devices
[BUGFIX 2/4] PCI/PM: Keep parent bridge active when probing device
[BUGFIX 3/4] PCI/PM: Fix config reg access for D3cold and bridge suspending
[PATCH 4/4] PCI/PM: Add ABI document for sysfs file d3cold_allowed

Best Regards,
Huang Ying
