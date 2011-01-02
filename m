Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1ABH1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:27:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:37293 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab1ABH1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:27:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Len Brown <len.brown@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 211/260] ACPI: EC: add Vista incompatibility DMI entry for Toshiba Satellite L355
Date: Sun,  2 Jan 2011 02:18:27 -0500
Message-Id: <1293952756-15010-212-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:00.0901 (UTC) FILETIME=[06D56350:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

commit 7a1d602f5fc35d14907b7da98d5627acb69589d1 upstream.

https://bugzilla.kernel.org/show_bug.cgi?id=12641

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/acpi/blacklist.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 2815df6..6931946 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -218,6 +218,14 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
 		},
 	},
 	{
+	.callback = dmi_disable_osi_vista,
+	.ident = "Toshiba Satellite L355",
+	.matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		     DMI_MATCH(DMI_PRODUCT_VERSION, "Satellite L355"),
+		},
+	},
+	{
 	.callback = dmi_disable_osi_win7,
 	.ident = "ASUS K50IJ",
 	.matches = {
-- 
1.7.3.3

