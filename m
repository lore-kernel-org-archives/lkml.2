Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1EQNkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:40:17 -0400
Received: from imr3.ericy.com ([198.24.6.13]:36459 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab1EQNkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:40:15 -0400
Date: Tue, 17 May 2011 06:38:05 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: "fabien.marteau@armadeus.com" <fabien.marteau@armadeus.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: Driver for as1531, Austria-Microsystem Analog
 to Digital Converter.
Message-ID: <20110517133805.GA4006@ericsson.com>
References: <fabien.marteau@armadeus.com>
 <1305553154-18195-2-git-send-email-fabien.marteau@armadeus.com>
 <20110516153900.GA31255@ericsson.com>
 <4DD21E5E.9000605@armadeus.com>
 <4DD23EED.4010201@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4DD23EED.4010201@cam.ac.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 05:25:01AM -0400, Jonathan Cameron wrote:
> On 05/17/11 08:06, Fabien Marteau wrote:
> > Hi Guenter,
> > 
> > Thanks for the review.
> > 
> > On 16/05/2011 17:39, Guenter Roeck wrote:
> >> On Mon, May 16, 2011 at 09:39:14AM -0400, fabien.marteau@armadeus.com wrote:
> >>> From: Fabien Marteau <fabien.marteau@armadeus.com>
> >>>
> >>>
> >> Some description, such as "Dhis driver adds support for xxx" would be nice.
> >>
> >> Also, I wonder if this driver belongs into hwmon in the first place. It is
> >> a generic ADC chip with high conversion rate. iio would probably be more
> >> appropriate and also much better in supporting high speed readings.
> > I provided this driver "as is" because it's a driver that work well on
> > our platform. I thought that iio was not stable enough driver framework
> > to be used.
> > I can rewrite it under iio framework but I have no time for this moment
> > to do that. You think it's better to wait for an iio driver or to
> > continue commiting this ?
> I'd say that if you primary use is hwmon, put it there for now and we can think
> about moving it at a later date depending on how people are actually using it.
> Guenter, would that be ok for you?

Yes, that would be ok.

Thanks,
Guenter
