Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1LKBjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 20:39:52 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:42066 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751266Ab1LKBju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 20:39:50 -0500
Message-ID: <4EE409CA.3080404@tao.ma>
Date: Sun, 11 Dec 2011 09:39:22 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vmscan/trace: Add 'active' and 'file' info to trace_mm_vmscan_lru_isolate.
References: <1323533451-2953-1-git-send-email-tm@tao.ma> <4EE388D0.2090608@gmail.com>
In-Reply-To: <4EE388D0.2090608@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.52.233 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2011 12:29 AM, KOSAKI Motohiro wrote:
> (12/10/11 11:10 AM), Tao Ma wrote:
>> From: Tao Ma<boyu.mt@taobao.com>
>>
>> In trace_mm_vmscan_lru_isolate, we don't output 'active' and 'file'
>> information to the trace event and it is a bit inconvenient for the
>> user to get the real information(like pasted below).
>> mm_vmscan_lru_isolate: isolate_mode=2 order=0 nr_requested=32 nr_scanned=32
>> nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0
>>
>> So this patch adds these 2 info to the trace event and it now looks like:
>> mm_vmscan_lru_isolate: isolate_mode=2 order=0 nr_requested=32 nr_scanned=32
>> nr_taken=32 contig_taken=0 contig_dirty=0 contig_failed=0 lru=1,0
> 
> addition is ok to me. but lru=1,0 is not human readable. I suspect
> people will easily forget which value is active.
Sure, I can change it to something like "active=1,file=0".
Maybe I am too worried about the memory used.
So if there is no objection, I will change it.

Thanks
Tao
