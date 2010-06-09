Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab0FIPwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:52:33 -0400
Received: from mail.perches.com ([173.55.12.10]:2891 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab0FIPwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:52:31 -0400
Subject: Re: [PATCH 00/17] MAINTAINERS: Add drivers/staging entries
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
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
In-Reply-To: <20100609150833.GD20705@kroah.com>
References: <cover.1275935090.git.joe@perches.com>
	 <1276032382.24044.23.camel@Joe-Laptop.home>
	 <20100609000713.GB16160@kroah.com> <201006091524.51998.arnd@arndb.de>
	 <20100609150833.GD20705@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 08:52:24 -0700
Message-ID: <1276098744.1556.50.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 08:08 -0700, Greg KH wrote:
> On Wed, Jun 09, 2010 at 03:24:51PM +0200, Arnd Bergmann wrote:
> > On Wednesday 09 June 2010, Greg KH wrote:
> > > > > I also found it a bit odd you didn't send these to the stable subsystem
> > > > > maintainer, why?
> > > > The MAINTAINERS patches are forward going, not historical.
> > > What does that mean?
> > I guess you meant to write '... to the /staging/ subsystem maintainer'.
> Doh, yes, you are right.
> Joe, why didn't you send these to the "STAGING" subsystem maintainer?

Gee, who would that be?  Why be so indirect?
(Even though you are both the stable and the staging maintainer)

Why don't you just write "How come I didn't get cc'd?"

I'm the closest thing there is to a MAINTAINERS maintainer.
Andrew has taken all the patches I've posted to it except for
the patchset that added file patterns and you're rarely a
path to get things into MAINTAINERS.

$ ./scripts/get_maintainer.pl -f --rolestats MAINTAINERS 
Andrew Morton <akpm@linux-foundation.org> (commit_signer:97/515=19%)
Joe Perches <joe@perches.com> (commit_signer:83/515=16%)
"David S. Miller" <davem@davemloft.net> (commit_signer:35/515=7%)

And you already had written that you wouldn't take a
similar individual patch.

http://lkml.org/lkml/2010/6/2/428


