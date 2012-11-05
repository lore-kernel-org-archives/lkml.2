Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab2KENLD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:11:03 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53937 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754010Ab2KENLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:11:02 -0500
X-Sasl-enc: Od/lGY7hxwzf1dLIKTwAsV2j+uF0h9/OktQqn6sZN3aB 1352121060
Date: Mon, 5 Nov 2012 14:11:08 +0100
From: Greg Kroah-Hartman <greg@kroah.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/media: Use dev_ printks in go7007/s2250-loader.c
Message-ID: <20121105131108.GC27238@kroah.com>
References: <1352115282-8081-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352115282-8081-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 08:34:42PM +0900, YAMANE Toshiaki wrote:
> fixed below checkpatch warnings.
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> - WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/media/go7007/s2250-loader.c |   35 ++++++++++++++-------------
>  1 file changed, 18 insertions(+), 17 deletions(-)

Please note that I don't touch the drivers/staging/media/* files, so
copying me on these patches doesn't do anything :)

thanks,

greg k-h
