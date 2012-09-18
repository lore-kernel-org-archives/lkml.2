Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab2IRXgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:36:15 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:57393 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2IRXgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:36:12 -0400
Date: Tue, 18 Sep 2012 16:35:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [GIT PULL] rcu: idle changes v2
Message-ID: <20120918233509.GP2487@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1347640539-8470-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347640539-8470-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091823-7408-0000-0000-0000089DBFA0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 06:35:37PM +0200, Frederic Weisbecker wrote:
> Paul,
> 
> This is the second version of my rcu/idle-for-v3.7 which rebases
> your rcu/idle to address reviews.
> 
> It has the same modifications than rcu/idle-for-v3.7 plus
> an update of:
> 
> - "rcu: Exit RCU extended QS on user preemption" : update changelog
> and comments after a discussion with Peterz. And compile conditionally
> schedule_user().
> 
> - "x86: Use the new schedule_user API on userspace preemption" : build
> time choose between calling schedule and schedule_user.
> 
> I'm only reposting these two patches.
> 
> The new branch is:
> 
> git://github.com/fweisbec/linux-dynticks.git
> 	rcu/idle-v2-for-v3.7

Pulled, thank you!

I also modified the first patch in the series to remove the exports
based on Josh's patch (7ece55a4: Don't declare trace_*_rcuidle functions
in modules) in -tip.

							Thanx, Paul

