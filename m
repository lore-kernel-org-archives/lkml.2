Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab1FCJ3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:29:38 -0400
Received: from mail.perches.com ([173.55.12.10]:2476 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab1FCJ3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:29:36 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 5/5] staging: msm: Use angle brackets for system includes
Date: Fri,  3 Jun 2011 02:28:50 -0700
Message-Id: <1220799998956e0a84ae55199a8b2210fccecbb3.1307092589.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1307092588.git.joe@perches.com>
References: <cover.1307092588.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the normal include style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/msm/ebi2_l2f.c    |    2 +-
 drivers/staging/msm/ebi2_tmd20.c  |    2 +-
 drivers/staging/msm/mddihost.h    |    2 +-
 drivers/staging/msm/mdp_ppp.c     |    2 +-
 drivers/staging/msm/mdp_ppp_v20.c |    2 +-
 drivers/staging/msm/mdp_ppp_v31.c |    2 +-
 drivers/staging/msm/msm_fb.h      |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/msm/ebi2_l2f.c b/drivers/staging/msm/ebi2_l2f.c
index eea891d..5bfea28 100644
--- a/drivers/staging/msm/ebi2_l2f.c
+++ b/drivers/staging/msm/ebi2_l2f.c
@@ -23,7 +23,7 @@
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include "linux/proc_fs.h"
+#include <linux/proc_fs.h>
 
 #include <linux/delay.h>
 
diff --git a/drivers/staging/msm/ebi2_tmd20.c b/drivers/staging/msm/ebi2_tmd20.c
index d66d039..d7d667a 100644
--- a/drivers/staging/msm/ebi2_tmd20.c
+++ b/drivers/staging/msm/ebi2_tmd20.c
@@ -23,7 +23,7 @@
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include "linux/proc_fs.h"
+#include <linux/proc_fs.h>
 
 #include <linux/delay.h>
 
diff --git a/drivers/staging/msm/mddihost.h b/drivers/staging/msm/mddihost.h
index 8f532d0..d7b785c 100644
--- a/drivers/staging/msm/mddihost.h
+++ b/drivers/staging/msm/mddihost.h
@@ -18,7 +18,7 @@
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include "linux/proc_fs.h"
+#include <linux/proc_fs.h>
 #include <linux/types.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
diff --git a/drivers/staging/msm/mdp_ppp.c b/drivers/staging/msm/mdp_ppp.c
index c35a6ae..01b372f 100644
--- a/drivers/staging/msm/mdp_ppp.c
+++ b/drivers/staging/msm/mdp_ppp.c
@@ -24,7 +24,7 @@
 #include <linux/file.h>
 #include <linux/major.h>
 
-#include "linux/proc_fs.h"
+#include <linux/proc_fs.h>
 
 #include <mach/hardware.h>
 #include <linux/io.h>
diff --git a/drivers/staging/msm/mdp_ppp_v20.c b/drivers/staging/msm/mdp_ppp_v20.c
index b5b7271..3bc02a1 100644
--- a/drivers/staging/msm/mdp_ppp_v20.c
+++ b/drivers/staging/msm/mdp_ppp_v20.c
@@ -22,7 +22,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/fb.h>
-#include "linux/proc_fs.h"
+#include <linux/proc_fs.h>
 
 #include <mach/hardware.h>
 #include <linux/io.h>
diff --git a/drivers/staging/msm/mdp_ppp_v31.c b/drivers/staging/msm/mdp_ppp_v31.c
index 76495db..d8b7953 100644
--- a/drivers/staging/msm/mdp_ppp_v31.c
+++ b/drivers/staging/msm/mdp_ppp_v31.c
@@ -22,7 +22,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/fb.h>
-#include "linux/proc_fs.h"
+#include <linux/proc_fs.h>
 
 #include <mach/hardware.h>
 #include <linux/io.h>
diff --git a/drivers/staging/msm/msm_fb.h b/drivers/staging/msm/msm_fb.h
index 4bca6d2..0441aa9 100644
--- a/drivers/staging/msm/msm_fb.h
+++ b/drivers/staging/msm/msm_fb.h
@@ -19,7 +19,7 @@
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include "linux/proc_fs.h"
+#include <linux/proc_fs.h>
 
 #include <mach/hardware.h>
 #include <linux/io.h>
-- 
1.7.5.rc3.dirty

