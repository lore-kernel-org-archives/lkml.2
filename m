Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab2HGSQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:16:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52056 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016Ab2HGSQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:16:44 -0400
Date: Tue, 7 Aug 2012 19:16:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH RFC] regulator: suppress printk if there is no real info
Message-ID: <20120807181642.GF16861@opensource.wolfsonmicro.com>
References: <1344244720-24051-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20120807181022.GE16861@opensource.wolfsonmicro.com>
 <20120807181549.GF9888@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120807181549.GF9888@pengutronix.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 08:15:49PM +0200, Uwe Kleine-König wrote:
> On Tue, Aug 07, 2012 at 07:10:22PM +0100, Mark Brown wrote:

> > > 	if (!buf[0])
> > > 		buf = "no parameters";

> > Yeah, having the log message for other regulators is helpful since
> > things often go boom after you mess with power but not so useful for
> > dummy.

> That's a +1 for which approach?

The above one which preserves the log message.
