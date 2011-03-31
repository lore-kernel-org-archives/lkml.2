Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab1CaNZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:25:28 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62913 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757193Ab1CaNZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:25:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=ZA2COI4EZ6n1k/lJL+MpyQhHByTbTTBdrMzCJhcVOh/xbRnjVg3WeJ4Mt+BwFi42pq
         MbJIyX9Fr67SlcVw4k6kKAwKMq7zbKNhWgFnkwfxnpBpRVvXVAsfBv5DykMaTLmouLIu
         3sUUMPT3Z15kW+XYNZ21F0NgXYtRjszj0wICQ=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110331151627.58092365@schatten.dmk.lab>
References: <1301558489-4198-1-git-send-email-florian@mickler.org>
	<1301561386.1904.15.camel@t41.thuisdomein>
	<20110331125305.1e8c70ba@schatten.dmk.lab>
	<AANLkTikmWDu7FZ2A7_CWGCuAeKOeK4x+u8vctCro0mSN@mail.gmail.com>
	<20110331151627.58092365@schatten.dmk.lab>
Date: Thu, 31 Mar 2011 15:25:25 +0200
Message-ID: <AANLkTikC5KC3-DBrtoSSEn4BzQaLyAgBtOHgfAzvnckj@mail.gmail.com>
Subject: Re: [PATCH][POKE] Skip looking for ioapic overrides when ioapics are
 not present
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, mingo@elte.hu, rjw@sisk.pl, zersaa@gmail.com,
        stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 3:16 PM, Florian Mickler <florian@mickler.org> wrote:
> On Thu, 31 Mar 2011 13:01:18 +0200
> Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>
>> >
>> > Thanks for letting me know. Sedat, did you actually test with 2.6.38?
>> >
>> > Regards,
>> > Flo
>>
>> I have and had this patch in my own patch-series *before* Debian
>> included it (IIRC right after Eric committed it to LKML).
>> To answer your question: Yes.
>> I have the patch also in my current linux-next kernels (next-20110331).
>>
>> - Sedat -
>
> Sorry, I meant tested _without_ the patch. (i.e. does Paul's patch work
> or not for you...) And double sorry, if you did already test
> vanilla 2.6.38. Tripple sorry if you already wrote that you did test
> _without_ the patch and it is still needed... I guess in that case I
> should just ditch my copy of 'speed-reading for dummies' ... :) )
>

No worries, no sorries needed for this (I know you fight to get things done).
I can't really say what is w/o Eric's patch.
As I replied to the BR #17772:
I added "lapic" boot-parameter as a result of a perf/NMI patch.
With both things "WorksForMe" I headed to other stuff in kernel development :-).
I was not aware that there was further discussion on the initial patch.

> But anyhow, Eric already stepped up and said that the current state is
> supoptimal, so it doesn't matter if vanilla 2.6.38 (without Eric's
> patch) fixes it for you since it looks like Eric's patch should go in
> nevertheless.
>

I am as always open for testing if there is a new patch around, just
let me know.

- Sedat -
