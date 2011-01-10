Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab1AJPpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:45:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60947 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1AJPpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:45:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ARuwamKV4tJa3fPB88NkOZRfPFeRKeDmADIDENGL9DHzyjBkXXV18O4Val66mHRRxR
         zp1TxPeHFG2nO1xXc92Qfe1FMY/NOSAeeKjzP8HSR5H2Hzq4X7GKXSzc2v4bCBeGyU0Y
         1C7km3N/th+wu1zbp9vlq1i2dhDqrxwjdAOfw=
MIME-Version: 1.0
In-Reply-To: <20110108222838.GE23189@cmpxchg.org>
References: <cover.1293031046.git.minchan.kim@gmail.com>
	<4c25f88c476520c47e3b0217e09b6b2d58638685.1293031046.git.minchan.kim@gmail.com>
	<20110108222838.GE23189@cmpxchg.org>
Date: Tue, 11 Jan 2011 00:45:51 +0900
Message-ID: <AANLkTim=+aofmFG=OHTz6fuBC27+Mto31c75Tp_bYrph@mail.gmail.com>
Subject: Re: [PATCH 4/7] swap: Change remove_from_page_cache
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 9, 2011 at 7:28 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Thu, Dec 23, 2010 at 12:32:46AM +0900, Minchan Kim wrote:
>> This patch series changes remove_from_page_cache's page ref counting
>> rule. Page cache ref count is decreased in delete_from_page_cache.
>> So we don't need decreasing page reference by caller.
>>
>> Cc:Hugh Dickins <hughd@google.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>>  mm/shmem.c |    3 +--
>
> Patch subject should probably say 'shmem' instead of 'swap'.

Thanks, Hannes.
Will fix.

>
> Otherwise,
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
>



-- 
Kind regards,
Minchan Kim
