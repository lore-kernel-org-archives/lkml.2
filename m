Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab2AEAbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:31:40 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50630 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932119Ab2AEAbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:31:39 -0500
X-Sasl-enc: OIxCKHCF6YQg1i5hdQpdmAkyS8T9msquMmEKUgHz4+8k 1325723497
Date: Wed, 4 Jan 2012 16:17:00 -0800
From: Greg KH <greg@kroah.com>
To: Vitaly Kuznetsov <vitty@altlinux.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: change permissions for /sys from 0755 to 0555
Message-ID: <20120105001700.GA26711@kroah.com>
References: <1b3c733f0412e214042566bac2c3f3e6@hadoop.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b3c733f0412e214042566bac2c3f3e6@hadoop.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 07:34:50PM +0400, Vitaly Kuznetsov wrote:
> There is a misleading difference between /proc and /sys permissions,
> /proc is 0555 and /sys is 0755. But
> as it is impossible to create or unlink something in /sys it would
> be nice to have same permissions.
> 
> Signed-off-by: Vitaly Kuznetsov <vitty@altlinux.ru>
> ---
>  fs/sysfs/mount.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index 4974995..9d56fdd 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -36,7 +36,7 @@ struct sysfs_dirent sysfs_root = {
>         .s_name         = "",
>         .s_count        = ATOMIC_INIT(1),
>         .s_flags        = SYSFS_DIR,
> -       .s_mode         = S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
> +       .s_mode         = S_IFDIR | S_IRUGO | S_IXUGO,
>         .s_ino          = 1,

The tabs are all converted to spaces here, making this impossible to
apply :(

