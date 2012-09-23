Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2IWEfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 00:35:41 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:43694 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2IWEen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 00:34:43 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 07/23] ACPICA: Debug output: Update output for Processor object.
Date: Sun, 23 Sep 2012 00:33:55 -0400
Message-Id: <0b232fcad225c35513c9d5719613ae552abccd82.1348371388.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.1.396.g16eed7c
In-Reply-To: <1348374851-20378-1-git-send-email-lenb@kernel.org>
References: <1348374851-20378-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1348371388.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1348371388.git.len.brown@intel.com>
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
1.7.12.1.396.g16eed7c

