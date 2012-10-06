Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2JFUOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:14:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:52672 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab2JFUOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:14:34 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 15/49] ACPICA: Headers: Add new ACPI 5 HEST notify type values.
Date: Sat,  6 Oct 2012 16:09:36 -0400
Message-Id: <ca4a03143f6c911189f708a3a3c7eae3dfb8678c.1349554106.git.len.brown@intel.com>
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

Add values 5 (CMCI) and 6 (MCE).

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/acpi/actbl1.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index c41d6f9..280fc45 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -495,7 +495,9 @@ enum acpi_hest_notify_types {
 	ACPI_HEST_NOTIFY_LOCAL = 2,
 	ACPI_HEST_NOTIFY_SCI = 3,
 	ACPI_HEST_NOTIFY_NMI = 4,
-	ACPI_HEST_NOTIFY_RESERVED = 5	/* 5 and greater are reserved */
+	ACPI_HEST_NOTIFY_CMCI = 5,	/* ACPI 5.0 */
+	ACPI_HEST_NOTIFY_MCE = 6,	/* ACPI 5.0 */
+	ACPI_HEST_NOTIFY_RESERVED = 7	/* 7 and greater are reserved */
 };
 
 /* Values for config_write_enable bitfield above */
-- 
1.8.0.rc0.18.gf84667d

