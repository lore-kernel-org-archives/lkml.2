Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab1ABP5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 10:57:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63241 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1ABP5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 10:57:42 -0500
Message-ID: <4D20A05F.1000802@mail.berlios.de>
Date: Sun, 02 Jan 2011 16:57:19 +0100
From: Stefan Weil <weil@mail.berlios.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: Ashish Gupta <asg@thelearninglabs.com>, Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Blackfin: Fix spelling in unused code (struct name)
References: <1289164493-9124-1-git-send-email-weil@mail.berlios.de>
In-Reply-To: <1289164493-9124-1-git-send-email-weil@mail.berlios.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:MEhZ6n6HtiLQkgehj9QphdYVyBqitASZ0T8SVmCaA2t
 gDMvo8Bq9gEn8fI3UuziI/ZBSlt28MqFt278VlZNnoDYP5yS7l
 fyo+sWALENsBMmok5s3hmmJkPFSgTqeOi59sJNyF3b+kFBb38i
 nwKRA7lSjCyWK2tizoSJ7T5/A6gPv0no8DQksxNXsKkHoaPKhS
 W8QppCjGKgWndKHQWs8HCAy/oushScmicurGl0yox6rTc1Xjip
 +cJNYsmHKfc6s
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.11.2010 22:14, schrieb Stefan Weil:
> platfrom -> platform
>
> This changes a struct name. The related code is conditionally
> compiled and won't work because the include file linux/gpio-decoder.h
> is missing, so removing this code would be an even better solution.
>
> If the missing include file is added, it must fix the spelling, too.
>
> Cc: Ashish Gupta <asg@thelearninglabs.com>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: uclinux-dist-devel@blackfin.uclinux.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
> arch/blackfin/mach-bf527/boards/tll6527m.c | 2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/blackfin/mach-bf527/boards/tll6527m.c 
> b/arch/blackfin/mach-bf527/boards/tll6527m.c
> index 9ec5757..89ae87b 100644
> --- a/arch/blackfin/mach-bf527/boards/tll6527m.c
> +++ b/arch/blackfin/mach-bf527/boards/tll6527m.c
> @@ -193,7 +193,7 @@ static unsigned gpio_addr_inputs[] = {
> GPIO_PG1, GPIO_PH9, GPIO_PH10
> };
>
> -static struct gpio_decoder_platfrom_data spi_decoded_cs = {
> +static struct gpio_decoder_platform_data spi_decoded_cs = {
> .base = EXP_GPIO_SPISEL_BASE,
> .input_addrs = gpio_addr_inputs,
> .nr_input_addrs = ARRAY_SIZE(gpio_addr_inputs),

I did not get any answers for this patch.

Will it be applied to linux git, or should I send a new patch
which removes the non-working conditional code?

Or will the maintainers fix the missing include file?

Kind regards,
Stefan Weil

