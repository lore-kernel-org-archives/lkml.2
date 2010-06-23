Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab0FWDi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 23:38:58 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:63135 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab0FWDi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 23:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=edduODnsxtrjoGqV6t1+Locw0ghl6UaL/ni0yww8B4Jdw+z2EyNP6SVf4KtJTxU8sq
         BQBUNrGCFKkACg/r0Q0H1YCveIA+pmNHCVB48h/HZH3przLmbmBtjmBrF6JGEb+uQ8II
         A5bsk8U6FS2LRI9BLhMQJ7KpvnQ2mKFdZHuZE=
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: gregkh@suse.de, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: [PATCH] Staging: memrar: fix coding style issues in memrar_handler.c
Date: Tue, 22 Jun 2010 22:37:33 -0500
Message-Id: <1277264253-10583-1-git-send-email-silvagustavo@users.sourceforge.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the memrar_handler.c file that fixes up the following
issues:

ERROR: trailing whitespace
ERROR: code indent should use tabs where possible
WARNING: please, no space before tabs

Signed-off-by: Gustavo Silva <silvagustavo@users.sourceforge.net>
---
 drivers/staging/memrar/memrar_handler.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/memrar/memrar_handler.c b/drivers/staging/memrar/memrar_handler.c
index efa7fd6..cb2840e 100644
--- a/drivers/staging/memrar/memrar_handler.c
+++ b/drivers/staging/memrar/memrar_handler.c
@@ -291,7 +291,7 @@ static int memrar_init_rar_resources(int rarnum, char const *devname)
 	if (rar_get_address(rarnum, &low, &high) != 0)
 		/* No RAR is available. */
 		return -ENODEV;
-	
+
 	if (low == 0 || high == 0) {
 		rar->base      = 0;
 		rar->length    = 0;
@@ -531,7 +531,7 @@ static long memrar_get_stat(struct RAR_stat *r)
 {
 	struct memrar_allocator *allocator;
 
- 	if (!memrar_is_valid_rar_type(r->type))
+	if (!memrar_is_valid_rar_type(r->type))
 		return -EINVAL;
 
 	if (!memrars[r->type].allocated)
-- 
1.7.1

