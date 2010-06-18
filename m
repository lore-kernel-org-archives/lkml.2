Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914Ab0FRLA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 07:00:27 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48706 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524Ab0FRLA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 07:00:26 -0400
Message-ID: <4C1B518F.4090307@ru.mvista.com>
Date: Fri, 18 Jun 2010 14:59:27 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
       avictor.za@gmail.com, haavard.skinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: some Atmel drivers change maintainer
References: <1276694487-20065-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1276694487-20065-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Nicolas Ferre wrote:

> I take over the maintenance of SPI, USART, Ethernet and USB gadget drivers.
> Those drivers are found in Atmel microcontrollers, both AT32/AVR32 and
> AT91/ARM.

> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> ---
>  MAINTAINERS |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6d119c9..5f71809 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1148,7 +1148,7 @@ F:	drivers/mmc/host/atmel-mci.c
[...]
>  ATMEL USBA UDC DRIVER
> -M:	Haavard Skinnemoen <hskinnemoen@atmel.com>
> -L:	kernel@avr32linux.org
> +M:	Nicolas Ferre <nicolas.ferre@atmel.com>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)

    Not linux-usb@vger.kernel.org?

WBR, Sergei

