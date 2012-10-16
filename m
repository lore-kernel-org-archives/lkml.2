Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab2JPHdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:33:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50697 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab2JPHdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:33:19 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-32-507d0dbe70bb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
In-reply-to: <007101cdab6f$6c8bc030$45a34090$%han@samsung.com>
Subject: [PATCH 15/17] backlight: tdo24m: fix checkpatch warning
Date: Tue, 16 Oct 2012 16:33:17 +0900
Message-id: <008001cdab70$829a75a0$87cf60e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rb2x3b+BtYCwlRU+aka06gjxy+QAAQfxQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t9jQd19vLUBBqeec1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MH5frC2bwVvQ+msbawHiLq4uRk0NCwETi0Lf7rBC2mMSFe+vZ
	uhi5OIQEpjNKnJjbBeXMZpLYseIyI0gVm4CaxJcvh9lBbBGBCInmGbOYuxg5OJgFfCQ2z9IE
	CQsJ2EqsnvEWrIRTwE5i4+uDLCC2sICDxNENN5hAbBYBVYnFS0+xgLTyAtUfne8JEuYVEJT4
	MfkeWDmzgJbE+p3HmSBseYnNa96CbZIQUJd49FcX4gAjiY5985ghSkQk9r14xziBUWgWkkmz
	kEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEh/Az6R2MqxosDjEKcDAq
	8fBmONcECLEmlhVX5h5ilOBgVhLh9ZgIFOJNSaysSi3Kjy8qzUktPsQozcGiJM7b7JESICSQ
	nliSmp2aWpBaBJNl4uCUamDse7CzyeM668v4BYf9TCurCy2eP9AyaXhyU3PGepOOw/UpwdOb
	AlSf7QyQvPS2K2pJ24HMAxwSc2yKs5xn3PH98z16w8PaBfFWSl8O3FvgOJ37rsLp1N8l287G
	Nts7dDOGp8R8ic20lVP7efTTSY4ppfFvE6+9z/waY/FJ73pe59XV+wzvlbQrsRRnJBpqMRcV
	JwIAxQQ+0V0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the checkpatch warning as below:

WARNING: please, no space before tabs

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/video/backlight/tdo24m.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index 02444d0..0f6eaa4 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -2,7 +2,7 @@
  * tdo24m - SPI-based drivers for Toppoly TDO24M series LCD panels
  *
  * Copyright (C) 2008 Marvell International Ltd.
- * 	Eric Miao <eric.miao@marvell.com>
+ *	Eric Miao <eric.miao@marvell.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 as
@@ -90,7 +90,7 @@ static uint32_t lcd_qvga_pass_through_tdo24m[] = {
 };
 
 static uint32_t lcd_vga_transfer_tdo24m[] = {
-	CMD1(0xcf, 0x02), 	/* Blanking period control (1) */
+	CMD1(0xcf, 0x02),	/* Blanking period control (1) */
 	CMD2(0xd0, 0x08, 0x04),	/* Blanking period control (2) */
 	CMD1(0xd1, 0x01),	/* CKV timing control on/off */
 	CMD2(0xd2, 0x14, 0x00),	/* CKV 1,2 timing control */
@@ -132,7 +132,7 @@ static uint32_t lcd_qvga_pass_through_tdo35s[] = {
 };
 
 static uint32_t lcd_vga_transfer_tdo35s[] = {
-	CMD1(0xcf, 0x02), 	/* Blanking period control (1) */
+	CMD1(0xcf, 0x02),	/* Blanking period control (1) */
 	CMD2(0xd0, 0x08, 0x04),	/* Blanking period control (2) */
 	CMD1(0xd1, 0x01),	/* CKV timing control on/off */
 	CMD2(0xd2, 0x00, 0x1e),	/* CKV 1,2 timing control */
-- 
1.7.1


