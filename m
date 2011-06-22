Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab1FVMfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:35:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757502Ab1FVMfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:35:03 -0400
Message-ID: <4E01E148.2080302@redhat.com>
Date: Wed, 22 Jun 2011 20:34:16 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andrea Arcangeli <aarcange@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: make the threshold of enabling THP configurable
References: <1308587683-2555-1-git-send-email-amwang@redhat.com> <1308587683-2555-2-git-send-email-amwang@redhat.com> <20110620165955.GB9396@suse.de> <4DFF8050.9070201@redhat.com> <20110621093640.GD9396@suse.de> <4E015672.2020407@redhat.com> <20110622091611.GB7585@csn.ul.ie> <4E01C80F.8070605@redhat.com> <20110622111525.GK9396@suse.de>
In-Reply-To: <20110622111525.GK9396@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月22日 19:15, Mel Gorman 写道:
> On Wed, Jun 22, 2011 at 06:46:39PM +0800, Cong Wang wrote:
>> ??? 2011???06???22??? 17:16, Mel Gorman ??????:
>>>
>>> What I meant was that there is a rational reason why 512M is the
>>> default for enabling THP by default. Tuning it lower than that by any
>>> means makes very little sense. Tuning it higher might make some sense
>>> but it is more likely that THP would simply be disabled via sysctl. I
>>> see very little advantage to introducing this Kconfig option other
>>> than as a source of confusion when running make oldconfig.
>>>
>>
>> The tunable range is (512, 8192), so 512M is the minimum.
>>
>> Sure, I knew it can be disabled via /sys, actually we can do even
>> more in user-space, that is totally move the 512M check out of kernel,
>> why we didn't?
>>
>
> Because the reason why 512M is the default is not obvious and there
> was no guarantee all distros would chose a reasonable default for
> an init script (or know that an init script was even necessary).
> This is one of the few cases where there is a sensible default that
> is the least surprising.
>

Putting a well-explained Kconfig help would solve this problem,
so I don't think this is a surprising thing.
