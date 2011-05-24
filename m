Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab1EXTTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:19:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50238 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab1EXTTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:19:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cj0QPd0OJTOVGwHbliwGnR81JqZgTbhaYLnWiSVV+i9AuzkMNv8oTI/RMEcmFpg8/v
         1UrHmT9dwPjvdVFXIXTf+LP2ePldKPQdFfpyadqeSr1jMr33zrir5bR5w2NV/K+A5YBe
         XKZL3cCEtyTi4aCqpLGALDBwbDMWybrAsOI1w=
Date: Tue, 24 May 2011 23:19:38 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: Fix annotation for
 s3c_adc_battery_probe()
Message-ID: <20110524191938.GB17373@oksana.dev.rtsoft.ru>
References: <1306233962-7283-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <201105241436.01179.anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201105241436.01179.anarsoul@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 02:36:00PM +0300, Vasily Khoruzhick wrote:
> On Tuesday 24 May 2011 13:46:02 Mark Brown wrote:
> > A probe() function is used at device init time rather than system init
> > time.
> > 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Acked-by: Vasily Khoruzhick <anarsoul@gmail.com>

Applied, thank you!

> > ---
> >  drivers/power/s3c_adc_battery.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/power/s3c_adc_battery.c
> > b/drivers/power/s3c_adc_battery.c index d36c289..a675e31 100644
> > --- a/drivers/power/s3c_adc_battery.c
> > +++ b/drivers/power/s3c_adc_battery.c
> > @@ -266,7 +266,7 @@ static irqreturn_t s3c_adc_bat_charged(int irq, void
> > *dev_id) return IRQ_HANDLED;
> >  }
> > 
> > -static int __init s3c_adc_bat_probe(struct platform_device *pdev)
> > +static int __devinit s3c_adc_bat_probe(struct platform_device *pdev)
> >  {
> >  	struct s3c_adc_client	*client;
> >  	struct s3c_adc_bat_pdata *pdata = pdev->dev.platform_data;

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
