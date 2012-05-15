Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab2EONpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 09:45:15 -0400
Received: from imr3.ericy.com ([198.24.6.13]:42989 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758824Ab2EONpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 09:45:13 -0400
Date: Tue, 15 May 2012 06:42:57 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
CC: "Tc, Jenny" <jenny.tc@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: Generic ADC support for hwmon
Message-ID: <20120515134257.GA21933@ericsson.com>
References: <1337092008-31263-1-git-send-email-jenny.tc@intel.com>
 <20120515121339.GA21600@ericsson.com>
 <4D68720C2E767A4AA6A8796D42C8EB59124E22@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB59124E22@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 08:42:57AM -0400, R, Durgadoss wrote:
> Hi Guenter,
> 
> Thanks for a quick reply.
> 
> > On Tue, May 15, 2012 at 10:26:48AM -0400, Jenny TC wrote:
> > > Currently drivers are using custom APIs to communicate with ADC driver.
> > > So it make sense to have generic APIs to commnicate with ADC drivers.
> > > This patch introduces generic APIs to communicate with ADC drivers.
> > >
> > > Signed-off-by: Jenny TC <jenny.tc@intel.com>
> > 
> > Hi Jenny,
> > 
> > Do you have a practical use case ?
> 
> We have some platform specific component drivers, thermal drivers,
> battery drivers using this General purpose ADC in the platform.
> That's why we thought of doing something like this.
> 
> > 
> > Also, shouldn't those generic ADCs rather be supported through the IO
> > subsystem ?
> > After all, hwmon is all about hardware monitoring, not to provide generic ADC
> > access.
> 
> In this case, can we try this in iio or mfd subsystem ?
> Kindly advise.
> 
I meant iio (more specifically staging/iio/adc).

I suspect it might make more sense to have a hwmon client, in parallel to the other
users/clients (battery control, thermal etc), if the values reported by the ADC reflect
information relevant for hardware monitoring.

Thanks,
Guenter
