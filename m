Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab0KONPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 08:15:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab0KONPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:15:14 -0500
Date: Mon, 15 Nov 2010 14:15:12 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ext4: fix redirty_page_for_writepage() typo in comment
In-Reply-To: <20101111112329.GA6923@localhost>
Message-ID: <alpine.LNX.2.00.1011151414580.7420@pobox.suse.cz>
References: <20101111112329.GA6923@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Wu Fengguang wrote:

> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 1916164..b82fbd9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3357,7 +3357,7 @@ int ext4_alloc_da_blocks(struct inode *inode)
>  	 * doing I/O at all.
>  	 *
>  	 * We could call write_cache_pages(), and then redirty all of
> -	 * the pages by calling redirty_page_for_writeback() but that
> +	 * the pages by calling redirty_page_for_writepage() but that
>  	 * would be ugly in the extreme.  So instead we would need to
>  	 * replicate parts of the code in the above functions,
>  	 * simplifying them becuase we wouldn't actually intend to

This fix doesn't seem to be present in linux-next as of today, so I have 
picked it up. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
