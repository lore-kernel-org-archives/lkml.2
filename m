Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0ESSsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:48:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0ESSsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:48:09 -0400
Message-ID: <4BF4322A.3000507@redhat.com>
Date: Wed, 19 May 2010 14:47:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Shaohua Li <shaohua.li@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tmpfs: Insert tmpfs cache pages to inactive list at first
References: <20100519174327.9591.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100519174327.9591.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 04:44 AM, KOSAKI Motohiro wrote:
> Shaohua Li reported parallel file copy on tmpfs can lead to
> OOM killer. This is regression of caused by commit 9ff473b9a7
> (vmscan: evict streaming IO first). Wow, It is 2 years old patch!

> Thus, now we can use lru_cache_add_anon() instead.
>
> Reported-by: Shaohua Li<shaohua.li@intel.com>
> Cc: Wu Fengguang<fengguang.wu@intel.com>
> Cc: Johannes Weiner<hannes@cmpxchg.org>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: Minchan Kim<minchan.kim@gmail.com>
> Cc: Hugh Dickins<hughd@google.com>
> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
