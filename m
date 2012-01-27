Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2A0BqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 20:46:08 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:32472 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2A0Bpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 20:45:52 -0500
X-AuditID: cbfee61a-b7cd2ae000004fa5-44-4f2201cfe262
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Greg KH'" <gregkh@suse.de>
Subject: [PATCH] serial: samsung: Add support serial for EXYNOS4212 and
 EXYNOS4412
Date: Fri, 27 Jan 2012 10:45:51 +0900
Message-id: <017001ccdc95$6698f5c0$33cae140$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczclWaEzxcCP5D8S+m5SusHDXnFWg==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This should be added for EXYNOS4212 and EXYNOS4412 SoCs.

Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: stable@kerne.org
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/tty/serial/samsung.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index f96f37b..ce632da 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1593,7 +1593,8 @@ static struct s3c24xx_serial_drv_data s5pv210_serial_drv_data = {
 #define S5PV210_SERIAL_DRV_DATA	(kernel_ulong_t)NULL
 #endif
 
-#ifdef CONFIG_CPU_EXYNOS4210
+#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS4212) || \
+	defined(CONFIG_CPU_EXYNOS4412)
 static struct s3c24xx_serial_drv_data exynos4210_serial_drv_data = {
 	.info = &(struct s3c24xx_uart_info) {
 		.name		= "Samsung Exynos4 UART",
-- 
1.7.1


