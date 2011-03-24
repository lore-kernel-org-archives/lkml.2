Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab1CXHl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:41:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36479 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933550Ab1CXHl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=F047B3ej55K5SORSfhIL0A8rpA1FbBwjdFw0+anFQ4THDU8fdMyb/hDfD8/XFPP7q9
         azxQ8GWGM3siOnOKrBPUFiSnAOQfXrz5t0yqCTR3zJOhsEUyi2kGybC9YT6MNwvIb4Rx
         rvhcX6uaKtaITHjArIclFjpyf55W83s8UFLoA=
MIME-Version: 1.0
In-Reply-To: <AANLkTimafdn8wPD7Zu3tK4PLgik=-0MeE62nGxq7ks4N@mail.gmail.com>
References: <20110324160349.CC83.A69D9226@jp.fujitsu.com>
	<AANLkTi=rOCdojotYG3wyX2Bt+aDrgxTO9DQWe7h1BQrC@mail.gmail.com>
	<20110324162936.CC87.A69D9226@jp.fujitsu.com>
	<AANLkTimafdn8wPD7Zu3tK4PLgik=-0MeE62nGxq7ks4N@mail.gmail.com>
Date: Thu, 24 Mar 2011 16:41:25 +0900
Message-ID: <AANLkTimPKEODvp3MmYmFrmEYSbAPr1b4dTq6fDHWAEsD@mail.gmail.com>
Subject: Re: [PATCH 1/5] vmscan: remove all_unreclaimable check from direct
 reclaim path completely
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 4:34 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Thu, Mar 24, 2011 at 4:28 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
>>> For example, In 4G desktop system.
>>> 32M full scanning and fail to reclaim a page.
>>> It's under 1% coverage.
>>
>> ?? I'm sorry. I haven't catch it.
>> Where 32M come from?
>
> (1<<12) * 4K + (1<<11) + 4K + .. (1 << 0) + 4K in shrink_zones.

Stupid me.
Sorry. my calculation is totally wrong.

Your explanation was perfect
Okay. I don't have any objection to your solution.



-- 
Kind regards,
Minchan Kim
