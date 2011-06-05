Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1FEQ2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 12:28:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46694 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab1FEQ2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 12:28:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=o2lu4/p+9auKNuTezpFlRQtz0d6GyL4hJLQQQ9FyOqMCw0RxNxPWhOjv6+DakZvbSA
         ++NixKF+cGVjI5ydCkbcl+gJq5DhspOSMEe5zUCRTVZE4PoBP2rU2cnTflXQkzDueCZr
         dxurePOBVktDnsAMXI5TMlVcBaiW7Okddqw6U=
From: Joseph Salisbury <salisbury.joseph@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joseph Salisbury <salisbury.joseph@googlemail.com>,
        Joseph Salisbury <salisbury.joseph@gmail.com>
Subject: [PATCH] Staging: wlan-ng: fix brace coding style issue in prism2fw.c
Date: Sun,  5 Jun 2011 17:28:12 +0100
Message-Id: <1307291292-11142-1-git-send-email-salisbury.joseph@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joseph Salisbury <salisbury.joseph@googlemail.com>

This is a patch to the prism2fw.c file that fixes up a brace
warning found by the checkpatch.pl tool.

Signed-off-by: Joseph Salisbury <salisbury.joseph@gmail.com>
---
 drivers/staging/wlan-ng/prism2fw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index 729d03d..3c40096 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -442,9 +442,9 @@ int crcimage(struct imgchunk *fchunk, unsigned int nfchunks,
 void free_chunks(struct imgchunk *fchunk, unsigned int *nfchunks)
 {
 	int i;
-	for (i = 0; i < *nfchunks; i++) {
+	for (i = 0; i < *nfchunks; i++)
 		kfree(fchunk[i].data);
-	}
+
 	*nfchunks = 0;
 	memset(fchunk, 0, sizeof(*fchunk));
 
-- 
1.7.4.1

