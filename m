Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab2LTXm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 18:42:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2LTXmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 18:42:51 -0500
Date: Fri, 21 Dec 2012 00:42:49 +0100
From: Jan Kara <jack@suse.cz>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 4/4] ext4: Fix an incorrect comment about i_mutex
Message-ID: <20121220234249.GA13474@quack.suse.cz>
References: <cover.1356043686.git.luto@amacapital.net>
 <30dd429015418a31f6412fd1106a2df12d2922dd.1356043686.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30dd429015418a31f6412fd1106a2df12d2922dd.1356043686.git.luto@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-12-12 15:10:12, Andy Lutomirski wrote:
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

  BTW: The right person for this patch is ext4 maintainer:
"Theodore Ts'o" <tytso@mit.edu>
  Since this is completely independent of anything else in this series,
just submit the patch to him. Thanks!

								Honza
> ---
>  fs/ext4/fsync.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index be1d89f..8c15642 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -113,8 +113,6 @@ static int __sync_inode(struct inode *inode, int datasync)
>   *
>   * What we do is just kick off a commit and wait on it.  This will snapshot the
>   * inode to disk.
> - *
> - * i_mutex lock is held when entering and exiting this function
>   */
>  
>  int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
> -- 
> 1.7.11.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
