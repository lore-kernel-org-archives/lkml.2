Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178Ab2J2Ru7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:50:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51193 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab2J2Ru4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:50:56 -0400
Date: Mon, 29 Oct 2012 18:50:47 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>
Cc: lm-sensors@lm-sensors.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        oprofile-list@lists.sf.net, Stephane Eranian <eranian@google.com>,
        Robert Richter <rric@kernel.org>, Borislav Petkov <bp@alien8.de>,
        =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
Subject: [PATCH 1/4] hwmon, fam15h_power: Change email address, MAINTAINERS
 entry
Message-ID: <20121029175047.GB5024@tweety>
References: <20121029174924.GA5024@tweety>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029174924.GA5024@tweety>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <herrmann.der.user@googlemail.com>
---
 Documentation/hwmon/fam15h_power |    2 +-
 MAINTAINERS                      |    2 +-
 drivers/hwmon/fam15h_power.c     |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/hwmon/fam15h_power b/Documentation/hwmon/fam15h_power
index a92918e..8065481 100644
--- a/Documentation/hwmon/fam15h_power
+++ b/Documentation/hwmon/fam15h_power
@@ -10,7 +10,7 @@ Supported chips:
   BIOS and Kernel Developer's Guide (BKDG) For AMD Family 15h Processors
     (not yet published)
 
-Author: Andreas Herrmann <andreas.herrmann3@amd.com>
+Author: Andreas Herrmann <herrmann.der.user@googlemail.com>
 
 Description
 -----------
diff --git a/MAINTAINERS b/MAINTAINERS
index 1fa9074..a4e8136 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -503,7 +503,7 @@ F:	include/linux/altera_uart.h
 F:	include/linux/altera_jtaguart.h
 
 AMD FAM15H PROCESSOR POWER MONITORING DRIVER
-M:	Andreas Herrmann <andreas.herrmann3@amd.com>
+M:	Andreas Herrmann <herrmann.der.user@googlemail.com>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/fam15h_power
diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 68ad7d2..4f41104 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -2,7 +2,7 @@
  * fam15h_power.c - AMD Family 15h processor power monitoring
  *
  * Copyright (c) 2011 Advanced Micro Devices, Inc.
- * Author: Andreas Herrmann <andreas.herrmann3@amd.com>
+ * Author: Andreas Herrmann <herrmann.der.user@googlemail.com>
  *
  *
  * This driver is free software; you can redistribute it and/or
@@ -28,7 +28,7 @@
 #include <asm/processor.h>
 
 MODULE_DESCRIPTION("AMD Family 15h CPU processor power monitor");
-MODULE_AUTHOR("Andreas Herrmann <andreas.herrmann3@amd.com>");
+MODULE_AUTHOR("Andreas Herrmann <herrmann.der.user@googlemail.com>");
 MODULE_LICENSE("GPL");
 
 /* D18F3 */
-- 
1.7.9.5

