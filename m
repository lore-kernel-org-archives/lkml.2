Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab2G2UbK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:31:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40103 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363Ab2G2UbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:31:09 -0400
Date: Sun, 29 Jul 2012 21:31:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 01/18] Documentation: Describe the ux500 realated audio
 related DT nodes
Message-ID: <20120729203106.GD4384@opensource.wolfsonmicro.com>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
 <1343393162-11938-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343393162-11938-2-git-send-email-lee.jones@linaro.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 01:45:45PM +0100, Lee Jones wrote:

> +++ b/Documentation/devicetree/bindings/sound/ux500.txt
> @@ -0,0 +1,62 @@
> +* ux500 Audio Driver and ab8500 Audio CODEC
> +
> +Required properties:
> + - compatible:
> +   - Machine Driver : "stericsson,snd-soc-mop500"
> +   - CPU-side DAI   : "stericsson,ux500-msp-i2s"
> +   - DMA (platform) : "stericsson,ux500-pcm"
> +   - Audio CODEC    : "stericsson,ab8500-codec"

What is this a binding document for?  It looks like the binding for a
machine driver...

> +Optional properties:
> + - reg              : Physical base address and length of the device's registers.
> + - interrupts       : The interrupt outputs from the device.
> + - interrupt-parent : The parent interrupt controller.
> + - <name>-supply    : Phandle to the regulator <name> supply

...but these don't look anything like machine driver properties.
