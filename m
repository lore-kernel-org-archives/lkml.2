Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab2GMMDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 08:03:46 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:2479 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932140Ab2GMMDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 08:03:44 -0400
Message-ID: <1342181022.22584.46.camel@x61.thuisdomein>
Subject: [PATCH] staging: wlags49_h2: remove vi modelines
From: Paul Bolle <pebolle@tiscali.nl>
To: Henk de Groot <pe1dnn@amsat.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 13 Jul 2012 14:03:42 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 13 Jul 2012 12:03:42.0680 (UTC) FILETIME=[8C0E2580:01CD60EF]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Opening drivers/staging/wlags49_h2/dhf.2 with vim triggered this
warning:
"drivers/staging/wlags49_h2/dhf.h" 226L, 8428C
Error detected while processing modelines:
line    2:
E518: Unknown option: */
Press ENTER or type command to continue

1) Since the Linux kernel coding style disallows modelines this invalid
modeline can simply be removed. And since we're touching this file we
might as well remove all vim modelines from this driver.

2) vim tested only.

 drivers/staging/wlags49_h2/dhf.c    |    1 -
 drivers/staging/wlags49_h2/dhf.h    |    1 -
 drivers/staging/wlags49_h2/hcf.h    |    1 -
 drivers/staging/wlags49_h2/hcfcfg.h |    1 -
 drivers/staging/wlags49_h2/mdd.h    |    1 -
 drivers/staging/wlags49_h2/mmd.c    |    1 -
 drivers/staging/wlags49_h2/mmd.h    |    1 -
 7 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wlags49_h2/dhf.c b/drivers/staging/wlags49_h2/dhf.c
index bb80b54..13d360f 100644
--- a/drivers/staging/wlags49_h2/dhf.c
+++ b/drivers/staging/wlags49_h2/dhf.c
@@ -1,5 +1,4 @@
 
-/*   vim:tw=110:ts=4: */
 /**************************************************************************************************************
 *
 * FILE   :	DHF.C
diff --git a/drivers/staging/wlags49_h2/dhf.h b/drivers/staging/wlags49_h2/dhf.h
index dbe0611..1299b825 100644
--- a/drivers/staging/wlags49_h2/dhf.h
+++ b/drivers/staging/wlags49_h2/dhf.h
@@ -1,5 +1,4 @@
 
-/*   vim:tw=110:ts=4: */
 #ifndef DHF_H
 #define DHF_H
 
diff --git a/drivers/staging/wlags49_h2/hcf.h b/drivers/staging/wlags49_h2/hcf.h
index 68e2330..2abeaa1 100644
--- a/drivers/staging/wlags49_h2/hcf.h
+++ b/drivers/staging/wlags49_h2/hcf.h
@@ -1,5 +1,4 @@
 
-//   vim:tw=110:ts=4:
 #ifndef HCF_H
 #define HCF_H 1
 
diff --git a/drivers/staging/wlags49_h2/hcfcfg.h b/drivers/staging/wlags49_h2/hcfcfg.h
index ef60da8..39fb4d3 100644
--- a/drivers/staging/wlags49_h2/hcfcfg.h
+++ b/drivers/staging/wlags49_h2/hcfcfg.h
@@ -1,5 +1,4 @@
 
-//   vim:tw=110:ts=4:
 #ifndef HCFCFG_H
 #define HCFCFG_H 1
 
diff --git a/drivers/staging/wlags49_h2/mdd.h b/drivers/staging/wlags49_h2/mdd.h
index 5f951ef..5c3515f 100644
--- a/drivers/staging/wlags49_h2/mdd.h
+++ b/drivers/staging/wlags49_h2/mdd.h
@@ -1,5 +1,4 @@
 
-//   vim:tw=110:ts=4:
 #ifndef MDD_H
 #define MDD_H 1
 
diff --git a/drivers/staging/wlags49_h2/mmd.c b/drivers/staging/wlags49_h2/mmd.c
index 7204a37..3312348 100644
--- a/drivers/staging/wlags49_h2/mmd.c
+++ b/drivers/staging/wlags49_h2/mmd.c
@@ -1,5 +1,4 @@
 
-//   vim:tw=110:ts=4:
 /************************************************************************************************************
 *
 * FILE	  : mmd.c
diff --git a/drivers/staging/wlags49_h2/mmd.h b/drivers/staging/wlags49_h2/mmd.h
index 9149525..1445803 100644
--- a/drivers/staging/wlags49_h2/mmd.h
+++ b/drivers/staging/wlags49_h2/mmd.h
@@ -1,5 +1,4 @@
 
-//   vim:tw=110:ts=4:
 #ifndef MMD_H
 #define MMD_H 1
 
-- 
1.7.7.6

