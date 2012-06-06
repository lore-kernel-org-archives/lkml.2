Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab2FFFYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 01:24:55 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:48765 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753816Ab2FFFYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 01:24:54 -0400
Date: Wed, 6 Jun 2012 14:24:39 +0900
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Fabio Estevam <festevam@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, kernel@pengutronix.de,
        shawn.guo@freescale.com, Fabio Estevam <fabio.estevam@freescale.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/15] hw_random: mxc-rnga: Use
 clk_prepare_enable/clk_disable_unprepare
Message-ID: <20120606052439.GA28233@gondor.apana.org.au>
References: <1337987696-31728-4-git-send-email-festevam@gmail.com>
 <1338048232-3523-1-git-send-email-festevam@gmail.com>
 <20120529091757.GG30400@pengutronix.de>
 <CAOMZO5AZ0mw7yDs6aBN4NP0K5jK-Ee6Yz6hfu5nhr6HXdNP_+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5AZ0mw7yDs6aBN4NP0K5jK-Ee6Yz6hfu5nhr6HXdNP_+A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 12:41:17AM -0300, Fabio Estevam wrote:
> Herbert,
> 
> On Tue, May 29, 2012 at 6:17 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Sat, May 26, 2012 at 01:03:52PM -0300, Fabio Estevam wrote:
> >> From: Fabio Estevam <fabio.estevam@freescale.com>
> >>
> >> Prepare the clock before enabling it.
> >>
> >> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> >> Cc: <linux-kernel@vger.kernel.org>
> >> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> >
> > Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Can this be applied?

Your patch is in my queue.  I'm at LinuxCon Japan right now,
so I'll be applying them later this week.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
