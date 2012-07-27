Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2G0IHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 04:07:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:53305 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab2G0IHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 04:07:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="172107134"
From: Huang Ying <ying.huang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Mork <bjorn@mork.no>, Huang Ying <ying.huang@intel.com>
Subject: [RFC] PCI/PM: Add ABI document for sysfs file d3cold_allowed
Date: Fri, 27 Jul 2012 16:07:34 +0800
Message-Id: <1343376454-28520-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds ABI document for the following sysfs file:

/sys/bus/pci/devices/.../d3cold_allowed

Signed-off-by: Huang Ying <ying.huang@intel.com>
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
+		device may be put into D3Cold state if other requirement are
+		satisfied too.  Reading this attribute will show the current
+		value of d3cold_allowed bit.  Writting this attribute will set
+		the value of d3cold_allowed bit.
