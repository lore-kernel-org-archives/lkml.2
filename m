Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1ABHXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:35276 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab1ABHXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 101/260] apm_power: Add missing break statement
Date: Sun,  2 Jan 2011 02:16:37 -0500
Message-Id: <1293952756-15010-102-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:01.0008 (UTC) FILETIME=[BF5F2B00:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <cbouatmailru@gmail.com>

commit 1d220334d6a8a711149234dc5f98d34ae02226b8 upstream.

The missing break statement causes wrong capacity calculation for
batteries that report energy.

Reported-by: d binderman <dcb314@hotmail.com>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/power/apm_power.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/apm_power.c b/drivers/power/apm_power.c
index 936bae5..dc628cb 100644
--- a/drivers/power/apm_power.c
+++ b/drivers/power/apm_power.c
@@ -233,6 +233,7 @@ static int calculate_capacity(enum apm_source source)
 		empty_design_prop = POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN;
 		now_prop = POWER_SUPPLY_PROP_ENERGY_NOW;
 		avg_prop = POWER_SUPPLY_PROP_ENERGY_AVG;
+		break;
 	case SOURCE_VOLTAGE:
 		full_prop = POWER_SUPPLY_PROP_VOLTAGE_MAX;
 		empty_prop = POWER_SUPPLY_PROP_VOLTAGE_MIN;
-- 
1.7.3.3

