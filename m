Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab2KGLpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:45:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab2KGLpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:45:04 -0500
Message-ID: <509A4A52.8000303@redhat.com>
Date: Wed, 07 Nov 2012 06:47:30 -0500
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
Subject: Re: [PATCH 16/19] mm: numa: Add pte updates, hinting and migration
 stats
References: <1352193295-26815-1-git-send-email-mgorman@suse.de> <1352193295-26815-17-git-send-email-mgorman@suse.de> <50996B1A.7040601@redhat.com> <20121107105742.GV8218@suse.de>
In-Reply-To: <20121107105742.GV8218@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 05:57 AM, Mel Gorman wrote:
> On Tue, Nov 06, 2012 at 02:55:06PM -0500, Rik van Riel wrote:
>> On 11/06/2012 04:14 AM, Mel Gorman wrote:

>>> Signed-off-by: Mel Gorman <mgorman@suse.de>
>>
>> I'm skipping the ACKing of the policy patches, which
>> appear to be meant to be placeholders for a "real"
>> policy.
>
> I do expect the MORON policy to disappear or at least change so much it
> is not recognisable.

On the other hand, maybe it would be better to get
things at least into -mm, so the policy can be built
on top?

Just in case...

Acked-by: Rik van Riel <riel@redhat.com>

