Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1BQMwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 07:52:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53520 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab1BQMw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 07:52:29 -0500
Date: Thu, 17 Feb 2011 13:51:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, simoneau@ele.uri.edu,
        will.newton@gmail.com, matt@console-pimps.org, rostedt@goodmis.org,
        peterz@infradead.org, jbaron@redhat.com, mathieu.desnoyers@polymtl.ca,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110217125145.GB27504@elte.hu>
References: <4D59B891.8010300@zytor.com>
 <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
 <20110215211123.GA3094@ele.uri.edu>
 <20110215.132702.39199169.davem@davemloft.net>
 <1297808418.2460.9.camel@pasglop>
 <20110216083542.GE16529@elte.hu>
 <4D5C7418.4080307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C7418.4080307@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 02/16/2011 12:35 AM, Ingo Molnar wrote:
> > 
> > Just curious: how does this work if there's an interrupt (or NMI) right after the 
> > invalidate instruction but before the 'll' instruction? The IRQ/NMI may refill the 
> > L1. Or are the two instructions coupled by hw (they form a single instruction in 
> > essence) and irqs/NMIs are inhibited inbetween?
> > 
> 
> http://en.wikipedia.org/wiki/Load-link/store-conditional

Oh, ll/sc, that indeed clicks - i even wrote such assembly code many years ago ;-)

Thanks,

	Ingo
