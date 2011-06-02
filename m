Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639Ab1FBM1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:27:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39313 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543Ab1FBM1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:27:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HjDSmnrYQxlM7d9zrE4I02rOWJv3wid4R7CNFFU/ibbeHlY8j333VUi9rgYuOcUMxU
         9WLAbsXRzLlTLHAv4kBbX4KausY9Bp02w7UFjxqHbzno1kGj0EtxG5YdEBF7JpG5pQjx
         DkAWj55JnL+djxRdhWTXq52rtToSm37PeM8Q8=
MIME-Version: 1.0
In-Reply-To: <20110530094337.GF20166@tiehlicka.suse.cz>
References: <BANLkTinLvqa0DiayLOwvxE9zBmqb4Y7Rww@mail.gmail.com>
	<20110523112558.GC11439@tiehlicka.suse.cz>
	<BANLkTi=2SwKFfwBxrQr3xLYSUzoGOy6oKA@mail.gmail.com>
	<20110530094337.GF20166@tiehlicka.suse.cz>
Date: Thu, 2 Jun 2011 20:27:39 +0800
Message-ID: <BANLkTimaHMHv44CP0RH-Mur-Mb6qyR341Q@mail.gmail.com>
Subject: Re: [Patch] mm: remove noswapaccount kernel parameter
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 5:43 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Mon 23-05-11 19:50:21, Am??rico Wang wrote:
>> On Mon, May 23, 2011 at 7:25 PM, Michal Hocko <mhocko@suse.cz> wrote:
>> > On Mon 23-05-11 19:08:08, Am??rico Wang wrote:
>> >> noswapaccount is deprecated by swapaccount=0, and it is scheduled
>> >> to be removed in 2.6.40.
>> >
>> > Similar patch is already in the Andrew's tree
>>
>> Ah, my google search failed to find it. :-/
>>
>> > (memsw-remove-noswapaccount-kernel-parameter.patch). Andrew, are you
>> > going to push it?
>> > Btw. the patch is missing documentation part which is present here.
>> >
>>
>> Hmm, maybe I should send a delta patch... Andrew?
>
> Have you reposted that patch? The primary patch which removes the
> paramter already hit the Linus tree (a2c8990a).
>

Cool, will resend it!
