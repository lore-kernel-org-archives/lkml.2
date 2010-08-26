Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0HZPye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:54:34 -0400
Received: from imr3.ericy.com ([198.24.6.13]:34186 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab0HZPyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:54:32 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>, linux-doc@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH] hwmon: Add tempX_emergency to sysfs ABI
Date: Thu, 26 Aug 2010 08:54:45 -0700
Message-ID: <1282838085-7210-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
tempX_emergency will be used by max6696. It can also be used for other chips
supporting three upper temperature limits.

 Documentation/hwmon/sysfs-interface |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
index ff45d1f..1ceb2b9 100644
--- a/Documentation/hwmon/sysfs-interface
+++ b/Documentation/hwmon/sysfs-interface
@@ -310,6 +310,12 @@ temp[1-*]_crit_hyst
 		from the critical value.
 		RW
 
+temp[1-*]_emergency
+		Temperature emergency value, typically greater than
+		corresponding temp_crit values.
+		Unit: millidegree Celsius
+		RW
+
 temp[1-*]_lcrit	Temperature critical min value, typically lower than
 		corresponding temp_min values.
 		Unit: millidegree Celsius
-- 
1.7.0.87.g0901d

