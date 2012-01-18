Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2ARJkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:40:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33137 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104Ab2ARJkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:40:05 -0500
Date: Wed, 18 Jan 2012 10:39:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [GIT PULL] tracing: make signal tracepoints more useful
Message-ID: <20120118093944.GD5842@elte.hu>
References: <20120110174509.GA30802@redhat.com>
 <20120113182015.GA3902@redhat.com>
 <20120115182441.GA24694@redhat.com>
 <20120116074540.GE15641@elte.hu>
 <1326717070.7642.144.camel@gandalf.stny.rr.com>
 <20120116125329.GB31667@elte.hu>
 <20120116151001.GB12817@redhat.com>
 <CA+55aFwBW3abeSGoRMZBKERmSKk76Xm+uv7N+ZajvqOyv=aH3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwBW3abeSGoRMZBKERmSKk76Xm+uv7N+ZajvqOyv=aH3g@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jan 16, 2012 at 7:10 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > But do we really need to keep the old tracepoint? IOW, what 
> > if we simply rename it and add more info?
> 
> Quite frankly, unless somebody can point to something that 
> breaks, I'd rather just change the existing one.
> 
> Nobody outside of a few special cases uses tracepoints. 
> *nobody*.  The only apps I have ever seen that matters to 
> anybody ends up being latencytop and powertop. If those two 
> have been tested and don't care, I don't think we should care.

Correct. (There's also sysprof and perf - both should be fine.)

As i said in my very first mail:

> [...] Which apps/tools rely on the old tracepoint? If it's 
> exactly zero apps then we might be able to change it, but this 
> needs to be investigated.

I resisted Steve's "this ABI change is safe by design" notion 
which is somewhat of a disease. It is probably fine but not by 
definition.

Thanks,

	Ingo
