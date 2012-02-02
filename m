Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab2BBNin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:38:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37873 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032Ab2BBNim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:38:42 -0500
Date: Thu, 2 Feb 2012 13:38:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Coquelin <maxime.coquelin@stericsson.com>,
        Alex Macro <alex.macro@stericsson.com>,
        Michel Jaouen <michel.jaouen@stericsson.com>
Subject: Re: [PATCH 2/4] mfd/ab8500: add version detection and enforcing
Message-ID: <20120202133838.GO7428@opensource.wolfsonmicro.com>
References: <1328112561-32494-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328112561-32494-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 05:09:21PM +0100, Linus Walleij wrote:

> --- a/arch/arm/mach-ux500/board-mop500.c
> +++ b/arch/arm/mach-ux500/board-mop500.c
> @@ -512,7 +512,6 @@ static struct stedma40_chan_cfg uart2_dma_cfg_tx = {
>  };
>  #endif
>  
> -
>  static pin_cfg_t mop500_pins_uart0[] = {
>  	GPIO0_U0_CTSn   | PIN_INPUT_PULLUP,
>  	GPIO1_U0_RTSn   | PIN_OUTPUT_HIGH,

This probably should be dropped, it's not like there's even any other
arch/arm updates here.

Otherwise looks good

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
