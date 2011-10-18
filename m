Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab1JRHUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 03:20:36 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:33198 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab1JRHUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 03:20:35 -0400
Date: Tue, 18 Oct 2011 09:20:30 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111018092030.4d55ccfc@de.ibm.com>
In-Reply-To: <4E9C94A1.7080209@zytor.com>
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
	<4E9C94A1.7080209@zytor.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011 13:48:33 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 10/17/2011 12:55 AM, Martin Schwidefsky wrote:
> > 
> > I introduced those macros to find all the places in the kernel operating
> > on a cputime value. The additional debug patch defined cputime_t as a
> > struct which contained a single u64. That way I got a compiler error
> > for every place I missed.
> > 
> 
> And was there a reason that that structure thingy didn't get merged?

Oh yes, it is fragile, hackish and ugly as hell.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

