Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab0JAMIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:08:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab0JAMIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:08:20 -0400
Message-ID: <4CA5CF17.1090807@redhat.com>
Date: Fri, 01 Oct 2010 08:07:51 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 0/2] Reduce mmap_sem hold times during file backed page
 faults
References: <1285909484-30958-1-git-send-email-walken@google.com>
In-Reply-To: <1285909484-30958-1-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2010 01:04 AM, Michel Lespinasse wrote:
> Linus, I would appreciate your comments on this since you shot down the
> previous proposal. I hope you'll find this approach is sane, but I would
> be interested to hear if you have specific objections.
>
> mmap_sem is very coarse grained (per process) and has long read-hold times
> (disk latencies); this breaks down rapidly for workloads that use both
> read and write mmap_sem acquires. This short patch series tries to reduce
> mmap_sem hold times when faulting in file backed VMAs.

The changes make sense to me, but it would be good to know
what kind of benefits you have seen with these patches.

Especially performance numbers :)

-- 
All rights reversed
