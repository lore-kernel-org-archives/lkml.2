Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1JQUtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:49:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35916 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab1JQUtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:49:15 -0400
Message-ID: <4E9C94A1.7080209@zytor.com>
Date: Mon, 17 Oct 2011 13:48:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 3.1-rc9
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com> <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca> <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca> <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca> <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com> <20111017095544.6bf76dea@de.ibm.com>
In-Reply-To: <20111017095544.6bf76dea@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2011 12:55 AM, Martin Schwidefsky wrote:
> 
> I introduced those macros to find all the places in the kernel operating
> on a cputime value. The additional debug patch defined cputime_t as a
> struct which contained a single u64. That way I got a compiler error
> for every place I missed.
> 

And was there a reason that that structure thingy didn't get merged?

	-hpa
