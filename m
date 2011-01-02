Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1ABHZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:10 -0500
Received: from mail.windriver.com ([147.11.1.11]:36884 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab1ABHZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Len Brown <len.brown@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 212/260] ACPI: delete ZEPTO idle=nomwait DMI quirk
Date: Sun,  2 Jan 2011 02:18:28 -0500
Message-Id: <1293952756-15010-213-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:01.0823 (UTC) FILETIME=[076212F0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

commit 64a32307b710c100beb101e9c78f8022f0e8ba61 upstream.

per comments in the bug report, this entry
seems to hurt at much as it helps.

https://bugzilla.kernel.org/show_bug.cgi?id=10807

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/acpi/processor_core.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index e9699aa..b618f88 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -29,12 +29,6 @@ static int set_no_mwait(const struct dmi_system_id *id)
 
 static struct dmi_system_id __cpuinitdata processor_idle_dmi_table[] = {
 	{
-	set_no_mwait, "IFL91 board", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "COMPAL"),
-	DMI_MATCH(DMI_SYS_VENDOR, "ZEPTO"),
-	DMI_MATCH(DMI_PRODUCT_VERSION, "3215W"),
-	DMI_MATCH(DMI_BOARD_NAME, "IFL91") }, NULL},
-	{
 	set_no_mwait, "Extensa 5220", {
 	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
 	DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
-- 
1.7.3.3

