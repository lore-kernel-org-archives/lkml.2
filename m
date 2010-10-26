Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab0JZR4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:56:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35307 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932520Ab0JZRz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:55:58 -0400
Date: Tue, 26 Oct 2010 19:55:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        rusty@rustcorp.com.au, fweisbec@gmail.com, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de
Subject: Re: [tip:perf/urgent] tracing: Prevent unloadable modules from using
 trace_bprintk()
Message-ID: <20101026175519.GA12202@elte.hu>
References: <tip-c3b87c579e5df72a59fe97d77d4c3791dc8154ec@git.kernel.org>
 <AANLkTin7Daj=HnWXstuWxymjuBfF9axfKZWvei_EKefw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin7Daj=HnWXstuWxymjuBfF9axfKZWvei_EKefw@mail.gmail.com>
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

> On Tue, Oct 26, 2010 at 3:21 AM, tip-bot for Steven Rostedt
> <srostedt@redhat.com> wrote:
> >
> > tracing: Prevent unloadable modules from using trace_bprintk()
> 
> I still don't think this patch makes sense.

Yeah, i said that to Steve too in the discussion and essentially NAK-ed that patch - 
it's just that i pulled the wrong branch. After seeing the commit mail i realized my 
mistake and unpulled this one and pulled the right one ...

Thanks,

	Ingo
