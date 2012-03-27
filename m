Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2C0QQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:16:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab2C0QQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:16:32 -0400
Date: Tue, 27 Mar 2012 18:15:40 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dan Smith <danms@us.ibm.com>, Paul Turner <pjt@google.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>, Bharata B Rao <bharata.rao@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/39] autonuma: CPU follow memory algorithm
Message-ID: <20120327161540.GS5906@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
 <1332783986-24195-12-git-send-email-aarcange@redhat.com>
 <1332786353.16159.173.camel@twins>
 <4F70C365.8020009@redhat.com>
 <20120326194435.GW5906@redhat.com>
 <CA+55aFwk0Etg_UhoZcKsfFJ7PQNLdQ58xxXiwcA-jemuXdZCZQ@mail.gmail.com>
 <20120326203951.GZ5906@redhat.com>
 <1332837595.16159.208.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332837595.16159.208.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 10:39:55AM +0200, Peter Zijlstra wrote:
> I am most certainly not going to fix your mess as I completely disagree
> with the approach taken.

This is _purely_ a performance optimization so if my design is so bad,
and you're also requiring all apps that spans over more than one NUMA
node to be modified to use your new syscalls, you won't have problems
to win against AutoNUMA in the benchmarks.

At the moment I can't believe your design has a chance to compete.

But please proof me wrong with the numbers, and I won't be stubborn
and I'll rm -r autonuma and (if you let me), I'll be happy to contribute
to your code.

> You're in fact very unclear. You post patches without the RFC tag,

Subject: [PATCH 00/39] [RFC] AutoNUMA alpha10
