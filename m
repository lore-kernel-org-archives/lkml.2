Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3AGHSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:18:41 -0500
Received: from mga03.intel.com ([143.182.124.21]:19149 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab3AGHSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:18:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,422,1355126400"; 
   d="scan'208";a="240732853"
From: Durgadoss R <durgadoss.r@intel.com>
To: rui.zhang@intel.com, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com,
        Durgadoss R <durgadoss.r@intel.com>
Subject: [PATCH 8/9] Thermal: Add ABI Documentation for sysfs interfaces
Date: Mon,  7 Jan 2013 12:43:25 +0530
Message-Id: <1357542806-20449-9-git-send-email-durgadoss.r@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Documentation for ABI's introduced
for thermal subsystem (under /sys/class/thermal/).

Signed-off-by: Durgadoss R <durgadoss.r@intel.com>
---
 Documentation/ABI/testing/sysfs-class-thermal |   93 +++++++++++++++++++++++++
 1 file changed, 93 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-thermal

diff --git a/Documentation/ABI/testing/sysfs-class-thermal b/Documentation/ABI/testing/sysfs-class-thermal
new file mode 100644
index 0000000..d1a450e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-thermal
@@ -0,0 +1,93 @@
+What:		/sys/class/thermal/sensorX/temp
+Date:		January 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Exposes 'temperature' of a thermal sensor in mC
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/sensorX/name
+Date:		January 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Name of the thermal sensor
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/sensorX/thresholdY
+Date:		January 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Programmable threshold (in terms of mC). On reaching
+		this, the thermal governors may take action to control
+		temperature.
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/name
+Date:		January 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Name of the thermal zone.
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/sensorY
+Date:		January 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Symlink to a sensor associated with this zone.
+Users:		User space thermal governors or applications
+
+What:		/sys/class/thermal/zoneX/cooling_deviceY
+Date:		January 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Symlink to a cooling device associated with this zone.
+Users:		User space thermal governors or applications
+
+What:		/sys/class/thermal/zoneX/sensorY_trip_active
+Date:		January 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Space separated list of active trip points for 'sensorY'
+		in 'zoneX' (in mC).
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/sensorY_trip_passive
+Date:		January 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Space separated list of passive trip points for 'sensorY'
+		in 'zoneX' (in mC).
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/sensorY_trip_hot
+Date:		January 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Hot trip point for 'sensorY' in 'zoneX' (in mC).
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/sensorY_trip_critical
+Date:		January 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Critical trip point for 'sensorY' in 'zoneX' (in mC).
+Users:		Kernel/User space thermal governors
+
+What:		/sys/class/thermal/zoneX/mapY
+Date:		January 2013
+KernelVersion:	3.8
+Contact:	Linux PM Mailing list <linux-pm@vger.kernel.org>
+Description:
+		Mapping information between a sensor and a cooling device
+		in 'zoneX'. See Documentation/thermal/sysfs-api2.txt for more
+		information on this interface.
+Users:		Kernel/User space thermal governors
-- 
1.7.9.5

