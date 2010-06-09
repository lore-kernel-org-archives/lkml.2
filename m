Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0FIAHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 20:07:21 -0400
Received: from kroah.org ([198.145.64.141]:51501 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab0FIAHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 20:07:19 -0400
Date: Tue, 8 Jun 2010 17:07:13 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
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
Subject: Re: [PATCH 00/17] MAINTAINERS: Add drivers/staging entries
Message-ID: <20100609000713.GB16160@kroah.com>
References: <cover.1275935090.git.joe@perches.com>
 <20100608211246.GC10657@kroah.com>
 <1276032382.24044.23.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276032382.24044.23.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 02:26:22PM -0700, Joe Perches wrote:
> On Tue, 2010-06-08 at 14:12 -0700, Greg KH wrote:
> > On Mon, Jun 07, 2010 at 11:49:34AM -0700, Joe Perches wrote:
> > > Some drivers/staging directories use a TODO file with email entries.
> > > Make the same entries in the normal MAINTAINERS file.
> > 
> > No, please don't do this.  I don't want to clutter up the MAINTAINERS
> > file with staging stuff.
> 
> It's not clutter when it helps get patches to the right reviewers
> or responsible parties.

That's my job as staging maintainer, right?  Am I somehow not doing this
properly?

> > The get_maintainer.pl script handles staging
> > patches just fine today without this being needed at all.
> 
> Dubious.
> 
> Many of these nominal maintainer email entries are not
> found in git logs.

Many, but not all, as you pointed out.

> > I also found it a bit odd you didn't send these to the stable subsystem
> > maintainer, why?
> 
> The MAINTAINERS patches are forward going, not historical.

What does that mean?
