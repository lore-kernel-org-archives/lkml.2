Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab1ABOVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 09:21:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53140 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab1ABOVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 09:21:46 -0500
From: Stefan Weil <weil@mail.berlios.de>
Cc: Stefan Weil <weil@mail.berlios.de>, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix spelling milisecond -> millisecond in comments and debug messages
Date: Sun,  2 Jan 2011 15:21:41 +0100
Message-Id: <1293978101-5252-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:6eG7W5Vu8sFGEHzLLEIK89XukRhk1yTQtOARBYrcTOq
 bL3VIQE3aREisRpMPEI0cJKo53nfVdulGhq1GHjo9aOnMb7CkK
 KbqoM3cSyMAM7eLa+PVZ1T/5pSz+3O1rK9hxvGbpdk0HAakJL2
 2IS78YTd4OXB1+Qz66DPtqd1k27HHppSHUrjfc0LGRGtrTPwxt
 2p47c9bUu6439OxhgG/fDqQ6oZ3i/UqGfKVVGtDAAAYEhfEzMa
 YwqJosL/uUsiW
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 arch/arm/mach-bcmring/include/csp/tmrHw.h |    4 ++--
 drivers/acpi/apei/einj.c                  |    2 +-
 drivers/acpi/apei/erst.c                  |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c    |    4 ++--
 drivers/net/wireless/wl1251/wl1251.h      |    2 +-
 drivers/net/wireless/wl12xx/wl1271.h      |    4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-bcmring/include/csp/tmrHw.h b/arch/arm/mach-bcmring/include/csp/tmrHw.h
index f1236d0..2cbb530 100644
--- a/arch/arm/mach-bcmring/include/csp/tmrHw.h
+++ b/arch/arm/mach-bcmring/include/csp/tmrHw.h
@@ -76,7 +76,7 @@ tmrHw_RATE_t tmrHw_setPeriodicTimerRate(tmrHw_ID_t timerId,	/*  [ IN ] Timer Id
 *           certain time interval
 *
 *  This function initializes a periodic timer to generate timer interrupt
-*  after every time interval in milisecond
+*  after every time interval in millisecond
 *
 *  @return   On success: Effective interval set in mili-second
 *            On failure: 0
@@ -93,7 +93,7 @@ tmrHw_INTERVAL_t tmrHw_setPeriodicTimerInterval(tmrHw_ID_t timerId,	/*  [ IN ] T
 *           after certain time interval
 *
 *  This function initializes a periodic timer to generate a single ticks after
-*  certain time interval in milisecond
+*  certain time interval in millisecond
 *
 *  @return   On success: Effective interval set in mili-second
 *            On failure: 0
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index cf29df6..096aebf 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -39,7 +39,7 @@
 #define EINJ_PFX "EINJ: "
 
 #define SPIN_UNIT		100			/* 100ns */
-/* Firmware should respond within 1 miliseconds */
+/* Firmware should respond within 1 milliseconds */
 #define FIRMWARE_TIMEOUT	(1 * NSEC_PER_MSEC)
 
 /*
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 5850d32..cf6db6b 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -53,7 +53,7 @@
 				     sizeof(struct acpi_table_erst)))
 
 #define SPIN_UNIT		100			/* 100ns */
-/* Firmware should respond within 1 miliseconds */
+/* Firmware should respond within 1 milliseconds */
 #define FIRMWARE_TIMEOUT	(1 * NSEC_PER_MSEC)
 #define FIRMWARE_MAX_STALL	50			/* 50us */
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
index b229357..73c2dab 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -1927,7 +1927,7 @@ init_ltime(struct nvbios *bios, uint16_t offset, struct init_exec *iexec)
 	 * offset      (8  bit): opcode
 	 * offset + 1  (16 bit): time
 	 *
-	 * Sleep for "time" miliseconds.
+	 * Sleep for "time" milliseconds.
 	 */
 
 	unsigned time = ROM16(bios->data[offset + 1]);
@@ -1935,7 +1935,7 @@ init_ltime(struct nvbios *bios, uint16_t offset, struct init_exec *iexec)
 	if (!iexec->execute)
 		return 3;
 
-	BIOSLOG(bios, "0x%04X: Sleeping for 0x%04X miliseconds\n",
+	BIOSLOG(bios, "0x%04X: Sleeping for 0x%04X milliseconds\n",
 		offset, time);
 
 	msleep(time);
diff --git a/drivers/net/wireless/wl1251/wl1251.h b/drivers/net/wireless/wl1251/wl1251.h
index e113d4c..47d2653 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -418,7 +418,7 @@ void wl1251_disable_interrupts(struct wl1251 *wl);
 #define WL1251_FW_NAME "wl1251-fw.bin"
 #define WL1251_NVS_NAME "wl1251-nvs.bin"
 
-#define WL1251_POWER_ON_SLEEP 10 /* in miliseconds */
+#define WL1251_POWER_ON_SLEEP 10 /* in milliseconds */
 
 #define WL1251_PART_DOWN_MEM_START	0x0
 #define WL1251_PART_DOWN_MEM_SIZE	0x16800
diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 8a4cd76..046acb8 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -506,7 +506,7 @@ int wl1271_plt_stop(struct wl1271 *wl);
 
 /* WL1271 needs a 200ms sleep after power on, and a 20ms sleep before power
    on in case is has been shut down shortly before */
-#define WL1271_PRE_POWER_ON_SLEEP 20 /* in miliseconds */
-#define WL1271_POWER_ON_SLEEP 200 /* in miliseconds */
+#define WL1271_PRE_POWER_ON_SLEEP 20 /* in milliseconds */
+#define WL1271_POWER_ON_SLEEP 200 /* in milliseconds */
 
 #endif
-- 
1.7.2.3

