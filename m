Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab0DWJMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 05:12:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48267 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab0DWJM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 05:12:29 -0400
Date: Fri, 23 Apr 2010 11:11:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Perf probe support for PowerPC, from Ian Munsie
Message-ID: <20100423091158.GA6078@elte.hu>
References: <20100423003251.GA2420@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423003251.GA2420@brick.ozlabs.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo,
> 
> Please pull my perf.git master branch:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perf.git master
> 
> It has two commits from Ian Munsie that allow us to access local
> variables with perf probe on PowerPC.  We also need a commit in Ben's
> powerpc-next branch for it to function, but it compiles without that.
> 
> Thanks,
> Paul.
> 
> ---
> 
> The following changes since commit 6eca8cc35b50af1037bc919106dd6dd332c959c2:
>   Frederic Weisbecker (1):
>         perf: Fix perf probe build error
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perf.git master
> 
> Ian Munsie (2):
>       perf: Move arch specific code into separate arch directory
>       perf probe: Add PowerPC DWARF register number mappings
> 
>  tools/perf/Makefile                       |   36 ++++++++++--
>  tools/perf/arch/powerpc/Makefile          |    4 +
>  tools/perf/arch/powerpc/util/dwarf-regs.c |   88 +++++++++++++++++++++++++++++
>  tools/perf/arch/x86/Makefile              |    4 +
>  tools/perf/arch/x86/util/dwarf-regs.c     |   75 ++++++++++++++++++++++++
>  tools/perf/util/include/dwarf-regs.h      |    8 +++
>  tools/perf/util/probe-finder.c            |   55 +-----------------
>  7 files changed, 211 insertions(+), 59 deletions(-)
>  create mode 100644 tools/perf/arch/powerpc/Makefile
>  create mode 100644 tools/perf/arch/powerpc/util/dwarf-regs.c
>  create mode 100644 tools/perf/arch/x86/Makefile
>  create mode 100644 tools/perf/arch/x86/util/dwarf-regs.c
>  create mode 100644 tools/perf/util/include/dwarf-regs.h

Pulled, thanks a lot Paul!

	Ingo
