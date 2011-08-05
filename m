Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1HEOjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 10:39:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab1HEOjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 10:39:03 -0400
Message-ID: <4E3C006B.5090900@redhat.com>
Date: Fri, 05 Aug 2011 10:38:35 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Johannes Weiner <jweiner@redhat.com>
CC: linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/5] mm: writeback: make determine_dirtyable_memory static
 again
References: <1311625159-13771-1-git-send-email-jweiner@redhat.com> <1311625159-13771-3-git-send-email-jweiner@redhat.com>
In-Reply-To: <1311625159-13771-3-git-send-email-jweiner@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 04:19 PM, Johannes Weiner wrote:
> From: Johannes Weiner<hannes@cmpxchg.org>
>
> The tracing ring-buffer used this function briefly, but not anymore.
> Make it local to the writeback code again.
>
> Also, move the function so that no forward declaration needs to be
> reintroduced.
>
> Signed-off-by: Johannes Weiner<hannes@cmpxchg.org>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
