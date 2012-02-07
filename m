Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2BGO23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:28:29 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34167 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab2BGO0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:26:50 -0500
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 6/6] MCE, AMD: Constify error tables
Date: Tue,  7 Feb 2012 15:26:07 +0100
Message-Id: <1328624767-7956-7-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1328624767-7956-1-git-send-email-bp@amd64.org>
References: <1328624767-7956-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... so that checkpatch can chill out.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/edac/mce_amd.c |   14 +++++++-------
 drivers/edac/mce_amd.h |   12 ++++++------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 88a9297..36e1486 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -39,29 +39,29 @@ EXPORT_SYMBOL_GPL(amd_unregister_ecc_decoder);
  */
 
 /* transaction type */
-const char *tt_msgs[] = { "INSN", "DATA", "GEN", "RESV" };
+const char * const tt_msgs[] = { "INSN", "DATA", "GEN", "RESV" };
 EXPORT_SYMBOL_GPL(tt_msgs);
 
 /* cache level */
-const char *ll_msgs[] = { "RESV", "L1", "L2", "L3/GEN" };
+const char * const ll_msgs[] = { "RESV", "L1", "L2", "L3/GEN" };
 EXPORT_SYMBOL_GPL(ll_msgs);
 
 /* memory transaction type */
-const char *rrrr_msgs[] = {
+const char * const rrrr_msgs[] = {
        "GEN", "RD", "WR", "DRD", "DWR", "IRD", "PRF", "EV", "SNP"
 };
 EXPORT_SYMBOL_GPL(rrrr_msgs);
 
 /* participating processor */
-const char *pp_msgs[] = { "SRC", "RES", "OBS", "GEN" };
+const char * const pp_msgs[] = { "SRC", "RES", "OBS", "GEN" };
 EXPORT_SYMBOL_GPL(pp_msgs);
 
 /* request timeout */
-const char *to_msgs[] = { "no timeout",	"timed out" };
+const char * const to_msgs[] = { "no timeout", "timed out" };
 EXPORT_SYMBOL_GPL(to_msgs);
 
 /* memory or i/o */
-const char *ii_msgs[] = { "MEM", "RESV", "IO", "GEN" };
+const char * const ii_msgs[] = { "MEM", "RESV", "IO", "GEN" };
 EXPORT_SYMBOL_GPL(ii_msgs);
 
 static const char * const f15h_ic_mce_desc[] = {
@@ -101,7 +101,7 @@ static const char * const f15h_cu_mce_desc[] = {
 	"PRB address parity error"
 };
 
-static const char *nb_mce_desc[] = {
+static const char * const nb_mce_desc[] = {
 	"DRAM ECC error detected on the NB",
 	"CRC error detected on HT link",
 	"Link-defined sync error packets detected on HT link",
diff --git a/drivers/edac/mce_amd.h b/drivers/edac/mce_amd.h
index 6fcf599..c6074c5 100644
--- a/drivers/edac/mce_amd.h
+++ b/drivers/edac/mce_amd.h
@@ -69,12 +69,12 @@ enum rrrr_ids {
 	R4_SNOOP,
 };
 
-extern const char *tt_msgs[];
-extern const char *ll_msgs[];
-extern const char *rrrr_msgs[];
-extern const char *pp_msgs[];
-extern const char *to_msgs[];
-extern const char *ii_msgs[];
+extern const char * const tt_msgs[];
+extern const char * const ll_msgs[];
+extern const char * const rrrr_msgs[];
+extern const char * const pp_msgs[];
+extern const char * const to_msgs[];
+extern const char * const ii_msgs[];
 
 /*
  * per-family decoder ops
-- 
1.7.8.rc0

