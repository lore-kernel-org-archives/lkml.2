Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2DMWRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 18:17:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51333 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab2DMWRX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 18:17:23 -0400
MIME-Version: 1.0
In-Reply-To: <1334101538-19127-1-git-send-email-gurligebis@gentoo.org>
References: <1334101538-19127-1-git-send-email-gurligebis@gentoo.org>
Date: Sat, 14 Apr 2012 00:17:22 +0200
X-Google-Sender-Auth: eImcYbfUX-DE5va0IJE1Dvy35uc
Message-ID: <CACPM=kUwXocWWMQUKyakydeH72d7FHj-Rxw3bzqc0qDeyWP-yg@mail.gmail.com>
Subject: Re: [PATCH] NET5501: Change active_low to 0 for LED driver.
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: philipp@redfish-solutions.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11. apr. 2012 01.45 skrev Bjarke Istrup Pedersen <gurligebis@gentoo.org>:
> It seems that there was an error with the active_low = 1 for the
> LED, since it should be set to 0 (meaning that active is high,
> since 0 is false, hence the confusion.
>
> The wiki article about it confuses it, since it contradicts
> itself, regarding what turns on the LED.
>
> I have tested 3.4-rc2 on my net5501 with this patch, and it
> makes the LED behave correctly, where "none" turns it off, and
> "default-on" turns it on, when echoed onto the trigger "file"
> in /sys/class/leds.
>
> Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
> ---
>  arch/x86/platform/geode/net5501.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/platform/geode/net5501.c b/arch/x86/platform/geode/net5501.c
> index 66d377e..646e3b5 100644
> --- a/arch/x86/platform/geode/net5501.c
> +++ b/arch/x86/platform/geode/net5501.c
> @@ -63,7 +63,7 @@ static struct gpio_led net5501_leds[] = {
>                .name = "net5501:1",
>                .gpio = 6,
>                .default_trigger = "default-on",
> -               .active_low = 1,
> +               .active_low = 0,
>        },
>  };
>
> --
> 1.7.8.5
>

I have tried sending it to linux-geode, but the list seems to reject
mails from me for some reason.
Anyone able to forward it to the right people for inclusion in 3.4-rcX ?

Thanks in advance,
Bjarke
