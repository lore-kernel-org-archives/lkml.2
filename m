Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1BZQPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 11:15:18 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46011 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab1BZQPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 11:15:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eRJF87/ebMPueCB0XsYX/4eaicchK+R9ku4Iv0c9fsBTb+WsozE4jxPaLlGRLynbXj
         xK7YdUWGURGS0F/NnPyfNfB+RSPMKnX6rmaCzf37JZQCUu80/8BqvdugXZUc5rjKKCcg
         gjCZSeyGymYYw2ZFy7AVvbhbX0aRcurgC0J0Q=
Date: Sat, 26 Feb 2011 11:15:13 -0500
From: Tracey Dent <tdent48227@gmail.com>
To: tdent48227@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, dedekind1@gmail.com
Subject: [PATCH] fs/jffs2/xattr: Fix coding style
Message-ID: <20110226161513.GA6782@c-68-60-162-129.hsd1.mi.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the trailing white space.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 fs/jffs2/xattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index 4f9cc04..3e93cdd 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -31,7 +31,7 @@
  *   is used to release xattr name/value pair and detach from c->xattrindex.
  * reclaim_xattr_datum(c)
  *   is used to reclaim xattr name/value pairs on the xattr name/value pair cache when
- *   memory usage by cache is over c->xdatum_mem_threshold. Currently, this threshold 
+ *   memory usage by cache is over c->xdatum_mem_threshold. Currently, this threshold
  *   is hard coded as 32KiB.
  * do_verify_xattr_datum(c, xd)
  *   is used to load the xdatum informations without name/value pair from the medium.
-- 
1.7.4.1.53.ga66ce

