Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2CQHdw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 03:33:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43497 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab2CQHdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 03:33:19 -0400
Message-ID: <1331969590.30866.0.camel@phoenix>
Subject: [PATCH 1/2] power_supply: Fix a typo in BATTERY_DS2781 Kconfig entry
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Renata Sayakhova <rsayakhova@gmail.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Date: Sat, 17 Mar 2012 15:33:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 459f664..340de6e 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -77,7 +77,7 @@ config BATTERY_DS2780
 	  Say Y here to enable support for batteries with ds2780 chip.
 
 config BATTERY_DS2781
-	tristate "2781 battery driver"
+	tristate "DS2781 battery driver"
 	depends on HAS_IOMEM
 	select W1
 	select W1_SLAVE_DS2781
-- 
1.7.5.4



