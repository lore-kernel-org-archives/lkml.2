Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab1CAA5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:57:03 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1843 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1CAA4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:56:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 28 Feb 2011 16:56:42 -0800
From: rklein@nvidia.com
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: olof@lixom.net, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 4/4] power_supply: update power_supply_is_watt_property
Date: Mon, 28 Feb 2011 16:55:31 -0800
Message-Id: <1298940931-17552-5-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1298940931-17552-1-git-send-email-rklein@nvidia.com>
References: <1298940931-17552-1-git-send-email-rklein@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rhyland Klein <rklein@nvidia.com>

Update the power_supply_is_watt_property function to include POWER_NOW.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 include/linux/power_supply.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 20f23fe..204c18d 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -251,6 +251,7 @@ static inline bool power_supply_is_watt_property(enum power_supply_property psp)
 	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+	case POWER_SUPPLY_PROP_POWER_NOW:
 		return 1;
 	default:
 		break;
-- 
1.7.0.4

