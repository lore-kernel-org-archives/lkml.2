Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1BFTgh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 14:36:37 -0500
Received: from smtp-out-015.synserver.de ([212.40.185.15]:1279 "HELO
	smtp-out-014.synserver.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753875Ab1BFTgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 14:36:35 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24265
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 12/14] POWER: bq27x00: Minor cleanups
Date: Sun,  6 Feb 2011 01:48:09 +0100
Message-Id: <1296953291-10373-13-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296953291-10373-1-git-send-email-lars@metafoo.de>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

* Consistently use uppercase for hexadecimal values.
* Clarify/fix the unit of functions return value in its comment.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/bq27x00_battery.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 961238f..83904a2 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -56,7 +56,7 @@
 #define BQ27000_FLAG_CHGS		BIT(7)
 #define BQ27000_FLAG_FC			BIT(5)
 
-#define BQ27500_REG_SOC			0x2c
+#define BQ27500_REG_SOC			0x2C
 #define BQ27500_REG_DCAP		0x3C /* Design capacity */
 #define BQ27500_FLAG_DSC		BIT(0)
 #define BQ27500_FLAG_FC			BIT(9)
@@ -136,7 +136,7 @@ static inline int bq27x00_read(struct bq27x00_device_info *di, u8 reg,
 }
 
 /*
- * Return the battery Voltage in milivolts
+ * Return the battery Voltage in µV
  * Or < 0 if something fails.
  */
 static int bq27x00_battery_read_voltage(struct bq27x00_device_info *di)
@@ -349,7 +349,7 @@ static int bq27x00_battery_temperature(struct bq27x00_device_info *di,
 }
 
 /*
- * Return the battery average current
+ * Return the battery average current in µA
  * Note that current can be negative signed as well
  * Or 0 if something fails.
  */
-- 
1.7.2.3

