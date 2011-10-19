Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1JSOuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:50:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57888 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944Ab1JSOuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:50:03 -0400
Date: Wed, 19 Oct 2011 15:50:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Rajendra Nayak <rnayak@ti.com>, grant.likely@secretlab.ca,
        patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111019144959.GA31850@opensource.wolfsonmicro.com>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-4-git-send-email-rnayak@ti.com>
 <20111018132032.GD30703@S2100-06.ap.freescale.net>
 <4E9EB61C.1040207@ti.com>
 <20111019144215.GA32007@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019144215.GA32007@S2100-06.ap.freescale.net>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 10:42:16PM +0800, Shawn Guo wrote:

*Please* delete irrelevant quotes from mails.

> On Wed, Oct 19, 2011 at 05:05:56PM +0530, Rajendra Nayak wrote:

> > Yes, it seems like a good idea given that most drivers seem to blindly
> > pass the regulator_init_data onto regulator_register, however there
> > are cases like the twl regulator driver which seems to peek into the
> > constraints passed from the board to make sure it drops anything that
> > the hardware does not support,

> I'm not sure why twl works in that way.  Is it a sign that those
> configuration peeked by twl regulator driver should be encoded in twl
> regulator driver itself instead of being passed from the board?  Or
> why the board does not pass something matching driver/hardware
> capability to save that peek?

It's completely unneeded but harmless, it's there because there were a
large number of discussions going on with the original author and it was
easier to merge the code.
