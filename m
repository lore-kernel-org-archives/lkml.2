Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab2GBO47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:56:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:39070 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab2GBO46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:56:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187529316"
Date: Mon, 2 Jul 2012 17:08:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Sundar Iyer <sundar.iyer@stericsson.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tc3589x: Guard PM methods with CONFIG_PM_SLEEP
Message-ID: <20120702150816.GN22065@sortiz-mobl>
References: <1341220792.10295.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341220792.10295.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Mon, Jul 02, 2012 at 05:19:52PM +0800, Axel Lin wrote:
> Guard PM methods with CONFIG_PM_SLEEP and get rid of some unneeded #ifdefs.
> This fixes below build warnings:
> 
>   CC      drivers/mfd/tc3589x.o
> drivers/mfd/tc3589x.c:361:12: warning: 'tc3589x_suspend' defined but not used [-Wunused-function]
> drivers/mfd/tc3589x.c:375:12: warning: 'tc3589x_resume' defined but not used [-Wunused-function]
> 
> SIMPLE_DEV_PM_OPS already defines constant dev_pm_ops, thus also fix
> 'duplicate const' sparse warning.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/tc3589x.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
