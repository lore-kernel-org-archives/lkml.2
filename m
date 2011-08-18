Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1HRKev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:34:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34056 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755198Ab1HRKeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:34:50 -0400
Subject: Re: [PATCH] Added #include of module.h to s3c_adc_battery.c
From: Ian <ian@opensource.wolfsonmicro.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <201108181321.11293.anarsoul@gmail.com>
References: <1313662449.18176.18.camel@Tapajos>
	 <201108181321.11293.anarsoul@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 11:34:48 +0100
Message-ID: <1313663688.18176.23.camel@Tapajos>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 13:21 +0300, Vasily Khoruzhick wrote:
> On Thursday 18 August 2011 13:14:09 Ian wrote:
> > s3c_adc_battery.c will not compile without moule.h as it contains the
> > definitions of: MODULE_AUTHOR, MODULE_DESCRIPTION & MODULE_LICENSE.
> 
> I've already sent pretty same patch a ~week ago, here it is:
> https://patchwork.kernel.org/patch/1061302/

Ah, apologies - please disregard this patch then.

Regards
Ian

> 
> Regards
> Vasily
> 
> > 
> > Signed-off-by: Ian Lartey <ian@opensource.wolfsonmicro.com>
> > ---
> >  drivers/power/s3c_adc_battery.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/power/s3c_adc_battery.c
> > b/drivers/power/s3c_adc_battery.c index a675e31..20770ba 100644
> > --- a/drivers/power/s3c_adc_battery.c
> > +++ b/drivers/power/s3c_adc_battery.c
> > @@ -9,6 +9,7 @@
> >   *
> >   */
> > 
> > +#include <linux/module.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/power_supply.h>


