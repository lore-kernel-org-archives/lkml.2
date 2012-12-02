Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2LBMO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 07:14:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59199 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2LBMO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 07:14:27 -0500
Date: Sun, 2 Dec 2012 20:27:26 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: zwu.kernel@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: remove some unused code lines
Message-ID: <20121202122726.GA14852@gmail.com>
Mail-Followup-To: zwu.kernel@gmail.com, linux-ext4@vger.kernel.org,
	tytso@mit.edu, linux-kernel@vger.kernel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
References: <1354183200-8628-1-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354183200-8628-1-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 06:00:00PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Please write a commit log to describe this patch, even though it is
quite simple and straightfoward

Otherwise, it looks good to me.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Regards,
                                                - Zheng

> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  fs/ext4/extents.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7011ac9..43ec639 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2156,7 +2156,6 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
>  		  struct ext4_extent *ex)
>  {
>  	struct ext4_ext_cache *cex;
> -	struct ext4_sb_info *sbi;
>  	int ret = 0;
>  
>  	/*
> @@ -2164,7 +2163,6 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
>  	 */
>  	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	cex = &EXT4_I(inode)->i_cached_extent;
> -	sbi = EXT4_SB(inode->i_sb);
>  
>  	/* has cache valid data? */
>  	if (cex->ec_len == 0)
> -- 
> 1.7.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
