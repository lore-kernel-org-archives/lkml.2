Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2HFBeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:34:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:16530 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab2HFBee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:34:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193560346"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH -v2 0/4] PCI/PM: PCI D3cold support fixes for 3.6-rc1
Date: Mon,  6 Aug 2012 09:34:26 +0800
Message-Id: <1344216870-21105-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:

v2:

- Change some pm_runtime_put to pm_runtime_put_sync per Alan and Rafael's comments.


[BUGFIX -v2 1/4] PCI/PM: enable D3/D3cold by default for most devices
[BUGFIX -v2 2/4] PCI/PM: Keep parent bridge active when probing device
[BUGFIX -v2 3/4] PCI/PM: Fix config reg access for D3cold and bridge suspending
[PATCH -v2 4/4] PCI/PM: Add ABI document for sysfs file d3cold_allowed
