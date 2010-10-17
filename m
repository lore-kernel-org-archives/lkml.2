Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab0JQFuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 01:50:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57667 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab0JQFuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 01:50:03 -0400
Date: Sun, 17 Oct 2010 07:49:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, kernel@lists.fedoraproject.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        eparis@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101017054924.GA2864@elte.hu>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
 <20101017004945.GE1614@infradead.org>
 <20101017010917.GB8332@bombadil.infradead.org>
 <20101017011350.GA2838@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017011350.GA2838@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Oct 16, 2010 at 09:09:17PM -0400, Kyle McMartin wrote:
>
> > The Kconfig description sounds generally useful to me. If it's 
> > bloated crap, how did it get merged?
> 
> Just like all the other crap.  It's been made pretty clear that "no" 
> generally is not an answer for a merge request.  Just bikeshedding 
> over whitespace or maintainer files entries for a couple month of 
> delay is fine.

IMO insensitive, tester alienating insults like the one you have just 
launched against the wrong person are far more destructive to the 
efficiency of the kernel quality process than the same-old influx of 
crap.

You'd be right to flame the heck out of the lkml hardened person(s) who 
allowed that crap, but not the person who was in the chain of testing 
that helped us find it, for chrissakes!

We keep losing really good people due to social imbeciles like you.

Thanks,

	Ingo
