Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab2F2Stw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:49:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:37270 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab2F2Stu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:49:50 -0400
Message-ID: <1340995742.28750.110.camel@twins>
Subject: Re: [PATCH 13/40] autonuma: CPU follow memory algorithm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: dlaor@redhat.com
Cc: Ingo Molnar <mingo@kernel.org>, Hillf Danton <dhillf@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 29 Jun 2012 20:49:02 +0200
In-Reply-To: <4FEDDD0C.60609@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
	 <1340888180-15355-14-git-send-email-aarcange@redhat.com>
	 <1340895238.28750.49.camel@twins>
	 <CAJd=RBA+FPgB9iq07YG0Pd=tN65SGK1ifmj98tomBDbYeKOE-Q@mail.gmail.com>
	 <20120629125517.GD32637@gmail.com> <4FEDDD0C.60609@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-29 at 12:51 -0400, Dor Laor wrote:
> AFAIK, Andrea answered many of Peter's request by reducing the memory 
> overhead, adding documentation and changing the scheduler integration.
> 
He ignored even more. Getting him to change anything is like pulling
teeth. I'm well tired of it. Take for instance this kthread_bind_node()
nonsense, I've said from the very beginning that wasn't good. Nor is it
required, yet he persists in including it.

The thing is, I would very much like to talk about the design of this
thing, but there's just nothing coming. Yes Andrea wrote a lot of words,
but they didn't explain anything much at all.

And while I have a fair idea of what and how its working, I still miss a
number of critical fundamentals of the whole approach.

And yes I'm tired and I'm cranky.. but wouldn't you be if you'd spend
days poring over dense and ill documented code, giving comments only to
have your feedback dismissed and ignored.


