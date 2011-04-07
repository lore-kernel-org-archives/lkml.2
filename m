Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab1DGNwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:52:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:56666 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751646Ab1DGNwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:52:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+qUKFFqjqqXAL/qTinEzBB1+wjmrS7WarfPral6/
	znnSKwi9t3SKMQ
Subject: Re: [PATCH 00/23] sched: Rewrite sched_domain/sched_group creation
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <20110407120941.400629539@chello.nl>
References: <20110407120941.400629539@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 15:51:54 +0200
Message-ID: <1302184314.8065.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-07 at 14:09 +0200, Peter Zijlstra wrote:
> This series rewrite the sched_domain and sched_group creation code.
> 
> While its still not completely finished it does get us a lot of cleanups
> and code reduction and seems fairly stable at this point and should thus
> be a fairly good base to continue from.

Looks and sounds like good plan to me.

> Also available through:
>   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-sched.git sched_domain
> 
> ---
>  include/linux/sched.h |   26 +-
>  kernel/cpuset.c       |    2 +-
>  kernel/sched.c        |  963 +++++++++++++++----------------------------------
>  kernel/sched_fair.c   |   32 ++-
>  4 files changed, 326 insertions(+), 697 deletions(-)

We could use a few more diffstats like this one :)

	-Mike


