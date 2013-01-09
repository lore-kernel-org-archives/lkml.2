Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab3AIR5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:57:37 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:41553 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab3AIR5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:57:36 -0500
Message-ID: <1357754254.1800.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] staging: zsmalloc: comment zs_create_pool function
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Date: Wed, 09 Jan 2013 09:57:34 -0800
In-Reply-To: <1357330440.1926.1.camel@buesod1.americas.hpqcorp.net>
References: <1357330440.1926.1.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Fri, 2013-01-04 at 12:14 -0800, Davidlohr Bueso wrote:
> Just as with zs_malloc() and zs_map_object(), it is worth
> formally commenting the zs_create_pool() function.
> 
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> ---
>  drivers/staging/zsmalloc/zsmalloc-main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index 09a9d35..eb00772 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -798,6 +798,17 @@ fail:
>  	return notifier_to_errno(ret);
>  }
>  
> +/**
> + * zs_create_pool - Creates an allocation pool to work from.
> + * @name: name of the pool to be created
> + * @flags: allocation flags used when growing pool
> + *
> + * This function must be called before anything when using
> + * the zsmalloc allocator.
> + *
> + * On success, a pointer to the newly created pool is returned,
> + * otherwise NULL.
> + */
>  struct zs_pool *zs_create_pool(const char *name, gfp_t flags)
>  {
>  	int i, ovhd_size;


