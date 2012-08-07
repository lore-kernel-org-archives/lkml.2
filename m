Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab2HGSPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:15:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60598 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab2HGSPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:15:53 -0400
Date: Tue, 7 Aug 2012 20:15:49 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH RFC] regulator: suppress printk if there is no real info
Message-ID: <20120807181549.GF9888@pengutronix.de>
References: <1344244720-24051-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20120807181022.GE16861@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120807181022.GE16861@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 07:10:22PM +0100, Mark Brown wrote:
> On Mon, Aug 06, 2012 at 11:18:40AM +0200, Uwe Kleine-König wrote:
> 
> > probably this really only applies to the dummy regulator. If not it
> > might be more sensible to do:
> 
> > 	if (!buf[0])
> > 		buf = "no parameters";
> 
> Yeah, having the log message for other regulators is helpful since
> things often go boom after you mess with power but not so useful for
> dummy.
That's a +1 for which approach?
 
> > or similar. Other than that I wonder if setting the devicename from
> > "dummy" to say "regulator-dummy" would be an improvement, too.
> 
> That'd work too.
I'd like to combine it with one of the two suggested above.
If you answer my question I can follow up with a patch.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
