Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab2JFUMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:12:19 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37079 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2JFUMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:12:14 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 07/49] ACPICA: Debug output: Update output for Processor object.
Date: Sat,  6 Oct 2012 16:09:28 -0400
Message-Id: <0b232fcad225c35513c9d5719613ae552abccd82.1349554105.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Cleanup output for Processor(). Length is a byte, not a word.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/nsdump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/nsdump.c b/drivers/acpi/acpica/nsdump.c
index 7ee4e6a..2526aaf 100644
--- a/drivers/acpi/acpica/nsdump.c
+++ b/drivers/acpi/acpica/nsdump.c
@@ -264,7 +264,7 @@ acpi_ns_dump_one_object(acpi_handle obj_handle,
 		switch (type) {
 		case ACPI_TYPE_PROCESSOR:
 
-			acpi_os_printf("ID %X Len %.4X Addr %p\n",
+			acpi_os_printf("ID %02X Len %02X Addr %p\n",
 				       obj_desc->processor.proc_id,
 				       obj_desc->processor.length,
 				       ACPI_CAST_PTR(void,
-- 
1.8.0.rc0.18.gf84667d

