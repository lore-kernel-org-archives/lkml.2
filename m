Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872Ab1EBO4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:56:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab1EBO4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:56:52 -0400
Message-ID: <4DBEC626.7060704@redhat.com>
Date: Mon, 02 May 2011 10:56:38 -0400
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
Subject: Re: [PATCH 1/2] Check PageUnevictable in lru_deactivate_fn
References: <cover.1304261567.git.minchan.kim@gmail.com> <c7a7b3ceafe4fdc4bc038774374504827c01481f.1304261567.git.minchan.kim@gmail.com>
In-Reply-To: <c7a7b3ceafe4fdc4bc038774374504827c01481f.1304261567.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2011 11:03 AM, Minchan Kim wrote:
> The lru_deactivate_fn should not move page which in on unevictable lru
> into inactive list. Otherwise, we can meet BUG when we use isolate_lru_pages
> as __isolate_lru_page could return -EINVAL.
> It's really BUG and let's fix it.
>
> Reported-by: Ying Han<yinghan@google.com>
> Tested-by: Ying Han<yinghan@google.com>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel<riel@redhat.com>

-- 
All rights reversed
