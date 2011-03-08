Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab1CHWtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 17:49:15 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:63706 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab1CHWtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 17:49:14 -0500
Message-ID: <4D76B243.4010806@snapgear.com>
Date: Wed, 9 Mar 2011 08:48:35 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alexander Kurz <linux@kbdbabel.org>
CC: Greg Ungerer <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68knommu: fixing compiler warnings
References: <alpine.DEB.1.10.1103071110070.17775@vs81.sauer-cs.de>
In-Reply-To: <alpine.DEB.1.10.1103071110070.17775@vs81.sauer-cs.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On 07/03/11 18:11, Alexander Kurz wrote:
>> From 9e6846f985e84b0a915df50908f7f44d942ab891 Mon Sep 17 00:00:00 2001
> From: Alexander Kurz<linux@kbdbabel.org>
> Date: Sun, 20 Feb 2011 22:45:33 +0100
> Subject: [PATCH] m68knommu: fixing compiler warnings

Thanks. I'll apply to the m68knommu git tree (for inclusion in 2.6.39).

Looks like a few of the other ColdFire gpio support files need this too.
I'll fix those similar to this.

Regards
Greg



> Signed-off-by: Alexander Kurz<linux@kbdbabel.org>
> ---
>   arch/m68knommu/platform/528x/gpio.c |  210 +++++++++++++++++-----------------
>   1 files changed, 105 insertions(+), 105 deletions(-)
>
> diff --git a/arch/m68knommu/platform/528x/gpio.c b/arch/m68knommu/platform/528x/gpio.c
> index eedaf0a..526db66 100644
> --- a/arch/m68knommu/platform/528x/gpio.c
> +++ b/arch/m68knommu/platform/528x/gpio.c
> @@ -33,9 +33,9 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 1,
>   			.ngpio			= 7,
>   		},
> -		.pddr				= MCFEPORT_EPDDR,
> -		.podr				= MCFEPORT_EPDR,
> -		.ppdr				= MCFEPORT_EPPDR,
> +		.pddr				= (void __iomem *)MCFEPORT_EPDDR,
> +		.podr				= (void __iomem *)MCFEPORT_EPDR,
> +		.ppdr				= (void __iomem *)MCFEPORT_EPPDR,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -49,9 +49,9 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 8,
>   			.ngpio			= 4,
>   		},
> -		.pddr				= MCFGPTA_GPTDDR,
> -		.podr				= MCFGPTA_GPTPORT,
> -		.ppdr				= MCFGPTB_GPTPORT,
> +		.pddr				= (void __iomem *)MCFGPTA_GPTDDR,
> +		.podr				= (void __iomem *)MCFGPTA_GPTPORT,
> +		.ppdr				= (void __iomem *)MCFGPTB_GPTPORT,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -65,9 +65,9 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 16,
>   			.ngpio			= 4,
>   		},
> -		.pddr				= MCFGPTB_GPTDDR,
> -		.podr				= MCFGPTB_GPTPORT,
> -		.ppdr				= MCFGPTB_GPTPORT,
> +		.pddr				= (void __iomem *)MCFGPTB_GPTDDR,
> +		.podr				= (void __iomem *)MCFGPTB_GPTPORT,
> +		.ppdr				= (void __iomem *)MCFGPTB_GPTPORT,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -81,9 +81,9 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 24,
>   			.ngpio			= 4,
>   		},
> -		.pddr				= MCFQADC_DDRQA,
> -		.podr				= MCFQADC_PORTQA,
> -		.ppdr				= MCFQADC_PORTQA,
> +		.pddr				= (void __iomem *)MCFQADC_DDRQA,
> +		.podr				= (void __iomem *)MCFQADC_PORTQA,
> +		.ppdr				= (void __iomem *)MCFQADC_PORTQA,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -97,9 +97,9 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 32,
>   			.ngpio			= 4,
>   		},
> -		.pddr				= MCFQADC_DDRQB,
> -		.podr				= MCFQADC_PORTQB,
> -		.ppdr				= MCFQADC_PORTQB,
> +		.pddr				= (void __iomem *)MCFQADC_DDRQB,
> +		.podr				= (void __iomem *)MCFQADC_PORTQB,
> +		.ppdr				= (void __iomem *)MCFQADC_PORTQB,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -113,11 +113,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 40,
>   			.ngpio			= 8,
>   		},
> -		.pddr				= MCFGPIO_DDRA,
> -		.podr				= MCFGPIO_PORTA,
> -		.ppdr				= MCFGPIO_PORTAP,
> -		.setr				= MCFGPIO_SETA,
> -		.clrr				= MCFGPIO_CLRA,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRA,
> +		.podr				= (void __iomem *)MCFGPIO_PORTA,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTAP,
> +		.setr				= (void __iomem *)MCFGPIO_SETA,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRA,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -131,11 +131,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 48,
>   			.ngpio			= 8,
>   		},
> -		.pddr				= MCFGPIO_DDRB,
> -		.podr				= MCFGPIO_PORTB,
> -		.ppdr				= MCFGPIO_PORTBP,
> -		.setr				= MCFGPIO_SETB,
> -		.clrr				= MCFGPIO_CLRB,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRB,
> +		.podr				= (void __iomem *)MCFGPIO_PORTB,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTBP,
> +		.setr				= (void __iomem *)MCFGPIO_SETB,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRB,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -149,11 +149,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 56,
>   			.ngpio			= 8,
>   		},
> -		.pddr				= MCFGPIO_DDRC,
> -		.podr				= MCFGPIO_PORTC,
> -		.ppdr				= MCFGPIO_PORTCP,
> -		.setr				= MCFGPIO_SETC,
> -		.clrr				= MCFGPIO_CLRC,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRC,
> +		.podr				= (void __iomem *)MCFGPIO_PORTC,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTCP,
> +		.setr				= (void __iomem *)MCFGPIO_SETC,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRC,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -167,11 +167,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 64,
>   			.ngpio			= 8,
>   		},
> -		.pddr				= MCFGPIO_DDRD,
> -		.podr				= MCFGPIO_PORTD,
> -		.ppdr				= MCFGPIO_PORTDP,
> -		.setr				= MCFGPIO_SETD,
> -		.clrr				= MCFGPIO_CLRD,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRD,
> +		.podr				= (void __iomem *)MCFGPIO_PORTD,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTDP,
> +		.setr				= (void __iomem *)MCFGPIO_SETD,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRD,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -185,11 +185,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 72,
>   			.ngpio			= 8,
>   		},
> -		.pddr				= MCFGPIO_DDRE,
> -		.podr				= MCFGPIO_PORTE,
> -		.ppdr				= MCFGPIO_PORTEP,
> -		.setr				= MCFGPIO_SETE,
> -		.clrr				= MCFGPIO_CLRE,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRE,
> +		.podr				= (void __iomem *)MCFGPIO_PORTE,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTEP,
> +		.setr				= (void __iomem *)MCFGPIO_SETE,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRE,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -203,11 +203,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 80,
>   			.ngpio			= 8,
>   		},
> -		.pddr				= MCFGPIO_DDRF,
> -		.podr				= MCFGPIO_PORTF,
> -		.ppdr				= MCFGPIO_PORTFP,
> -		.setr				= MCFGPIO_SETF,
> -		.clrr				= MCFGPIO_CLRF,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRF,
> +		.podr				= (void __iomem *)MCFGPIO_PORTF,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTFP,
> +		.setr				= (void __iomem *)MCFGPIO_SETF,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRF,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -221,11 +221,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 88,
>   			.ngpio			= 8,
>   		},
> -		.pddr				= MCFGPIO_DDRG,
> -		.podr				= MCFGPIO_PORTG,
> -		.ppdr				= MCFGPIO_PORTGP,
> -		.setr				= MCFGPIO_SETG,
> -		.clrr				= MCFGPIO_CLRG,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRG,
> +		.podr				= (void __iomem *)MCFGPIO_PORTG,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTGP,
> +		.setr				= (void __iomem *)MCFGPIO_SETG,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRG,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -239,11 +239,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 96,
>   			.ngpio			= 8,
>   		},
> -		.pddr				= MCFGPIO_DDRH,
> -		.podr				= MCFGPIO_PORTH,
> -		.ppdr				= MCFGPIO_PORTHP,
> -		.setr				= MCFGPIO_SETH,
> -		.clrr				= MCFGPIO_CLRH,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRH,
> +		.podr				= (void __iomem *)MCFGPIO_PORTH,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTHP,
> +		.setr				= (void __iomem *)MCFGPIO_SETH,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRH,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -257,11 +257,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 104,
>   			.ngpio			= 8,
>   		},
> -		.pddr				= MCFGPIO_DDRJ,
> -		.podr				= MCFGPIO_PORTJ,
> -		.ppdr				= MCFGPIO_PORTJP,
> -		.setr				= MCFGPIO_SETJ,
> -		.clrr				= MCFGPIO_CLRJ,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRJ,
> +		.podr				= (void __iomem *)MCFGPIO_PORTJ,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTJP,
> +		.setr				= (void __iomem *)MCFGPIO_SETJ,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRJ,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -275,11 +275,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 112,
>   			.ngpio			= 8,
>   		},
> -		.pddr				= MCFGPIO_DDRDD,
> -		.podr				= MCFGPIO_PORTDD,
> -		.ppdr				= MCFGPIO_PORTDDP,
> -		.setr				= MCFGPIO_SETDD,
> -		.clrr				= MCFGPIO_CLRDD,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRDD,
> +		.podr				= (void __iomem *)MCFGPIO_PORTDD,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTDDP,
> +		.setr				= (void __iomem *)MCFGPIO_SETDD,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRDD,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -293,11 +293,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 120,
>   			.ngpio			= 8,
>   		},
> -		.pddr				= MCFGPIO_DDREH,
> -		.podr				= MCFGPIO_PORTEH,
> -		.ppdr				= MCFGPIO_PORTEHP,
> -		.setr				= MCFGPIO_SETEH,
> -		.clrr				= MCFGPIO_CLREH,
> +		.pddr				= (void __iomem *)MCFGPIO_DDREH,
> +		.podr				= (void __iomem *)MCFGPIO_PORTEH,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTEHP,
> +		.setr				= (void __iomem *)MCFGPIO_SETEH,
> +		.clrr				= (void __iomem *)MCFGPIO_CLREH,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -311,11 +311,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 128,
>   			.ngpio			= 8,
>   		},
> -		.pddr				= MCFGPIO_DDREL,
> -		.podr				= MCFGPIO_PORTEL,
> -		.ppdr				= MCFGPIO_PORTELP,
> -		.setr				= MCFGPIO_SETEL,
> -		.clrr				= MCFGPIO_CLREL,
> +		.pddr				= (void __iomem *)MCFGPIO_DDREL,
> +		.podr				= (void __iomem *)MCFGPIO_PORTEL,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTELP,
> +		.setr				= (void __iomem *)MCFGPIO_SETEL,
> +		.clrr				= (void __iomem *)MCFGPIO_CLREL,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -329,11 +329,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 136,
>   			.ngpio			= 6,
>   		},
> -		.pddr				= MCFGPIO_DDRAS,
> -		.podr				= MCFGPIO_PORTAS,
> -		.ppdr				= MCFGPIO_PORTASP,
> -		.setr				= MCFGPIO_SETAS,
> -		.clrr				= MCFGPIO_CLRAS,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRAS,
> +		.podr				= (void __iomem *)MCFGPIO_PORTAS,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTASP,
> +		.setr				= (void __iomem *)MCFGPIO_SETAS,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRAS,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -347,11 +347,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 144,
>   			.ngpio			= 7,
>   		},
> -		.pddr				= MCFGPIO_DDRQS,
> -		.podr				= MCFGPIO_PORTQS,
> -		.ppdr				= MCFGPIO_PORTQSP,
> -		.setr				= MCFGPIO_SETQS,
> -		.clrr				= MCFGPIO_CLRQS,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRQS,
> +		.podr				= (void __iomem *)MCFGPIO_PORTQS,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTQSP,
> +		.setr				= (void __iomem *)MCFGPIO_SETQS,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRQS,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -365,11 +365,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 152,
>   			.ngpio			= 6,
>   		},
> -		.pddr				= MCFGPIO_DDRSD,
> -		.podr				= MCFGPIO_PORTSD,
> -		.ppdr				= MCFGPIO_PORTSDP,
> -		.setr				= MCFGPIO_SETSD,
> -		.clrr				= MCFGPIO_CLRSD,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRSD,
> +		.podr				= (void __iomem *)MCFGPIO_PORTSD,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTSDP,
> +		.setr				= (void __iomem *)MCFGPIO_SETSD,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRSD,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -383,11 +383,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 160,
>   			.ngpio			= 4,
>   		},
> -		.pddr				= MCFGPIO_DDRTC,
> -		.podr				= MCFGPIO_PORTTC,
> -		.ppdr				= MCFGPIO_PORTTCP,
> -		.setr				= MCFGPIO_SETTC,
> -		.clrr				= MCFGPIO_CLRTC,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRTC,
> +		.podr				= (void __iomem *)MCFGPIO_PORTTC,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTTCP,
> +		.setr				= (void __iomem *)MCFGPIO_SETTC,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRTC,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -401,11 +401,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 168,
>   			.ngpio			= 4,
>   		},
> -		.pddr				= MCFGPIO_DDRTD,
> -		.podr				= MCFGPIO_PORTTD,
> -		.ppdr				= MCFGPIO_PORTTDP,
> -		.setr				= MCFGPIO_SETTD,
> -		.clrr				= MCFGPIO_CLRTD,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRTD,
> +		.podr				= (void __iomem *)MCFGPIO_PORTTD,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTTDP,
> +		.setr				= (void __iomem *)MCFGPIO_SETTD,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRTD,
>   	},
>   	{
>   		.gpio_chip			= {
> @@ -419,11 +419,11 @@ static struct mcf_gpio_chip mcf_gpio_chips[] = {
>   			.base			= 176,
>   			.ngpio			= 4,
>   		},
> -		.pddr				= MCFGPIO_DDRUA,
> -		.podr				= MCFGPIO_PORTUA,
> -		.ppdr				= MCFGPIO_PORTUAP,
> -		.setr				= MCFGPIO_SETUA,
> -		.clrr				= MCFGPIO_CLRUA,
> +		.pddr				= (void __iomem *)MCFGPIO_DDRUA,
> +		.podr				= (void __iomem *)MCFGPIO_PORTUA,
> +		.ppdr				= (void __iomem *)MCFGPIO_PORTUAP,
> +		.setr				= (void __iomem *)MCFGPIO_SETUA,
> +		.clrr				= (void __iomem *)MCFGPIO_CLRUA,
>   	},
>   };
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
