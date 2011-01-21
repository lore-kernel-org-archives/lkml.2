Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1AUP1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:27:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab1AUP1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:27:17 -0500
Date: Fri, 21 Jan 2011 16:27:12 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Tao Ma <boyu.mt@taobao.com>
Subject: Re: [PATCH] ext4/trivial: Fix comment typo "especiially".
In-Reply-To: <1295623291-10909-1-git-send-email-tm@tao.ma>
Message-ID: <alpine.LNX.2.00.1101211627070.5725@pobox.suse.cz>
References: <1295623291-10909-1-git-send-email-tm@tao.ma>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> Change "especiially" to "especially".
> 
> Cc: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext4/extents.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 63a7581..353b387 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -131,7 +131,7 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
>  		 * fragmenting the file system's free space.  Maybe we
>  		 * should have some hueristics or some way to allow
>  		 * userspace to pass a hint to file system,
> -		 * especiially if the latter case turns out to be
> +		 * especially if the latter case turns out to be
>  		 * common.
>  		 */
>  		ex = path[depth].p_ext;

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
