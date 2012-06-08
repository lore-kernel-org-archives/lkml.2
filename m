Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083Ab2FHHhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:37:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40116 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2FHHhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:37:21 -0400
Message-ID: <4FD1ABA6.6030103@vflare.org>
Date: Fri, 08 Jun 2012 00:37:10 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sam Hansen <solid.se7en@gmail.com>
CC: Sam Hansen <sam@meebo-inc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: zram: conventions, __aligned() attribute
References: <1339100404-18773-1-git-send-email-solid.se7en@gmail.com> <1339100404-18773-3-git-send-email-solid.se7en@gmail.com>
In-Reply-To: <1339100404-18773-3-git-send-email-solid.se7en@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 01:20 PM, Sam Hansen wrote:

> Using the __aligned() attribute in favor of __attribute__((aligned(size)))
> 
> Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
> ---
>  drivers/staging/zram/zram_drv.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
> index fbe8ac9..cda89ec 100644
> --- a/drivers/staging/zram/zram_drv.h
> +++ b/drivers/staging/zram/zram_drv.h
> @@ -85,7 +85,7 @@ struct table {
>  	u16 size;	/* object size (excluding header) */
>  	u8 count;	/* object ref count (not yet used) */
>  	u8 flags;
> -} __attribute__((aligned(4)));
> +} __aligned(4);
>  
>  struct zram_stats {
>  	u64 compr_size;		/* compressed size of pages stored */


I plan to get rid of this table soon (as part of zsmalloc compaction
work). So, we can skip any changes to this part of the code.

Thanks,
Nitin

