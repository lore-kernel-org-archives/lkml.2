Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1BQFFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 00:05:16 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:36742 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750780Ab1BQFFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 00:05:13 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+qza0qnYqqpRpc6+OUa9WlqB4Qw72NHPTjrMWWkz
	kgawyqsVv2YbWB
Subject: Re: Patch "sched: Give CPU bound RT tasks preference" has been
 added to the 2.6.32-longterm tree
From: Mike Galbraith <efault@gmx.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, gregkh@suse.de,
        srostedt <srostedt@redhat.com>, a.p.zijlstra@chello.nl,
        ghaskins@novell.com, stable@kernel.org, stable-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110216152906.75d4000c@stein>
References: <12978046423644@kroah.org>
	 <1297810967.23343.122.camel@gandalf.stny.rr.com>
	 <1297821667.5126.11.camel@marge.simson.net>
	 <20110216082559.GA16529@elte.hu> <4D5B90E8.6080605@gmail.com>
	 <1297849553.5275.29.camel@marge.simson.net> <20110216152906.75d4000c@stein>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 06:05:07 +0100
Message-ID: <1297919107.6361.59.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 15:29 +0100, Stefan Richter wrote:
> On Feb 16 Mike Galbraith wrote:
> > On Wed, 2011-02-16 at 09:55 +0100, Jiri Slaby wrote:
> > > On 02/16/2011 09:25 AM, Ingo Molnar wrote:
> > > > We try to concentrate on regression fixes though.
> > > 
> > > Hi, I cannot fully agree with this. The question is who are "we" here?
> > > If every packager using this stable tree is forced by users/customers to
> > > take it anyway, it's better to have it in stable.
> > > 
> > > It has several reasons:
> > > * It will have an eye of experts on them. Not that at distro providers
> > > there are no experts, but the authors who are cced here know definitely
> > > the code better.
> > > * Not every packager has to duplicate others work.
> > > * The stable tree changes constantly. Managing hundreds of patches
> > > applied to a stable tree before kernels are being packaged is thus
> > > sometimes a hell. Reducing this number is a good thing(TM).
> > 
> > Fully agree on all fronts, but it's a hard call.  When I start auditing,
> > I sweat bullets.  I see piles of bug fixes, and piles of performance
> > enhancements, all of which are ever so tempting, all of which are worthy
> > of backport.. but humans _are_ buggy, so there is risk involved.
> 
> Jiri,
> if the desire is to improve performance of existing features (and maybe
> add this and that little feature that looks attractive), while at the same
> time you want
>   - experts to have looked at these improvements,
>   - packagers to avoid duplicate work,
>   - keep the number of local patches in check,
> then the solution is to /stay close enough to the mainline/.

That's the intent of pushing more than _purely_ critical bugfixes, get a
bit closer.  Enterprise can't move as fast as mainline, not even close,
that's a given.  Stable problem get griped about though, so there's no
choice but to take some risk.  The tricky bit is how much, and how you
go about it.

People are fixing this and that in their enterprise kernels privately
every day.  The only difference between that, and pushing baked fixes
back is that pushing to stable is visible.  I strongly suspect that
there are just tons of mainline backports sitting in each and every
enterprise tree in existence.  They could have been pushed to stable,
with _less_ stability risk, due to the higher visibility.

Just my opinion.  Oh, and critical eye is definitely good, that's why I
posted to stable after all ;-)

	-Mike

