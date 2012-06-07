Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2FGQJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:09:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:57573 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2FGQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:09:44 -0400
Date: Thu, 7 Jun 2012 13:09:09 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Avik Sil <avik.sil@linaro.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Sunjin Yang <fan4326@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-perf-users@vger.kernel.org
Subject: Re: [GIT PULL 00/15] perf/urgent fixes
Message-ID: <20120607160909.GA4986@infradead.org>
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
 <20120606065014.GB17808@gmail.com>
 <4FD02567.20505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD02567.20505@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jun 06, 2012 at 09:52:07PM -0600, David Ahern escreveu:
> On 6/6/12 12:50 AM, Ingo Molnar wrote:
> >Those declarations were not so unused on this fresh install of
> >Fedora 17.

> >Luckily, the offending commit was the last one in the series, so
> >I merged your tree at cb7225f, excluding only the buggy commit.

> I see the problem now: I had a stale util/string.h file which was
> removed by e206d556. Local problem (stupidity) as to why. Sorry for
> the noise.

> Arnaldo: please drop the patch.

Thanks for getting to the bottom of it, and strange that I my test
builds didn't catch this (f14 and RHEL6 tho).

I guess its time for me to move this machine to f17 and do the ritual
dance of complaining about gnome3...

- Arnaldo
