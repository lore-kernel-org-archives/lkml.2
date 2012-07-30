Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2G3Njd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:39:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35680 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab2G3Njc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:39:32 -0400
Date: Mon, 30 Jul 2012 14:39:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 05/18] ASoC: Ux500: Enable ux500 MSP driver for Device
 Tree
Message-ID: <20120730133930.GB4468@opensource.wolfsonmicro.com>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
 <1343393162-11938-6-git-send-email-lee.jones@linaro.org>
 <20120729204218.GI4384@opensource.wolfsonmicro.com>
 <50162F70.2050900@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50162F70.2050900@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 07:53:36AM +0100, Lee Jones wrote:
> On 29/07/12 21:42, Mark Brown wrote:

> >>+	if (of_get_property(np, "stericsson,use-pinctrl", NULL))

> >This doesn't seem particularly sane...  why is this conditional?

> It's conditional because only MSP1 and MSP3 have pinctrl support.

Why does the driver care - doesn't the pinctrl abstraction and/or
bindings handle this sensibly?
