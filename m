Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab2A0LwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:52:10 -0500
Received: from ns1.ryston.cz ([31.30.2.11]:45094 "EHLO ns1.ryston.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab2A0LwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:52:08 -0500
X-Greylist: delayed 1993 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jan 2012 06:52:07 EST
From: "Karel Znamenacek" <karel@ryston.cz>
Organization: Ryston Electronics s.r.o.
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Date: Fri, 27 Jan 2012 12:17:36 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] ARM: at91: USB AT91 gadget registration for module
CC: karel@ryston.cz, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        stable <stable@vger.kernel.org>
Message-ID: <4F2287CF.5411.F0E5DC@karel.ryston.cz>
In-reply-to: <1327660087-20864-1-git-send-email-nicolas.ferre@atmel.com>
References: <1327660087-20864-1-git-send-email-nicolas.ferre@atmel.com>
X-mailer: Pegasus Mail for Windows (4.51)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK

Karel

On 27 Jan 2012 at 11:28, Nicolas Ferre wrote:

> Registration of at91_udc as a module will enable SoC
> related code.
> 
> Fix following an idea from Karel Znamenacek.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: stable <stable@vger.kernel.org>
> ---
> Karel,
> 
> Do you want to add your "Acked-by" line?
> 
>  arch/arm/mach-at91/at91rm9200_devices.c  |    2 +-
>  arch/arm/mach-at91/at91sam9260_devices.c |    2 +-
>  arch/arm/mach-at91/at91sam9261_devices.c |    2 +-
>  arch/arm/mach-at91/at91sam9263_devices.c |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
> index 18bacec..97676bd 100644
> --- a/arch/arm/mach-at91/at91rm9200_devices.c
> +++ b/arch/arm/mach-at91/at91rm9200_devices.c
> @@ -83,7 +83,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
>   *  USB Device (Gadget)
>   * -------------------------------------------------------------------- */
>  
> -#ifdef CONFIG_USB_AT91
> +#if defined(CONFIG_USB_AT91) || defined(CONFIG_USB_AT91_MODULE)
>  static struct at91_udc_data udc_data;
>  
>  static struct resource udc_resources[] = {
> diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
> index 642ccb6..f1a1bb45 100644
> --- a/arch/arm/mach-at91/at91sam9260_devices.c
> +++ b/arch/arm/mach-at91/at91sam9260_devices.c
> @@ -84,7 +84,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
>   *  USB Device (Gadget)
>   * -------------------------------------------------------------------- */
>  
> -#ifdef CONFIG_USB_AT91
> +#if defined(CONFIG_USB_AT91) || defined(CONFIG_USB_AT91_MODULE)
>  static struct at91_udc_data udc_data;
>  
>  static struct resource udc_resources[] = {
> diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
> index fc59cbd..1e28bed 100644
> --- a/arch/arm/mach-at91/at91sam9261_devices.c
> +++ b/arch/arm/mach-at91/at91sam9261_devices.c
> @@ -87,7 +87,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
>   *  USB Device (Gadget)
>   * -------------------------------------------------------------------- */
>  
> -#ifdef CONFIG_USB_AT91
> +#if defined(CONFIG_USB_AT91) || defined(CONFIG_USB_AT91_MODULE)
>  static struct at91_udc_data udc_data;
>  
>  static struct resource udc_resources[] = {
> diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
> index 7b46b27..618013d 100644
> --- a/arch/arm/mach-at91/at91sam9263_devices.c
> +++ b/arch/arm/mach-at91/at91sam9263_devices.c
> @@ -92,7 +92,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
>   *  USB Device (Gadget)
>   * -------------------------------------------------------------------- */
>  
> -#ifdef CONFIG_USB_AT91
> +#if defined(CONFIG_USB_AT91) || defined(CONFIG_USB_AT91_MODULE)
>  static struct at91_udc_data udc_data;
>  
>  static struct resource udc_resources[] = {
> -- 
> 1.7.5.4
> 


