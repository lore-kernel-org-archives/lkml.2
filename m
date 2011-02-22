Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab1BVIHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:07:20 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:34797 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1BVIHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:07:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANv8Yk2rR7Ht/2dsb2JhbACmQ3OfcptbhV4EhQ2HBoM7gxA
X-IronPort-AV: E=Sophos;i="4.62,206,1297036800"; 
   d="scan'208";a="268243301"
Message-ID: <4D636EB5.3030605@cisco.com>
Date: Tue, 22 Feb 2011 01:07:17 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        peterz@infradead.org, paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 0/4] perf events: Add realtime clock event and timehist
 option -v2
References: <1298322150-15505-1-git-send-email-daahern@cisco.com> <20110221213740.GC3583@nowhere> <4D62DC21.4070407@cisco.com> <20110221215533.GD3583@nowhere> <4D62E2B0.1070607@cisco.com> <20110221222104.GE3583@nowhere> <4D630E79.7030106@cisco.com> <20110222025001.GA5475@nowhere> <20110222074158.GA32322@elte.hu>
In-Reply-To: <20110222074158.GA32322@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/11 00:41, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
>> perf-script is not new, it was there in november already, although named perf 
>> trace at that time.
> 
> Yes.
> 
> The new 'perf trace' utility - which might be the straightforward 'report a trace' 
> utility that David is looking for is still WIP and can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tmp.perf/trace
> 
> Warning: the code is stale and needs much more work to become mergable. But 
> displaying GTOD timestamps is very much something that looks sensible in the 'perf 
> trace' context as well.

Ok. I'll look at moving the timehist option from perf-report to perf-script.

David

> 
> Thanks,
> 
> 	Ingo
