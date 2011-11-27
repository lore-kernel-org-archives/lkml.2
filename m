Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab1K0Re0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 12:34:26 -0500
Received: from imr3.ericy.com ([198.24.6.13]:32856 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab1K0ReY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 12:34:24 -0500
Date: Sun, 27 Nov 2011 09:32:04 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: Dirk Eibach <eibach@gdsys.de>, David George <david.george@ska.ac.za>,
        Guillaume Ligneul <guillaume.ligneul@gmail.com>,
        Riku Voipio <riku.voipio@iki.fi>, "Hans J. Koch" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH] hwmon: convert drivers/hwmon/* to use
 module_i2c_driver()
Message-ID: <20111127173204.GA31171@ericsson.com>
References: <1322204787.11718.1.camel@phoenix>
 <20111125165708.GA11317@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111125165708.GA11317@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 11:57:08AM -0500, Guenter Roeck wrote:
> On Fri, Nov 25, 2011 at 02:06:27AM -0500, Axel Lin wrote:
> > This patch converts the drivers in drivers/hwmon/* to use the
> > module_i2c_driver() macro which makes the code smaller and a bit
> > simpler.
> > 
> > Cc: Corentin Labbe <corentin.labbe@geomatys.fr>
> > Cc: Dirk Eibach <eibach@gdsys.de>
> > Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
> > Cc: Steve Glendinning <steve.glendinning@smsc.com>
> > Cc: Riku Voipio <riku.voipio@iki.fi>
> > Cc: Guillaume Ligneul <guillaume.ligneul@gmail.com>
> > Cc: David George <david.george@ska.ac.za>
> > Cc: "Hans J. Koch" <hjk@hansjkoch.de>
> > Cc: Marc Hulsman <m.hulsman@tudelft.nl>
> > Cc: Rudolf Marek <r.marek@assembler.cz>
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> 
> Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
> What is the plan for those patches ? Are they expected to all go through the same tree,
> or through individual trees after the necessary defines are introduced into mainline ?
> 
My question was answered in another thread related to the misc subsystem.
The patch this one depends on will only be available in 3.3-rc1. It would have been
nice to let us know ahead of time, because I _did_ find out the hard way.

I would suggest to resubmit the i2c and spi patches against a working baseline
once it is available, to make sure it does not miss some new drivers.

On a side note, this patch does miss the drivers in hwmon/pmbus, but I can take care
of those myself.

Guenter
