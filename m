Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab1EMSmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:42:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:7409 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab1EMSl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:41:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,365,1301900400"; 
   d="scan'208";a="1944164"
Date: Fri, 13 May 2011 20:41:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Liam Girdwood <lrg@ti.com>, "grant@secretlab.ca" <grant@secretlab.ca>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv5 2/4] TPS65910: GPIO: Add GPIO driver
Message-ID: <20110513184153.GZ8970@sortiz-mobl>
References: <2CAE1D41-48DC-457F-8FF3-E45B17AC3E0F@slimlogic.co.uk>
 <4DBAD7E8.8090703@ti.com>
 <20110429220651.GG7497@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110429220651.GG7497@ponder.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Fri, Apr 29, 2011 at 04:06:51PM -0600, Grant Likely wrote:
> On Fri, Apr 29, 2011 at 04:23:20PM +0100, Liam Girdwood wrote:
> > On 27/04/11 16:51, Jorge Eduardo Candelaria wrote:
> > > From: Graeme Gregory <gg@slimlogic.co.uk>
> > > 
> > > TPS65910 has one configurable GPIO that can be used for several
> > > purposes. Subsequent versions of the TPS chip support more than
> > > one GPIO.
> > > 
> > > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> > > Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> > > ---
> > >  drivers/mfd/Makefile         |    2 +-
> > >  drivers/mfd/tps65910-gpio.c  |   91 ++++++++++++++++++++++++++++++++++++++++++
> > >  drivers/mfd/tps65910.c       |    7 +++
> > >  include/linux/mfd/tps65910.h |    2 +
> > >  4 files changed, 101 insertions(+), 1 deletions(-)
> > >  create mode 100644 drivers/mfd/tps65910-gpio.c
> > > 
> > 
> > Grant, if you are happy with this I can take all via regulator.
> 
> Yes, I'm okay with it.
Would you be ok with moving this one to drivers/gpio/ ? And in general, moving
most of the GPIO drivers under drivers/mfd/ back to drivers/gpio/ ?
David didn't want to take the basic MFD related GPIO drivers, that's why we
have several of them under mfd.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
