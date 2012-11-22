Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab2KVTIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:08:21 -0500
Received: from mga14.intel.com ([143.182.124.37]:25178 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273Ab2KVTIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:08:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,299,1352102400"; 
   d="scan'208";a="221003689"
From: Adrian Hunter <adrian.hunter@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ACPI: add SDHCI to ACPI platform devices
Date: Thu, 22 Nov 2012 10:43:49 +0200
Message-Id: <1353573830-13006-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353573830-13006-1-git-send-email-adrian.hunter@intel.com>
References: <1353573830-13006-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/acpi/scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 8c4ac6d..67a7fa6 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -35,6 +35,8 @@ static const char *dummy_hid = "device";
  */
 static const struct acpi_device_id acpi_platform_device_ids[] = {
 
+	{ "PNP0D40" },
+
 	{ }
 };
 
-- 
1.7.11.7

