Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1JQJSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:18:35 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:50826 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1JQJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:18:33 -0400
Date: Mon, 17 Oct 2011 11:18:28 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111017111828.23601d49@de.ibm.com>
In-Reply-To: <1318842771.6594.30.camel@twins>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
	<20111007070842.GA27555@hostway.ca>
	<20111007174848.GA11011@hostway.ca>
	<1318010515.398.8.camel@twins>
	<20111008005035.GC22843@hostway.ca>
	<1318060551.8395.0.camel@twins>
	<20111012213555.GC24461@hostway.ca>
	<20111013232521.GA5654@hostway.ca>
	<CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>
	<20111017095544.6bf76dea@de.ibm.com>
	<1318842771.6594.30.camel@twins>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011 11:12:51 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2011-10-17 at 09:55 +0200, Martin Schwidefsky wrote:
> > 
> > The reason for the cputime_xxx primitives has been my fear that people
> > ignore the cputime_t type and just use unsigned long (as they always
> > have). That would break s390 which needs a u64 for its cputime value.
> > Dunno if we still need it, seems like we got used to using cputime_t. 
> 
> Right, and like mentioned last time this came up, we could possibly make
> use of sparse to ensure things don't go fail on 32bit s390.

Indeed. No progress on the sparse check so far I'm afraid. 


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

