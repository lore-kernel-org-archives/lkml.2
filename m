Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0LAHml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:42:41 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45664 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab0LAHmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:42:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=SO3jkE2UJA04NNN8qaBHToTHfbk8Zf31ab3NOaXnavY624FCGKVHMf2ODesYHI0NlQ
         EXimGImYZtRK5P9/FXykTkAQ5A1kAyNaQ7OKbm2zV7ntBoMeZtBeyEe+O3UH9bYL0n7/
         Kq2Xd+wbmOHasuaC/g2xKHC4PHuFF+LjuNxJ8=
Date: Wed, 1 Dec 2010 09:43:16 +0200
From: Jarkko Nikula <jhnikula@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Vladimir Barinov <vbarinov@embeddedalley.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Remove unused aic3x_i2c_init and aic3x_i2c_exit
 functions
Message-Id: <20101201094316.6751d3a1.jhnikula@gmail.com>
In-Reply-To: <1291185504.5563.1.camel@mola>
References: <1291185504.5563.1.camel@mola>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Dec 2010 14:38:24 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/tlv320aic3x.c |   15 ---------------
>  1 files changed, 0 insertions(+), 15 deletions(-)
> 
> diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
> index fc5abdf..8cd4cf5 100644
> --- a/sound/soc/codecs/tlv320aic3x.c
> +++ b/sound/soc/codecs/tlv320aic3x.c
> @@ -1545,21 +1545,6 @@ static struct i2c_driver aic3x_i2c_driver = {
>  	.remove = aic3x_i2c_remove,
>  	.id_table = aic3x_i2c_id,
>  };
> -
> -static inline void aic3x_i2c_init(void)
> -{
> -	int ret;
> -
> -	ret = i2c_add_driver(&aic3x_i2c_driver);
> -	if (ret)
> -		printk(KERN_ERR "%s: error regsitering i2c driver, %d\n",
> -		       __func__, ret);
> -}
> -
> -static inline void aic3x_i2c_exit(void)
> -{
> -	i2c_del_driver(&aic3x_i2c_driver);
> -}
>  #endif
>  
True, these are unused nowadays.

Acked-by: Jarkko Nikula <jhnikula@gmail.com>
