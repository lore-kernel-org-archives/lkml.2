Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2HGSK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:10:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56628 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755824Ab2HGSKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:10:25 -0400
Date: Tue, 7 Aug 2012 19:10:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH RFC] regulator: suppress printk if there is no real info
Message-ID: <20120807181022.GE16861@opensource.wolfsonmicro.com>
References: <1344244720-24051-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1344244720-24051-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 11:18:40AM +0200, Uwe Kleine-König wrote:

> probably this really only applies to the dummy regulator. If not it
> might be more sensible to do:

> 	if (!buf[0])
> 		buf = "no parameters";

Yeah, having the log message for other regulators is helpful since
things often go boom after you mess with power but not so useful for
dummy.

> or similar. Other than that I wonder if setting the devicename from
> "dummy" to say "regulator-dummy" would be an improvement, too.

That'd work too.
