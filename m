Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2E2NjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:39:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:55463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab2E2NjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:39:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158216589"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        devel@linuxdriverproject.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/4 V2] mei: mei.txt: minor grammar fixes
Date: Tue, 29 May 2012 16:39:09 +0300
Message-Id: <1338298752-15445-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
References: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: just resend
 Documentation/misc-devices/mei/mei.txt |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/misc-devices/mei/mei.txt b/Documentation/misc-devices/mei/mei.txt
index 2785697..6ec7029 100644
--- a/Documentation/misc-devices/mei/mei.txt
+++ b/Documentation/misc-devices/mei/mei.txt
@@ -50,25 +50,25 @@ Intel MEI Driver
 The driver exposes a misc device called /dev/mei.
 
 An application maintains communication with an Intel ME feature while
-/dev/mei is open. The binding to a specific features is performed by calling
+/dev/mei is open. The binding to a specific feature is performed by calling
 MEI_CONNECT_CLIENT_IOCTL, which passes the desired UUID.
 The number of instances of an Intel ME feature that can be opened
 at the same time depends on the Intel ME feature, but most of the
 features allow only a single instance.
 
 The Intel AMT Host Interface (Intel AMTHI) feature supports multiple
-simultaneous user applications. Therefore, the Intel MEI driver handles
-this internally by maintaining request queues for the applications.
+simultaneous user connected applications. The Intel MEI driver
+handles this internally by maintaining request queues for the applications.
 
-The driver is oblivious to data that is passed between firmware feature
+The driver is transparent to data that are passed between firmware feature
 and host application.
 
 Because some of the Intel ME features can change the system
 configuration, the driver by default allows only a privileged
 user to access it.
 
-A code snippet for an application communicating with
-Intel AMTHI client:
+A code snippet for an application communicating with Intel AMTHI client:
+
 	struct mei_connect_client_data data;
 	fd = open(MEI_DEVICE);
 
@@ -185,7 +185,7 @@ The Intel AMT Watchdog is composed of two parts:
 	2) Intel MEI driver - connects to the watchdog feature, configures the
 	   watchdog and sends the heartbeats.
 
-The Intel MEI driver uses the kernel watchdog to configure the Intel AMT
+The Intel MEI driver uses the kernel watchdog API to configure the Intel AMT
 Watchdog and to send heartbeats to it. The default timeout of the
 watchdog is 120 seconds.
 
-- 
1.7.4.4

