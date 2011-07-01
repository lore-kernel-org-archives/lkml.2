Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1GAJ6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:58:22 -0400
Received: from mail.perches.com ([173.55.12.10]:3412 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab1GAJ6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:58:20 -0400
Subject: Re: [PATCH v2] block: ioctl: Fix coding style issues
From: Joe Perches <joe@perches.com>
To: Chris Forbes <chrisf@ijw.co.nz>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
In-Reply-To: <1309513472-30687-1-git-send-email-chrisf@ijw.co.nz>
References: <BANLkTin_4UHOxAip2XWgiX5=f0dOG3S5wg@mail.gmail.com>
	 <1309513472-30687-1-git-send-email-chrisf@ijw.co.nz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 02:58:19 -0700
Message-ID: <1309514299.7277.30.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 21:44 +1200, Chris Forbes wrote:
> Fixed issues as flagged by checkpatch.pl
> diff --git a/block/ioctl.c b/block/ioctl.c
[]
> @@ -6,10 +6,10 @@
>  #include <linux/backing-dev.h>
>  #include <linux/buffer_head.h>
>  #include <linux/blktrace_api.h>
> -#include <asm/uaccess.h>
> +#include <linux/uaccess.h>
>  
> -static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user *arg)
> -{
> +static int blkpg_ioctl(struct block_device *bdev,
> +			struct blkpg_ioctl_arg __user *arg) {

Hey Chris.

Sorry, that's not right.
The open brace needs to be on a new line.


