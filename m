Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab0I0RJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 13:09:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:36715 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757031Ab0I0RJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 13:09:24 -0400
Date: Mon, 27 Sep 2010 19:08:30 +0200
From: Jan Kara <jack@suse.cz>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Jiri Kosina <trivial@kernel.org>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: fix comment on ext2_try_to_allocate()
Message-ID: <20100927170830.GD3610@quack.suse.cz>
References: <1285482660-9937-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285482660-9937-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 26-09-10 15:31:00, Namhyung Kim wrote:
> @handle doesn't exist in ext2. Remove it.
> Also, fit comment header into kernel-doc format.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
  Thanks. I've merged it in my tree.

							Honza
> ---
>  fs/ext2/balloc.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index c6c684b..0d06f4e 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -646,10 +646,9 @@ find_next_usable_block(int start, struct buffer_head *bh, int maxblocks)
>  	return here;
>  }
>  
> -/*
> +/**
>   * ext2_try_to_allocate()
>   * @sb:			superblock
> - * @handle:		handle to this transaction
>   * @group:		given allocation block group
>   * @bitmap_bh:		bufferhead holds the block bitmap
>   * @grp_goal:		given target block within the group
> -- 
> 1.7.2.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
