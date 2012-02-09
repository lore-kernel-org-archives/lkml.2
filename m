Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab2BINrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:47:24 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33073 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2BINrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:47:23 -0500
Message-ID: <1328795289.25876.5.camel@blackout-netbook>
Subject: [PATCH] [trivial] Correcting typos in rtlwifi/base.c
From: Tristan Pourcelot <tristan.pourcelot@gmail.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 09 Feb 2012 14:48:09 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch correct some typos in a comment.


>From 79bce2d3fb5c2e3c78ff39f3c9a0f10c20be9221 Mon Sep 17 00:00:00 2001
From: Tristan Pourcelot <tristan.pourcelot@gmail.com>
Date: Thu, 9 Feb 2012 14:45:28 +0100
Subject: [PATCH] Correcting typos in rtlwifi/base.c


Signed-off-by: Tristan Pourcelot <tristan.pourcelot@gmail.com>
---
 drivers/net/wireless/rtlwifi/base.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c
b/drivers/net/wireless/rtlwifi/base.c
index 8d6eb0f..08e4b28 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -40,10 +40,10 @@
 #include "regd.h"
 
 /*
- *NOTICE!!!: This file will be very big, we hsould
- *keep it clear under follwing roles:
+ *NOTICE!!!: This file will be very big, we should
+ *keep it clear under following roles:
  *
- *This file include follwing part, so, if you add new
+ *This file include following parts, so, if you add new
  *functions into this file, please check which part it
  *should includes. or check if you should add new part
  *for this file:
-- 
1.7.9





