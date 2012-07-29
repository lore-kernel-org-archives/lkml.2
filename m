Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2G2UuG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:50:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51182 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485Ab2G2UuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:50:04 -0400
Date: Sun, 29 Jul 2012 21:50:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 13/18] ARM: ux500: Add ux500 PCM to DB8500 Device Tree
Message-ID: <20120729205001.GK4384@opensource.wolfsonmicro.com>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
 <1343393162-11938-14-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343393162-11938-14-git-send-email-lee.jones@linaro.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 01:45:57PM +0100, Lee Jones wrote:
> Nothing special here. We're only providing a compatible string
> to ensure the driver is probed using a Device Tree boot.

> +		pcm: ux500-pcm {
> +			compatible = "stericsson,ux500-pcm";
> +		};
> +

One of two things is wrong here.  Either you've not provided any
information about the hardware so the driver won't be able to work out
what to talk to or you've not provided any data so you're registering a
purely virtual Linux-internal device via the device tree.

Once more, the idea here is to describe the hardware not to dump Linux's
internal data structures into the device tree.
