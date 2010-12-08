Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab0LHINh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 03:13:37 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:62271 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab0LHINg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 03:13:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a/D7l6eNWTaAJrLcIJrpaER/pRSQ/CR5rdHqJ9CE+NMGvnnTjci/ZkhAJCB3/TUYmQ
         xhHcUgLbC+IAZgvRTqe7TD/MuMcG3lWy5hhosJicZ+ALWqqSZm6f0kWyvFw0Ssekf7yL
         o2BbgdgAWdeVGzt/LvyHiJzCMeliwlIvzm1Lg=
MIME-Version: 1.0
In-Reply-To: <20101208165944.174D.A69D9226@jp.fujitsu.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
	<dff7a42e5877b23a3cc3355743da4b7ef37299f8.1291568905.git.minchan.kim@gmail.com>
	<20101208165944.174D.A69D9226@jp.fujitsu.com>
Date: Wed, 8 Dec 2010 17:13:35 +0900
Message-ID: <AANLkTik4mtr8T6PddQopi4cwWGRmJ+-utykgjywGoxj+@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] add profile information for invalidated page reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KOSAKI,

On Wed, Dec 8, 2010 at 5:02 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> This patch adds profile information about invalidated page reclaim.
>> It's just for profiling for test so it would be discard when the series
>> are merged.
>>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Wu Fengguang <fengguang.wu@intel.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Nick Piggin <npiggin@kernel.dk>
>> Cc: Mel Gorman <mel@csn.ul.ie>
>> ---
>>  include/linux/vmstat.h |    4 ++--
>>  mm/swap.c              |    3 +++
>>  mm/vmstat.c            |    3 +++
>>  3 files changed, 8 insertions(+), 2 deletions(-)
>
> Today, we have tracepoint. tracepoint has no overhead if it's unused.
> but vmstat has a overhead even if unused.
>
> Then, all new vmstat proposal should be described why you think it is
> frequently used from administrators.

It's just for easy gathering the data when Ben will test.
I never want to merge it in upstream and even mmtom.

If you don't like it for just testing, I am happy to change it with tracepoint.

Thanks.
-- 
Kind regards,
Minchan Kim
