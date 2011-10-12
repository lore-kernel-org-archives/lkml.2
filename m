Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1JLHgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:36:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56752 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab1JLHgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:36:12 -0400
Date: Wed, 12 Oct 2011 09:34:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH RFC V3 2/8] stop_machine: make stop_machine safe and
 efficient to call early
Message-ID: <20111012073402.GJ18618@elte.hu>
References: <cover.1317755691.git.jeremy.fitzhardinge@citrix.com>
 <619c66d6da63aa086e2eac017e7aed216cc8ddc3.1317755691.git.jeremy.fitzhardinge@citrix.com>
 <8762k4grwy.fsf@rustcorp.com.au>
 <20111010073405.GC29035@elte.hu>
 <4E934F37.2020300@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E934F37.2020300@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 10/10/2011 12:34 AM, Ingo Molnar wrote:
> > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> >> On Tue,  4 Oct 2011 12:18:03 -0700, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >>>
> >>> Make stop_machine() safe to call early in boot, before stop_machine()
> >>> has been set up, by simply calling the callback function directly if
> >>> there's only one CPU online.
> >> Not that you need this, since it's >90% Tejun's code now, but:
> >>
> >> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> > hey, extra review is always useful.
> >
> > Jeremy, Tejun, what's the expected merge path of these changes?
> 
> Andrew has already picked up the stop_machine patch, I think.  But it's
> pretty settled now, so it shouldn't cause any problem if it gets via
> multiple paths.
> 
> What about the jump-label stuff?  Has that been going via tip.git in the
> past, or by some other path?

If it has Jason's and PeterZ's ack then it can go via any other tree 
in this cycle - we are not carrying jump label patches right now.

But those acks are very much desired.

Thanks,

	Ingo
