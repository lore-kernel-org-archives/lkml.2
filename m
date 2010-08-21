Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab0HUKMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 06:12:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45848 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751731Ab0HUKMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 06:12:14 -0400
Date: Sat, 21 Aug 2010 11:12:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] MFD: Align AB8500 with the abx500.h interface
Message-ID: <20100821101213.GC5545@opensource.wolfsonmicro.com>
References: <1282382428-10389-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282382428-10389-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 11:20:28AM +0200, Linus Walleij wrote:
> From: Mattias Wallin <mattias.wallin@stericsson.com>
> 
> This patch consolidates the ab8500 mixed signal chip to expose the
> same interface for register access as the ab3100, ab3550 and ab5500
> chips. The ab8500_read() and ab8500_write() are removed and replaced
> with abx500_get_register_interruptible() and
> abx500_set_register_interruptible() respectively.
> 
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

>  static struct mfd_cell ab8500_devs[] = {
> +#ifdef CONFIG_DEBUG_FS
> +	{
> +		.name = "ab8500-debug",
> +	},
> +#endif

This one looks like it slipped in from a separate change, though?
