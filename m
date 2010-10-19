Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab0JSLs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:48:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:42454 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514Ab0JSLsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:48:25 -0400
Subject: Re: PATCH [0/4] perf: clean-up of power events API
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Pierre Tardy <tardyp@gmail.com>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        linux-trace-users@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        rjw@sisk.pl, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Steven Rostedt <rostedt@goodmis.org>, Frank Eigler <fche@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101019114501.GA25371@elte.hu>
References: <201010062334.46971.trenn@suse.de>
	 <4CB095FA.8060803@linux.intel.com> <20101010121928.GA2688@elte.hu>
	 <201010191331.03080.trenn@suse.de>  <20101019114501.GA25371@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Oct 2010 13:47:21 +0200
Message-ID: <1287488841.1994.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 13:45 +0200, Ingo Molnar wrote:
> 
> * Thomas Renninger <trenn@suse.de> wrote:
> 
> > > Most definitely. It's no accident that it took such a long time for this issue 
> > > to be raised in the first place. It's a rare occurance -
> >
> > Do you agree that this occurance happened now and these events should get cleaned 
> > up before ARM and other archs make use of the broken interface?
> >
> > If not, discussing this further, is a big waste of time... and Jean would have to 
> > try to adapt his ARM code on the broken ABI...
> 
> The discussion seems to have died down somewhat. Please re-send to lkml the latest 
> patches you have to remind everyone of the latest state of things - the merge window 
> is getting near.
> 
> My only compatibility/ABI point is basically that it shouldnt break _existing_ 
> tracepoints (and users thereof). If your latest bits meet that then it ought to be a 
> good first step. You are free to (and encouraged to) introduce more complete sets of 
> events.

Can we deprecate and eventually remove the old ones, or will we be
forever obliged to carry the old ones too?
