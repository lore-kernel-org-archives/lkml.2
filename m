Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab1D2WG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:06:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52401 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab1D2WGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:06:54 -0400
Date: Fri, 29 Apr 2011 16:06:51 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Liam Girdwood <lrg@ti.com>
Cc: "grant@secretlab.ca" <grant@secretlab.ca>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv5 2/4] TPS65910: GPIO: Add GPIO driver
Message-ID: <20110429220651.GG7497@ponder.secretlab.ca>
References: <2CAE1D41-48DC-457F-8FF3-E45B17AC3E0F@slimlogic.co.uk>
 <4DBAD7E8.8090703@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBAD7E8.8090703@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 04:23:20PM +0100, Liam Girdwood wrote:
> On 27/04/11 16:51, Jorge Eduardo Candelaria wrote:
> > From: Graeme Gregory <gg@slimlogic.co.uk>
> > 
> > TPS65910 has one configurable GPIO that can be used for several
> > purposes. Subsequent versions of the TPS chip support more than
> > one GPIO.
> > 
> > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> > Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> > ---
> >  drivers/mfd/Makefile         |    2 +-
> >  drivers/mfd/tps65910-gpio.c  |   91 ++++++++++++++++++++++++++++++++++++++++++
> >  drivers/mfd/tps65910.c       |    7 +++
> >  include/linux/mfd/tps65910.h |    2 +
> >  4 files changed, 101 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/mfd/tps65910-gpio.c
> > 
> 
> Grant, if you are happy with this I can take all via regulator.

Yes, I'm okay with it.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

