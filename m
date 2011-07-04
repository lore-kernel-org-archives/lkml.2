Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab1GDMsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 08:48:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35447 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab1GDMsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 08:48:51 -0400
Date: Mon, 4 Jul 2011 14:48:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile updates for v3.1
Message-ID: <20110704124839.GB25978@elte.hu>
References: <20110704102344.GW4590@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704102344.GW4590@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Ingo,
> 
> please pull oprofile updates for v3.1 (tip/perf/core):
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> Thanks,
> 
> -Robert
> 
> 
> The following changes since commit 29dfc4fd7e792854b30d771d4e299fbdd2adb763:
> 
>   perf, powerpc: Fix build borkage (2011-07-01 16:20:04 +0200)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> Daniel Kalmar (2):
>       MIPS: Add new unwind_stack variant
>       MIPS: oprofile: Add callgraph support
> 
> Robert Richter (3):
>       oprofile, x86: Fix race in nmi handler while starting counters
>       oprofile, x86: Fix nmi-unsafe callgraph support
>       Merge branch 'oprofile/urgent' into HEAD
> 
>  arch/mips/include/asm/stacktrace.h |    4 +
>  arch/mips/kernel/process.c         |   19 +++-
>  arch/mips/oprofile/Makefile        |    2 +-
>  arch/mips/oprofile/backtrace.c     |  175 ++++++++++++++++++++++++++++++++++++
>  arch/mips/oprofile/common.c        |    1 +
>  arch/mips/oprofile/op_impl.h       |    2 +
>  arch/x86/oprofile/backtrace.c      |   56 ++++++++++--
>  arch/x86/oprofile/nmi_int.c        |   14 ++-
>  8 files changed, 254 insertions(+), 19 deletions(-)
>  create mode 100644 arch/mips/oprofile/backtrace.c

Pulled, thanks Robert!

	Ingo
