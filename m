Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab1FHQWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:22:19 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33220 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab1FHQWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:22:17 -0400
Date: Wed, 8 Jun 2011 18:21:52 +0200
From: Florian Mickler <florian@mickler.org>
To: Stratos Psomadakis <psomas@ece.ntua.gr>
Cc: Matt Mackall <mpm@selenic.com>, david@lang.hm,
        linux-kernel@vger.kernel.org,
        Frank Kingswood <frank@kingswood-consulting.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ketchup script and 3.0
Message-ID: <20110608182152.0cbbc74c@schatten.dmk.lab>
In-Reply-To: <4DEE9695.7060805@ece.ntua.gr>
References: <4DEDD5F4.1070602@kingswood-consulting.co.uk>
	<1307451186.4204.953.camel@calx>
	<4DEE808D.6020405@ece.ntua.gr>
	<1307477435.4204.968.camel@calx>
	<4DEE8AD9.3050508@ece.ntua.gr>
	<1307479572.4204.977.camel@calx>
	<alpine.DEB.2.02.1106071349000.28905@asgard.lang.hm>
	<1307480372.4204.987.camel@calx>
	<4DEE9695.7060805@ece.ntua.gr>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jun 2011 00:22:29 +0300
Stratos Psomadakis <psomas@ece.ntua.gr> wrote:

> On 06/07/2011 11:59 PM, Matt Mackall wrote:
> > On Tue, 2011-06-07 at 13:50 -0700, david@lang.hm wrote:
> >> On Tue, 7 Jun 2011, Matt Mackall wrote:
> >>
> >>> But my point is that if we have adhoc transitions, we will encounter the
> >>> "fix all the scripts and websites" pain at every transition. And tools
> >>> that are managed via distros and the like can literally take years to
> >>> get into the hands of users. It'd be nice if the copy of ketchup shipped
> >>> in <enterprise distro> just worked 3 years from now because 4.0 wasn't a
> >>> surprise.
> >> if you special case 2.4->2.6, and make the default that 4.0 > 3.x, 5.0 > 
> >> 4.x, etc won't things 'just work' for the forseeable future?
> > No, because you sometimes want to know what 2.6.39++ is and what 3.0--
> > is.
> >
> > For instance, to upgrade from 2.6.37.2 to 3.1.2, ketchup will want to
> > download, cache, and apply:
> >
> > patch-2.6.37.2 (reversed!)
> > patch-2.6.38
> > patch-2.6.39
> > patch-3.0 ?? <- hopefully Linus will make a delta against 2.6.39!
> > patch-3.1
> > patch-3.1.2
> Well, if this is a ketchup-only issue (and there's no other need for
> defining at which point major numbers are going to inc), we could find a
> solution/workaround (to future-proof it, without the need of constant
> updating of the code with every major release), but it'll probably be
> uglier, and I think that what Matt proposed is better.
> 
> Anyway, when this issue is clarified, I'll try to fix the code, in order
> to handle next major releases, without requiring code changes.
> 
> Thanks,
> 

Well, what I would do is to somehow get kernel.org to generate a
tag-list from git, append '-release' to the tag names which do not end
in '-rc[0-9]+' and then sort this list alphanumerical and just let
that be the first thing ketchup downloads. 

Regards,
Flo
