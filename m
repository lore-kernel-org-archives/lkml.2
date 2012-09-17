Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2IQIyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:54:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:12419 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492Ab2IQIys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:54:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,434,1344236400"; 
   d="scan'208";a="222936818"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>
Subject: [RFC 0/3] PCI/PM: RTD3 fixes/changes for 3.7
Date: Mon, 17 Sep 2012 16:54:33 +0800
Message-Id: <1347872076-5260-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RFC 1/3] PCI/PM: Fix kexec for D3cold and bridge suspending
[RFC 2/3] PCI/PM: Make PCI devices notified when its power
[RFC 3/3] PCI/PM: Disable PME poll for PCIe devices

Best Regards,
Huang Ying
