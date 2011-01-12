Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab1ALNhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:37:07 -0500
Received: from mail.atmel.fr ([81.80.104.162]:36388 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932499Ab1ALNhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:37:03 -0500
Message-ID: <4D2DAE40.80803@atmel.com>
Date: Wed, 12 Jan 2011 14:36:00 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com,
        plagnioj@jcrosoft.com
Subject: Re: [PATCH] MAINTAINERS: Update Atmel AT91 entry
References: <1294250698-13275-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1294250698-13275-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 05/01/2011 19:04, Nicolas Ferre :
> Add two co-maintainers and update the entry with new information.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Andrew Victor <linux@maxim.org.za>
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Hi Andrew (Morton),

Maybe you can handle this "MAINTAINERS" patch?

Thanks a lot, bye.

> ---
>  MAINTAINERS |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7585e9d..cb58500 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -552,11 +552,15 @@ M:	Lennert Buytenhek <kernel@wantstofly.org>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  
> -ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
> +ARM/ATMEL AT91RM9200 AND AT91SAM ARM ARCHITECTURES
>  M:	Andrew Victor <linux@maxim.org.za>
> +M:	Nicolas Ferre <nicolas.ferre@atmel.com>
> +M:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  W:	http://maxim.org.za/at91_26.html
> -S:	Maintained
> +W:	http://www.linux4sam.org
> +S:	Supported
> +F:	arch/arm/mach-at91/
>  
>  ARM/BCMRING ARM ARCHITECTURE
>  M:	Jiandong Zheng <jdzheng@broadcom.com>


-- 
Nicolas Ferre
