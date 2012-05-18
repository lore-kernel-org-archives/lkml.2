Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab2ERFDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 01:03:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46361 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab2ERFDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 01:03:22 -0400
Message-ID: <4FB5D80B.8060000@gmail.com>
Date: Fri, 18 May 2012 13:03:07 +0800
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
Organization: NJU
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] refault distance-based file cache sizing
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org> <4FB33A4E.1010208@gmail.com> <4FB4F902.1050708@redhat.com>
In-Reply-To: <4FB4F902.1050708@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2012年05月17日 21:11, Rik van Riel wrote:
> On 05/16/2012 01:25 AM, nai.xia wrote:
>> Hi Johannes,
>>
>> Just out of curiosity(since I didn't study deep into the
>> reclaiming algorithms), I can recall from here that around 2005,
>> there was an(or some?) implementation of the "Clock-pro" algorithm
>> which also have the idea of "reuse distance", but it seems that algo
>> did not work well enough to get merged?
>
> The main issue with clock-pro was scalability.
>
> Johannes has managed to take the good parts of clock-pro,
> and add it on top of our split lru VM, which lets us keep
> the scalability, while still being able to deal with file
> faults from beyond the inactive list.
>

Hmm, I see. Thanks for the reply.

