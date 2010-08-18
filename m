Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab0HRXC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:02:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:37213 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab0HRXC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:02:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,229,1280732400"; 
   d="scan'208";a="546610545"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Rudolf Marek" <r.marek@assembler.cz>, "Huaxu Wan" <huaxu.wan@intel.com>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "Jean Delvare" <khali@linux-fr.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH] drivers/hwmon/coretemp: Remove warnings of unused variables
Date: Wed, 18 Aug 2010 15:53:46 -0700
Message-Id: <1282172027-640-2-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
References: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Remove compilation warnings of unused variables p and n in coretemp_init().

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 drivers/hwmon/coretemp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index c070c97..de81111 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -518,7 +518,6 @@ static struct notifier_block coretemp_cpu_notifier __refdata = {
 static int __init coretemp_init(void)
 {
 	int i, err = -ENODEV;
-	struct pdev_entry *p, *n;
 
 	/* quick check if we run Intel */
 	if (cpu_data(0).x86_vendor != X86_VENDOR_INTEL)
-- 
1.6.0.3

