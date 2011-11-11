Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab1KKTYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 14:24:04 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38843 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758116Ab1KKTYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 14:24:03 -0500
Message-ID: <1321039441.15412.3.camel@Joe-Laptop>
Subject: Re: Mercurial linux-kernel repository at kernel.org?
From: Joe Perches <joe@perches.com>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, warthog9@kernel.org
Date: Fri, 11 Nov 2011 11:24:01 -0800
In-Reply-To: <1321034791.5399.195.camel@calx>
References: <1320998367.16747.127.camel@dagon.hellion.org.uk>
	 <1321013367.6676.13.camel@Joe-Laptop> <1321034791.5399.195.camel@calx>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-11 at 12:06 -0600, Matt Mackall wrote:
> [uncrossposting]
> 
> On Fri, 2011-11-11 at 04:09 -0800, Joe Perches wrote:
> > Prior to intrusion, a mercurial repository essentially
> > duplicating the Linus' git tree existed at:
> > http://www.kernel.com/hg/linux-2.6
> > 
> > I do not use it, but are there any plans to restore it?
> 
> Not on kernel.org, certainly.
> 
> I asked the kernel.org admins a while back to send me a copy of the SHA
> map file from my account I needed to continue the mirror elsewhere and
> HPA declined, making some handwaving towards "eventually letting people
> download tarballs of their old accounts".
> 
> As far as I know, "eventually" hasn't happened yet. I guess it's time to
> fire up a new mirror from scratch. It'll be incompatible with old clones
> due to not having the above file and various minor changes in both git
> and hg in the 6 years the original mirror was running. I'll announce it
> when it's done - it'll probably take a while.

No worries.  I'm not an hg user.  Ian Campbell sent a patch
to get_maintainer to use git log option --follow for a largish
file rename event in drivers/net/... and I was trying to get
the hg commands in get_maintainer to do the same.

Any idea if tracking file renames in hg needs an additional
command line option and if so what it is?

