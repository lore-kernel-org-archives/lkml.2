Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab1LNBu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 20:50:28 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46947 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1LNBu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 20:50:27 -0500
Message-ID: <4EE800DF.9030907@vflare.org>
Date: Tue, 13 Dec 2011 20:50:23 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Jerome Marchand <jmarchan@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: zram: print the disk size in KB
References: <CAB4K4y74HtRxF6iMayonaSvc2Uoe9Fr+7Bwf9Fr05NwbrSDU8g@mail.gmail.com>
In-Reply-To: <CAB4K4y74HtRxF6iMayonaSvc2Uoe9Fr+7Bwf9Fr05NwbrSDU8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ajeet,

On 12/13/2011 12:16 AM, Ajeet Yadav wrote:

> From a5d5ba92b5af9134e617986884856334c377e1d0 Mon Sep 17 00:00:00 2001
> From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
> Date: Mon, 12 Dec 2011 18:42:30 +0530
> Subject: [PATCH 1/1] Staging: zram: print the disk size in KB
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
>  		"\tMemory Size: %zu kB\n"
>  		"\tSize you selected: %llu kB\n"
>  		"Continuing anyway ...\n",
> -		totalram_bytes >> 10, zram->disksize
> +		totalram_bytes >> 10, zram->disksize >> 10
>  		);
>  	}
> 


I'm planning to send some cleanup patches soon which, among other
things, removes this message. So, there seems to be no need to fix the same.

Thanks,
Nitin
