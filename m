Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab2G2UmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:42:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51310 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454Ab2G2UmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:42:20 -0400
Date: Sun, 29 Jul 2012 21:42:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 05/18] ASoC: Ux500: Enable ux500 MSP driver for Device
 Tree
Message-ID: <20120729204218.GI4384@opensource.wolfsonmicro.com>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
 <1343393162-11938-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343393162-11938-6-git-send-email-lee.jones@linaro.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 01:45:49PM +0100, Lee Jones wrote:

> +	if (of_get_property(np, "stericsson,use-pinctrl", NULL))
> +		msp->use_pinctrl = true;
> +	else
> +		msp->use_pinctrl = false;

I don't recall seeing any response to my query about this on the first
iteration.  Please don't just ignore review comments.
