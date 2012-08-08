Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2HHBIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 21:08:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:40862 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab2HHBHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 21:07:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="182925521"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH -v3 4/4] PCI/PM: Add ABI document for sysfs file d3cold_allowed
Date: Wed,  8 Aug 2012 09:07:41 +0800
Message-Id: <1344388061-18981-5-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344388061-18981-1-git-send-email-ying.huang@intel.com>
References: <1344388061-18981-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds ABI document for the following sysfs file:

/sys/bus/pci/devices/.../d3cold_allowed

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/ABI/testing/sysfs-bus-pci |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -210,3 +210,15 @@ Users:
 		firmware assigned instance number of the PCI
 		device that can help in understanding the firmware
 		intended order of the PCI device.
+
+What:		/sys/bus/pci/devices/.../d3cold_allowed
+Date:		July 2012
+Contact:	Huang Ying <ying.huang@intel.com>
+Description:
+		d3cold_allowed is bit to control whether the corresponding PCI
+		device can be put into D3Cold state.  If it is cleared, the
+		device will never be put into D3Cold state.  If it is set, the
+		device may be put into D3Cold state if other requirements are
+		satisfied too.  Reading this attribute will show the current
+		value of d3cold_allowed bit.  Writing this attribute will set
+		the value of d3cold_allowed bit.
