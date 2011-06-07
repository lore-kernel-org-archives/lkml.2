Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab1FGU7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:59:38 -0400
Received: from waste.org ([173.11.57.241]:45246 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273Ab1FGU7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:59:37 -0400
Subject: Re: ketchup script and 3.0
From: Matt Mackall <mpm@selenic.com>
To: david@lang.hm
Cc: Stratos Psomadakis <psomas@ece.ntua.gr>, linux-kernel@vger.kernel.org,
        Frank Kingswood <frank@kingswood-consulting.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1106071349000.28905@asgard.lang.hm>
References: <4DEDD5F4.1070602@kingswood-consulting.co.uk>
	 <1307451186.4204.953.camel@calx>  <4DEE808D.6020405@ece.ntua.gr>
	 <1307477435.4204.968.camel@calx>  <4DEE8AD9.3050508@ece.ntua.gr>
	 <1307479572.4204.977.camel@calx>
	 <alpine.DEB.2.02.1106071349000.28905@asgard.lang.hm>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 15:59:32 -0500
Message-ID: <1307480372.4204.987.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 13:50 -0700, david@lang.hm wrote:
> On Tue, 7 Jun 2011, Matt Mackall wrote:
> 
> > But my point is that if we have adhoc transitions, we will encounter the
> > "fix all the scripts and websites" pain at every transition. And tools
> > that are managed via distros and the like can literally take years to
> > get into the hands of users. It'd be nice if the copy of ketchup shipped
> > in <enterprise distro> just worked 3 years from now because 4.0 wasn't a
> > surprise.
> 
> if you special case 2.4->2.6, and make the default that 4.0 > 3.x, 5.0 > 
> 4.x, etc won't things 'just work' for the forseeable future?

No, because you sometimes want to know what 2.6.39++ is and what 3.0--
is.

For instance, to upgrade from 2.6.37.2 to 3.1.2, ketchup will want to
download, cache, and apply:

patch-2.6.37.2 (reversed!)
patch-2.6.38
patch-2.6.39
patch-3.0 ?? <- hopefully Linus will make a delta against 2.6.39!
patch-3.1
patch-3.1.2


-- 
Mathematics is the supreme nostalgia of our time.


