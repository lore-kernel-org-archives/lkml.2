Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1DAI6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 04:58:38 -0400
Received: from smtp.nokia.com ([147.243.128.26]:42823 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab1DAI6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 04:58:36 -0400
From: Ameya Palande <ameya.palande@nokia.com>
To: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH] Documentation: Add Documentation/leds/00-INDEX
Date: Fri,  1 Apr 2011 11:58:34 +0300
Message-Id: <1301648314-3441-1-git-send-email-ameya.palande@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110331084420.47eaa91c.rdunlap@xenotime.net>
References: <20110331084420.47eaa91c.rdunlap@xenotime.net>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
---
 Documentation/leds/00-INDEX |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/leds/00-INDEX

diff --git a/Documentation/leds/00-INDEX b/Documentation/leds/00-INDEX
new file mode 100644
index 0000000..762d676
--- /dev/null
+++ b/Documentation/leds/00-INDEX
@@ -0,0 +1,10 @@
+00-INDEX
+	- This file
+leds-class.txt
+	- Info about led sysfs class
+leds-lp3944.txt
+	- Info on National Semiconductor LP3944 fun-light chip
+leds-lp5521.txt
+	- Info on National Semiconductor LP5521 led driver chip
+leds-lp5523.txt
+	- Info on National Semiconductor LP5523 led driver chip
-- 
1.7.1

