Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3AECpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:45:05 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:56848 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab3AECpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:45:00 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [v3 PATCH 9/9] ARM: dts: add the watchdog nodes for at91sam9g25ek boards
Date: Sat,  5 Jan 2013 10:38:49 +0800
Message-Id: <1357353529-20901-10-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357353529-20901-1-git-send-email-wenyou.yang@atmel.com>
References: <1357353529-20901-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 05 Jan 2013 02:44:39.0925 (UTC) FILETIME=[9BB7EA50:01CDEAEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on the at91sam9g25ek boards

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/at91sam9x5ek.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi b/arch/arm/boot/dts/at91sam9x5ek.dtsi
index 8a7cf1d..afddf75 100644
--- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
@@ -69,6 +69,10 @@
 				status = "okay";
 			};
 
+			watchdog@fffffe40 {
+				status = "okay";
+			};
+
 			pinctrl@fffff400 {
 				mmc0 {
 					pinctrl_board_mmc0: mmc0-board {
-- 
1.7.9.5

