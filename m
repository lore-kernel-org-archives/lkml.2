Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab1CPUQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:16:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45499 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab1CPUQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=g6ZOODJEVNqGfaTXQMvwABSZSn7vHtZYmLlDFdXLl7I3R8C4fI1e1p/t7a3FqHpuMX
         0A260a4VoRYV5gcIw+FRrrSl6sE8MPVxbRSLbwcynvr0U9oMw4JlWOvI26JPwfzCB+ND
         PrXNBryYSUkZLvWKq2klS6ODdOTg9pnA+oXHg=
MIME-Version: 1.0
In-Reply-To: <1300301742.2203.1899.camel@twins>
References: <20110217162327.434629380@chello.nl>
	<20110217163234.823185666@chello.nl>
	<20110310155032.GB32302@csn.ul.ie>
	<1300301742.2203.1899.camel@twins>
Date: Wed, 16 Mar 2011 21:15:58 +0100
X-Google-Sender-Auth: aIdImDqikVbTm73WD0vh476BInQ
Message-ID: <AANLkTimB4NFSPz5dSQCuEy3Rj5968n5k0=4c7tvhErE5@mail.gmail.com>
Subject: Re: [PATCH 02/17] mm: mmu_gather rework
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
        Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Nick Piggin <npiggin@kernel.dk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Tony Luck <tony.luck@intel.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 19:55, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2011-03-10 at 15:50 +0000, Mel Gorman wrote:
>
>> > +static inline void
>> > +tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_mm_flush)
>> >  {
>>
>> checkpatch will bitch about line length.
>
> I did a s/full_mm_flush/fullmm/ which puts the line length at 81. At
> which point I'll ignore it ;-)

But what does "fullmm" mean here? Shouldn't that be documented.
BTW, the function no longer returns a struct, but void, so the documentation
should be updated for sure.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
