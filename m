Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab1BPOaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:30:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59585 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab1BPOa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:30:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 16 Feb 2011 15:29:06 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, gregkh@suse.de,
        srostedt <srostedt@redhat.com>, a.p.zijlstra@chello.nl,
        ghaskins@novell.com, stable@kernel.org, stable-commits@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Patch "sched: Give CPU bound RT tasks preference" has been
 added to the 2.6.32-longterm tree
Message-ID: <20110216152906.75d4000c@stein>
In-Reply-To: <1297849553.5275.29.camel@marge.simson.net>
References: <12978046423644@kroah.org>
	<1297810967.23343.122.camel@gandalf.stny.rr.com>
	<1297821667.5126.11.camel@marge.simson.net>
	<20110216082559.GA16529@elte.hu>
	<4D5B90E8.6080605@gmail.com>
	<1297849553.5275.29.camel@marge.simson.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16 Mike Galbraith wrote:
> On Wed, 2011-02-16 at 09:55 +0100, Jiri Slaby wrote:
> > On 02/16/2011 09:25 AM, Ingo Molnar wrote:
> > > We try to concentrate on regression fixes though.
> > 
> > Hi, I cannot fully agree with this. The question is who are "we" here?
> > If every packager using this stable tree is forced by users/customers to
> > take it anyway, it's better to have it in stable.
> > 
> > It has several reasons:
> > * It will have an eye of experts on them. Not that at distro providers
> > there are no experts, but the authors who are cced here know definitely
> > the code better.
> > * Not every packager has to duplicate others work.
> > * The stable tree changes constantly. Managing hundreds of patches
> > applied to a stable tree before kernels are being packaged is thus
> > sometimes a hell. Reducing this number is a good thing(TM).
> 
> Fully agree on all fronts, but it's a hard call.  When I start auditing,
> I sweat bullets.  I see piles of bug fixes, and piles of performance
> enhancements, all of which are ever so tempting, all of which are worthy
> of backport.. but humans _are_ buggy, so there is risk involved.

Jiri,
if the desire is to improve performance of existing features (and maybe
add this and that little feature that looks attractive), while at the same
time you want
  - experts to have looked at these improvements,
  - packagers to avoid duplicate work,
  - keep the number of local patches in check,
then the solution is to /stay close enough to the mainline/.

Unstable -longterm trees (unstable as in having a high rate of changes,
possibly as in having frequent regressions) are for sure an alternative
solution that those who use these trees apparently do consider.  But if
regressions avoidance is not their top priority, what other reason do they
have to follow -longterm instead of the mainline?

(Says a mainline user, and a driver maintainer who has pushed his share of
occasional regressions to -stable branches but hopes to constantly get
better at regression avoidance.)
-- 
Stefan Richter
-=====-==-== --=- =----
http://arcgraph.de/sr/
