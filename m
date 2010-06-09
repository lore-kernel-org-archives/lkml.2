Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab0FIQYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:24:43 -0400
Received: from mail.perches.com ([173.55.12.10]:2919 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757677Ab0FIQYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:24:42 -0400
Subject: Re: [PATCH 00/17] MAINTAINERS: Add drivers/staging entries
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Jarod Wilson <jarod@wilsonet.com>,
       linux-kernel@vger.kernel.org, Henk de Groot <pe1dnn@amsat.org>,
       Naren Sankar <nsankar@broadcom.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       Pavel Machek <pavel@ucw.cz>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>, devel@driverdev.osuosl.org,
       Mori Hess <fmhess@users.sourceforge.net>,
       Steve Underwood <steveu@coppice.org>,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
       Arnaud Patard <apatard@mandriva.com>,
       Marek Lindner <lindner_marek@yahoo.de>,
       Forest Bond <forest@alittletooquiet.net>,
       Ossama Othman <ossama.othman@intel.com>, Arnd Bergmann <arnd@arndb.de>,
       Haiyang Zhang <haiyangz@microsoft.com>, Ian Abbott <abbotti@mev.co.uk>,
       Willy Tarreau <willy@meta-x.org>, Scott Davilla <davilla@4pi.com>,
       Scott Smedley <ss@aao.gov.au>, Jakub Schmidtke <sjakub@gmail.com>,
       Teddy Wang <teddy.wang@siliconmotion.com.cn>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rowe <david@rowetel.com>
In-Reply-To: <20100609160119.GA23100@kroah.com>
References: <cover.1275935090.git.joe@perches.com>
	 <1276032382.24044.23.camel@Joe-Laptop.home>
	 <20100609000713.GB16160@kroah.com> <201006091524.51998.arnd@arndb.de>
	 <20100609150833.GD20705@kroah.com>
	 <1276098744.1556.50.camel@Joe-Laptop.home>
	 <20100609160119.GA23100@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 09:24:36 -0700
Message-ID: <1276100676.1556.98.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 09:01 -0700, Greg KH wrote:
> I was trying to point out that you are ignoring the maintainer
> of the subsystem for which you are adding entries for.  In fact, going
> against the wishes of that maintainer (i.e. me) at the same time.
> > I'm the closest thing there is to a MAINTAINERS maintainer.
> > Andrew has taken all the patches I've posted to it except for
> > the patchset that added file patterns and you're rarely a
> > path to get things into MAINTAINERS.
[]
> But that has little to do with this.

Of course it does.

Without these patches, people have to look in multiple places
to determine where best to send patches and get_maintainers.pl
produces poorer results.

The centralization is good, the redundancy is low, and I like
it when tools produce good results.

It seems you produce fewer satisfaction endorphins from that
than I. ;)

> If you are going to be responsible for keeping these up to date,
> especially when the drivers go away or move, then fine, make these
> changes.

Yup, I do that and will likely continue to do so.

I occasionally run scripts that sieve MAINTAINERS file patterns
against the current tree and highlight what's renamed or removed.

Then I post patches.

> But if not, then don't accept them, as I'm not going to.

Who are you writing that to?  Me?
Linus doesn't pull from me.

Anyway no worries Greg.  Life's good.

Hope your enjoyment endorphin receptors are always active...

