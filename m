Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1JQUgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:36:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35678 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab1JQUgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:36:02 -0400
Message-ID: <4E9C917B.2050802@zytor.com>
Date: Mon, 17 Oct 2011 13:35:07 -0700
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
References: <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca> <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca> <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca> <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com> <20111017045806.GA11561@elte.hu> <alpine.LFD.2.02.1110171101250.3240@ionos> <20111017184916.GA5545@elte.hu>
In-Reply-To: <20111017184916.GA5545@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2011 11:49 AM, Ingo Molnar wrote:
> Do we have some hard data on this, which we could put into comments 
> in include/linux/ktime.h and such? Older versions of GCC used to do a 
> bad job of long long handling on 32-bit systems - that might be a 
> factor in the performance figures.
> 
> But i suspect you are right that the cost is still very much there 

64/64 division is done bit by bit on most (all?) 32-bit architectures.

64/32 division can be done in hardware on some architectures, e.g. x86.

	-hpa
