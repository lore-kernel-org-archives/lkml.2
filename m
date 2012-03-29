Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab2C2GKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:10:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:28780 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab2C2GJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:09:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="126409918"
From: Lin Ming <ming.m.lin@intel.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-acpi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] PM / Runtime: Add may_power_off flag to subsys data
Date: Thu, 29 Mar 2012 14:09:40 +0800
Message-Id: <1333001380-6050-4-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1333001380-6050-1-git-send-email-ming.m.lin@intel.com>
References: <1333001380-6050-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parent device will check child's may_power_off flag to see if child device can
be powered off.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 include/linux/pm.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index e4982ac..c9953b4 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -465,6 +465,7 @@ struct pm_subsys_data {
 #ifdef CONFIG_PM_GENERIC_DOMAINS
 	struct pm_domain_data *domain_data;
 #endif
+	bool may_power_off;
 };
 
 struct dev_pm_info {
-- 
1.7.2.5

