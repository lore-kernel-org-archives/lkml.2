Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab1DNA5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 20:57:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55498 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757693Ab1DNA5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 20:57:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EoB6ek/ypXbKJtZ/9qW/22a5UR5UEdwQqSxvfG5FB5KDYIDlKd/NvvjgeUFye82OpN
         he6OuqOdon84hXXRuppDY2Oj8T7sMQlNTLcci7jUvRa9vn8xrN2urp4tCBpCTt9K/Yx7
         aCbZ/A4F/vb78E8i8wvyTePTQzVWUjMpV2anc=
MIME-Version: 1.0
In-Reply-To: <20110414093549.80539260.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110329101234.54d5d45a.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=pMapbVoUO6+7nUEg1bY4fb844-A@mail.gmail.com>
	<20110414092033.0809.A69D9226@jp.fujitsu.com>
	<20110414093549.80539260.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 14 Apr 2011 09:57:42 +0900
Message-ID: <BANLkTikj9EcEQTmz6vDBAW6oGnqyhnCkSQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] forkbomb killer
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, KOSAKI and Kame.

On Thu, Apr 14, 2011 at 9:35 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 14 Apr 2011 09:20:41 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> Hi, Minchan, Kamezawa-san,
>>
>> > >> So whenever user push sysrq, older tasks would be killed and at last,
>> > >> root forkbomb task would be killed.
>> > >>
>> > >
>> > > Maybe good for a single user system and it can send Sysrq.
>> > > But I myself not very excited with this new feature becasuse I need to
>> > > run to push Sysrq ....
>> > >
>> > > Please do as you like, I think the idea itself is interesting.
>> > > But I love some automatic ones. I do other jobs.
>> >
>> > Okay. Thanks for the comment, Kame.
>> >
>> > I hope Andrew or someone gives feedback forkbomb problem itself before
>> > diving into this.
>>
>> May I ask current status of this thread? I'm unhappy if our kernel keep
>> to have forkbomb weakness. ;)
>
> I've stopped updating but can restart at any time. (And I found a bug ;)
>
>> Can we consider to take either or both idea?
>>
> I think yes, both idea can be used.
> One idea is
>  - kill all recent threads by Sysrq. The user can use Sysrq multiple times
>   until forkbomb stops.
> Another(mine) is
>  - kill all problematic in automatic. This adds some tracking costs but
>   can be configurable.
>
> Thanks,
> -Kame
>
>

Unfortunately, we didn't have a slot to discuss the oom and forkbomb.
So, personally, I talked it with some guys(who we know very well :) )
for a moment during lunch time at LSF/MM. It seems he doesn't feel
strongly we really need it and still I am not sure it, either.

Now most important thing is to listen other's opinions about we really
need it and  we need it in kernel.

And I have a idea to implement my one in automatic, too.  :)

Thanks for your interest.

-- 
Kind regards,
Minchan Kim
