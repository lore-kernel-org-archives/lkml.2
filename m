Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2LMTMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:12:39 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52158 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2LMTMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:12:38 -0500
Message-ID: <50CA28A1.2080003@gmail.com>
Date: Thu, 13 Dec 2012 12:12:33 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.8
References: <50C94ECD.6020504@gmail.com> <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com> <50C95A21.1010101@gmail.com> <20121213073056.GA13156@gmail.com> <50C9E692.9070506@gmail.com> <CA+55aFzmDooC3tYzvP1YGv9g4ej1hBUQBPV6R+ukrfxuEELBaQ@mail.gmail.com> <50CA0134.2090608@gmail.com> <CA+55aFyZ2kAQPmZSv_sfHDAR1gusOxO22TRX-kqSim-cZrMscw@mail.gmail.com> <CA+55aFwSYyoLmdDJ5xsdwcWLThYQ7oieoeWDV2g+wV3CJk4vtg@mail.gmail.com> <50CA10C8.3020509@gmail.com> <20121213173617.GB19444@gmail.com>
In-Reply-To: <20121213173617.GB19444@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/12 10:36 AM, Ingo Molnar wrote:
> The #1 problem child in this particular case, the one you should
> care about most is:
>
> 	perf record -e cycles:pp
>
> As 99% of the people won't be doing any host or guest side
> profiling, they just want to do profiling.

In older code (v3.6 and before) -e cycles:p sets the exclude_guest flag 
to 0, so -e cycles:p and -e cycles:pG are equivalent with respect to 
exclude_guest.


> Ok? So now we need a patch that does all that - otherwise we'll
> have to revert the one that added the regression.

I will not have time to work on a patch until Sunday at the earliest.

David
