Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab1IWSQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:16:05 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40261 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751092Ab1IWSQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:16:01 -0400
Subject: Re: [PATCH] btrfs/ioctl.c: quiet sparse warnings
From: Joe Perches <joe@perches.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
        chris.mason@oracle.com
Date: Fri, 23 Sep 2011 11:15:59 -0700
In-Reply-To: <201109231107.54227.hartleys@visionengravers.com>
References: <201109231107.54227.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1316801760.28330.5.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 11:07 -0700, H Hartley Sweeten wrote:
> Quiet the following sparse warnings:
[]
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
[]
> @@ -2705,7 +2705,7 @@ long btrfs_ioctl_space_info(struct btrfs_root *root, void __user *arg)
>  		up_read(&info->groups_sem);
>  	}
>  
> -	user_dest = (struct btrfs_ioctl_space_info *)
> +	user_dest = (struct btrfs_ioctl_space_info __user *)
>                 (arg + sizeof(struct btrfs_ioctl_space_args));

	user_dest = arg;
	user_dest++;

?


