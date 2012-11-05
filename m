Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab2KEQdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:33:21 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34443 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab2KEQdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:33:20 -0500
Date: Mon, 5 Nov 2012 17:33:15 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/8] mfd: ab8500-core: Remove unused ab8500-gpio IRQ
 ranges
Message-ID: <20121105163315.GE5220@gmail.com>
References: <1352128236-11554-1-git-send-email-lee.jones@linaro.org>
 <1352128236-11554-2-git-send-email-lee.jones@linaro.org>
 <201211051616.24257.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201211051616.24257.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2012, Arnd Bergmann wrote:

> On Monday 05 November 2012, Lee Jones wrote:
> > The IRQ ranges provided in ab8500-core to be passed on to the
> > ab8500-gpio driver are not only redundant, but they are also
> > causing a warning in the boot log. These IRQ ranges, like any
> > other MFD related IRQ resource are passed though MFD core for
> > automatic conversion to virtual IRQs; however, MFD core does
> > not support IRQ mapping of IRQ ranges. Let's just remove them.
> > 
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Whoops, I missed Linus' Tested-by on this patch too, so:

Tested-by: Linus Walleij <linus.walleij@linaro.org>

I also forgot to to mention that this should really be going
for the -rcs rather than -next.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
