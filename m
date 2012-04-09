Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab2DISKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:10:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab2DISKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:10:16 -0400
Message-ID: <4F8325FB.80409@redhat.com>
Date: Mon, 09 Apr 2012 14:10:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [RFC PATCH 0/2] Removal of lumpy reclaim
References: <1332950783-31662-1-git-send-email-mgorman@suse.de> <20120406123439.d2ba8920.akpm@linux-foundation.org> <alpine.LSU.2.00.1204061316580.3057@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1204061316580.3057@eggly.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 04:31 PM, Hugh Dickins wrote:
> On Fri, 6 Apr 2012, Andrew Morton wrote:
>> On Wed, 28 Mar 2012 17:06:21 +0100
>> Mel Gorman<mgorman@suse.de>  wrote:
>>
>>> (cc'ing active people in the thread "[patch 68/92] mm: forbid lumpy-reclaim
>>> in shrink_active_list()")
>>>
>>> In the interest of keeping my fingers from the flames at LSF/MM, I'm
>>> releasing an RFC for lumpy reclaim removal.
>>
>> I grabbed them, thanks.
>
> I do have a concern with this: I was expecting lumpy reclaim to be
> replaced by compaction, and indeed it is when CONFIG_COMPACTION=y.
> But when CONFIG_COMPACTION is not set, we're back to 2.6.22 in
> relying upon blind chance to provide order>0 pages.

Is this an issue for any architecture?

I could see NOMMU being unable to use compaction, but
chances are lumpy reclaim would be sufficient for that
configuration, anyway...

-- 
All rights reversed
