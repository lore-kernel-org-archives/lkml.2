Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1LUSay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:30:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50389 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab1LUSat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:30:49 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, mszeredi@suse.cz
Subject: [PATCH 3/9] vfs: export do_splice_direct() to modules
Date: Wed, 21 Dec 2011 19:29:42 +0100
Message-Id: <1324492188-3481-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1324492188-3481-1-git-send-email-miklos@szeredi.hu>
References: <1324492188-3481-1-git-send-email-miklos@szeredi.hu>
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
index 1ec0493..b9d4861 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1299,6 +1299,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 
 	return ret;
 }
+EXPORT_SYMBOL(do_splice_direct);
 
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
-- 
1.7.7

