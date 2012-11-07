Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2KGLn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:43:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab2KGLnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:43:55 -0500
Message-ID: <509A4A00.1040602@redhat.com>
Date: Wed, 07 Nov 2012 06:46:08 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/19] mm: numa: Add fault driven placement and migration
References: <1352193295-26815-1-git-send-email-mgorman@suse.de> <1352193295-26815-16-git-send-email-mgorman@suse.de> <509967D9.7050706@redhat.com> <20121107104940.GU8218@suse.de>
In-Reply-To: <20121107104940.GU8218@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 05:49 AM, Mel Gorman wrote:
> On Tue, Nov 06, 2012 at 02:41:13PM -0500, Rik van Riel wrote:
>> On 11/06/2012 04:14 AM, Mel Gorman wrote:

>>> Signed-off-by: Mel Gorman <mgorman@suse.de>
>>
>> Excellent basis for implementing a smarter NUMA
>> policy.
>>
>> Not sure if such a policy should be implemented
>> as a replacement for this patch, or on top of it...
>>
>
> I'm expecting on top of it.

In that case:

Acked-by: Rik van Riel <riel@redhat.com>

