Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198Ab1D0XUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:20:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50774 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab1D0XUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bZbis931A5x7e2lwMtcUHRiaS0z4CuLc4NpcJC4dG2f3g9E8pKDXtOwqo1AnXa32Pf
         0pZvzl47rsLI2pecBNNBo+IeeumqDX4/RPIbbYqabozj5E3PQ/zHadPDcWgfCq5Du01f
         WPpe2ZEUrV09iHINIgv+46dXZUk4l3KjyRRxI=
MIME-Version: 1.0
In-Reply-To: <20110427171157.3751528f.kamezawa.hiroyu@jp.fujitsu.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<bb2acc3882594cf54689d9e29c61077ff581c533.1303833417.git.minchan.kim@gmail.com>
	<20110427171157.3751528f.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 28 Apr 2011 08:20:32 +0900
Message-ID: <BANLkTik2FTKgSSYkyP4XT4pkhOYvpjgSTA@mail.gmail.com>
Subject: Re: [RFC 4/8] Make clear description of putback_lru_page
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 5:11 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 27 Apr 2011 01:25:21 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> Commonly, putback_lru_page is used with isolated_lru_page.
>> The isolated_lru_page picks the page in middle of LRU and
>> putback_lru_page insert the lru in head of LRU.
>> It means it could make LRU churning so we have to be very careful.
>> Let's clear description of putback_lru_page.
>>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
> seems good...
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> But is there consensus which side of LRU is tail? head?

I don't know. I used to think it's head.
If other guys raise a concern as well, let's talk about it. :)
Thanks

> I always need to revisit codes when I see a word head/tail....
>
>
>



-- 
Kind regards,
Minchan Kim
