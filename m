Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab1EaK1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:27:14 -0400
Received: from 9.26.mail-out.ovh.net ([46.105.56.220]:52611 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752041Ab1EaK1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:27:12 -0400
X-Greylist: delayed 6400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 May 2011 06:27:11 EDT
Date: Tue, 31 May 2011 10:28:00 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Maxim Osipov <maxim.osipov@gmail.com>
Cc: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] AT91: flexibity: default leds to heartbeat
Message-ID: <20110531082800.GE26294@game.jcrosoft.org>
References: <1306775627-6640-1-git-send-email-maxim.osipov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306775627-6640-1-git-send-email-maxim.osipov@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12212636290216930274
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:13 Mon 30 May     , Maxim Osipov wrote:
> This patch changes default behavior of Flexibity board LEDs to blinking
> for boot diagnostic purpose.
> 
> Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
> ---
>  arch/arm/mach-at91/board-flexibity.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
> index 4fdc96c..8cbec8a 100644
> --- a/arch/arm/mach-at91/board-flexibity.c
> +++ b/arch/arm/mach-at91/board-flexibity.c
> @@ -96,49 +96,49 @@ static struct gpio_led flexibity_leds[] = {
>  		.name			= "usb1:green",
>  		.gpio			= AT91_PIN_PA12,
>  		.active_low		= 1,
> -		.default_trigger	= "default-on",
> +		.default_trigger	= "heartbeat",
can we factorize this a few
they have all the same default_trigger and active low

Best Regards,
J.
