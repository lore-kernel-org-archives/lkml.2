Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0IBDS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:18:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63413 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab0IBDS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Tb/MyS4/i7WMznmQtxU9bJQs1GjYrXt9kRg3Lqa2DUp/EpndJUCCY+wDTKFUuEG+Kn
         MHyqL9G8ty0yM1QaharZGWNYnC97fpo68FZYxhXDvQ5tja0GOMZhruu8Gaidhq858njd
         M5rIXUPQCkUTQyzH6PPorpJQD68+cj5usUwQc=
MIME-Version: 1.0
In-Reply-To: <20100902115640.D071.A69D9226@jp.fujitsu.com>
References: <20100902091206.D053.A69D9226@jp.fujitsu.com>
	<AANLkTiknTqHw11xRXNP4X-0yN1=rWyCh3MJV=HjRiZQJ@mail.gmail.com>
	<20100902115640.D071.A69D9226@jp.fujitsu.com>
Date: Thu, 2 Sep 2010 12:18:27 +0900
Message-ID: <AANLkTi=DrT1QUTPoUOVBt-d+b-4N_JGDDzaxZqrujD7P@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] vmscan: don't use return value trick when oom_killer_disabled
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "M. Vefa Bicakci" <bicave@superonline.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 12:05 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > I don't want to send risky patch to -stable.
>>
>> Still I don't want to use oom_killer_disabled magic.
>> But I don't want to prevent urgent stable patch due to my just nitpick.
>>
>> This is my last try(just quick patch, even I didn't tried compile test).
>
> Looks like conceptually correct. If you will test it and fix whitespace damage,
> I'll ack this one gladly.
>
> Thanks.
>

I will resend formal patch ASAP. Maybe tonight after out of office.
Thanks for quick reply.


-- 
Kind regards,
Minchan Kim
