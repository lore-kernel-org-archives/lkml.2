Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab1AXWAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:00:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab1AXWAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:00:52 -0500
Date: Mon, 24 Jan 2011 20:00:32 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20110124220032.GE29975@ghostprotocols.net>
References: <20110124133400.GA1228@elte.hu> <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com> <20110124200738.GA10833@elte.hu> <AANLkTi=C0L=21zhH_L+cRPv2ZCRE9L93tKtC9ELrcTBW@mail.gmail.com> <AANLkTi=V61L6vgFZ_4u20dZvv2=tvi-XJMc2HqOnjMo4@mail.gmail.com> <20110124203802.GC29975@ghostprotocols.net> <20110124212526.GA13724@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124212526.GA13724@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 24, 2011 at 10:25:26PM +0100, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > Was this on a freshly installed machine? Or on a freshly updated one?
> > 
> > Probably its the build-id collecting at the end of a session, on the
> > first run you had a cold cache and it had to figure out which binaries
> > to cache on ~/.debug, second time it was already cached so it was fast.
> 
> Hm, it would be nice to not surprise users with an unlimited-timeout, up to half a 
> minute 'frozen' app. Can we possibly display a more finegrained progress indicator?

Definetely, adding this to the todo list.

In fact perf_session__process_events already has an ui_progress stuff,
its just that it works only on report/TUI. Need to make it work with
some /-|/- spinning text progress indicator after a "collecting
build-ids:" string, something like that.

- Arnaldo
