Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1F0Oh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:37:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41742 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1F0OhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Q87fQMyers12sS7QNhS/NGq7aZTBQtHHIXL2Gfwk97WMchEyypQlmpJ7RKz2BDBU7l
         t97De5pXrqS8CDuaYPRgw33IcWNBIhk6fEu/C8W3UqAGrsEvvsiliwoIVxPQu2e2Ul8x
         xEZXzgcQOkh/aNyEUM0GGxS9IxTQV5I3G1J7M=
Subject: [PATCH] watchdog: gef_wdt: fix MODULE_ALIAS
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Martyn Welch <martyn.welch@ge.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 22:37:16 +0800
Message-ID: <1309185436.29085.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the space between "platform:" prefix and the driver name.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/watchdog/gef_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index 29a7cd4..b146082 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -329,4 +329,4 @@ MODULE_AUTHOR("Martyn Welch <martyn.welch@ge.com>");
 MODULE_DESCRIPTION("GE watchdog driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS("platform: gef_wdt");
+MODULE_ALIAS("platform:gef_wdt");
-- 
1.7.4.1



