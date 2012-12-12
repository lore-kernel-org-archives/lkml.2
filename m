Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2LLWE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:04:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab2LLWE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:04:57 -0500
Message-ID: <50C8FF00.3090802@redhat.com>
Date: Wed, 12 Dec 2012 17:02:40 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/8] mm: vmscan: save work scanning (almost) empty LRU
 lists
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org> <1355348620-9382-4-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1355348620-9382-4-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 04:43 PM, Johannes Weiner wrote:
> In certain cases (kswapd reclaim, memcg target reclaim), a fixed
> minimum amount of pages is scanned from the LRU lists on each
> iteration, to make progress.
>
> Do not make this minimum bigger than the respective LRU list size,
> however, and save some busy work trying to isolate and reclaim pages
> that are not there.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

