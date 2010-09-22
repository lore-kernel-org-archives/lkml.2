Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab0IVCle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 22:41:34 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:34361 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab0IVCld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 22:41:33 -0400
Date: Wed, 22 Sep 2010 12:41:25 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: Matt Turner <mattst88@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
In-Reply-To: <4C98D8AA.80606@gmail.com>
Message-ID: <alpine.LNX.2.00.1009221205330.4570@nippy.intranet>
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com> <AANLkTinE73z9QV0zriVE3bRtzMifWSGvG36hfvnA9biD@mail.gmail.com> <4C983C7D.1050000@gmail.com> <AANLkTimYp6ua743x9ze4fcU09ZZ=oZZd_iKCmU0WQ2h7@mail.gmail.com> <alpine.LNX.2.00.1009211516180.9370@nippy.intranet>
 <4C98D8AA.80606@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Sep 2010, Justin P. Mattock wrote:

> On 09/20/2010 10:17 PM, Finn Thain wrote:
> > 
> > I would say that if a URL is in the web archive, then no patch is needed.
> > 
> > Finn
> > 
> 
> before I go and remove all of the archive.org stuff, can I get some feedback
> from other people as well on having this used? i.e. if keeping the old broken
> link in the kernel, how will people know to go to archive.org or any other
> archive site to read the old info?, as opposed to already having this in there
> so people can just click and go?..
> 
> The idea to use archive.org came from this thread:
> http://amailbox.org/mailarchive/linux-kernel/2010/7/21/4596207/thread
> where there are people still wanting to read the old info.

If people want to read the old links, and they don't know about 
archive.org, then they should. If you've seen one 
"http://web.archive.org/web/*/foo/bar", you've seen them all. So this is 
bloat in some sense.

As the web matures, and more and more information disappears from the web, 
archive.org will become common knowledge (if it isn't already).

Applying your reasoning that "people are still wanting to read the old 
info", a policy to accept patches like:
- http://foo/bar
+ http://web.archive.org/web/*/foo/bar
would imply another continual stream of patches when the domain foo 
changes hands. Then you have to pach,
- http://web.archive.org/web/*/foo/bar
+ http://web.archive.org/web/YYYYMMDDHHMMSS/foo/bar

Then the problem becomes what is the correct YYYYMMMDDHHMMSS? The one 
closest to the datestamp of submission of the patch? Or the datestamp from 
the email that submitted the patch? When these questions arise, it becomes 
a new burden on maintainers to determine the right version of the web page 
in the archive, and whether or not the latest version is the best one.

So both of these (arguably) continuous streams of patches would become a 
burden on maintainers and offer little or no benefit to those reading the 
source code.

The benefit to end users is also dubious, because you're chasing web pages 
that were abandoned, implying low value in the first place.

Though they move from one URL to another, the links that are valuable are 
the web pages that are regularly updated. These are are the links that 
need to be kept up-to-date. And I think your work in that direction is 
valuable.

Thanks.

Finn

> 
> Justin P. Mattock
> 
> 
