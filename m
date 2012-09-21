Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab2IUUxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:53:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35399 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab2IUUxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:53:20 -0400
MIME-Version: 1.0
From: Paul Turner <pjt@google.com>
Date: Fri, 21 Sep 2012 13:52:49 -0700
Message-ID: <CAPM31R+mT+g0qTGOVgC1QYJk3Ju-u06UpkBwx-4tHxeh89kD3w@mail.gmail.com>
Subject: sched: per-entity load-tracking
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

Hi all,

I've refreshed the load-tracking branch at:
    http://git.kernel.org/?p=linux/kernel/git/pjt/sched.git;a=summary
With the latest rebased version.  Similar I've got a quilt export
below to make it easier for people to patch in.

If you prefer raw patches there's a quilt series at:
  http://rs5.risingnet.net/~pjt/patches/load_tracking/

And a tar-ball at:
  http://rs5.risingnet.net/~pjt/patches/load_tracking/series.tar.gz

There are no functional differences from the version posted at:
  https://lkml.org/lkml/2012/8/23/267
So I won't bother posting the series again here.  If you have find
errors, please post them there and I'll do another round.

Similarly, if you previously pulled from my git tree above; the only
difference is that it's been re-written to current tip head, and that
the generator for the fixed-point math constants have been added to
the changelogs.

Thanks!

- Paul
