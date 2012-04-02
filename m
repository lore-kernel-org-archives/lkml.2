Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab2DBQe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:34:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52624 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2DBQe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:34:56 -0400
MIME-Version: 1.0
In-Reply-To: <4F69022D.3080300@redhat.com>
References: <20120316144028.036474157@chello.nl>
	<4F670325.7080700@redhat.com>
	<1332155527.18960.292.camel@twins>
	<20120319130401.GI24602@redhat.com>
	<1332163591.18960.334.camel@twins>
	<20120319135745.GL24602@redhat.com>
	<4F673D73.90106@redhat.com>
	<20120319143002.GQ24602@redhat.com>
	<1332182523.18960.372.camel@twins>
	<4F69022D.3080300@redhat.com>
Date: Mon, 2 Apr 2012 19:34:54 +0300
X-Google-Sender-Auth: zjawQxUioVN8e9wGKA3KF2yd0ls
Message-ID: <CAOJsxLHPc7QxdsUADikgeqQo7WVCzUD1KoHRT7Ngr7xXM_F7ig@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/26] sched/numa
From: Pekka Enberg <penberg@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 12:18 AM, Rik van Riel <riel@redhat.com> wrote:
> I suspect Java and other runtimes may have issues where
> they simply do not know which thread will end up using
> which objects from the heap heavily.

What kind of JVM workloads are you thinking of? Modern GCs use
thread-local allocation for performance reasons so I'd assume that
most of accesses are on local node.
