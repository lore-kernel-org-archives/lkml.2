Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab0GSNdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 09:33:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074Ab0GSNdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 09:33:36 -0400
Message-ID: <4C445403.3020905@redhat.com>
Date: Mon, 19 Jul 2010 09:32:51 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 3/8] vmscan: tracing: Update post-processing script to
 distinguish between anon and file IO from page reclaim
References: <1279545090-19169-1-git-send-email-mel@csn.ul.ie> <1279545090-19169-4-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1279545090-19169-4-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2010 09:11 AM, Mel Gorman wrote:
> It is useful to distinguish between IO for anon and file pages. This patch
> updates
> vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
> so the post-processing script can handle the additional information.
>
> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
