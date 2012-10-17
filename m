Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab2JQPCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 11:02:51 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50039 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab2JQPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 11:02:45 -0400
From: Sangho Yi <antiroot@gmail.com>
To: broonie@opensource.wolfsonmicro.com, cbow@mail.ru, dwmw2@inradead.org
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 2/3] power: wm831x_power.c: fixed const struct declaration warning
Date: Thu, 18 Oct 2012 00:01:15 +0900
Message-Id: <1350486076-3784-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350486076-3784-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350486076-3784-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the following coding style violation;
WARNING: static const char * array should probably be static const char
* const

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/power/wm831x_power.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index 833841b..1afca43 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -430,7 +430,7 @@ static enum power_supply_property wm831x_bat_props[] = {
 	POWER_SUPPLY_PROP_CHARGE_TYPE,
 };
 
-static const char *wm831x_bat_irqs[] = {
+static const char * const wm831x_bat_irqs[] = {
 	"BATT HOT",
 	"BATT COLD",
 	"BATT FAIL",
-- 
1.7.9.5

