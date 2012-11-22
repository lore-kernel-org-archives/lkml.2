Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab2KVTFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:05:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:44199 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab2KVTFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:05:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,299,1352102400"; 
   d="scan'208";a="221003677"
From: Adrian Hunter <adrian.hunter@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] PNPACPI: exclude SDHCI devices
Date: Thu, 22 Nov 2012 10:43:48 +0200
Message-Id: <1353573830-13006-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353573830-13006-1-git-send-email-adrian.hunter@intel.com>
References: <1353573830-13006-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These devices will be handled by a ACPI Platform driver.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/pnp/pnpacpi/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index 26b5d4b..5b17cc8 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -43,6 +43,7 @@ static struct acpi_device_id excluded_id_list[] __initdata = {
 	{"PNP0C0F", 0},		/* Link device */
 	{"PNP0000", 0},		/* PIC */
 	{"PNP0100", 0},		/* Timer */
+	{"PNP0D40", 0},		/* SDHCI */
 	{"", 0},
 };
 
-- 
1.7.11.7

