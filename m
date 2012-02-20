Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab2BTPfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:35:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50950 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab2BTPfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:35:04 -0500
Date: Mon, 20 Feb 2012 16:34:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Test saved %rip in NMI to determine
 nested NMI
Message-ID: <20120220153452.GA4962@elte.hu>
References: <1329617173.1561.5.camel@acer.local.home>
 <20120219125601.GD25900@elte.hu>
 <1329663451.25686.21.camel@gandalf.stny.rr.com>
 <20120220081045.GD30810@elte.hu>
 <1329748907.25686.29.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329748907.25686.29.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 2012-02-20 at 09:10 +0100, Ingo Molnar wrote:
> > > 
> > > Note, it does not seem to cause any destruction, but screw up 
> > > profiling.
> > 
> > Except if the source of the NMI was not profiling, right?
> 
> Well, what else are NMIs used for? [...]

There's various (legacy) diagnostics NMIs on various x86 
platforms, mostly signalling some sort of deep trouble
with the hw.

Thanks,

	Ingo
