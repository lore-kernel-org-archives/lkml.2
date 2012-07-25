Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab2GYDnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:43:32 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46154 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973Ab2GYDnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:43:24 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Lin Ming <ming.m.lin@intel.com>, Len Brown <len.brown@intel.com>
Subject: [PATCH 44/52] ACPICA: Update header files copyrights to 2012
Date: Tue, 24 Jul 2012 23:41:40 -0400
Message-Id: <75e7386b104b27b1158bf7d13c69d5317f0033ca.1343187617.git.len.brown@intel.com>
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

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 include/acpi/acexcep.h          | 2 +-
 include/acpi/acnames.h          | 2 +-
 include/acpi/acoutput.h         | 2 +-
 include/acpi/acpi.h             | 2 +-
 include/acpi/acpiosxf.h         | 2 +-
 include/acpi/acpixf.h           | 2 +-
 include/acpi/acrestyp.h         | 2 +-
 include/acpi/actbl.h            | 2 +-
 include/acpi/actbl1.h           | 2 +-
 include/acpi/actbl2.h           | 2 +-
 include/acpi/actbl3.h           | 2 +-
 include/acpi/actypes.h          | 2 +-
 include/acpi/platform/acenv.h   | 2 +-
 include/acpi/platform/acgcc.h   | 2 +-
 include/acpi/platform/aclinux.h | 2 +-
 15 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/acpi/acexcep.h b/include/acpi/acexcep.h
index 0b5dcb6..1950344 100644
--- a/include/acpi/acexcep.h
+++ b/include/acpi/acexcep.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/acnames.h b/include/acpi/acnames.h
index 38f5088..ef24d82 100644
--- a/include/acpi/acnames.h
+++ b/include/acpi/acnames.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/acoutput.h b/include/acpi/acoutput.h
index f1cb332..2457ac8 100644
--- a/include/acpi/acoutput.h
+++ b/include/acpi/acoutput.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/acpi.h b/include/acpi/acpi.h
index de39915..c433d5e 100644
--- a/include/acpi/acpi.h
+++ b/include/acpi/acpi.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index f3746f7..0650f5f 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -8,7 +8,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 079bb90..9877432 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/acrestyp.h b/include/acpi/acrestyp.h
index 3506e39..2504091 100644
--- a/include/acpi/acrestyp.h
+++ b/include/acpi/acrestyp.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/actbl.h b/include/acpi/actbl.h
index 8dea546..a629a01 100644
--- a/include/acpi/actbl.h
+++ b/include/acpi/actbl.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
index 71e747b..9ac26b4 100644
--- a/include/acpi/actbl1.h
+++ b/include/acpi/actbl1.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
index 58bdd05..34198bf2 100644
--- a/include/acpi/actbl2.h
+++ b/include/acpi/actbl2.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/actbl3.h b/include/acpi/actbl3.h
index c22ce80..f65a0ed 100644
--- a/include/acpi/actbl3.h
+++ b/include/acpi/actbl3.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 376c9ed..bc4a327 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/platform/acenv.h b/include/acpi/platform/acenv.h
index 5af3ed5..560a9f2 100644
--- a/include/acpi/platform/acenv.h
+++ b/include/acpi/platform/acenv.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/platform/acgcc.h b/include/acpi/platform/acgcc.h
index e228893..72553b0 100644
--- a/include/acpi/platform/acgcc.h
+++ b/include/acpi/platform/acgcc.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 6fbc4ca..7509be3 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
-- 
1.7.12.rc0

