Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab1EAPKP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:10:15 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52679 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1EAPKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=egIqAj0BZwr7/4a8OMssyBT/xON8zCwDAeCY+/xLRieJI08HHuY5vCLdUS3GDGSiF8
         HEVaB7cX8nPsFecW27exZ5zM7ew4DS0PyJ698R7SRTts3+5lrR2fC/waNdk7gBjeTX7o
         y1o3bB7OX4Qas4EtzgBnnMBk4UJ6Mo4gBDyiE=
MIME-Version: 1.0
In-Reply-To: <20110501221459.75E4.A69D9226@jp.fujitsu.com>
References: <BANLkTik2FTKgSSYkyP4XT4pkhOYvpjgSTA@mail.gmail.com>
	<20110428084500.GG12437@cmpxchg.org>
	<20110501221459.75E4.A69D9226@jp.fujitsu.com>
Date: Mon, 2 May 2011 00:10:12 +0900
Message-ID: <BANLkTikr+nW=9a9B=HN9PBir=cpKjXnwLA@mail.gmail.com>
Subject: Re: [RFC 4/8] Make clear description of putback_lru_page
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 1, 2011 at 10:13 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Thu, Apr 28, 2011 at 08:20:32AM +0900, Minchan Kim wrote:
>> > On Wed, Apr 27, 2011 at 5:11 PM, KAMEZAWA Hiroyuki
>> > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > > On Wed, 27 Apr 2011 01:25:21 +0900
>> > > Minchan Kim <minchan.kim@gmail.com> wrote:
>> > >
>> > >> Commonly, putback_lru_page is used with isolated_lru_page.
>> > >> The isolated_lru_page picks the page in middle of LRU and
>> > >> putback_lru_page insert the lru in head of LRU.
>> > >> It means it could make LRU churning so we have to be very careful.
>> > >> Let's clear description of putback_lru_page.
>> > >>
>> > >> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > >> Cc: Mel Gorman <mgorman@suse.de>
>> > >> Cc: Rik van Riel <riel@redhat.com>
>> > >> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> > >> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> > >
>> > > seems good...
>> > > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > >
>> > > But is there consensus which side of LRU is tail? head?
>> >
>> > I don't know. I used to think it's head.
>> > If other guys raise a concern as well, let's talk about it. :)
>> > Thanks
>>
>> I suppose we add new pages to the head of the LRU and reclaim old
>> pages from the tail.
>>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>
> So, It would be better if isolate_lru_page() also have "LRU tail blah blah blah"
> comments.

Okay. I will try it.

>
> anyway,
>        Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>

Thanks.


-- 
Kind regards,
Minchan Kim
