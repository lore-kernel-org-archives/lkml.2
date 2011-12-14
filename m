Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab1LNAWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 19:22:08 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45595 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956Ab1LNAWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 19:22:05 -0500
X-Sasl-enc: uuVellw3nyesJ29lSf7XF0aRHmSNpGBlZkqGEhzsq6Hx 1323822124
Date: Tue, 13 Dec 2011 16:18:47 -0800
From: Greg KH <greg@kroah.com>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: zram: print the disk size in KB
Message-ID: <20111214001847.GA26688@kroah.com>
References: <CAB4K4y74HtRxF6iMayonaSvc2Uoe9Fr+7Bwf9Fr05NwbrSDU8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB4K4y74HtRxF6iMayonaSvc2Uoe9Fr+7Bwf9Fr05NwbrSDU8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 10:46:53AM +0530, Ajeet Yadav wrote:
> >From a5d5ba92b5af9134e617986884856334c377e1d0 Mon Sep 17 00:00:00 2001
> From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> Date: Mon, 12 Dec 2011 18:42:30 +0530
> Subject: [PATCH 1/1] Staging: zram: print the disk size in KB

Why did you include the patch in an email instead of using
git-send-email?  This would force me to edit the patch by hand, removing
this useless stuff.

> 
> Total memory size is in KB, but the zram disk size was not
> printed in KB, correct the figure in KB units.
> 
> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> ---
>  drivers/staging/zram/zram_drv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 09de99f..ff591e3 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -126,7 +126,7 @@ static void zram_set_disksize(struct zram *zram,
> size_t totalram_bytes)

And your patch is line-wrapped, making it so I would have to edit it
again.

Please fix up, and get the acks from the zram maintainer (as this does
change a kernel/user api) before I can accept this.

greg k-h
