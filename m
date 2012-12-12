Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab2LLWDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:03:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab2LLWDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:03:22 -0500
Message-ID: <50C8FE9E.9030203@redhat.com>
Date: Wed, 12 Dec 2012 17:01:02 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] mm: vmscan: disregard swappiness shortly before going
 OOM
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org> <1355348620-9382-3-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1355348620-9382-3-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 04:43 PM, Johannes Weiner wrote:
> When a reclaim scanner is doing its final scan before giving up and
> there is swap space available, pay no attention to swappiness
> preference anymore.  Just swap.
>
> Note that this change won't make too big of a difference for general
> reclaim: anonymous pages are already force-scanned when there is only
> very little file cache left, and there very likely isn't when the
> reclaimer enters this final cycle.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

