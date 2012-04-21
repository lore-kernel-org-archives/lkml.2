Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab2DUWMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 18:12:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46002 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2DUWL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 18:11:59 -0400
Date: Sun, 22 Apr 2012 01:13:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Valentin Rothberg <valentinrothberg@googlemail.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jordan Crouse <jordan@cosmicpenguin.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 3/3] staging: olpc_dcon.c: Remove a few spaces between
 casts and variables
Message-ID: <20120421221356.GO27101@mwanda>
References: <alpine.LNX.2.00.1204212025140.25551@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1204212031360.25551@swampdragon.chaosbits.net>
 <20120421202825.GW6498@mwanda>
 <alpine.LNX.2.00.1204212238040.25551@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1204212238040.25551@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F933089.0021,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 10:41:00PM +0200, Jesper Juhl wrote:
> On Sat, 21 Apr 2012, Dan Carpenter wrote:
> 
> > On Sat, Apr 21, 2012 at 08:33:15PM +0200, Jesper Juhl wrote:
> > > Just a trivial style cleanup.
> > > 
> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > > ---
> > >  drivers/staging/olpc_dcon/olpc_dcon.c |    8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
> > > index 7fe6eb6..992275c 100644
> > > --- a/drivers/staging/olpc_dcon/olpc_dcon.c
> > > +++ b/drivers/staging/olpc_dcon/olpc_dcon.c
> > > @@ -134,7 +134,7 @@ static int dcon_bus_stabilize(struct dcon_priv *dcon, int is_powered_down)
> > >  power_up:
> > >  	if (is_powered_down) {
> > >  		x = 1;
> > > -		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
> > > +		x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
> >                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > This will only work on little endian systems btw.  On big endian
> > systems the first byte is going to be 0x00 instead of 0x01.
> > 
> Thank you, Dan, for bothering to take a look at this trivial patch.
> 

Trivial patches are the easiest to review.  ;)

> I hope we can agree that this issue is not affected by my trivial 
> whitespace cleanup ;-)  So, would you be OK with just leaving the patch 
> alone for Greg to merge along with the others and then address this issue 
> in a separate patch later?
> 

Sure.  That's not a problem.

regards,
dan carpenter
