Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab1BVGnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 01:43:01 -0500
Received: from smtp-out-090.synserver.de ([212.40.185.90]:1067 "EHLO
	smtp-out-090.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab1BVGm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 01:42:59 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 18504
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Pali Rohar <pali.rohar@gmail.com>, Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3 14/16] bq27x00: Minor cleanups
Date: Tue, 22 Feb 2011 07:37:59 +0100
Message-Id: <1298356681-8317-15-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298356681-8317-1-git-send-email-lars@metafoo.de>
References: <1298356681-8317-1-git-send-email-lars@metafoo.de>
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
Tested-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/bq27x00_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 003be5f..b44555f 100644
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
@@ -321,7 +321,7 @@ static int bq27x00_battery_temperature(struct bq27x00_device_info *di,
 }
 
 /*
- * Return the battery average current
+ * Return the battery average current in µA
  * Note that current can be negative signed as well
  * Or 0 if something fails.
  */
-- 
1.7.2.3

