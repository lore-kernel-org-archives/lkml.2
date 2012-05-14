Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2ENJ4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:56:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755434Ab2ENJ4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:56:12 -0400
Date: Mon, 14 May 2012 11:55:25 +0200
From: Jan Kara <jack@suse.cz>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext2: cleanup the comment for ext2_export_ops
Message-ID: <20120514095525.GD5353@quack.suse.cz>
References: <4FB0B0F4.3060908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB0B0F4.3060908@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-05-12 15:15:00, Wang Sheng-Hui wrote:
> ext2_export_ops gets more valued fields, not get_parent only.
> Clean up the comment.
  Um, I'd just remove the whole comment. It isn't particularly informative
anyway - NULL meaning the default behavior is very common in kernel. And we
really set about half of entries anyway...

								Honza
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/ext2/super.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index e1025c7..640b4c6 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -359,7 +359,6 @@ static struct dentry *ext2_fh_to_parent(struct super_block *sb, struct fid *fid,
>  /* Yes, most of these are left as NULL!!
>   * A NULL value implies the default, which works with ext2-like file
>   * systems, but can be improved upon.
> - * Currently only get_parent is required.
>   */
>  static const struct export_operations ext2_export_ops = {
>  	.fh_to_dentry = ext2_fh_to_dentry,
> -- 
> 1.7.1
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
