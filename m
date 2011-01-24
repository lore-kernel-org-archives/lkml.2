Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab1AXUIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:08:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38844 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab1AXUH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:07:59 -0500
Date: Mon, 24 Jan 2011 21:07:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20110124200738.GA10833@elte.hu>
References: <20110124133400.GA1228@elte.hu>
 <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jan 24, 2011 at 11:34 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Please pull the latest perf-fixes-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus
> 
> I'm not sure if this was true before too, but when I do
> 
>     perf report -agf sleep 10

(that's perf record i guess?)

> 
> while compiling the kernel to get a system profile on x86-32, the
> resulting pef.data file will cause "perf report" to just hang.
> 
> Is it just me?

We used to have such bugs recently so i'm quite sure what you see is real.

The above test is almost the same what i did before sending you the pull request, so 
it's not occuring all the time and on all boxes.

The distro version on that box you are using would be helpful, plus the build output 
you get when you build 'tools/perf'. (I.e. which libraries are there. If it comes up 
empty with no complaints you have all the devel libraries.)

We'll try to reproduce it locally before asking more debug data from you, 
perf.data's can be pretty large to send via email :)

Thanks,

	Ingo
