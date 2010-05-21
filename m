Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab0EUCBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 22:01:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449Ab0EUCBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 22:01:07 -0400
Message-ID: <4BF5E92C.5020507@redhat.com>
Date: Thu, 20 May 2010 22:00:12 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tmpfs: Insert tmpfs cache pages to inactive list at first
References: <20100519174327.9591.A69D9226@jp.fujitsu.com> <alpine.DEB.1.00.1005201822120.19421@tigran.mtv.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.1005201822120.19421@tigran.mtv.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 09:31 PM, Hugh Dickins wrote:

> Acked-by: Hugh Dickins<hughd@google.com>
>
> Thanks - though I don't quite agree with your description: I can't
> see why the lru_cache_add_active_anon() was ever justified - that
> "active" came in along with the separate anon and file LRU lists.

I guess I kind of expected that function to be used by
anonymous pages, when I wrote it.  Except we use a
different variant from do_anonymous_page :)

-- 
All rights reversed
