Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0KVKHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:07:12 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:64910 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab0KVKHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:07:11 -0500
Subject: Re: [PATCH] backlight: make 1-bit signed filed unsigned in
 l4f00242t03.c
From: Richard Purdie <rpurdie@linux.intel.com>
To: Mariusz Kozlowski <mk@lab.zgora.pl>, akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1290254484-12141-1-git-send-email-mk@lab.zgora.pl>
References: <1290254484-12141-1-git-send-email-mk@lab.zgora.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 10:06:50 +0000
Message-ID: <1290420410.1272.16689.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-20 at 13:01 +0100, Mariusz Kozlowski wrote:
> Fixes sparse warning:
> drivers/video/backlight/l4f00242t03.c:28:21: error: dubious one-bit
> signed bitfield
> 
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
> ---
>  drivers/video/backlight/l4f00242t03.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
> index c67801e..6d9ba0e 100644
> --- a/drivers/video/backlight/l4f00242t03.c
> +++ b/drivers/video/backlight/l4f00242t03.c
> @@ -25,7 +25,7 @@
>  struct l4f00242t03_priv {
>  	struct spi_device	*spi;
>  	struct lcd_device	*ld;
> -	int lcd_on:1;
> +	unsigned int lcd_on:1;
>  	struct regulator *io_reg;
>  	struct regulator *core_reg;
>  };


