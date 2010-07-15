Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab0GOQZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:25:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39376 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933694Ab0GOQZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:25:48 -0400
Date: Thu, 15 Jul 2010 18:25:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ian Munsie <imunsie@au.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Matt Fleming <matt@console-pimps.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL 0/1] perf/core improvements
Message-ID: <20100715162535.GB5533@elte.hu>
References: <1279153761-18169-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279153761-18169-1-git-send-email-acme@infradead.org>
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


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
>         Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> Regards,
> 
> - Arnaldo
> 
> Matt Fleming (1):
>   perf tools: Add DWARF register lookup for SH
> 
>  tools/perf/arch/sh/Makefile          |    4 ++
>  tools/perf/arch/sh/util/dwarf-regs.c |   55 ++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+), 0 deletions(-)
>  create mode 100644 tools/perf/arch/sh/Makefile
>  create mode 100644 tools/perf/arch/sh/util/dwarf-regs.c

Pulled, thanks!

	Ingo
