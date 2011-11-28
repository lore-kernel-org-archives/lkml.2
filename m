Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1K1I1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 03:27:36 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:7297 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1K1I1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 03:27:34 -0500
Date: Mon, 28 Nov 2011 09:27:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Jochen Friedrich <jochen@scram.de>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Barry Song <21cnbao@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2] i2c: convert drivers/i2c/* to use 
 module_platform_driver()
Message-ID: <20111128092721.15ac7b7d@endymion.delvare>
In-Reply-To: <1322439206.2709.2.camel@phoenix>
References: <1322439206.2709.2.camel@phoenix>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Nov 2011 08:13:26 +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/i2c/* to use the

Now drivers/i2c/busses/* even.

> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Jochen Friedrich <jochen@scram.de>
> Cc: Peter Korsgaard <jacmet@sunsite.dk>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> Cc: Manuel Lauss <manuel.lauss@googlemail.com>
> Cc: Barry Song <21cnbao@gmail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
> Acked-by: Wolfram Sang <w.sang@pengutronix.de>
> Acked-by: Jochen Friedrich<jochen@scram.de>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/i2c/busses/i2c-at91.c         |   17 ++---------------
>  drivers/i2c/busses/i2c-au1550.c       |   13 +------------
>  drivers/i2c/busses/i2c-cpm.c          |   13 +------------
>  drivers/i2c/busses/i2c-highlander.c   |   13 +------------
>  drivers/i2c/busses/i2c-ibm_iic.c      |   13 +------------
>  drivers/i2c/busses/i2c-iop3xx.c       |   16 +---------------
>  drivers/i2c/busses/i2c-isch.c         |   13 +------------
>  drivers/i2c/busses/i2c-ixp2000.c      |   13 +------------
>  drivers/i2c/busses/i2c-mpc.c          |   13 +------------
>  drivers/i2c/busses/i2c-mv64xxx.c      |   15 +--------------
>  drivers/i2c/busses/i2c-ocores.c       |   17 ++---------------
>  drivers/i2c/busses/i2c-octeon.c       |   16 +---------------
>  drivers/i2c/busses/i2c-pca-platform.c |   14 +-------------
>  drivers/i2c/busses/i2c-pmcmsp.c       |   17 ++---------------
>  drivers/i2c/busses/i2c-powermac.c     |   19 ++-----------------
>  drivers/i2c/busses/i2c-puv3.c         |   16 ++--------------
>  drivers/i2c/busses/i2c-sh7760.c       |   13 +------------
>  drivers/i2c/busses/i2c-simtec.c       |   18 ++----------------
>  drivers/i2c/busses/i2c-xiic.c         |   18 ++----------------
>  19 files changed, 26 insertions(+), 261 deletions(-)
> (...)

Reviewed-by: Jean Delvare <khali@linux-fr.org>

As said before, I'll let Ben pick the patch in his tree to minimize the
risks of merge conflicts.

-- 
Jean Delvare
