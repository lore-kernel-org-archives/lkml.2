Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab1CDR5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:57:08 -0500
Received: from imr3.ericy.com ([198.24.6.13]:37361 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497Ab1CDR5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:57:03 -0500
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ian Dobson <i.dobson@planet-ian.com>, Andy Lutomirski <luto@mit.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, <binximeng@gmail.com>,
        <lmsensors@tapanitarvainen.fi>, <andrea.rizzolo@gmail.com>,
        <jeff.sadowski@gmail.com>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v5 05/11] hwmon: (w83627ehf) Remove references to datasheets which no longer exist
Date: Fri, 4 Mar 2011 09:58:00 -0800
Message-ID: <1299261486-15190-6-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
References: <1299261486-15190-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 Documentation/hwmon/w83627ehf |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/hwmon/w83627ehf b/Documentation/hwmon/w83627ehf
index 0643019..b634e98 100644
--- a/Documentation/hwmon/w83627ehf
+++ b/Documentation/hwmon/w83627ehf
@@ -5,13 +5,11 @@ Supported chips:
   * Winbond W83627EHF/EHG (ISA access ONLY)
     Prefix: 'w83627ehf'
     Addresses scanned: ISA address retrieved from Super I/O registers
-    Datasheet:
-        http://www.nuvoton.com.tw/NR/rdonlyres/A6A258F0-F0C9-4F97-81C0-C4D29E7E943E/0/W83627EHF.pdf
+    Datasheet: not available
   * Winbond W83627DHG
     Prefix: 'w83627dhg'
     Addresses scanned: ISA address retrieved from Super I/O registers
-    Datasheet:
-        http://www.nuvoton.com.tw/NR/rdonlyres/7885623D-A487-4CF9-A47F-30C5F73D6FE6/0/W83627DHG.pdf
+    Datasheet: not available
   * Winbond W83627DHG-P
     Prefix: 'w83627dhg'
     Addresses scanned: ISA address retrieved from Super I/O registers
-- 
1.7.3.1

