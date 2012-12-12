Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2LLWIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:08:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318Ab2LLWIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:08:19 -0500
Message-ID: <50C8FFF3.1030206@redhat.com>
Date: Wed, 12 Dec 2012 17:06:43 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/8] mm: vmscan: clean up get_scan_count()
References: <1355348620-9382-1-git-send-email-hannes@cmpxchg.org> <1355348620-9382-7-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1355348620-9382-7-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 04:43 PM, Johannes Weiner wrote:
> Reclaim pressure balance between anon and file pages is calculated
> through a tuple of numerators and a shared denominator.
>
> Exceptional cases that want to force-scan anon or file pages configure
> the numerators and denominator such that one list is preferred, which
> is not necessarily the most obvious way:
>
>      fraction[0] = 1;
>      fraction[1] = 0;
>      denominator = 1;
>      goto out;
>
> Make this easier by making the force-scan cases explicit and use the
> fractionals only in case they are calculated from reclaim history.
>
> And bring the variable declarations/definitions in order.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

