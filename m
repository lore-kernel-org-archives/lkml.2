Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1GYP0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:26:32 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:59892 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1GYPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:24:45 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.89
Message-ID: <4E2D89B3.2020804@tremplin-utc.net>
Date: Mon, 25 Jul 2011 17:20:19 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Malte Starostik <m-starostik@versanet.de>,
        LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH 06/10] CONFIG_HP_ACCEL: Fix help text
References: <4E2D8858.8000900@tremplin-utc.net>
In-Reply-To: <4E2D8858.8000900@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt the help text for CONFIG_HP_ACCEL to the move of
Documentation/hwmon/lis3lv02d to Documentation/misc-devices/ in
ff606677f6a47c63329cf8e6c7cf978c29f2d736

Signed-off-by: Malte Starostik <m-starostik@versanet.de>
Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/platform/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 45e0191..d25f486 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -164,7 +164,7 @@ config HP_ACCEL
 
 	  Support for a led indicating disk protection will be provided as
 	  hp::hddprotect. For more information on the feature, refer to
-	  Documentation/hwmon/lis3lv02d.
+	  Documentation/misc-devices/lis3lv02d.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called hp_accel.
-- 
1.7.6
