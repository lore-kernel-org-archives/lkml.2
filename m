Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2C0FOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 01:14:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36791 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753052Ab2C0FOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 01:14:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+bS3Ep7XWba2A/4v7lDHrGIcRQq0NvAnTJ3PTNhF
	Tq2CXBCCoYhEhk
Message-ID: <1332825236.7411.54.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] BFS CPU scheduler version 0.420 AKA "Smoking" for
 linux kernel 3.3.0
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Valdis.Kletnieks@vt.edu, Gene Heskett <gene.heskett@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 27 Mar 2012 07:13:56 +0200
In-Reply-To: <CABqErrGaBLisO4YK5dP2O9Pv0QonZ+q9G43jm=Nf12yWVGv6tw@mail.gmail.com>
References: <CABqErrHS6C6RVMKChaPGACoaWoXCKf+6dS5KFrWG04+DnZO6Dw@mail.gmail.com>
	 <201203240553.32526.gene.heskett@gmail.com>
	 <57375.1332641134@turing-police.cc.vt.edu>
	 <1332682650.9154.111.camel@marge.simpson.net>
	 <CABqErrGaBLisO4YK5dP2O9Pv0QonZ+q9G43jm=Nf12yWVGv6tw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 09:30 +1100, Con Kolivas wrote: 
> On 26 March 2012 00:37, Mike Galbraith <efault@gmx.de> wrote:
> > Yeah.  In all the interactivity testing I've ever done, it's really hard
> > to not see what you expect and/or hope to see.  For normal desktop use,
> > I don't see any real difference with BFS vs CFS unless I load test of
> > course, and that can go either way, depending on the load.
> >
> > Example:
> >
> > 3.3.0-bfs vs 3.3.0-cfs - identical config
> >
> > Q6600 desktop box doing a measured interactivity test.
> >
> > time mplayer BigBuckBunny-DivXPlusHD.mkv, with massive_intr 8 as competition
> >
> > no bg load real    9m56.627s              1.000
> > CFS        real    9m59.199s              1.004
> > BFS        real    12m8.166s              1.220
> >
> > As you can see, neither scheduler can run that perfectly on my box, as
> > the load needs a tad more than its fair share.  However, the Interactive
> > Experience was far better in CFS in this case due to it being more fair.
> > In BFS, the interactive tasks (mplayer/Xorg) could not get their fair
> > share, causing interactivity to measurably suffer.
> 
> massive_intr runs a number of threads that each run for 8ms and then
> sleep for 1ms. That means they are 89% cpu bound. Run 8 of them and
> your CPU load is 88.8 * 8 = 7.1. So now you're testing a difficult
> mplayer benchmark in the presence of a load of 7.1 on a CPU with 4
> cores. I don't know how much CPU the playback of your particular video
> is but I suspect it does require a fair amount of CPU based on the CPU
> it got back in your test. I can virtually guarantee that the amount of
> CPU BFS is giving to mplayer is proportional to how much CPU is left.
> Ergo as far as I can see, BFS is likely being absolutely perfectly
> fair. This sort of fairness equation has been already elucidated in
> the pHD that I linked to in my original post and he has done a much
> more thorough analysis than this kind of drive-by test that you're
> doing and misinterpreting has already shown that BFS is fair to a
> fault.
> 
> snip the rest
> 
> 'top' snapshots are uninteresting because CFS and BFS report cpu time
> completely differently and a single snapshot tells us nothing.
> 
> Snip uninteresting-to-desktop-user throughput benchmarks.

You accuse others of disinterest in their dirty underwear, and wave away
the wide skid marks in your own with a flick of the wrist.  Amazing.

-Mike

