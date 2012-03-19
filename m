Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab2CSSmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 14:42:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33774 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab2CSSmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 14:42:33 -0400
Message-ID: <1332182523.18960.372.camel@twins>
Subject: Re: [RFC][PATCH 00/26] sched/numa
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>,
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 19 Mar 2012 19:42:03 +0100
In-Reply-To: <20120319143002.GQ24602@redhat.com>
References: <20120316144028.036474157@chello.nl>
	 <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins>
	 <20120319130401.GI24602@redhat.com> <1332163591.18960.334.camel@twins>
	 <20120319135745.GL24602@redhat.com> <4F673D73.90106@redhat.com>
	 <20120319143002.GQ24602@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 15:30 +0100, Andrea Arcangeli wrote:

> I agree for qemu those soft bindings are fine.

So for what exact program(s) are you working? Your solution seems purely
focused on the hard case of a multi-threaded application that's larger
than a single node.

While I'm sure such applications exist, how realistic is it that they're
the majority?

> But how you compute the statistical data is most difficult part, how
> you collect them not so important after all.

> When you focus only on the cost of collecting the information and no
> actual discussion was spent yet on how to compute or react to it,
> something's wrong... as that's the really interesting part of the code.

Yeah, the thing that's wrong is you dumping a ~2300 line patch of dense
code over the wall without any high-level explanation.

I just about got to the policy parts but its not like its easy reading.

Also, you giving clues but not really saying what you mean attitude
combined with your tendency to write books instead of emails isn't
really conductive to me wanting to ask for any explanation either.
