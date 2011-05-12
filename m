Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab1ELVhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:37:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38753 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771Ab1ELVhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:37:08 -0400
Date: Thu, 12 May 2011 23:36:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110512213657.GC17596@elte.hu>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
 <BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
 <BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
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


* Stephane Eranian <eranian@google.com> wrote:

> > The bug is that perf doesn't say "I can't match kernel symbols", but 
> > instead does some crazy matching and gives total crap module information (I 
> > think it just picks the one that shows up last in /proc/kallsyms).
>
> But I agree perf must not silently return bogus information. It should print 
> a big warning message and/or fallback to printing the raw addresses. [...]

Yes, agreed, this is a bug in perf. I found out about this about two weeks ago 
and reported it to Arnaldo, but he is away right now - he might be able to fix 
it next week the earliest.

> [...] So much for having perf in the kernel source tree to keep things in 
> sync...

What do you mean?

Thanks,

	Ingo
