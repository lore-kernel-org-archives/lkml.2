Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1F2JGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 05:06:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab1F2JGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 05:06:03 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary physical addresses
Date: Wed, 29 Jun 2011 11:05:59 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.5-default; KDE/4.6.0; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <201106171038.25988.ptesarik@suse.cz> <20110617093032.GA19235@elte.hu>
In-Reply-To: <20110617093032.GA19235@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106291106.00070.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Pá 17. června 2011 11:30:32 Ingo Molnar napsal(a):
> * Petr Tesarik <ptesarik@suse.cz> wrote:
> > This patch series enhances /dev/mem, so that read and write is
> > possible at any address. The patchset includes actual
> > implementation for x86.
> 
> This series lacks a description of why this is desired.
>[...]
> 
> Are you aware of any legitimate usecases?

Looking back at the mail tread, I'd say there are people who have legitimate 
usecases. However, this may not be the most important question. At the moment, 
the /dev/mem interface is broken (it doesn't implement the specification 
correctly), and my patchset fixes it.

If there are no technical objections, I'd like to ask for an Acked-by from all 
involved people.

@Ingo: you can also send a patchset that rips off the /dev/mem driver 
completely if you believe that would get through. I'm completely fine with 
that, because then the /dev/crash driver will no longer be a semi-broken re-
implementation of an existing in-kernel driver, so I'll be able to post it as 
a new driver.

But please make a decision either way.

Petr Tesarik
