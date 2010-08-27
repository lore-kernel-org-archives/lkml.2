Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0H0JL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:11:57 -0400
Received: from imr3.ericy.com ([198.24.6.13]:50574 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab0H0JLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:11:55 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <rdunlap@xenotime.net>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>, linux-doc@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2] hwmon: Add tempX_emergency attribute to sysfs ABI
Date: Fri, 27 Aug 2010 02:11:49 -0700
Message-ID: <1282900309-17074-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
v2: Re-phrased attribute description

 Documentation/hwmon/sysfs-interface |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
index ff45d1f..101300b 100644
--- a/Documentation/hwmon/sysfs-interface
+++ b/Documentation/hwmon/sysfs-interface
@@ -310,6 +310,13 @@ temp[1-*]_crit_hyst
 		from the critical value.
 		RW
 
+temp[1-*]_emergency
+		Temperature emergency max value, for chips supporting more than
+		two upper temperature limits. Must be equal or greater than
+		corresponding temp_crit values.
+		Unit: millidegree Celsius
+		RW
+
 temp[1-*]_lcrit	Temperature critical min value, typically lower than
 		corresponding temp_min values.
 		Unit: millidegree Celsius
-- 
1.7.0.87.g0901d

