Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1BFUVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 15:21:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab1BFUVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 15:21:09 -0500
Message-ID: <4D4F0291.4070301@redhat.com>
Date: Sun, 06 Feb 2011 15:20:33 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <mszeredi@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] mm: Add hook of freepage
References: <1297004934-4605-1-git-send-email-minchan.kim@gmail.com>
In-Reply-To: <1297004934-4605-1-git-send-email-minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2011 10:08 AM, Minchan Kim wrote:
> Recently, "Call the filesystem back whenever a page is removed from
> the page cache(6072d13c)" added new freepage hook in page cache
> drop function.
>
> So, replace_page_cache_page should call freepage to support
> page cleanup to fs.
>
> Cc: Miklos Szeredi<mszeredi@suse.cz>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Mel Gorman<mel@csn.ul.ie>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
