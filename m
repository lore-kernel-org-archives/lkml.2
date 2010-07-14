Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab0GNIyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 04:54:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43878 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab0GNIyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 04:54:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qlSZEWJGJy28QUtR+gTcuSOLXz7ip/KwYLQY45lEqZDf5yLPXJr/AiLzgkXd0Xagso
         AkRd7/FGG8HD8yfMHrke19qR0fMGMzkZPCJKLPACEad0n8gx11XsfZjHiyj8ZiL/S4jH
         eqpmbKhvwEfEjkZ6i5tvxEonXnmG41eWo3MpI=
MIME-Version: 1.0
In-Reply-To: <4C3D777F.8090702@cs.helsinki.fi>
References: <AANLkTil6opQmTVVxuP1ngz72_ijpLzdlSFWDSyi4whOt@mail.gmail.com>
	<AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
	<20100714083112.GA4627@brouette>
	<AANLkTimo7xnkFwufcxFIsv4WXoV9a4vmSRVFnDFLvtOr@mail.gmail.com>
	<4C3D777F.8090702@cs.helsinki.fi>
Date: Wed, 14 Jul 2010 10:54:21 +0200
Message-ID: <AANLkTin2f6at5ZvRp3fnOyxprxxaZwdJpaVUUh0pU6Ao@mail.gmail.com>
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Zeno Davatz <zdavatz@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mike Galbraith <efault@gmx.de>, Damien Wyart <damien.wyart@free.fr>,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 10:38 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Zeno Davatz wrote:
>>
>> On Wed, Jul 14, 2010 at 10:31 AM, Damien Wyart <damien.wyart@free.fr>
>> wrote:
>>
>>>> On Wed, Jul 14, 2010 at 9:12 AM, Zeno Davatz <zdavatz@gmail.com> wrote:
>>>>>
>>>>> I got a new Intel core-8 i7 processor.
>>>>> I am on kernel uname -a
>>>>> Linux zenogentoo 2.6.35-rc5 #97 SMP Tue Jul 13 16:13:25 CEST 2010 i686
>>>>> Intel(R) Core(TM) i7 CPU 960 @ 3.20GHz GenuineIntel GNU/Linux
>>>>> Sometimes in the middle of nowhere all of a sudden all of my 8-cores
>>>>> are at 100% CPU usage and my machine really lags and hangs and is not
>>>>> useable anymore. Some random process just grabs a bunch CPUs according
>>>>> to htop.
>>>
>>> * Pekka Enberg <penberg@cs.helsinki.fi> [2010-07-14 11:05]:
>>>>
>>>> Why did you enable CONFIG_DEBUG_KMEMLEAK? Memory leak scanning is
>>>> likely the source of these pauses.
>>>
>>> I am seeing the same problem with a Core i7 920 and 2.6.35-rc5, and I do
>>> not have CONFIG_DEBUG_KMEMLEAK enabled, so I think this is not related.
>>>
>>> I do not see anything special in the logs, just the load becoming mad
>>> and almost preventing ssh access. I've been seeing that since the first
>>> 2.6.35 rc I tested (-rc2 or -rc3, I don't remember) and I did not have
>>> time to report it before but I was surprised nobody else did. No problem
>>> with 2.6.34 and 2.6.34.1.
>>
>> same with me. My last build I tested was 2.6.34-rc7. No problems
>> there. No CPU jumps out of nowhere.
>>
>> It is like any application all of a sudden use 400% CPU i.e. htop.
>
> Interesting. Lets CC some scheduler folks for help.

Once it is gdm, once it is firefox-bin once it is htop. Its really od.
Nothing crashes one of those just uses lots of CPU. The machine just
gets really slow and then calms down again and everything is back to
normal.

;)

Maybe a bad temper?

Best
Zeno
