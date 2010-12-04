Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0LDPIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 10:08:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50023 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0LDPId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 10:08:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=UWzFo/0JGMmWe3ZjA41ALnsBtfUdPNFZapQZK3EcfPtcpfaLXVbv7ABmafVpSBB+uC
         XlGQq3WLgEP42OvKeXpScpzM7ntK6S/dszG7ff8/EVhAwSs2TFu92uTVNFopeKZLJlfk
         YK5a0g4tjN/ETCdLnKlJ0K2d/myg+KZZEjA+c=
From: Marek Vasut <marek.vasut@gmail.com>
To: Nicolas Kaiser <nikai@nikai.net>
Subject: Re: [PATCH] arm/income pxa270: enable backlight when pwm_bl is a module
Date: Sat, 4 Dec 2010 16:10:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: Pavel Revak <palo@bielyvlk.sk>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20101204152923.04244dfa@absol.kitzblitz>
In-Reply-To: <20101204152923.04244dfa@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012041610.17342.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 December 2010 15:29:23 Nicolas Kaiser wrote:
> Fixes a suspected typo in the config symbol.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
> I don't have the hardware to test, but this config symbol looks
> unusual enough to me that I'm suspecting it might be a typo.
> 
>  arch/arm/mach-pxa/colibri-pxa270-income.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/colibri-pxa270-income.c
> b/arch/arm/mach-pxa/colibri-pxa270-income.c index 37f0f3e..3aba0e1 100644
> --- a/arch/arm/mach-pxa/colibri-pxa270-income.c
> +++ b/arch/arm/mach-pxa/colibri-pxa270-income.c
> @@ -231,7 +231,7 @@ static inline void income_lcd_init(void) {}
>  /*************************************************************************
> ***** * Backlight
>  
> **************************************************************************
> ****/ -#if defined(CONFIG_BACKLIGHT_PWM) ||
> defined(CONFIG_BACKLIGHT_PWM__MODULE) +#if defined(CONFIG_BACKLIGHT_PWM)
> || defined(CONFIG_BACKLIGHT_PWM_MODULE) static struct
> platform_pwm_backlight_data income_backlight_data = { .pwm_id		= 0,
>  	.max_brightness	= 0x3ff,

Acked-by: Marek Vasut <marek.vasut@gmail.com>

Cheers
