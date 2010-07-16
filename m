Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0GPFJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 01:09:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44215 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab0GPFJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 01:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=dEDm9omZ4oXabyThofaft59UnZdm68ijQTTN1qoGshE6rJN553JTOHVamkeuVRqLnm
         DmAfGtksxNtYyHYta47cp09tiBuM2/Kgh+EK/8ioi2R8mokImPoCa6AcW9+laFb3Re7s
         HfchmYhXTi6VxbVOi7uwciS+ZXqB0umST/5T4=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM/nuc900: fix nuc900 touchscreen clk definition bug
Date: Fri, 16 Jul 2010 07:09:14 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: Wan ZongShun <mcuos.com@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
References: <4C3FCBFF.50506@gmail.com>
In-Reply-To: <4C3FCBFF.50506@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007160709.15385.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Pá 16. července 2010 05:03:27 Wan ZongShun napsal(a):
> This patch is to fix nuc900 touchscreen clk definition bug,the .dev_id's
> name should be 'nuc900-ts', it should be the same to pdev.name. or else,
> the touchscreen driver will be not working well due to clock engine
> disabled.
> 
> Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
> ---
>  arch/arm/mach-w90x900/cpu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
> index 642207e..83c5632 100644
> --- a/arch/arm/mach-w90x900/cpu.c
> +++ b/arch/arm/mach-w90x900/cpu.c
> @@ -93,7 +93,7 @@ static struct clk_lookup nuc900_clkregs[] = {
>  	DEF_CLKLOOK(&clk_kpi, "nuc900-kpi", NULL),
>  	DEF_CLKLOOK(&clk_wdt, "nuc900-wdt", NULL),
>  	DEF_CLKLOOK(&clk_gdma, "nuc900-gdma", NULL),
> -	DEF_CLKLOOK(&clk_adc, "nuc900-adc", NULL),
> +	DEF_CLKLOOK(&clk_adc, "nuc900-ts", NULL),
>  	DEF_CLKLOOK(&clk_usi, "nuc900-spi", NULL),
>  	DEF_CLKLOOK(&clk_ext, NULL, "ext"),
>  	DEF_CLKLOOK(&clk_timer0, NULL, "timer0"),

Hey,

Is that thing really touchscreen or general-purpose analog/digital converter ?

Cheers
