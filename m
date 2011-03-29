Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1C2WWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:22:50 -0400
Received: from mail.perches.com ([173.55.12.10]:4392 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab1C2WWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:22:43 -0400
From: Joe Perches <joe@perches.com>
To: Matthew Garrett <mjg@redhat.com>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 22/23] wmi: Removed trailing whitespace from logging message.
Date: Tue, 29 Mar 2011 15:21:53 -0700
Message-Id: <65eb74f915743adc72e19204524a513ff2cd1b44.1301436234.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.2.g597a6.dirty
In-Reply-To: <cover.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just neatening.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/wmi.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 05cc796..f23d5a8 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -486,16 +486,16 @@ static void wmi_dump_wdg(const struct guid_block *g)
 	pr_info("\tnotify_id: %02X\n", g->notify_id);
 	pr_info("\treserved: %02X\n", g->reserved);
 	pr_info("\tinstance_count: %d\n", g->instance_count);
-	pr_info("\tflags: %#x ", g->flags);
+	pr_info("\tflags: %#x", g->flags);
 	if (g->flags) {
 		if (g->flags & ACPI_WMI_EXPENSIVE)
-			pr_cont("ACPI_WMI_EXPENSIVE ");
+			pr_cont(" ACPI_WMI_EXPENSIVE");
 		if (g->flags & ACPI_WMI_METHOD)
-			pr_cont("ACPI_WMI_METHOD ");
+			pr_cont(" ACPI_WMI_METHOD");
 		if (g->flags & ACPI_WMI_STRING)
-			pr_cont("ACPI_WMI_STRING ");
+			pr_cont(" ACPI_WMI_STRING");
 		if (g->flags & ACPI_WMI_EVENT)
-			pr_cont("ACPI_WMI_EVENT ");
+			pr_cont(" ACPI_WMI_EVENT");
 	}
 	pr_cont("\n");
 
-- 
1.7.4.2.g597a6.dirty

