Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1JQUZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:25:54 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:34692 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219Ab1JQUZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:25:52 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [PATCH] drivers, vmw_balloon.c: Fix typo in code comment.
Date: Mon, 17 Oct 2011 13:25:50 -0700
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1318880063.10091.14.camel@localhost.localdomain>
In-Reply-To: <1318880063.10091.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110171325.50958.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 17, 2011 12:34:23 PM Rakib Mullick wrote:
>  Fix typo in code comment.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

Acked-by: Dmitry Torokhov <dtor@vmware.com>

> ---
> 
> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> index 053d36c..2480c21 100644
> --- a/drivers/misc/vmw_balloon.c
> +++ b/drivers/misc/vmw_balloon.c
> @@ -151,7 +151,7 @@ MODULE_LICENSE("GPL");
>  struct vmballoon_stats {
>  	unsigned int timer;
> 
> -	/* allocation statustics */
> +	/* allocation statistics */
>  	unsigned int alloc;
>  	unsigned int alloc_fail;
>  	unsigned int sleep_alloc;
