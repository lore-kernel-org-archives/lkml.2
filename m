Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab2GYDmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:42:18 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46154 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab2GYDmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:13 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 07/52] ACPICA: ACPI 5/iASL: Add support for PCC keyword
Date: Tue, 24 Jul 2012 23:41:03 -0400
Message-Id: <43e1c6892c88ae0730cb0eb7bd5a2812b960c32a.1343187617.git.len.brown@intel.com>
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

Adds support for the PCC keyword for the Register() resource
descriptor macro.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/acpi/actypes.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 0339a2d..376c9ed 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -728,8 +728,9 @@ typedef u8 acpi_adr_space_type;
 #define ACPI_ADR_SPACE_IPMI             (acpi_adr_space_type) 7
 #define ACPI_ADR_SPACE_GPIO             (acpi_adr_space_type) 8
 #define ACPI_ADR_SPACE_GSBUS            (acpi_adr_space_type) 9
+#define ACPI_ADR_SPACE_PLATFORM_COMM    (acpi_adr_space_type) 10
 
-#define ACPI_NUM_PREDEFINED_REGIONS     10
+#define ACPI_NUM_PREDEFINED_REGIONS     11
 
 /*
  * Special Address Spaces
-- 
1.7.12.rc0

