Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1JGUHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 16:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab1JGUHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 16:07:18 -0400
Message-ID: <4E8F5BEA.3040502@redhat.com>
Date: Fri, 07 Oct 2011 16:07:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
        Josh Boyer <jwboyer@redhat.com>, aarcange@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: Abort reclaim/compaction if compaction can proceed
References: <1318000643-27996-1-git-send-email-mgorman@suse.de> <1318000643-27996-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1318000643-27996-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2011 11:17 AM, Mel Gorman wrote:
> If compaction can proceed, shrink_zones() stops doing any work but
> the callers still shrink_slab(), raises the priority and potentially
> sleeps.  This patch aborts direct reclaim/compaction entirely if
> compaction can proceed.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>

This patch makes sense to me, but I have not tested it like
the first one.

Mel, have you tested this patch?  Did you see any changed
behaviour vs. just the first patch?

Having said that, I'm pretty sure the patch is ok :)

-- 
All rights reversed
