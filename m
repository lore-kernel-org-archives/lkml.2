Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab2EMUJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 16:09:17 -0400
Received: from blu0-omc3-s28.blu0.hotmail.com ([65.55.116.103]:26622 "EHLO
	blu0-omc3-s28.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019Ab2EMUJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 16:09:15 -0400
X-Originating-IP: [64.229.84.125]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU0-SMTP22F4864AE1F54838C150D797150@phx.gbl>
From: John David Anglin <dave.anglin@bell.net>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
In-Reply-To: <4FB011E7.1000604@linux.vnet.ibm.com>
Subject: Re: Linux 3.4-rc7
References: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com> <4FB011E7.1000604@linux.vnet.ibm.com>
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (Apple Message framework v936)
Date: Sun, 13 May 2012 16:08:56 -0400
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mikulas Patocka <mpatocka@redhat.com>, stepanm@codeaurora.org,
        Thomas Gleixner <tglx@linutronix.de>,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        eike-kernel@sf-tec.de, linux-parisc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.936)
X-OriginalArrivalTime: 13 May 2012 20:09:13.0121 (UTC) FILETIME=[43F3F110:01CD3144]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-May-12, at 3:56 PM, Srivatsa S. Bhat wrote:

> The regression was introduced in the 3.4 merge window itself (by  
> commit
> 5fbd036b55 "sched: Cleanup cpu_active madness").
>
> Links to the original posting:
> PA_RISC: http://marc.info/?l=linux-parisc&m=133241790810604&w=2


If I had the above change, I get

   CHK     include/generated/compile.h
   CC      arch/parisc/kernel/smp.o
arch/parisc/kernel/smp.c: In function 'smp_cpu_init':
arch/parisc/kernel/smp.c:300:2: error: implicit declaration of  
function 'notify_cpu_starting' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [arch/parisc/kernel/smp.o] Error 1

Dave
--
John David Anglin	dave.anglin@bell.net



