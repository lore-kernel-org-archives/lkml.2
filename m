Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab2HTVCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:02:32 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64047 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab2HTVCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:02:16 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] asus-laptop: HRWS/HWRS typo
Date: Mon, 20 Aug 2012 23:01:51 +0200
Message-Id: <1345496512-11780-3-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345496512-11780-1-git-send-email-corentin.chary@gmail.com>
References: <1345496512-11780-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index e38f91b..110c777 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -863,9 +863,9 @@ static ssize_t show_infos(struct device *dev,
 	 * The significance of others is yet to be found.
 	 * If we don't find the method, we assume the device are present.
 	 */
-	rv = acpi_evaluate_integer(asus->handle, "HRWS", NULL, &temp);
+	rv = acpi_evaluate_integer(asus->handle, "HWRS", NULL, &temp);
 	if (!ACPI_FAILURE(rv))
-		len += sprintf(page + len, "HRWS value         : %#x\n",
+		len += sprintf(page + len, "HWRS value         : %#x\n",
 			       (uint) temp);
 	/*
 	 * Another value for userspace: the ASYM method returns 0x02 for
@@ -1751,9 +1751,9 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 	 * The significance of others is yet to be found.
 	 */
 	status =
-	    acpi_evaluate_integer(asus->handle, "HRWS", NULL, &hwrs_result);
+	    acpi_evaluate_integer(asus->handle, "HWRS", NULL, &hwrs_result);
 	if (!ACPI_FAILURE(status))
-		pr_notice("  HRWS returned %x", (int)hwrs_result);
+		pr_notice("  HWRS returned %x", (int)hwrs_result);
 
 	if (!acpi_check_handle(asus->handle, METHOD_WL_STATUS, NULL))
 		asus->have_rsts = true;
-- 
1.7.9.5

