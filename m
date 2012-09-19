Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab2ISUJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:09:57 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:52325 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2ISUJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:09:55 -0400
Date: Wed, 19 Sep 2012 23:09:53 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mfd: introduce retu-mfd driver
Message-ID: <20120919200953.GB2063@blackmetal.musicnaut.iki.fi>
References: <1346703805-31598-1-git-send-email-aaro.koskinen@iki.fi>
 <1346703805-31598-3-git-send-email-aaro.koskinen@iki.fi>
 <20120919160230.GK28670@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919160230.GK28670@sortiz-mobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 19, 2012 at 06:02:30PM +0200, Samuel Ortiz wrote:
> On Mon, Sep 03, 2012 at 11:23:23PM +0300, Aaro Koskinen wrote:
> > Retu is a multi-function device found on Nokia Internet Tablets
> > implementing at least watchdog, RTC, headset detection and power button
> > functionality.
> > 
> > This patch implements minimum functionality providing register access,
> > IRQ handling and power off functions.
> > 
> > Cc: sameo@linux.intel.com
> > Acked-by: Tony Lindgren <tony@atomide.com>
> > Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> > ---
> >  drivers/mfd/Kconfig      |    8 +
> >  drivers/mfd/Makefile     |    1 +
> >  drivers/mfd/retu-mfd.c   |  347 ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/retu.h |   22 +++
> >  4 files changed, 378 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/mfd/retu-mfd.c
> >  create mode 100644 include/linux/mfd/retu.h
> Now with the IRQ chip code, using the regmap APIs would be even more
> benefitial.

Thanks for feedback, I'll look into this.

A.
