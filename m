Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab2J3EWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 00:22:21 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:14813
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116Ab2J3EWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 00:22:20 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI936eI1432I4015Izz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537hbe9i1155h)
Subject: Re: [PATCH] hwmon: da9055: Fix chan_mux[DA9055_ADC_ADCIN3] setting
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Axel Lin <axel.lin@ingics.com>, Jean Delvare <khali@linux-fr.org>,
        David Dajun Chen <dchen@diasemi.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20121030005246.GB19374@roeck-us.net>
References: <1351499678.14725.3.camel@phoenix>
	 <20121030005246.GB19374@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Oct 2012 09:51:40 +0530
Message-ID: <1351570900.19193.3.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 17:52 -0700, Guenter Roeck wrote:
> On Mon, Oct 29, 2012 at 04:34:38PM +0800, Axel Lin wrote:
> > Set chan_mux[DA9055_ADC_ADCIN3] = DA9055_ADC_MUX_ADCIN3.
> > 
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> > ---
> > Hi,
> >   This looks like a typo, but I don't have a hardware to test it.
> > Axel
> >  drivers/hwmon/da9055-hwmon.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/hwmon/da9055-hwmon.c b/drivers/hwmon/da9055-hwmon.c
> > index 0b41f2c..3a3377c 100644
> > --- a/drivers/hwmon/da9055-hwmon.c
> > +++ b/drivers/hwmon/da9055-hwmon.c
> > @@ -54,7 +54,7 @@ static const u8 chan_mux[DA9055_ADC_TJUNC + 1] = {
> >  	[DA9055_ADC_VSYS]	= DA9055_ADC_MUX_VSYS,
> >  	[DA9055_ADC_ADCIN1]	= DA9055_ADC_MUX_ADCIN1,
> >  	[DA9055_ADC_ADCIN2]	= DA9055_ADC_MUX_ADCIN2,
> > -	[DA9055_ADC_ADCIN3]	= DA9055_ADC_MUX_ADCIN1,
> > +	[DA9055_ADC_ADCIN3]	= DA9055_ADC_MUX_ADCIN3,
> >  	[DA9055_ADC_TJUNC]	= DA9055_ADC_MUX_T_SENSE,
> >  };
> 
> Very much loks like a typo.
> 
> David, Ashish, any comments ? I would like to get your Ack before applying it.
> 
> Thanks,
> Guenter
> 
Yes, its typo so you can apply the patch.


