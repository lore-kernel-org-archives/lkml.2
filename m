Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab2EMT5I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 15:57:08 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:60375 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab2EMT5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 15:57:06 -0400
Message-ID: <4FB011E7.1000604@linux.vnet.ibm.com>
Date: Mon, 14 May 2012 01:26:23 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mikulas Patocka <mpatocka@redhat.com>, stepanm@codeaurora.org,
        Thomas Gleixner <tglx@linutronix.de>,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        eike-kernel@sf-tec.de, linux-parisc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.4-rc7
References: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com>
In-Reply-To: <CA+55aFzsygnrJwLUPV8Vg4RPmwxXLuY-uo70fBLEZR8+barT5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12051310-3568-0000-0000-000001C2A08F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2012 07:34 AM, Linus Torvalds wrote:

> This is almost certainly the last -rc in this series - things really
> have calmed down, and I even considered just cutting 3.4 this weekend,
> but felt that another week wouldn't hurt.
[...] 
> So go forth and test. And don't send me any pull requests unless they
> contain *only* regressions or fixes for really nasty bugs.


Oh, I just noticed that 2 important fixes which fix boot failures on
PA-RISC and mn10300 architectures haven't made it to mainline yet.

The regression was introduced in the 3.4 merge window itself (by commit
5fbd036b55 "sched: Cleanup cpu_active madness").

Links to the original posting:
PA_RISC: http://marc.info/?l=linux-parisc&m=133241790810604&w=2
mn10300: http://marc.info/?l=linux-parisc&m=133241580509804&w=2

Mikulas confirmed that this fixes the boot failure on PA-RISC:
https://lkml.org/lkml/2012/5/8/97

Regards,
Srivatsa S. Bhat

