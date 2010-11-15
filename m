Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab0KOHqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 02:46:21 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50884 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660Ab0KOHqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 02:46:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lte9k5mz46BZ8WzLOkz9IPvuMDAMvRZ9slhtOHsJ4C7NzYgRMFyGEF+hiI+Jz9bS7t
         IWFHwUnBMs1Hc6IbsvaiwyUk4nLrOaJ6NTBQ5JRX01DDaIZUlox39Z29Rr5EBWIuit6U
         IYsU8oDUv9IfosO8bEweULKkSc14yFd6THF1o=
MIME-Version: 1.0
In-Reply-To: <20101115162713.BF12.A69D9226@jp.fujitsu.com>
References: <20101115160413.BF0F.A69D9226@jp.fujitsu.com>
	<AANLkTim0vCJkMoH5P0wCN9J6340rDsscyNBQ+R+_ph8m@mail.gmail.com>
	<20101115162713.BF12.A69D9226@jp.fujitsu.com>
Date: Mon, 15 Nov 2010 16:46:18 +0900
Message-ID: <AANLkTi=tZkRnbDhqx=V5TwKh9S1SouEqO5pU_9C-kope@mail.gmail.com>
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ben Gamari <bgamari.foss@gmail.com>, linux-kernel@vger.kernel.org,
        rsync@lists.samba.org, linux-mm@kvack.org,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 4:28 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Mon, Nov 15, 2010 at 4:09 PM, KOSAKI Motohiro
>> <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> > Because we have an alternative solution already. please try memcgroup :)
>> >>
>> >> I think memcg could be a solution of them but fundamental solution is
>> >> that we have to cure it in VM itself.
>> >> I feel it's absolutely absurd to enable and use memcg for amending it.
>> >>
>> >> I wonder what's the problem in Peter's patch 'drop behind'.
>> >> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg179576.html
>> >>
>> >> Could anyone tell me why it can't accept upstream?
>> >
>> > I don't know the reason. And this one looks reasonable to me. I'm curious the above
>> > patch solve rsync issue or not.
>> > Minchan, have you tested it yourself?
>>
>> Still yet. :)
>> If we all think it's reasonable, it would be valuable to adjust it
>> with current mmotm and see the effect.
>
> Who can make rsync like io pattern test suite? a code change is easy. but
> to comfirm justification is more harder work.

Maybe Ben, Brian those reports the problem. :)



-- 
Kind regards,
Minchan Kim
