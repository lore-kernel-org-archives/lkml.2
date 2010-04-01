Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0DAGRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 02:17:52 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59040 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0DAGRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 02:17:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XtEa360nArHtYvmsvm/KHE2zKbheilv3BdwKyXBUWDInQyTTU4hmp8UjA5Ry9fSmZZ
         6jrmKCuH+DxxmPfKDOuLdacTYV9jZ3TkPTUvvswUUXkQHGqwMEBXuYlkOU6uusS+A7Ya
         Akd6iT+PsRx3BEv+mcwLp5I69AxxMCgADLXBQ=
Date: Thu, 1 Apr 2010 09:17:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL v3] perf fixes
Message-ID: <20100401071742.GB5207@nowhere>
References: <1270007927-6391-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270007927-6391-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 05:58:45AM +0200, Frederic Weisbecker wrote:
> Ingo,
> 
> Please pull the perf/urgent branch that can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	perf/urgent


I have updated the tree. There was a leftover patch for perf/core
inside (not listed here). Also, since you've merged linus tree in
perf/urgent lately, I've zapped my merge commit. Other than that,
the three fixes remain.

Thanks.



> 
> It fixes the conflict against latest linus's tree that raised
> build errors (you can find a merge commit inside).
> 
> I am not yet totally sure about Peter's opinion concerning
> the context switch event that is now captured from the kernel.
> Our latest discussion on the strict exclude_kernel meaning
> seems in favour of this change but I'd prefer to wait for his
> final approval before you pull this.
> 
> (I'm not reposting the alignment fix as it is unchanged)
> 
> Thanks,
> 	Frederic
> ---
> 
> Frederic Weisbecker (2):
>       perf: Correctly align perf event tracing buffer
>       perf: Use hot regs with software sched switch/migrate events
> 
> Jason Wessel (1):
>       x86,kgdb: Always initialize the hw breakpoint attribute
> 
> 
>  arch/x86/kernel/cpu/perf_event.c |    2 --
>  arch/x86/kernel/kgdb.c           |    2 +-
>  include/linux/perf_event.h       |   21 ++++++++++++++-------
>  kernel/perf_event.c              |    4 +---
>  kernel/trace/trace_event_perf.c  |   11 +++++++++--
>  5 files changed, 25 insertions(+), 15 deletions(-)

