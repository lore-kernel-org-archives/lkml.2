Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1JGTcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:32:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab1JGTcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:32:42 -0400
Message-ID: <4E8F53CD.9000609@redhat.com>
Date: Fri, 07 Oct 2011 15:32:29 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
        Josh Boyer <jwboyer@redhat.com>, aarcange@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: vmscan: Limit direct reclaim for higher order
 allocations
References: <1318000643-27996-1-git-send-email-mgorman@suse.de> <1318000643-27996-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1318000643-27996-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2011 11:17 AM, Mel Gorman wrote:
> From: Rik van Riel<riel@redhat.com>
>
> When suffering from memory fragmentation due to unfreeable pages,
> THP page faults will repeatedly try to compact memory.  Due to the
> unfreeable pages, compaction fails.

I believe Andrew just merged this one :)

-- 
All rights reversed
