Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab2JFD2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 23:28:21 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:65224 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2JFD2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 23:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM31R+mT+g0qTGOVgC1QYJk3Ju-u06UpkBwx-4tHxeh89kD3w@mail.gmail.com>
References: <CAPM31R+mT+g0qTGOVgC1QYJk3Ju-u06UpkBwx-4tHxeh89kD3w@mail.gmail.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 5 Oct 2012 20:27:48 -0700
Message-ID: <CAPM31RLKEZ0xzPXYQc-pMGUesfkviQ5i0LZaJipWC8oY=J5-kg@mail.gmail.com>
Subject: Re: sched: per-entity load-tracking
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've rebased this to tip/master and pushed some minor updates (most
notable: rounding down in decay_load).

Tree is at:
    http://git.kernel.org/?p=linux/kernel/git/pjt/sched.git;a=summary
(branch: load-tracking)

If you prefer raw patches there's a quilt series at:
  http://rs5.risingnet.net/~pjt/patches/load_tracking/

And a tar-ball at:
  http://rs5.risingnet.net/~pjt/patches/load_tracking/series.tar.gz

Peter:
The rebase to tip/master made interdiff angry enough that it wasn't
producing the right relative diffs for your stack.  Sorry :(

- Paul
On Fri, Sep 21, 2012 at 1:52 PM, Paul Turner <pjt@google.com> wrote:
> Hi all,
>
> I've refreshed the load-tracking branch at:
>     http://git.kernel.org/?p=linux/kernel/git/pjt/sched.git;a=summary
> With the latest rebased version.  Similar I've got a quilt export
> below to make it easier for people to patch in.
>
> If you prefer raw patches there's a quilt series at:
>   http://rs5.risingnet.net/~pjt/patches/load_tracking/
>
> And a tar-ball at:
>   http://rs5.risingnet.net/~pjt/patches/load_tracking/series.tar.gz
>
> There are no functional differences from the version posted at:
>   https://lkml.org/lkml/2012/8/23/267
> So I won't bother posting the series again here.  If you have find
> errors, please post them there and I'll do another round.
>
> Similarly, if you previously pulled from my git tree above; the only
> difference is that it's been re-written to current tip head, and that
> the generator for the fixed-point math constants have been added to
> the changelogs.
>
> Thanks!
>
> - Paul
