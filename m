Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab0ICVYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 17:24:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab0ICVYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 17:24:05 -0400
Message-ID: <4C816760.4010807@redhat.com>
Date: Fri, 03 Sep 2010 17:23:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>, Ying Han <yinghan@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap
 system
References: <1283096628-4450-1-git-send-email-minchan.kim@gmail.com> <20100903140649.09dee316.akpm@linux-foundation.org>
In-Reply-To: <20100903140649.09dee316.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2010 05:06 PM, Andrew Morton wrote:

> We don't have any quantitative data on the effect of these excess tlb
> flushes, which makes it difficult to decide which kernel versions
> should receive this patch.
>
> Help?

I assume it is a relatively small performance optimization,
as well as a nice code cleanup ... so probably no real hurry
to get it upstream (next time you send Linus mm patches?),
and no real reason to have it backported to a -stable kernel
either.

-- 
All rights reversed
