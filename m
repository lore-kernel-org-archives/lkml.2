Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1GJKsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 06:48:14 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63788 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1GJKsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 06:48:12 -0400
MIME-Version: 1.0
In-Reply-To: <7e14caefe46d21a949efd9daeda3e43cb13eef45.1310289795.git.joe@perches.com>
References: <cover.1310289795.git.joe@perches.com> <7e14caefe46d21a949efd9daeda3e43cb13eef45.1310289795.git.joe@perches.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 10 Jul 2011 19:47:51 +0900
X-Google-Sender-Auth: I8fIJBBOShAAe7TUQdqqcyZtQ04
Message-ID: <CACxGe6vyFGD8SF4a8rsthnBGv10qOWy6pOtO_VnEw1huZkPhCg@mail.gmail.com>
Subject: Re: [PATCH 1/5] gpio-tps65910.c: Add missing breaks in switch/case
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel published a patch that fixed this issue which is already in mainline.

g.

On Sun, Jul 10, 2011 at 6:28 PM, Joe Perches <joe@perches.com> wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/gpio/gpio-tps65910.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpio/gpio-tps65910.c b/drivers/gpio/gpio-tps65910.c
> index 4171033..b9c1c29 100644
> --- a/drivers/gpio/gpio-tps65910.c
> +++ b/drivers/gpio/gpio-tps65910.c
> @@ -81,8 +81,10 @@ void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base)
>        switch(tps65910_chip_id(tps65910)) {
>        case TPS65910:
>                tps65910->gpio.ngpio    = 6;
> +               break;
>        case TPS65911:
>                tps65910->gpio.ngpio    = 9;
> +               break;
>        default:
>                return;
>        }
> --
> 1.7.6.131.g99019
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
