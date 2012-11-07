Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab2KGGjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:39:13 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61209 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2KGGjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:39:11 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: omar.ramirez@ti.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: tidspbridge: dynload: dload_internal.h: fix for coding style issue
Date: Tue,  6 Nov 2012 22:38:37 -0800
Message-Id: <1352270317-8361-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed few error messages as reported by checkpatch.pl

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 .../staging/tidspbridge/dynload/dload_internal.h   |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tidspbridge/dynload/dload_internal.h b/drivers/staging/tidspbridge/dynload/dload_internal.h
index 7b77573..b9d079b 100644
--- a/drivers/staging/tidspbridge/dynload/dload_internal.h
+++ b/drivers/staging/tidspbridge/dynload/dload_internal.h
@@ -313,14 +313,14 @@ extern uint32_t dload_reverse_checksum16(void *data, unsigned siz);
 /*
  * exported by reloc.c
  */
-extern void dload_relocate(struct dload_state *dlthis, tgt_au_t * data,
-			   struct reloc_record_t *rp, bool * tramps_generated,
+extern void dload_relocate(struct dload_state *dlthis, tgt_au_t *data,
+			   struct reloc_record_t *rp, bool *tramps_generated,
 			   bool second_pass);
 
-extern rvalue dload_unpack(struct dload_state *dlthis, tgt_au_t * data,
+extern rvalue dload_unpack(struct dload_state *dlthis, tgt_au_t *data,
 			   int fieldsz, int offset, unsigned sgn);
 
-extern int dload_repack(struct dload_state *dlthis, rvalue val, tgt_au_t * data,
+extern int dload_repack(struct dload_state *dlthis, rvalue val, tgt_au_t *data,
 			int fieldsz, int offset, unsigned sgn);
 
 /*
-- 
1.7.9.5

