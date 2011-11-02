Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab1KBS5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:57:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38442 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab1KBS5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:57:09 -0400
MIME-Version: 1.0
In-Reply-To: <20111102170619.GJ31337@atomide.com>
References: <20111102170619.GJ31337@atomide.com>
Date: Wed, 2 Nov 2011 19:57:08 +0100
Message-ID: <CABoOg6wtN-t-DRKCWukauMQZ=FRDUcVRxVAVaaYco+sWAqT3Ug@mail.gmail.com>
Subject: Re: [PATCH] mmc: omap_hsmmc: Fix build for hsmmc
From: Thomas Weber <thomas.weber.linux@googlemail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
        Girish K S <girish.shivananjappa@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tony, hello
Chris,https://mail.google.com/mail/?shva=1#label/linux-omap/133653efb30ae047

isn't this already fixed?

http://marc.info/?l=linux-omap&m=131991921316862&w=2

[PATCH] omap_hsmmc: fix missing parenthesis in pr_info

Thomas

On Wed, Nov 2, 2011 at 6:06 PM, Tony Lindgren <tony@atomide.com> wrote:
> Commit a3c76eb9d4a1e68a69dd880cf0bcb8a52418b993 (mmc: replace
> printk with appropriate display macro) does not compile:
>
> drivers/mmc/host/omap_hsmmc.c: In function 'omap_hsmmc_protect_card':
> drivers/mmc/host/omap_hsmmc.c:1273: error: 'pr_info' undeclared (first use in this function)
> drivers/mmc/host/omap_hsmmc.c:1273: error: (Each undeclared identifier is reported only once
> drivers/mmc/host/omap_hsmmc.c:1273: error: for each function it appears in.)
> drivers/mmc/host/omap_hsmmc.c:1273: error: expected ';' before string constant
> drivers/mmc/host/omap_hsmmc.c:1275: error: expected statement before ')' token
> distcc[15197] ERROR: compile drivers/mmc/host/omap_hsmmc.c on localhost failed
>
> Cc: Girish K S <girish.shivananjappa@linaro.org>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: linux-mmc@vger.kernel.org
> Signed-off-by: Tony Lindgren <tony@atomide.com>
>
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -1270,7 +1270,7 @@ static void omap_hsmmc_protect_card(struct omap_hsmmc_host *host)
>                }
>        } else {
>                if (!host->protect_card) {
> -                       pr_info"%s: cover is open, "
> +                       pr_info("%s: cover is open, "
>                                         "card is now inaccessible\n",
>                                         mmc_hostname(host->mmc));
>                        host->protect_card = 1;
>
