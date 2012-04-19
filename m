Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab2DSMGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 08:06:42 -0400
Received: from smtp.nokia.com ([147.243.1.47]:17731 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab2DSMGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 08:06:39 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linus.walleij@linaro.org, artem.bityutskiy@linux.intel.com,
        shubhrajyoti@ti.com
Subject: [PATCH 6/6] HSI: Add HSI ABI documentation
Date: Thu, 19 Apr 2012 15:05:27 +0300
Message-Id: <1334837127-12931-7-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
References: <1334837127-12931-1-git-send-email-carlos.chinea@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds sysfs HSI framework documentation

Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 Documentation/ABI/testing/sysfs-bus-hsi |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-hsi

diff --git a/Documentation/ABI/testing/sysfs-bus-hsi b/Documentation/ABI/testing/sysfs-bus-hsi
new file mode 100644
index 0000000..1b1b282
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-hsi
@@ -0,0 +1,19 @@
+What:		/sys/bus/hsi
+Date:		April 2012
+KernelVersion:	3.4
+Contact:	Carlos Chinea <carlos.chinea@nokia.com>
+Description:
+		High Speed Synchronous Serial Interface (HSI) is a
+		serial interface mainly used for connecting application
+		engines (APE) with cellular modem engines (CMT) in cellular
+		handsets.
+		The bus will be populated with devices (hsi_clients) representing
+		the protocols available in the system. Bus drivers implement
+		those protocols.
+
+What:		/sys/bus/hsi/devices/.../modalias
+Date:		April 2012
+KernelVersion:	3.4
+Contact:	Carlos Chinea <carlos.chinea@nokia.com>
+Description:	Stores the same MODALIAS value emitted by uevent
+		Format: hsi:<hsi_client device name>
-- 
1.7.5.4

