Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab1KNRHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:07:03 -0500
Received: from waste.org ([173.11.57.241]:36992 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab1KNRHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:07:01 -0500
Subject: Re: Mercurial linux-kernel repository at kernel.org?
From: Matt Mackall <mpm@selenic.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, warthog9@kernel.org
In-Reply-To: <1321039441.15412.3.camel@Joe-Laptop>
References: <1320998367.16747.127.camel@dagon.hellion.org.uk>
	 <1321013367.6676.13.camel@Joe-Laptop> <1321034791.5399.195.camel@calx>
	 <1321039441.15412.3.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 11:06:54 -0600
Message-ID: <1321290414.5399.295.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-11 at 11:24 -0800, Joe Perches wrote:
> On Fri, 2011-11-11 at 12:06 -0600, Matt Mackall wrote:
> > [uncrossposting]
> > 
> > On Fri, 2011-11-11 at 04:09 -0800, Joe Perches wrote:
> > > Prior to intrusion, a mercurial repository essentially
> > > duplicating the Linus' git tree existed at:
> > > http://www.kernel.com/hg/linux-2.6
> > > 
> > > I do not use it, but are there any plans to restore it?
> > 
> > Not on kernel.org, certainly.
> > 
> > I asked the kernel.org admins a while back to send me a copy of the SHA
> > map file from my account I needed to continue the mirror elsewhere and
> > HPA declined, making some handwaving towards "eventually letting people
> > download tarballs of their old accounts".
> > 
> > As far as I know, "eventually" hasn't happened yet. I guess it's time to
> > fire up a new mirror from scratch. It'll be incompatible with old clones
> > due to not having the above file and various minor changes in both git
> > and hg in the 6 years the original mirror was running. I'll announce it
> > when it's done - it'll probably take a while.
> 
> No worries.  I'm not an hg user.  Ian Campbell sent a patch
> to get_maintainer to use git log option --follow for a largish
> file rename event in drivers/net/... and I was trying to get
> the hg commands in get_maintainer to do the same.
> 
> Any idea if tracking file renames in hg needs an additional
> command line option and if so what it is?

hg log --follow <some-file> will follow the history across renames.

-- 
Mathematics is the supreme nostalgia of our time.


