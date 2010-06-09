Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab0FIQBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:01:39 -0400
Received: from kroah.org ([198.145.64.141]:40750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757879Ab0FIQBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:01:37 -0400
Date: Wed, 9 Jun 2010 09:01:19 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       Andrew Lunn <andrew@lunn.ch>, Jarod Wilson <jarod@wilsonet.com>,
       Jakub Schmidtke <sjakub@gmail.com>, Henk de Groot <pe1dnn@amsat.org>,
       Naren Sankar <nsankar@broadcom.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       Pavel Machek <pavel@ucw.cz>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>, devel@driverdev.osuosl.org,
       Mori Hess <fmhess@users.sourceforge.net>,
       Steve Underwood <steveu@coppice.org>,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
       Arnaud Patard <apatard@mandriva.com>,
       Marek Lindner <lindner_marek@yahoo.de>,
       Teddy Wang <teddy.wang@siliconmotion.com.cn>,
       Ossama Othman <ossama.othman@intel.com>,
       Haiyang Zhang <haiyangz@microsoft.com>, Ian Abbott <abbotti@mev.co.uk>,
       Willy Tarreau <willy@meta-x.org>, Scott Davilla <davilla@4pi.com>,
       Scott Smedley <ss@aao.gov.au>, linux-kernel@vger.kernel.org,
       Forest Bond <forest@alittletooquiet.net>,
       David Rowe <david@rowetel.com>
Subject: Re: [PATCH 00/17] MAINTAINERS: Add drivers/staging entries
Message-ID: <20100609160119.GA23100@kroah.com>
References: <cover.1275935090.git.joe@perches.com>
 <1276032382.24044.23.camel@Joe-Laptop.home>
 <20100609000713.GB16160@kroah.com>
 <201006091524.51998.arnd@arndb.de>
 <20100609150833.GD20705@kroah.com>
 <1276098744.1556.50.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276098744.1556.50.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 08:52:24AM -0700, Joe Perches wrote:
> On Wed, 2010-06-09 at 08:08 -0700, Greg KH wrote:
> > On Wed, Jun 09, 2010 at 03:24:51PM +0200, Arnd Bergmann wrote:
> > > On Wednesday 09 June 2010, Greg KH wrote:
> > > > > > I also found it a bit odd you didn't send these to the stable subsystem
> > > > > > maintainer, why?
> > > > > The MAINTAINERS patches are forward going, not historical.
> > > > What does that mean?
> > > I guess you meant to write '... to the /staging/ subsystem maintainer'.
> > Doh, yes, you are right.
> > Joe, why didn't you send these to the "STAGING" subsystem maintainer?
> 
> Gee, who would that be?  Why be so indirect?
> (Even though you are both the stable and the staging maintainer)
> 
> Why don't you just write "How come I didn't get cc'd?"

Because I was trying to point out that you are ignoring the maintainer
of the subsystem for which you are adding entries for.  In fact, going
against the wishes of that maintainer (i.e. me) at the same time.

> I'm the closest thing there is to a MAINTAINERS maintainer.
> Andrew has taken all the patches I've posted to it except for
> the patchset that added file patterns and you're rarely a
> path to get things into MAINTAINERS.

That's great and wonderful, and you do a great job.  But that has little
to do with this.

> And you already had written that you wouldn't take a
> similar individual patch.
> 
> http://lkml.org/lkml/2010/6/2/428

Exactly.  For the reasons stated previously.

If you are going to be responsible for keeping these up to date,
especially when the drivers go away or move, then fine, make these
changes.

But if not, then don't accept them, as I'm not going to.

greg k-h
