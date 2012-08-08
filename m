Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2HHBHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 21:07:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:40862 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab2HHBHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 21:07:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="182925478"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH -v3 0/4] PCI/PM: PCI D3cold support fixes for 3.6-rc1
Date: Wed,  8 Aug 2012 09:07:37 +0800
Message-Id: <1344388061-18981-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:

v3:

- Add some comments per Rafael's comments.

v2:

- Change some pm_runtime_put to pm_runtime_put_sync per Alan and Rafael's comments.


[BUGFIX -v3 1/4] PCI/PM: enable D3/D3cold by default for most devices
[BUGFIX -v3 2/4] PCI/PM: Keep parent bridge active when probing device
[BUGFIX -v3 3/4] PCI/PM: Fix config reg access for D3cold and bridge suspending
[PATCH -v3 4/4] PCI/PM: Add ABI document for sysfs file d3cold_allowed

Best Regards,
Huang Ying
