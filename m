Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2GPPEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:04:24 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33379 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752126Ab2GPPEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:04:22 -0400
Date: Mon, 16 Jul 2012 10:10:38 -0500
From: Ben Myers <bpm@sgi.com>
To: Chen Baozi <baozich@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfs: fix comment typo of struct xfs_da_blkinfo.
Message-ID: <20120716151038.GI29979@sgi.com>
References: <1342208293-3405-1-git-send-email-baozich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342208293-3405-1-git-send-email-baozich@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Chen,

On Sat, Jul 14, 2012 at 03:38:13AM +0800, Chen Baozi wrote:
> Fix trivial typo error that has written "It" to "Is".
> 
> Signed-off-by: Chen Baozi <baozich@gmail.com>

Reviewed-by: Ben Myers <bpm@sgi.com>

Thanks for the patch!  I'm happy you're working on XFS.  Do you have any
time/interest in taking on a work item or two?  I have a few would-be-nices
which I've made notes of, and I'm sure that Dave or Christoph could also think
of a few if you're interested.

Thanks again,
-Ben

> ---
>  fs/xfs/xfs_da_btree.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_da_btree.h b/fs/xfs/xfs_da_btree.h
> index dbf7c07..be30bd4 100644
> --- a/fs/xfs/xfs_da_btree.h
> +++ b/fs/xfs/xfs_da_btree.h
> @@ -32,7 +32,7 @@ struct zone;
>  /*
>   * This structure is common to both leaf nodes and non-leaf nodes in the Btree.
>   *
> - * Is is used to manage a doubly linked list of all blocks at the same
> + * It is used to manage a doubly linked list of all blocks at the same
>   * level in the Btree, and to identify which type of block this is.
>   */
>  #define XFS_DA_NODE_MAGIC	0xfebe	/* magic number: non-leaf blocks */
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
