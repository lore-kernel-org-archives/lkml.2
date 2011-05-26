Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab1EZShZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:37:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308Ab1EZShY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:37:24 -0400
Date: Thu, 26 May 2011 20:36:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110526183635.GA2490@elte.hu>
References: <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
 <20110526082451.GB26775@elte.hu>
 <4DDE1419.3000708@redhat.com>
 <20110526093040.GB19536@elte.hu>
 <4DDE31D6.4070209@redhat.com>
 <20110526113842.GA27618@elte.hu>
 <4DDE96B7.8030006@redhat.com>
 <20110526181554.GB3572@elte.hu>
 <4DDE99F6.4030804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDE99F6.4030804@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Live migration involves the guest running in parallel with its 
> memory being copied over.  Even a 1GB guest will take 10s over 
> 1GbE; any reasonably sized guest will take forever.

I suspect we are really offtopic here, but an initial rsync, then 
stopping the guest, final rsync + restart the guest at the target 
would work with minimal interruption.

Thanks,

	Ingo
