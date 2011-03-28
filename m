Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1C1Qal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab1C1Qag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=w2AiUO57IpzjOMm6FMu1kVvbpjl+Je4RV+Qek0A3jzXF4Vb7P8ZWQMnYb+5r8WOUMK
         8r4q53Apz4L3P1NbTDSfvj9i9AfKCPpv6HGvLajClgxA9MUXTFlTbjVM2FXVkdDIyeYK
         IFBynug5wieNoHkeVWxkU4/BZ9d5OrcsHWeik=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 17/25]drivers:target Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:40 -0700
Message-Id: <1301329788-3423-18-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/target/target_core_alua.c            |    1 -
 drivers/target/target_core_configfs.c        |    1 -
 drivers/target/target_core_fabric_configfs.c |    1 -
 drivers/target/target_core_file.c            |    1 -
 drivers/target/target_core_iblock.c          |    1 -
 drivers/target/target_core_pr.c              |    1 -
 drivers/target/target_core_pscsi.c           |    1 -
 drivers/target/target_core_rd.c              |    1 -
 drivers/target/target_core_stat.c            |    1 -
 drivers/target/target_core_tmr.c             |    1 -
 drivers/target/target_core_transport.c       |    1 -
 drivers/target/target_core_ua.c              |    1 -
 12 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 2c5fcfe..9b21e90 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -24,7 +24,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/configfs.h>
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a5f44a6..2541f01 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -23,7 +23,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 07ab5a3..2f6b7f9 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -22,7 +22,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 02f553a..11cb059 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -26,7 +26,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/timer.h>
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8663900..32c372b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -27,7 +27,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/timer.h>
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 2521f75..c3f8036 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -25,7 +25,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 7ff6a35..069ebfc 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -26,7 +26,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/timer.h>
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 7837dd3..adbda89 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -27,7 +27,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/timer.h>
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 5e3a067..889c64e 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -32,7 +32,6 @@
 #include <linux/delay.h>
 #include <linux/timer.h>
 #include <linux/string.h>
-#include <linux/version.h>
 #include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/proc_fs.h>
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 4a10983..d8cd464 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -24,7 +24,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index bf6aa8a..e8bd58b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -26,7 +26,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/net.h>
 #include <linux/delay.h>
 #include <linux/string.h>
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index a2ef346..5cc5902 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -24,7 +24,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <scsi/scsi.h>
-- 
1.7.4.1

