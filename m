Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab2FFV22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:28:28 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:2211 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758650Ab2FFV2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:28:25 -0400
Message-ID: <1339018103.21725.25.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] ab8500-btemp: Fix typo 'AB5500'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 06 Jun 2012 23:28:23 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Jun 2012 21:28:23.0884 (UTC) FILETIME=[4D8AD8C0:01CD442B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Bravely untested.

 drivers/power/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index e3a3b49..e37d239 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -301,7 +301,7 @@ config AB8500_BM
 	bool "AB8500 Battery Management Driver"
 	depends on AB8500_CORE && AB8500_GPADC
 	help
-	  Say Y to include support for AB5500 battery management.
+	  Say Y to include support for AB8500 battery management.
 
 config AB8500_BATTERY_THERM_ON_BATCTRL
 	bool "Thermistor connected on BATCTRL ADC"
-- 
1.7.7.6

