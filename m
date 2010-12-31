Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0LaSUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 13:20:48 -0500
Received: from mail-pw0-f66.google.com ([209.85.160.66]:53612 "EHLO
	mail-pw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab0LaSUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 13:20:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hyW4xnxickKmpDjDxL+vfzZf39iLROlS/W7dP0xuPpEa7b2jahy5D/j1fpW9IF6t1f
         nuAJBiw1jT/WF4Bj7sODZu0nycyGSPpBOMAqk97mKDX5cK7tprQK8Ry6J3J8q6s8qkpT
         XjK7XIcqO9NEO862dPxqUBf8M9i9pzIK/ELlM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] staging: tidspbridge Typo change dload_tramp_pkt_udpate to dload_tramp_pkt_update
Date: Fri, 31 Dec 2010 10:20:55 -0800
Message-Id: <1293819655-8803-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below changes a typo "dload_tramp_pkt_udpate" to "dload_tramp_pkt_update".
Let me know if this is the correct change for this.
Note:I am unable to compile test this, due to not finding this in my .config
(not sure where this is located)


Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/tidspbridge/dynload/cload.c        |    2 +-
 .../staging/tidspbridge/dynload/dload_internal.h   |    2 +-
 drivers/staging/tidspbridge/dynload/tramp.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tidspbridge/dynload/cload.c b/drivers/staging/tidspbridge/dynload/cload.c
index c85a5e8..3151f3f 100644
--- a/drivers/staging/tidspbridge/dynload/cload.c
+++ b/drivers/staging/tidspbridge/dynload/cload.c
@@ -1102,7 +1102,7 @@ static int relocate_packet(struct dload_state *dlthis,
 	 * trampoline copy of the packet since a 2nd phase relo will be done
 	 * later. */
 	if (*tramps_generated == true) {
-		dload_tramp_pkt_udpate(dlthis,
+		dload_tramp_pkt_update(dlthis,
 				       (dlthis->image_secn -
 					dlthis->ldr_sections),
 				       dlthis->image_offset, ipacket);
diff --git a/drivers/staging/tidspbridge/dynload/dload_internal.h b/drivers/staging/tidspbridge/dynload/dload_internal.h
index 302a7c5..0bc219b 100644
--- a/drivers/staging/tidspbridge/dynload/dload_internal.h
+++ b/drivers/staging/tidspbridge/dynload/dload_internal.h
@@ -333,7 +333,7 @@ int dload_tramp_generate(struct dload_state *dlthis, s16 secnn,
 			 u32 image_offset, struct image_packet_t *ipacket,
 			 struct reloc_record_t *rp);
 
-extern int dload_tramp_pkt_udpate(struct dload_state *dlthis,
+extern int dload_tramp_pkt_update(struct dload_state *dlthis,
 				  s16 secnn, u32 image_offset,
 				  struct image_packet_t *ipacket);
 
diff --git a/drivers/staging/tidspbridge/dynload/tramp.c b/drivers/staging/tidspbridge/dynload/tramp.c
index 60d22ea..0c20400 100644
--- a/drivers/staging/tidspbridge/dynload/tramp.c
+++ b/drivers/staging/tidspbridge/dynload/tramp.c
@@ -1005,7 +1005,7 @@ int dload_tramp_generate(struct dload_state *dlthis, s16 secnn,
  *	  pass relo is done during finalize the image packet can be
  *	  written to the target since all relo is done.
  */
-int dload_tramp_pkt_udpate(struct dload_state *dlthis, s16 secnn,
+int dload_tramp_pkt_update(struct dload_state *dlthis, s16 secnn,
 			   u32 image_offset, struct image_packet_t *ipacket)
 {
 	struct tramp_img_dup_pkt *dup_pkt = NULL;
-- 
1.6.5.2.180.gc5b3e

