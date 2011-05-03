Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1ECOvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:51:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab1ECOvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:51:01 -0400
Message-ID: <4DC0162A.8020505@redhat.com>
Date: Tue, 03 May 2011 10:50:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH v2 2/2] Filter unevictable page out in deactivate_page
References: <cover.1304433952.git.minchan.kim@gmail.com> <60486ca121ee8f526a0046f47384579e465bb59e.1304433952.git.minchan.kim@gmail.com>
In-Reply-To: <60486ca121ee8f526a0046f47384579e465bb59e.1304433952.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2011 10:48 AM, Minchan Kim wrote:
> It's pointless that deactive_page's pagevec operation about
> unevictable page as it's nop.
> This patch removes unnecessary overhead which might be a bit problem
> in case that there are many unevictable page in system(ex, mprotect workload)
>
> Reviewed-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel<riel@redhat.com>

-- 
All rights reversed
