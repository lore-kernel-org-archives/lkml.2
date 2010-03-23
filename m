Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab0CWUld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:41:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52757 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab0CWUl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:41:29 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, alan@lxorguk.ukuu.org.uk
Cc: pavan_savoy@ti.com, linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in
Subject: [PATCH 7/7] Documentation/ABI: for N_TI_SHARED ldisc
Date: Tue, 23 Mar 2010 15:41:15 -0500
Message-Id: <1269376875-25940-8-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1269376875-25940-7-git-send-email-pavan_savoy@ti.com>
References: <1269376875-25940-1-git-send-email-pavan_savoy@ti.com>
 <1269376875-25940-2-git-send-email-pavan_savoy@ti.com>
 <1269376875-25940-3-git-send-email-pavan_savoy@ti.com>
 <1269376875-25940-4-git-send-email-pavan_savoy@ti.com>
 <1269376875-25940-5-git-send-email-pavan_savoy@ti.com>
 <1269376875-25940-6-git-send-email-pavan_savoy@ti.com>
 <1269376875-25940-7-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

N_TI_SHARED creates a sysfs entry to communicate
with the application/daemon which would want to install/
un-install the line discipline, it's documentation
now exists in testing/ subdirectory.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 Documentation/ABI/testing/sysfs-uim |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-uim

diff --git a/Documentation/ABI/testing/sysfs-uim b/Documentation/ABI/testing/sysfs-uim
new file mode 100644
index 0000000..899aa4d
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-uim
@@ -0,0 +1,24 @@
+What:           /sys/uim
+Date:           March 22
+Contact:        Pavan Savoy <pavan_savoy@ti.com>
+Description:
+                Create a new kobject to pass information about the
+		N_TI_SHARED line discipline created to application/daemon
+		which would install/un-install line discipline.
+
+What:           /sys/uim/pid
+Date:           March 22
+Contact:        Pavan Savoy <pavan_savoy@ti.com>
+Description:
+		The daemon/application wanting to use the line discipline
+		N_TI_SHARED will write in it's process Id, for the LDISC
+		driver to send SIGUSR2 signal to the process whenever a
+		upper layer protocol driver wants to make use of the LDISC
+		driver.
+
+What:           /sys/uim/protocols
+Date:           March 22
+Contact:        Pavan Savoy <pavan_savoy@ti.com>
+Description:
+		List the protocols currently making use of the LDISC to ensure
+		LDISC is not un-installed when BT/FM or GPS is making use of it.
-- 
1.5.4.3

