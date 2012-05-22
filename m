Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017Ab2EVPAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:00:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57278 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987Ab2EVPAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:00:50 -0400
Message-ID: <1337698830.9698.37.camel@twins>
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Date: Tue, 22 May 2012 17:00:30 +0200
In-Reply-To: <1337688268.9698.29.camel@twins>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	 <alpine.DEB.2.00.1205191922250.24674@chino.kir.corp.google.com>
	 <20120521084046.GB31407@gmail.com>
	 <alpine.DEB.2.00.1205211914100.13682@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1205211932350.13682@chino.kir.corp.google.com>
	 <1337688268.9698.29.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 14:04 +0200, Peter Zijlstra wrote:
> The below appears to contain a bug, not sure its the one you're
> triggering, but who knows. Lemme stare more. 

OK, nevermind that patch (not that it isn't a good one), but I've found
the problem. build_overlap_sched_groups() is crummy.. just no idea how
to go about fixing it quite yet though.

/me goes kick his gray cells some more.
