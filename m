Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab1JWIHS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 04:07:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63837 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab1JWIHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 04:07:15 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-63-4ea3cb31eeed
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, "'Sangbeom Kim'" <sbkim73@samsung.com>
Subject: [PATCH 0/3] mfd: S5M series initial release
Date: Sun, 23 Oct 2011 17:07:13 +0900
Message-id: <009101cc915a$c5bc5500$5134ff00$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyRWsRMnlP8NZ0WQQu5gDoVuvW6EQ==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samsung is developing various multi function devices.
Currently, 3 devices are announced by samsung.
S5M8767 has pmic and rtc and battery charger.
S5M8763 has pmic, rtc, Li-ion battery charger
S5M8751 has pmic, codec, battery charger, backlight controller.
All devices are designed for mobile applications.
Sequentially, All driver will be posted.
This is initial version for MFD of S5M series.
The other driver will be submitted  separately.

Sangbeom

*Currently, My git server has some problem.
So, I can't use git send-email.
This patch are sent by outlook.

