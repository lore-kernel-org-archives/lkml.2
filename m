Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1IHISP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:18:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab1IHISN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:18:13 -0400
Message-ID: <4E687A33.1080401@redhat.com>
Date: Thu, 08 Sep 2011 10:17:55 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] Fix sparse warnings
References: <1315445357-14338-1-git-send-email-ngupta@vflare.org> <1315445357-14338-2-git-send-email-ngupta@vflare.org>
In-Reply-To: <1315445357-14338-2-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2011 03:29 AM, Nitin Gupta wrote:
> ---

I'm afraid this patch is missing a description.

Jerome

>  drivers/staging/zram/zram_drv.c |    3 ++-
>  drivers/staging/zram/zram_drv.h |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index d70ec1a..03ec5a2 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -684,7 +684,8 @@ fail:
>  	return ret;
>  }
>  
> -void zram_slot_free_notify(struct block_device *bdev, unsigned long index)
> +static void zram_slot_free_notify(struct block_device *bdev,
> +				unsigned long index)
>  {
>  	struct zram *zram;
>  
> diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
> index abe5221..70ce886 100644
> --- a/drivers/staging/zram/zram_drv.h
> +++ b/drivers/staging/zram/zram_drv.h
> @@ -47,7 +47,7 @@ static const unsigned default_disksize_perc_ram = 25;
>   * Pages that compress to size greater than this are stored
>   * uncompressed in memory.
>   */
> -static const unsigned max_zpage_size = PAGE_SIZE / 4 * 3;
> +static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
>  
>  /*
>   * NOTE: max_zpage_size must be less than or equal to:

