Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1KYI1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 03:27:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1KYI1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 03:27:03 -0500
Date: Fri, 25 Nov 2011 16:29:10 +0800
From: Dave Young <dyoung@redhat.com>
To: axboe@kernel.dk, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH]loop: fix loop block driver comment
Message-ID: <20111125082910.GA2661@darkstar.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop driver do not support discard if encryption is enabled, fix the comment.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 drivers/block/loop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/block/loop.c	2011-11-21 17:24:16.000000000 +0800
+++ linux-2.6/drivers/block/loop.c	2011-11-25 16:25:42.075280030 +0800
@@ -422,7 +422,7 @@ static int do_bio_filebacked(struct loop
 
 		/*
 		 * We use punch hole to reclaim the free space used by the
-		 * image a.k.a. discard. However we do support discard if
+		 * image a.k.a. discard. However we do not support discard if
 		 * encryption is enabled, because it may give an attacker
 		 * useful information.
 		 */
