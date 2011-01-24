Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1AXUOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:14:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1AXUOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:14:43 -0500
Date: Mon, 24 Jan 2011 18:14:20 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20110124201420.GB29975@ghostprotocols.net>
References: <20110124133400.GA1228@elte.hu> <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 25, 2011 at 05:48:01AM +1000, Linus Torvalds escreveu:
> On Mon, Jan 24, 2011 at 11:34 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Please pull the latest perf-fixes-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus
> 
> I'm not sure if this was true before too, but when I do
> 
>     perf report -agf sleep 10
> 
> while compiling the kernel to get a system profile on x86-32, the
> resulting pef.data file will cause "perf report" to just hang.
> 
> Is it just me?

s/report/record/ :-)

I'm building perf/urgent tooling then kernel on my Acer netbook with a:

model name	: Intel(R) Atom(TM) CPU N270   @ 1.60GHz

To check. It now has 2.6.38-rc1 with my perf/core branch tool/kernel
combo, where I couldn't reproduce the problem.

- Arnaldo
