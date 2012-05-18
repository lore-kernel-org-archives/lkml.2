Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946025Ab2ERNZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:25:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933711Ab2ERNZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:25:45 -0400
Date: Fri, 18 May 2012 15:25:24 +0200
From: Jan Kara <jack@suse.cz>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: trivial fix to comment for ext2_free_blocks
Message-ID: <20120518132524.GB5589@quack.suse.cz>
References: <4FB5F48D.1090902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB5F48D.1090902@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 18-05-12 15:04:45, Wang Sheng-Hui wrote:
> The function is ext2_free_blocks(), not ext2_free_blocks_sb().
  Thanks. Merged.

								Honza
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/ext2/balloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index a8cbe1b..1a6bf5e 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -479,7 +479,7 @@ void ext2_discard_reservation(struct inode *inode)
>  }
>  
>  /**
> - * ext2_free_blocks_sb() -- Free given blocks and update quota and i_blocks
> + * ext2_free_blocks() -- Free given blocks and update quota and i_blocks
>   * @inode:		inode
>   * @block:		start physcial block to free
>   * @count:		number of blocks to free
> -- 
> 1.7.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
