Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2LEBjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 20:39:10 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:3455 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab2LEBjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 20:39:05 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [v2 PATCH 8/8] ARM: dts: add the watchdog nodes for at91sam9g25ek boards
Date: Wed,  5 Dec 2012 09:34:27 +0800
Message-Id: <1354671267-19277-9-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354671267-19277-1-git-send-email-wenyou.yang@atmel.com>
References: <1354671267-19277-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 05 Dec 2012 01:38:51.0335 (UTC) FILETIME=[475EA570:01CDD289]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on the at91sam9g25ek boards

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/at91sam9g25ek.dts |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g25ek.dts b/arch/arm/boot/dts/at91sam9g25ek.dts
index 877c08f..2f03edc 100644
--- a/arch/arm/boot/dts/at91sam9g25ek.dts
+++ b/arch/arm/boot/dts/at91sam9g25ek.dts
@@ -44,6 +44,10 @@
 			i2c2: i2c@f8018000 {
 				status = "okay";
 			};
+
+			watchdog@fffffe40 {
+				status = "okay";
+			};
 		};
 
 		usb0: ohci@00600000 {
-- 
1.7.9.5

