Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab2EXJSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:18:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35231 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab2EXJSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:18:33 -0400
MIME-Version: 1.0
In-Reply-To: <1337152826-9850-6-git-send-email-sonic.zhang@analog.com>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
	<1337152826-9850-6-git-send-email-sonic.zhang@analog.com>
Date: Thu, 24 May 2012 17:18:32 +0800
Message-ID: <CAJxxZ0Pd=weSuVR7DUB3NDxTkwMhX=sg7zEeTBgRcNUt4f8gMg@mail.gmail.com>
Subject: Re: [PATCH 6/8] i2c:i2c-bfin-twi: include twi head file
From: Sonic Zhang <sonic.adi@gmail.com>
To: sonic.zhang@analog.com
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, Bob Liu <lliubbo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PING

On Wed, May 16, 2012 at 3:20 PM,  <sonic.zhang@analog.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> TWI bit mask macros are moved to twi head file.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bob Liu <lliubbo@gmail.com>
> ---
>  drivers/i2c/busses/i2c-bfin-twi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
> index 594bbb1..d7e8fba 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -25,6 +25,7 @@
>  #include <asm/blackfin.h>
>  #include <asm/portmux.h>
>  #include <asm/irq.h>
> +#include <asm/bfin_twi.h>
>
>  /* SMBus mode*/
>  #define TWI_I2C_MODE_STANDARD          1
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
