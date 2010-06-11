Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab0FKHXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 03:23:31 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:26405 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab0FKHX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 03:23:29 -0400
Message-ID: <4C11E460.4010101@atmel.com>
Date: Fri, 11 Jun 2010 09:23:12 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, haavard.skinnemoen@atmel.com,
       avictor.za@gmail.com
Subject: Re: [PATCH] MAINTAINERS: some Atmel drivers change maintainer
References: <20100528114245.3d030692@hskinnemoen-d830> <1275054888-13828-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1275054888-13828-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 28/05/2010 15:54, Nicolas Ferre :
> I take over the maintenance of SPI, USART, Ethernet and USB gadget drivers.
> Those drivers are found in Atmel microcontrollers, both AT32/AVR32 and
> AT91/ARM.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Ping,

With added acked-by:
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

> ---
> Haavard,
> I finally change the MAINTAINERS entries for all drivers that you were
> taking care of. I must admit that I was a bit frighten at the first place but
> anyway, since one year, I am getting used to it ;-)
> 
> 
>  MAINTAINERS |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 33047a6..d9ce9c6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1148,7 +1148,7 @@ F:	drivers/mmc/host/atmel-mci.c
>  F:	drivers/mmc/host/atmel-mci-regs.h
>  
>  ATMEL AT91 / AT32 SERIAL DRIVER
> -M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
> +M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>  S:	Supported
>  F:	drivers/serial/atmel_serial.c
>  
> @@ -1160,18 +1160,18 @@ F:	drivers/video/atmel_lcdfb.c
>  F:	include/video/atmel_lcdc.h
>  
>  ATMEL MACB ETHERNET DRIVER
> -M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
> +M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>  S:	Supported
>  F:	drivers/net/macb.*
>  
>  ATMEL SPI DRIVER
> -M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
> +M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>  S:	Supported
>  F:	drivers/spi/atmel_spi.*
>  
>  ATMEL USBA UDC DRIVER
> -M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
> -L:	kernel@avr32linux.org
> +M:	Nicolas Ferre <nicolas.ferre@atmel.com>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  W:	http://avr32linux.org/twiki/bin/view/Main/AtmelUsbDeviceDriver
>  S:	Supported
>  F:	drivers/usb/gadget/atmel_usba_udc.*


-- 
Nicolas Ferre

