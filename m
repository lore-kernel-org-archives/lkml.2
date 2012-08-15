Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab2HOPrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:47:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49173 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2HOPrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:47:09 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com, dhowells@redhat.com,
        hpj@urpla.net, sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz
Subject: [PATCH 02/13] vfs: export do_splice_direct() to modules
Date: Wed, 15 Aug 2012 17:48:09 +0200
Message-Id: <1345045700-9062-3-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Export do_splice_direct() to modules.  Needed by overlay filesystem.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 41514dd..2695a60 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1308,6 +1308,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 
 	return ret;
 }
+EXPORT_SYMBOL(do_splice_direct);
 
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
-- 
1.7.7

