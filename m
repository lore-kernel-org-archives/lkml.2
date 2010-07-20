Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab0GTAh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:37:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32111 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab0GTAhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 20:37:55 -0400
Message-ID: <4C44EF39.9000500@kernel.org>
Date: Mon, 19 Jul 2010 17:35:05 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH -v25 00/49] Use memblock with x86
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org> <AANLkTimC5Yio93MQ3QPjat_vpOp4gKkV_p1hmI-Nvl3B@mail.gmail.com>
In-Reply-To: <AANLkTimC5Yio93MQ3QPjat_vpOp4gKkV_p1hmI-Nvl3B@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C44EF9E.00E5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2010 05:14 PM, Linus Torvalds wrote:
> On Mon, Jul 19, 2010 at 4:56 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> New memblock could be used to replace early_res in x86.
>>
>> Suggested by: David, Ben, and Thomas
> 
> So how is this related to Ben's git tree that was tested on sparc? Not
> clear from the changelog.

base on Ben's git tree that was tested on sparc.
fold one patch from me to patch 19. so will not break bisecting.

Maybe Ben can check patch from 3 to 27 to see if the folding is right or not.

> 
>> First two patches are needed for 2.6.35. need to be applied at first.
> 
> Please send those two as a separate series with a separate cover-sheet
> and explanation. If they are regressions or major fixes for existing
> code, they should not go into some 50-patch series for the future.
> That way they just get lost in the noise, and it's not at all as clear
> that they are important for current kernels.

those two are already in Andrew's -mm, but were not into tip/x86 yet.
and some of patches (patch 28-49) could have some merging conflicts if
those two are not applied at first.

> 
> In fact, in general, the fewer 50-series patches we see, the better.
> If a series of 50 patches could be split up into separate independent
> series ("independent" in the sense that they do different things -
> maybe one series depends on another series for infrastructure, but
> then actually concentrates on a different issue), that would be good.
> 
> Because, quite frankly, when I get email-bombed by tens of patches, I
> immediately lose about 99% of my eagerness to actually check the
> patches out. And I bet I'm not the only one. So it would likely be
> much more productive if these kinds of things can be sent out as
> multiple smaller series that can be looked at separately (and not sent
> out at the same time).

ok, 
1. let's wait Ingo or hpa to pick first two.
2. wait Ben to rebase patch 3-27, and send them out at first.
3. then I will resend from 28 to 49.

Thanks

Yinghai
