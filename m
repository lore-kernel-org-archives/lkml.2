Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab2AZLR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:17:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40524 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab2AZLR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:17:27 -0500
Date: Thu, 26 Jan 2012 12:16:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        David Daney <david.daney@cavium.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Beulich <jbeulich@suse.com>, Joerg Roedel <joerg.roedel@amd.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: Re: [GIT PULL 0/9] perf/core improvements and fixes
Message-ID: <20120126111648.GH3853@elte.hu>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327446481-5505-1-git-send-email-acme@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Hi Ingo,
> 
> 	This is a signed tag, please lemme know if everything went well.
> 
> 	The --uid feature works for root, we still need to 
> sort out that paranoia with some threads owned by a user that 
> prevents 'perf --uid non-root-user' to work for 
> 'non-root-user'.

Just wondering what detail causes that failure - the whole point 
of --uid mingo would be to enable nonprivileged users to do 
'session wide' profiling, *especially* if paranoia is high.

So what does --uid do which perf record --pid 1234 wouldnt 
already do? By all means --uid ought to be a fancy way of doing 
a whole bunch of perf record --pid 1234 profiling sessions, at 
once.

[ Btw, we should probably alias --user to --uid as well, as that 
  might be the intuitive thing people would typically use? ]

> 	http://git.kernel.org/?p=linux/kernel/git/acme/linux.git;a=tag;h=ce9600c4c664ce7f97e8aa5e756b0b4ea5b017c7
> looks ok to me, need just to improve on the commit log message, I'll get
> used to it :-)
> 
> - Arnaldo
> 
> The following changes since commit 172d1b0b73256551f100fc00c69e356d047103f5:
> 
>   perf tools: Fix compile error on x86_64 Ubuntu (2012-01-08 13:34:55 -0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf-core-for-mingo
> 
> for you to fetch changes up to f8f4b2872295dca88339ec0c403b2217b1197353:
> 
>   perf tools: Fix strlen() bug in perf_event__synthesize_event_type() (2012-01-24 20:31:34 -0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes
> 
> ----------------------------------------------------------------

Anyway, pulled, thanks a lot Arnaldo!

One detail: don't we want some of these fixes cherry-picked into 
perf/urgent as well?

Thanks,

	Ingo
