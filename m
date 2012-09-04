Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2IDC5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 22:57:46 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:40349 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754484Ab2IDC5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 22:57:45 -0400
Date: Mon, 3 Sep 2012 19:57:22 -0700
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Fabio Estevam <festevam@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        "Theodore Ts'o" <tytso@mit.edu>, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] hw_random: mxc-rnga: Adapt clocks to new i.mx
 clock framework
Message-ID: <20120904025722.GA320@gondor.apana.org.au>
References: <1343407672-27185-1-git-send-email-fabio.estevam@freescale.com>
 <20120731064053.GW30009@pengutronix.de>
 <CAOMZO5BSi7sfK+4mjPUn9j89CssyGBJkLXY_0aDekA5SRrXD-w@mail.gmail.com>
 <CAOMZO5CY6GdwG2EfQjmejpiHV0i=GhFRdgnOP1puo7LjdiA48g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CY6GdwG2EfQjmejpiHV0i=GhFRdgnOP1puo7LjdiA48g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 06:08:45PM -0300, Fabio Estevam wrote:
> Herbert,
> 
> On Fri, Aug 3, 2012 at 12:10 PM, Fabio Estevam <festevam@gmail.com> wrote:
> > Hi Herbert,
> >
> > On Tue, Jul 31, 2012 at 3:40 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >> On Fri, Jul 27, 2012 at 01:47:51PM -0300, Fabio Estevam wrote:
> >>> Adapt clocks to the new i.mx clock framework and fix the following warning:
> >>>
> >>> Cc: Theodore Ts'o <tytso@mit.edu>
> >>> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> >>> Cc: <linux-kernel@vger.kernel.org>
> >>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> >>
> >> Both:
> >>
> >> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> >
> > Looks like git did not Cc'ed you in these patches.
> >
> > Would it be OK to apply these two patches?
> 
> Ping?

It would help if you actually send me the patches.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
