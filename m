Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0FHV03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:26:29 -0400
Received: from mail.perches.com ([173.55.12.10]:2821 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab0FHV02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:26:28 -0400
Subject: Re: [PATCH 00/17] MAINTAINERS: Add drivers/staging entries
From: Joe Perches <joe@perches.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrew Lunn <andrew@lunn.ch>,
       Jarod Wilson <jarod@wilsonet.com>, Jakub Schmidtke <sjakub@gmail.com>,
       Henk de Groot <pe1dnn@amsat.org>, Naren Sankar <nsankar@broadcom.com>,
       Jonathan Cameron <jic23@cam.ac.uk>, Pavel Machek <pavel@ucw.cz>,
       Luis Rodriguez <Luis.Rodriguez@Atheros.com>, devel@driverdev.osuosl.org,
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
In-Reply-To: <20100608211246.GC10657@kroah.com>
References: <cover.1275935090.git.joe@perches.com>
	 <20100608211246.GC10657@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jun 2010 14:26:22 -0700
Message-ID: <1276032382.24044.23.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-08 at 14:12 -0700, Greg KH wrote:
> On Mon, Jun 07, 2010 at 11:49:34AM -0700, Joe Perches wrote:
> > Some drivers/staging directories use a TODO file with email entries.
> > Make the same entries in the normal MAINTAINERS file.
> 
> No, please don't do this.  I don't want to clutter up the MAINTAINERS
> file with staging stuff.

It's not clutter when it helps get patches to the right reviewers
or responsible parties.

> The get_maintainer.pl script handles staging
> patches just fine today without this being needed at all.

Dubious.

Many of these nominal maintainer email entries are not
found in git logs.

For instance:

$ grep "@" drivers/staging/dt3155/TODO
Please send patches to Greg Kroah-Hartman <greg@kroah.com>
and Scott Smedley <ss@aao.gov.au>

$ ./scripts/get_maintainer.pl -f drivers/staging/dt3155/
Greg Kroah-Hartman <gregkh@suse.de>
Simon Horman <horms@verge.net.au>
H Hartley Sweeten <hsweeten@visionengravers.com>
devel@driverdev.osuosl.org
linux-kernel@vger.kernel.org

Some have cc:'d entries, but not many actually have
Signed-off-by's.  Perhaps that's because the individuals
are not frequently cc'd on the actual patches.  Perhaps
because the people that put their names in the TODO's
just don't care.

> I also found it a bit odd you didn't send these to the stable subsystem
> maintainer, why?

The MAINTAINERS patches are forward going, not historical.

cheers, Joe

