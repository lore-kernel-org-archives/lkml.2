Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab0FBU1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:27:55 -0400
Received: from mail.perches.com ([173.55.12.10]:2597 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758523Ab0FBU1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:27:54 -0400
Subject: Re: [PATCH] MAINTAINERS: Add staging/b.a.t.m.a.n
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
       Marek Lindner <lindner_marek@yahoo.de>,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
       Andrew Lunn <andrew@lunn.ch>
Cc: Greg KH <gregkh@suse.de>, devel <devel@driverdev.osuosl.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100602131938.cda13ed7.rdunlap@xenotime.net>
References: <1275498615.23599.12.camel@Joe-Laptop.home>
	 <20100602185323.GA6600@suse.de> <1275509319.23599.40.camel@Joe-Laptop.home>
	 <20100602201717.GA8803@suse.de>
	 <20100602131938.cda13ed7.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 13:27:52 -0700
Message-ID: <1275510472.23599.50.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 13:19 -0700, Randy Dunlap wrote:
> On Wed, 2 Jun 2010 13:17:17 -0700 Greg KH wrote:
> > On Wed, Jun 02, 2010 at 01:08:39PM -0700, Joe Perches wrote:
> > > On Wed, 2010-06-02 at 11:53 -0700, Greg KH wrote:
> > > > The TODO file in this directory clearly states who to copy on patches to
> > > > these files.
> > > Does anyone look at those? ;)
> > Yes, they should.
> > Heck, get_maintainer.pl would have given you the correct people to cc:
> > as well, why not use that?

I know that script.
In fact, I did use it with my preferred options.

> > > Signed-off-by: Joe Perches <joe@perches.com>
> > > ---
> > >  MAINTAINERS |    8 ++++++++
> > >  1 files changed, 8 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 2652ebc..e25e15a 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -5436,6 +5436,14 @@ L:	devel@driverdev.osuosl.org
> > >  S:	Maintained
> > >  F:	drivers/staging/
> > >  
> > > +STAGING B.A.T.M.A.N.
> > > +M:	Marek Lindner <lindner_marek@yahoo.de>
> > > +M:	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> > > +M:	Andrew Lunn <andrew@lunn.ch>
> > > +L:	b.a.t.m.a.n@lists.open-mesh.net
> > > +S:	Maintained (one day soon)
> > > +F:	drivers/staging/batman-adv/
> > 
> > Care to at least cc: the people who you are adding to the file?
> > To not do so is a bit rude, don't you think so?

twas, oversight.  Apologies to them.

They're already described in a TODO file as the people to cc,
so I rather doubt they'll mind.
 
> > I'm not going to take this, sorry.

You're just being you.
Perhaps Andrew will take it.

cheers, Joe


