Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab1FXNuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:50:24 -0400
Received: from imr4.ericy.com ([198.24.6.8]:51860 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758482Ab1FXNuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:50:09 -0400
Date: Fri, 24 Jun 2011 06:49:14 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "Stijn Devriendt (sdevrien)" <sdevrien@cisco.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] Add support for the Philips SA56004 temperature
 sensor.
Message-ID: <20110624134914.GA1177@ericsson.com>
References: <1307356845-10095-1-git-send-email-sdevrien@cisco.com>
 <20110606124047.GA26180@ericsson.com>
 <6E4D2678AC543844917CA081C9D6B33F04C74F28@XMB-AMS-103.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6E4D2678AC543844917CA081C9D6B33F04C74F28@XMB-AMS-103.cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 06:40:57AM -0400, Stijn Devriendt (sdevrien) wrote:
> Hi Guenter,
> 
> Is anything being done with this patch, yet?
> I haven't heard anything from Jean so far.
> 
Hi Stijn,

please don't top-post.

I don't recall a comment from Jean either.

Jean, any comments ? It is your driver, so I thought it would make sense
if you had a look.

Thanks,
Guenter

> Thanks,
> Stijn
> 
> > -----Original Message-----
> > From: Guenter Roeck [mailto:guenter.roeck@ericsson.com]
> > Sent: maandag 6 juni 2011 14:41
> > To: Stijn Devriendt (sdevrien)
> > Cc: khali@linux-fr.org; lm-sensors@lm-sensors.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH v3] Add support for the Philips SA56004
> temperature
> > sensor.
> > 
> > On Mon, Jun 06, 2011 at 06:40:45AM -0400, sdevrien@cisco.com wrote:
> > > From: Stijn Devriendt <sdevrien@cisco.com>
> > >
> > > Add support for the Philips SA56004, an LM86
> > > compatible temperature sensor.
> > >
> > > Changes since v2:
> > > - Changed BUG_ON to WARN_ON
> > > Changes since v1:
> > > - Updated documentation
> > > - Trace replaced by BUG_ON
> > > - style updates
> > >
> > > Signed-off-by: Stijn Devriendt <sdevrien@cisco.com>
> > 
> > Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > 
> > Jean, do you want to take this and/or have a look, or should I ?
> > 
> > Thanks,
> > Guenter
