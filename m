Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1JQLxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:53:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61667 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab1JQLxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:53:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, linus.walleij@stericsson.com, jamie@jamieiles.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/6] Documentation: add information for new sysfs soc bus functionality
Date: Mon, 17 Oct 2011 12:52:55 +0100
Message-Id: <1318852378-14180-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change applies the required documentation for each new
attribute recenty added by the new System-On-Chip (SoC)
information export bus driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/ABI/testing/sysfs-devices-soc |   48 +++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-soc

diff --git a/Documentation/ABI/testing/sysfs-devices-soc b/Documentation/ABI/testing/sysfs-devices-soc
new file mode 100644
index 0000000..549cbda
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-soc
@@ -0,0 +1,48 @@
+What:		/sys/devices/socX
+Date:		October 2011
+contact:	Lee Jones <lee.jones@linaro.org>
+Description:
+		The /sys/devices/ directory contains a sub-directory for each
+		System-on-Chip (SoC) device on a running platform. Information
+		regarding each SoC can be obtained by reading sysfs files. This
+		functionality is only available if implemented by the platform.
+
+		The directory created for each SoC will also house information
+		about devices which are commonly contained in /sys/devices/platform.
+		It has been agreed that if an SoC device exists, its supported
+		devices would be better suited to appear as children of that SoC.
+
+What:		/sys/devices/socX/machine
+Date:		October 2011
+contact:	Lee Jones <lee.jones@linaro.org>
+Description:
+		Read-only attribute common to all SoCs. Contains the SoC machine
+		name (e.g. Ux500).
+
+What:		/sys/devices/socX/family
+Date:		October 2011
+contact:	Lee Jones <lee.jones@linaro.org>
+Description:
+		Read-only attribute common to all SoCs. Contains SoC family name
+		(e.g. DB8500).
+
+What:		/sys/devices/socX/soc_id
+Date:		October 2011
+contact:	Lee Jones <lee.jones@linaro.org>
+Description:
+		Read-only attribute supported by most SoCs. In the case of
+		ST-Ericsson's chips this contains the SoC serial number.
+
+What:		/sys/devices/socX/revision
+Date:		October 2011
+contact:	Lee Jones <lee.jones@linaro.org>
+Description:
+		Read-only attribute supported by most SoCs. Contains the SoC's
+		manufacturing revision number.
+
+What:		/sys/devices/socX/process
+Date:		October 2011
+contact:	Lee Jones <lee.jones@linaro.org>
+Description:
+		Read-only attribute supported ST-Ericsson's silicon. Contains the
+		the process by which the silicon chip was manufactured.
-- 
1.7.5.4

