Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1KGSCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:02:38 -0500
Received: from imr3.ericy.com ([198.24.6.13]:36344 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950Ab1KGSCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:02:37 -0500
Subject: Re: [PATCH] Drivers: hwmon: it87: Add support for ITE 8728
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: "Frank T. Lofaro Jr." <ftlofaro@yahoo.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1320381858.22997.YahooMailNeo@web161601.mail.bf1.yahoo.com>
References: <1320381858.22997.YahooMailNeo@web161601.mail.bf1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Mon, 7 Nov 2011 10:00:45 -0800
Message-ID: <1320688845.2309.122.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-04 at 00:44 -0400, Frank T. Lofaro Jr. wrote:
> This patch allows the ITE 8728 chip to be detected and used.
> The chip appears to be compatible with the 8721.
> 

Can anyone confirm that those chips are actually compatible ?

Thanks,
Guenter

Signed-off-by: Frank T. Lofaro Jr. <ftlofaro@yahoo.com>
> ---
>  drivers/hwmon/it87.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
> index d912649..0b21d18 100644
> --- a/drivers/hwmon/it87.c
> +++ b/drivers/hwmon/it87.c
> @@ -17,6 +17,7 @@
>   *            IT8720F  Super I/O chip w/LPC interface
>   *            IT8721F  Super I/O chip w/LPC interface
>   *            IT8726F  Super I/O chip w/LPC interface
> + *            IT8728F  Super I/O chip w/LPC interface
>   *            IT8758E  Super I/O chip w/LPC interface
>   *            Sis950   A clone of the IT8705F
>   *
> @@ -135,6 +136,7 @@ static inline void superio_exit(void)
>  #define IT8720F_DEVID 0x8720
>  #define IT8721F_DEVID 0x8721
>  #define IT8726F_DEVID 0x8726
> +#define IT8728F_DEVID 0x8728
>  #define IT87_ACT_REG  0x30
>  #define IT87_BASE_REG 0x60
>  
> @@ -1603,6 +1605,7 @@ static int __init it87_find(unsigned short
> *address,
>                 sio_data->type = it8720;
>                 break;
>         case IT8721F_DEVID:
> +       case IT8728F_DEVID:
>                 sio_data->type = it8721;
>                 break;
>         case 0xffff:    /* No device at all */
> -- 
> 1.7.7.2
> 
> 


