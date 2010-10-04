Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0JDHwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 03:52:06 -0400
Received: from smtp.nokia.com ([192.100.105.134]:21995 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0JDHwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 03:52:04 -0400
From: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>
To: cbouatmailru@gmail.com
Cc: linux-kernel@vger.kernel.org, ext-heikki.krogerus@nokia.com
Subject: [PATCH 2/2] power_supply: Introduce maximum current property
Date: Mon,  4 Oct 2010 10:51:38 +0300
Message-Id: <1286178698-28428-3-git-send-email-ext-heikki.krogerus@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286178698-28428-1-git-send-email-ext-heikki.krogerus@nokia.com>
References: <1286178698-28428-1-git-send-email-ext-heikki.krogerus@nokia.com>
X-OriginalArrivalTime: 04 Oct 2010 07:51:49.0126 (UTC) FILETIME=[FFFED260:01CB6398]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <ext-heikki.krogerus@nokia.com>

USB only gives the maximum current allowed to draw.

Signed-off-by: Heikki Krogerus <ext-heikki.krogerus@nokia.com>
---
 drivers/power/power_supply_sysfs.c |    1 +
 include/linux/power_supply.h       |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 88f5e43..cd1f907 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -139,6 +139,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(voltage_min_design),
 	POWER_SUPPLY_ATTR(voltage_now),
 	POWER_SUPPLY_ATTR(voltage_avg),
+	POWER_SUPPLY_ATTR(current_max),
 	POWER_SUPPLY_ATTR(current_now),
 	POWER_SUPPLY_ATTR(current_avg),
 	POWER_SUPPLY_ATTR(power_now),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index d37fef6..7d73256 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -89,6 +89,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_CURRENT_MAX,
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_CURRENT_AVG,
 	POWER_SUPPLY_PROP_POWER_NOW,
-- 
1.7.0.4

