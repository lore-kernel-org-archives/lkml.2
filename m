Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab0FBUTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:19:49 -0400
Received: from xenotime.net ([72.52.115.56]:54582 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932937Ab0FBUTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:19:47 -0400
Date: Wed, 2 Jun 2010 13:19:38 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <gregkh@suse.de>
Cc: Joe Perches <joe@perches.com>, devel <devel@driverdev.osuosl.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] MAINTAINERS: Add staging/b.a.t.m.a.n
Message-Id: <20100602131938.cda13ed7.rdunlap@xenotime.net>
In-Reply-To: <20100602201717.GA8803@suse.de>
References: <1275498615.23599.12.camel@Joe-Laptop.home>
	<20100602185323.GA6600@suse.de>
	<1275509319.23599.40.camel@Joe-Laptop.home>
	<20100602201717.GA8803@suse.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010 13:17:17 -0700 Greg KH wrote:

> On Wed, Jun 02, 2010 at 01:08:39PM -0700, Joe Perches wrote:
> > On Wed, 2010-06-02 at 11:53 -0700, Greg KH wrote:
> > > The TODO file in this directory clearly states who to copy on patches to
> > > these files.
> > 
> > Does anyone look at those? ;)
> 
> Yes, they should.
> 
> Heck, get_maintainer.pl would have given you the correct people to cc:
> as well, why not use that?
> 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  MAINTAINERS |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 2652ebc..e25e15a 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5436,6 +5436,14 @@ L:	devel@driverdev.osuosl.org
> >  S:	Maintained
> >  F:	drivers/staging/
> >  
> > +STAGING B.A.T.M.A.N.
> > +M:	Marek Lindner <lindner_marek@yahoo.de>
> > +M:	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> > +M:	Andrew Lunn <andrew@lunn.ch>
> > +L:	b.a.t.m.a.n@lists.open-mesh.net
> > +S:	Maintained (one day soon)
> > +F:	drivers/staging/batman-adv/
> 
> Care to at least cc: the people who you are adding to the file?
> 
> To not do so is a bit rude, don't you think so?
> 
> I'm not going to take this, sorry.


Sure he should have cc-ed them, but it's still a valid patch and should
be applied.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
