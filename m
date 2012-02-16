Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2BPH7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 02:59:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab2BPH7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 02:59:09 -0500
From: Thomas Weber <weber@corscience.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Weber <weber@corscience.de>
Subject: [PATCH] [trivial] power: bq27x00: Fix typos in comment
Date: Thu, 16 Feb 2012 08:58:15 +0100
Message-Id: <1329379095-6340-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.8.4
X-Provags-ID: V02:K0:7ZgQwcsjX09/RPHEvzqqeYdQ7LxpBum8HJ5oKxGIw4/
 An4K3Ct8htWQE3u3ScNEMPyF6XTePm8AKosUs0GF+guBctA7N3
 U5DEMhjFjNubrqzMF9Jr3btYKLJU7L/wgE2TeTP+j7/BlwSH7M
 PevObtx8S5rbevVHb7YK9DXepG0E75g+BsHjKG8a3st7137489
 IA2jHPiQI9aYniElSoDR5axgvuAt1JsWF3/VD08cmD02Oygl7F
 l2qTP3iTUAJLIYNxUuexBNxbRF16YH7fuec/cO8cqg7ONtEfN+
 dkl4AkDwanzcc/w5peip8RyjWA93Bl5OGg1y7oC26mab4YuPDu
 pXxM7ul5gwPvpBlIL1qAkb8L3/kJ/NXtvyeLY6LxGYl6skJRc8
 WSFbR3hSP2QCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two typos in comments.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 drivers/power/bq27x00_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 37968a4..f5d6d37 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -47,10 +47,10 @@
 #define BQ27x00_REG_TTE			0x16
 #define BQ27x00_REG_TTF			0x18
 #define BQ27x00_REG_TTECP		0x26
-#define BQ27x00_REG_NAC			0x0C /* Nominal available capaciy */
+#define BQ27x00_REG_NAC			0x0C /* Nominal available capacity */
 #define BQ27x00_REG_LMD			0x12 /* Last measured discharge */
 #define BQ27x00_REG_CYCT		0x2A /* Cycle count total */
-#define BQ27x00_REG_AE			0x22 /* Available enery */
+#define BQ27x00_REG_AE			0x22 /* Available energy */
 
 #define BQ27000_REG_RSOC		0x0B /* Relative State-of-Charge */
 #define BQ27000_REG_ILMD		0x76 /* Initial last measured discharge */
-- 
1.7.8.4

