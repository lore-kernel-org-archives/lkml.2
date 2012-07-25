Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab2GYDtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:49:07 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:62253 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab2GYDnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:43:01 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 32/52] ACPICA: Utilities: conditionally compile backslash removal function
Date: Tue, 24 Jul 2012 23:41:28 -0400
Message-Id: <26181bf4b4ca6d963a369f119071a463c2107d69.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Only used for iASL and AcpiExec.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/utmisc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/acpica/utmisc.c b/drivers/acpi/acpica/utmisc.c
index e86f897..577a44e 100644
--- a/drivers/acpi/acpica/utmisc.c
+++ b/drivers/acpi/acpica/utmisc.c
@@ -50,6 +50,7 @@
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utmisc")
 
+#if defined ACPI_ASL_COMPILER || defined ACPI_EXEC_APP
 /*******************************************************************************
  *
  * FUNCTION:    ut_convert_backslashes
@@ -77,6 +78,7 @@ void ut_convert_backslashes(char *pathname)
 		pathname++;
 	}
 }
+#endif
 
 /*******************************************************************************
  *
-- 
1.7.12.rc0

