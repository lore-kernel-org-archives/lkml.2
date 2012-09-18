Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2IRUf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 16:35:58 -0400
Received: from fieldses.org ([174.143.236.118]:37246 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab2IRUf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 16:35:57 -0400
Date: Tue, 18 Sep 2012 16:35:51 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, Trond.Myklebust@netapp.com
Subject: [PATCH] trivial select_parent documentation fix
Message-ID: <20120918203550.GA21472@fieldses.org>
References: <871ui01jr1.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ui01jr1.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Search list for X" sounds like you're trying to find X on a list.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>

---

On Mon, Sep 17, 2012 at 10:23:30PM +0200, Miklos Szeredi wrote:
> IBM reported a deadlock in select_parent().

(And I went to look at select_parent() and got tripped up for a few
moments on this comment.  Arguably my reading comprehension is just
bad.)--b.

diff --git a/fs/dcache.c b/fs/dcache.c
index 8086636..a0b8d65 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1141,7 +1141,7 @@ rename_retry:
 EXPORT_SYMBOL(have_submounts);
 
 /*
- * Search the dentry child list for the specified parent,
+ * Search the dentry child list of the specified parent,
  * and move any unused dentries to the end of the unused
  * list for prune_dcache(). We descend to the next level
  * whenever the d_subdirs list is non-empty and continue
