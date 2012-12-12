Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab2LLWGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:06:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab2LLWGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:06:42 -0500
Message-ID: <50C8FF3A.5050903@redhat.com>
Date: Wed, 12 Dec 2012 17:03:38 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/8] mm: vmscan: clarify LRU balancing close to OOM
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org> <1355348620-9382-5-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1355348620-9382-5-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 04:43 PM, Johannes Weiner wrote:
> There are currently several inter-LRU balancing heuristics that simply
> get disabled when the reclaimer is at the last reclaim cycle before
> giving up, but the code is quite cumbersome and not really obvious.
>
> Make the heuristics visibly unreachable for the last reclaim cycle.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Nice cleanup!

Reviewed-by: Rik van Riel <riel@redhat.com>

