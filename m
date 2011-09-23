Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1IWXcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:32:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52887 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab1IWXci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:32:38 -0400
Date: Fri, 23 Sep 2011 20:31:58 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Darren Hart <dvhart@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric B Munson <emunson@mgebm.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [GIT PULL 00/12] perf tools fixes
Message-ID: <20110923233158.GB8543@ghostprotocols.net>
References: <1316809586-28529-1-git-send-email-acme@infradead.org>
 <CA+55aFwVrvMa1z7P5q0kUN3QAwZzTdL1mhLaF7+etHYQm511vA@mail.gmail.com>
 <CA+55aFysPyDCjs3MTwHBRWVq5OTU=-aWCRiJP=VZL-EdCGNU0w@mail.gmail.com>
 <20110923211158.GC27519@ghostprotocols.net>
 <20110923212523.GD27519@ghostprotocols.net>
 <CA+55aFwfobHqXYJbKZTn_6Z_wEhqHxpZO4rRMgOUtJW=L5pzYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwfobHqXYJbKZTn_6Z_wEhqHxpZO4rRMgOUtJW=L5pzYg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 23, 2011 at 04:12:54PM -0700, Linus Torvalds escreveu:
> On Fri, Sep 23, 2011 at 2:25 PM, Arnaldo Carvalho de Melo
> <acme@infradead.org> wrote:
> >
> > Sorry about the noise, there is a problem in the way the python binding
> > is built, i.e. it should notice that the header changed and rebuild the
> > python binding, I bet this was what made David not notice it :-\
> 
> Can you please make sure that gets fixed at some point too? No huge
> hurry, it can wait for the next merge window, but bugs like that not
> only cause this kind of stupid compile errors, they also cause really
> odd "why doesn't it work" problems that people can spend tons and tons
> of time debugging, because they don't really "exist" - they're just a
> result of a stale object file that didn't get properly recompiled.

At the top of the fix-it todo-list, not only because it annoys you, but
also because it annoys the hell out of me :-\
 
> > You noticed it probably because it was the first build of the tool on
> > your local repo or used a new O= output dir.
> 
> I do "git clean -dqfx" every once in a while (especially after having
> done "make allmodconfig" builds before -rc releases etc), and I don't
> recompile the perf tools very often. So yeah, this was the first build
> after a cleanout event.

I'll get it fixed if none of the make guys out there do me this favor.
:-\

- Arnaldo
