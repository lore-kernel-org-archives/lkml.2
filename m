Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab0KHSyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:54:49 -0500
Received: from ns2.cypress.com ([157.95.67.5]:32950 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab0KHSys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:54:48 -0500
Reply-To: <david.cross@cypress.com>
From: "David Cross" <david.cross@cypress.com>
To: "'Jesper Juhl'" <jj@chaosbits.net>, <linux-kernel@vger.kernel.org>
Cc: "'Greg Kroah-Hartman'" <gregkh@suse.de>
References: <alpine.LNX.2.00.1011070731380.25327@swampdragon.chaosbits.net>
Subject: RE: [PATCH] Cypress WestBridge OMAP3430 Kernel Hal: Remove unneeded local variables from alloc functions
Date: Mon, 8 Nov 2010 10:54:25 -0800
Organization: Cypress Semiconductor
Message-ID: <8E4F99B145E24F26B937AE2EE1316F09@stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
In-Reply-To: <alpine.LNX.2.00.1011070731380.25327@swampdragon.chaosbits.net>
Thread-Index: Act+R8VpWWWWHG6oSnaz4bYkNVPacQBLjKqg
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> In 
> drivers/staging/westbridge/astoria/arch/arm/mach->
omap2/cyashalomap_kernel.c
> the local variables 'ret_p' are not needed and should just go away.

> I have no way to test this code, but I believe the change is obviously 
> correct. Please consider it.

I agree. ACK. thanks for the review.

> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  cyashalomap_kernel.c |   10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)

> diff --git
a/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.
c
b/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.
c
> index a678029..ad0c61d 100644
> ---
a/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.
c
> +++
b/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.
c
> @@ -2127,10 +2127,7 @@ void
cy_as_hal_pll_lock_loss_handler(cy_as_hal_device_tag tag)
>   */
>  void *cy_as_hal_alloc(uint32_t cnt)
>  {
> -	void *ret_p;
> -
> -	ret_p = kmalloc(cnt, GFP_ATOMIC);
> -	return ret_p;
> +	return kmalloc(cnt, GFP_ATOMIC);
>  }
>
>  /*
> @@ -2150,10 +2147,7 @@ void cy_as_hal_free(void *mem_p)
>   */
>  void *cy_as_hal_c_b_alloc(uint32_t cnt)
>  {
> -	void *ret_p;
> -
> -	ret_p = kmalloc(cnt, GFP_ATOMIC);
> -	return ret_p;
> +	return kmalloc(cnt, GFP_ATOMIC);
>  }
>  
>  /*
>
>
> -- 
> Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
> Plain text mails only, please      http://www.expita.com/nomime.html
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

david

