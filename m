Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab1BQPl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:41:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab1BQPlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:41:51 -0500
Date: Thu, 17 Feb 2011 16:41:48 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: update comments to point correct document
In-Reply-To: <1295677892-3767-1-git-send-email-namhyung@gmail.com>
Message-ID: <alpine.LNX.2.00.1102171641340.2160@pobox.suse.cz>
References: <1295677892-3767-1-git-send-email-namhyung@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011, Namhyung Kim wrote:

> dcache-locking.txt is not exist any more, and the path was not
> correct anyway. Fix it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/dcache.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 9f493ee4dcba..56be05ef4fe3 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1779,7 +1779,7 @@ struct dentry *__d_lookup_rcu(struct dentry *parent, struct qstr *name,
>  	 * false-negative result. d_lookup() protects against concurrent
>  	 * renames using rename_lock seqlock.
>  	 *
> -	 * See Documentation/vfs/dcache-locking.txt for more details.
> +	 * See Documentation/filesystems/path-lookup.txt for more details.
>  	 */
>  	hlist_bl_for_each_entry_rcu(dentry, node, &b->head, d_hash) {
>  		struct inode *i;
> @@ -1899,7 +1899,7 @@ struct dentry *__d_lookup(struct dentry *parent, struct qstr *name)
>  	 * false-negative result. d_lookup() protects against concurrent
>  	 * renames using rename_lock seqlock.
>  	 *
> -	 * See Documentation/vfs/dcache-locking.txt for more details.
> +	 * See Documentation/filesystems/path-lookup.txt for more details.
>  	 */
>  	rcu_read_lock();

Doesn't seem to be present in linux-next as of today. I have picked that 
up.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
