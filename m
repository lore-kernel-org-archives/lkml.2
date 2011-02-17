Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1BQC7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:59:11 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50227 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1BQC7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:59:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IOHc3bGgMlYs6e4UuKVKqir0d/FYTcxIB6npiQVfMzspc5haRAnWX/ArE2f+l+m+iq
         odT6/kn9keICayvm3RS33Z0yQDeLDhCbOt6sLWje2PwE1kEmBsY86zdFUXjkil18Pstc
         ewy78Y38CSeQ4Pu+NWNaxivaBhuuf+1v1eE2E=
From: Klaas Neirinck <klaas.neirinck@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Klaas Neirinck <klaas.neirinck@gmail.com>,
        Klaas Neirinck <klaas.nerinck@gmail.com>
Subject: [PATCH 01/10] Staging: tidspbridge: fixed a brace coding style issue
Date: Thu, 17 Feb 2011 03:58:45 +0100
Message-Id: <1297911534-31534-1-git-send-email-klaas.neirinck@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Klaas Neirinck <klaas.nerinck@gmail.com>

diff --git a/drivers/staging/tidspbridge/core/io_sm.c b/drivers/staging/tidspbridge/core/io_sm.c
index 27e0aa8..69ecd73 100644
--- a/drivers/staging/tidspbridge/core/io_sm.c
+++ b/drivers/staging/tidspbridge/core/io_sm.c
@@ -1160,9 +1160,8 @@ static void input_chnl(struct io_mgr *pio_mgr, struct chnl_object *pchnl,
 				/* Tell DSP if no more I/O buffers available */
 				if (!pchnl->pio_requests)
 					goto func_end;
-				if (LST_IS_EMPTY(pchnl->pio_requests)) {
+				if (LST_IS_EMPTY(pchnl->pio_requests))
 					set_chnl_free(sm, pchnl->chnl_id);
-				}
 				clear_chnl = true;
 				notify_client = true;
 			} else {
-- 
1.7.1

