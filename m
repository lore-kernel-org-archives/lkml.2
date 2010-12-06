Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab0LFHxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 02:53:43 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:34895 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0LFHxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 02:53:41 -0500
Date: Mon, 6 Dec 2010 08:53:04 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ben Dooks <ben-i2c@fluff.org>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, andrew.chih.howe.khor@intel.com,
        yong.y.wang@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH] EG20T: Update PCH_I2C driver to 2.6.36
Message-ID: <20101206085304.094d1078@endymion.delvare>
In-Reply-To: <4CFC6622.1050006@fluff.org>
References: <4CD8CD32.5000909@dsn.okisemi.com>
	<4CFC6622.1050006@fluff.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Dec 2010 04:27:14 +0000, Ben Dooks wrote:
> On 09/11/10 04:25, Tomoya MORINAGA wrote:
> > diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> > index c3ef492..e55e051 100644
> > --- a/drivers/i2c/busses/Makefile
> > +++ b/drivers/i2c/busses/Makefile
> > @@ -60,6 +60,7 @@ obj-$(CONFIG_I2C_STU300)	+= i2c-stu300.o
> >  obj-$(CONFIG_I2C_VERSATILE)	+= i2c-versatile.o
> >  obj-$(CONFIG_I2C_OCTEON)	+= i2c-octeon.o
> >  obj-$(CONFIG_I2C_XILINX)	+= i2c-xiic.o
> > +obj-$(CONFIG_I2C_EG20T)         += i2c-eg20t.o
> 
> Jean, do you want these alphabetically sorted?

I prefer them sorted alphabetically, yes. For several reasons:
* Makes it easier to find out a specific entry.
* Makes it easier to spot duplicate drivers or drivers for very similar
  devices which could be merged.
* Limits the risks of reject when two new drivers are added in parallel.

Thanks,
-- 
Jean Delvare
