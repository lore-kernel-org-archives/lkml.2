Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2LMOav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:30:51 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42708 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756625Ab2LMOas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:30:48 -0500
Message-ID: <50C9E692.9070506@gmail.com>
Date: Thu, 13 Dec 2012 07:30:42 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com> <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com> <50C94ECD.6020504@gmail.com> <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com> <50C95A21.1010101@gmail.com> <20121213073056.GA13156@gmail.com>
In-Reply-To: <20121213073056.GA13156@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/12 12:30 AM, Ingo Molnar wrote:
>
> * David Ahern <dsahern@gmail.com> wrote:
>
>>> But doing it this way was wrong. Switch that "exclude_guest"
>>> attribute around, and admit that "H" was bogus, and that the
>>> right thing to do was to add a "V" flag that sets the
>>> "force_guest" flag instead.
>>
>> I understand this is annoying. [...]
>
> It's not annoying, it's outright broken - it's a regression that
> we'll fix.

One of the problems is that existing binaries set the exclude_guest flag 
(https://lkml.org/lkml/2012/7/9/292).

So, requesting users to update their binaries if they want to use 
precise sampling is not acceptable. A 100% catastrophic failure of all 
running VMs is acceptable? All VMs will crash and there is no direct 
causal relationship.

David
