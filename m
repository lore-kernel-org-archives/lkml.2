Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798Ab1LOXWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 18:22:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab1LOXWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 18:22:02 -0500
Message-ID: <4EEA80F9.5040407@redhat.com>
Date: Thu, 15 Dec 2011 18:21:29 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/11] mm: vmscan: Check if we isolated a compound page
 during lumpy scan
References: <1323877293-15401-1-git-send-email-mgorman@suse.de> <1323877293-15401-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1323877293-15401-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 10:41 AM, Mel Gorman wrote:
> From: Andrea Arcangeli<aarcange@redhat.com>
>
> Properly take into account if we isolated a compound page during the
> lumpy scan in reclaim and skip over the tail pages when encountered.
> This corrects the values given to the tracepoint for number of lumpy
> pages isolated and will avoid breaking the loop early if compound
> pages smaller than the requested allocation size are requested.
>
> [mgorman@suse.de: Updated changelog]
> Signed-off-by: Andrea Arcangeli<aarcange@redhat.com>
> Signed-off-by: Mel Gorman<mgorman@suse.de>
> Reviewed-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
