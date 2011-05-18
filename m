Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab1ERRu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:50:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55840 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341Ab1ERRuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:50:25 -0400
Date: Wed, 18 May 2011 11:50:22 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Liam Girdwood <lrg@ti.com>
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv4 4/6] GPIO: TPS65910: Move driver to drivers/gpio/
Message-ID: <20110518175022.GA25861@ponder.secretlab.ca>
References: <797F9124-08A3-45B9-BA71-284BB3048F1D@slimlogic.co.uk>
 <4DD3F6F7.5090508@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD3F6F7.5090508@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 05:42:31PM +0100, Liam Girdwood wrote:
> On 17/05/11 00:35, Jorge Eduardo Candelaria wrote:
> > The GPIO driver should reside in drivers/gpio/ for better
> > organization.
> > 
> > Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> > ---
> >  drivers/gpio/Kconfig         |    7 +++
> >  drivers/gpio/Makefile        |    1 +
> >  drivers/gpio/tps65910-gpio.c |   91 ++++++++++++++++++++++++++++++++++++++++++
> >  drivers/mfd/Kconfig          |    3 +-
> >  drivers/mfd/Makefile         |    2 +-
> >  drivers/mfd/tps65910-gpio.c  |   91 ------------------------------------------
> >  6 files changed, 102 insertions(+), 93 deletions(-)
> >  create mode 100644 drivers/gpio/tps65910-gpio.c
> >  delete mode 100644 drivers/mfd/tps65910-gpio.c
> > 
> 
> Grant, if you are happy with this I can this series altogether via regulator.

Yes, go ahead and take the series all together.

g.
