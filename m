Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2G3NsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 09:48:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60212 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216Ab2G3NsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 09:48:07 -0400
Date: Mon, 30 Jul 2012 14:48:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 01/18] Documentation: Describe the ux500 realated audio
 related DT nodes
Message-ID: <20120730134804.GE4468@opensource.wolfsonmicro.com>
References: <1343393162-11938-1-git-send-email-lee.jones@linaro.org>
 <1343393162-11938-2-git-send-email-lee.jones@linaro.org>
 <20120729203106.GD4384@opensource.wolfsonmicro.com>
 <50163A09.8060203@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50163A09.8060203@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 08:38:49AM +0100, Lee Jones wrote:
> On 29/07/12 21:31, Mark Brown wrote:
> >On Fri, Jul 27, 2012 at 01:45:45PM +0100, Lee Jones wrote:

> >>+   - Machine Driver : "stericsson,snd-soc-mop500"
> >>+   - CPU-side DAI   : "stericsson,ux500-msp-i2s"
> >>+   - DMA (platform) : "stericsson,ux500-pcm"
> >>+   - Audio CODEC    : "stericsson,ab8500-codec"

> >What is this a binding document for?  It looks like the binding for a
> >machine driver...

> No, it's a binding document for all of the ux500 driver and CODEC
> blocks. Do you really want me to split it all up? I think the only
> component which could be sanely split-out is the ab8500-codec, which
> could (should?) live in [1].

Yes, of course!  Each device will have a separate binding with different
requirements.

> These properties are relevant for some, but not all of the
> components above, hence why the are listed at 'optional properties'.

Which is part of the problem here, it makes it much harder to tell what
you need to do for the individual devices.
