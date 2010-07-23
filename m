Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605Ab0GWUWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:22:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42489 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab0GWUWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=bJbLRHON7QKIPh4MncWneVhdmgB0Y6zX4g/5GJp8pMLZ9LlKkKEjE0LXjRvMHcpBNi
         TtjlfmfhvkJCsznk2bNNtFBsar8Brv9RxAAAEW+LMRWkrISHjRU6W6gR+VuH2JcJdnCO
         LUlquEYxoJy4RxMWK/g//NnbYGV+fhrMGohSQ=
Date: Fri, 23 Jul 2010 22:23:50 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Marek Vasut <marek.vasut@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] ARM: sa1111: move __sa1111_probe() to
 .devinit.text
Message-ID: <20100723202350.GD976@boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <1279915120-4373-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1279915120-4373-3-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1279915120-4373-3-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


you beat me to it :)

Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

On Fri, Jul 23, 2010 at 09:58:26PM +0200, Uwe Kleine-König wrote:
> __sa1111_probe is only called by sa1111_probe that lives in .devinit.text.
> So it's save to move the former to .devinit.text, too.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  arch/arm/common/sa1111.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
> index 6f80665..97c5bc9 100644
> --- a/arch/arm/common/sa1111.c
> +++ b/arch/arm/common/sa1111.c
> @@ -681,7 +681,7 @@ out:
>   *	%-EBUSY		physical address already marked in-use.
>   *	%0		successful.
>   */
> -static int
> +static int __devinit
>  __sa1111_probe(struct device *me, struct resource *mem, int irq)
>  {
>  	struct sa1111 *sachip;
> -- 
> 1.7.1
