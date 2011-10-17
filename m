Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab1JQWJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 18:09:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36840 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939Ab1JQWJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 18:09:38 -0400
Message-ID: <4E9CA772.4000509@zytor.com>
Date: Mon, 17 Oct 2011 15:08:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Linux 3.1-rc9
References: <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca> <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com> <20111017045806.GA11561@elte.hu> <alpine.LFD.2.02.1110171101250.3240@ionos> <20111017184916.GA5545@elte.hu> <4E9C917B.2050802@zytor.com> <20111017211951.GA8043@elte.hu> <4E9C9CAE.9090207@zytor.com> <20111017213958.GA27126@elte.hu>
In-Reply-To: <20111017213958.GA27126@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2011 02:39 PM, Ingo Molnar wrote:
>>
>> We can do much better than that with reciprocal multiplication.  
> 
> Yes, 2^64/1e9 is the reciprocal.
> 

What I mean is that it's pretty easy to work it so it doesn't have the
errors.  We have 32*32 = 64 multiplication on all 32-bit platforms I'm
99.9% sure.

	-hpa

