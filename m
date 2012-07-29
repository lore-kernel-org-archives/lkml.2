Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2G2Uwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:52:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57506 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753555Ab2G2Uwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:52:30 -0400
Date: Sun, 29 Jul 2012 21:52:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 17/18] ARM: ux500: Add all encompassing Sound node to
 DB8500 Device Tree
Message-ID: <20120729205227.GL4384@opensource.wolfsonmicro.com>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
 <1343393162-11938-18-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343393162-11938-18-git-send-email-lee.jones@linaro.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 01:46:01PM +0100, Lee Jones wrote:

>  arch/arm/boot/dts/db8500.dtsi |    8 ++++++++

This is a generic DT include file but...

> +		sound {
> +			compatible = "stericsson,snd-soc-mop500";
> +
> +			stericsson,platform-pcm-dma = <&pcm>;
> +			stericsson,cpu-dai = <&msp1 &msp3>;
> +			stericsson,audio-codec = <&codec>;
> +		};

...this is clearly the board-specific setup for the system, showing how
the CPU and CODEC are hooked up.  This should therefore be in the DT for
whatever board this is you're working on.
