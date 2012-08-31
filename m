Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab2HaJlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:41:13 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:49667 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780Ab2HaJlM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:41:12 -0400
MIME-Version: 1.0
In-Reply-To: <1346405848.5316.11.camel@coredoba.hi.pengutronix.de>
References: <1346405224-20399-1-git-send-email-p.zabel@pengutronix.de>
 <1346405224-20399-7-git-send-email-p.zabel@pengutronix.de> <1346405848.5316.11.camel@coredoba.hi.pengutronix.de>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Fri, 31 Aug 2012 02:40:50 -0700
Message-ID: <CAMQu2gxsdeX4z2Zrnb2NW7-gnh2Tyjcxkd2pOMOagkdkHGsgWQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] misc: Generic on-chip SRAM allocation driver
To: =?ISO-8859-1?Q?Jan_L=FCbbe?= <jlu@pengutronix.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 2:37 AM, Jan Lübbe <jlu@pengutronix.de> wrote:
>
> On Fri, 2012-08-31 at 11:27 +0200, Philipp Zabel wrote:
> > This driver requests and remaps a memory region as configured in the
> > device tree. It serves memory from this region via the genalloc API.
> >
> > Other drivers can retrieve the genalloc pool from a phandle pointing
> > to this drivers' device node in the device tree.
> >
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/misc/Kconfig  |    8 ++++
> >  drivers/misc/Makefile |    1 +
> >  drivers/misc/sram.c   |  105
> > +++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 114 insertions(+)
> >  create mode 100644 drivers/misc/sram.c
>
> We now have drivers/memory, which seems to be a good place for this.
>
drivers/memory is created for Memory controller device drivers. SRAM is
just pool of memory and should belong to some other place.

Regards
Santosh
