Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2ARCpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 21:45:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64988 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2ARCpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 21:45:32 -0500
Message-ID: <1326854720.11831.1.camel@phoenix>
Subject: [PATCH 1/2] watchdog: Staticise nuc900_wdt
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Date: Wed, 18 Jan 2012 10:45:20 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is only used in this driver, so no need to make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/watchdog/nuc900_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
index 50359ba..2cce856 100644
--- a/drivers/watchdog/nuc900_wdt.c
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -72,7 +72,7 @@ struct nuc900_wdt {
 };
 
 static unsigned long nuc900wdt_busy;
-struct nuc900_wdt *nuc900_wdt;
+static struct nuc900_wdt *nuc900_wdt;
 
 static inline void nuc900_wdt_keepalive(void)
 {
-- 
1.7.5.4



