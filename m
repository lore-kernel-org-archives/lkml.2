Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2AaPLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:11:55 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48376 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2AaPLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:11:53 -0500
From: Kukjin Kim <kgene.kim@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, stable <stable@vger.kernel.org>
Subject: [PATCH v2] serial: samsung: Add support for EXYNOS4212 and EXYNOS4412
Date: Wed,  1 Feb 2012 00:11:23 +0900
Message-Id: <1328022683-2789-1-git-send-email-kgene.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be added for EXYNOS4212 and EXYNOS4412 SoCs.

Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: stable <stable@vger.kernel.org>
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
+	defined(CONFIG_SOC_EXYNOS4412)
 static struct s3c24xx_serial_drv_data exynos4210_serial_drv_data = {
 	.info = &(struct s3c24xx_uart_info) {
 		.name		= "Samsung Exynos4 UART",
-- 
1.7.4.4

