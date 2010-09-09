Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0IINWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 09:22:43 -0400
Received: from imr3.ericy.com ([198.24.6.13]:58442 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab0IINWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:22:39 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v2 1/7] hwmon: Add tempX_emergency_alarm attribute to sysfs ABI
Date: Thu, 9 Sep 2010 06:25:44 -0700
Message-ID: <1284038750-8833-2-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
References: <1284038750-8833-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 Documentation/hwmon/sysfs-interface |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
index 101300b..22843cb 100644
--- a/Documentation/hwmon/sysfs-interface
+++ b/Documentation/hwmon/sysfs-interface
@@ -513,6 +513,7 @@ fan[1-*]_max_alarm
 temp[1-*]_min_alarm
 temp[1-*]_max_alarm
 temp[1-*]_crit_alarm
+temp[1-*]_emergency_alarm
 		Limit alarm
 		0: no alarm
 		1: alarm
-- 
1.7.0.87.g0901d

