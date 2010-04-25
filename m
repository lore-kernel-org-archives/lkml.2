Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0DYRZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 13:25:47 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38864 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab0DYRZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 13:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=NeUkCHlZlJuoBpNHhyd6WyO5lnIqHkAOh/5NS0xim4q+58Y1XQFbd77OdPKBJVPpQR
         kRl9037L/qIJfFvFV1g5VbzFbSAXeGaA2B+y6Tu19Mil1uXsBeCrjPGNGQrXJZKwSWOt
         jZHYcRFjfFhIlSbFZU/3vydU6Hwzn9V8fheh4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4BD4757E.8020503@example.com>
References: <l2z2d0a357f1004250811w6da355ebp95d1730473026c22@mail.gmail.com>
	 <4BD45E68.4080900@example.com>
	 <g2z2d0a357f1004250931pf5880c60l32fd0643e0f14bde@mail.gmail.com>
	 <4BD46F9C.5060500@example.com>
	 <1272213597.2069.32.camel@edumazet-laptop>
	 <j2p2d0a357f1004250955i59969a2cp9fd9eb9f3ef22d4b@mail.gmail.com>
	 <4BD4757E.8020503@example.com>
Date: Sun, 25 Apr 2010 19:25:44 +0200
Message-ID: <x2t2d0a357f1004251025q5a284b0fwa351f762acdf62e4@mail.gmail.com>
Subject: Re: [2.6.34-rc5-git6] EIP: is at inet6_csk_bind_conflict + 06xe/0xb7 
	[ipv6]
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: piotr@hosowicz.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Jiri Olsa <jolsa@redhat.com>, Jongman Heo <jongman.heo@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 7:01 PM, Piotr Hosowicz <piotr@hosowicz.com> wrote:
> On 25.04.2010 18:55, Sedat Dilek wrote:
>>
[...]
>> On Sun, Apr 25, 2010 at 6:39 PM, Eric Dumazet<eric.dumazet@gmail.com>
>>  wrote:
>>>
>>> Le dimanche 25 avril 2010 à 18:36 +0200, Piotr Hosowicz a écrit :
>>>>
>>>> On 25.04.2010 18:31, Sedat Dilek wrote:
>>>>>
>>>>> [ CCing netdev ML ]
>>>>>
>>>>> Confirmed: The revert-patch [1] fixes the problem here.
>>>>
>>>> I confirm, I've built a git6 kernel and it works fine.
>>>>
>>>>> See also "Bug 15847 -  crash in inet6_csk_bind_conflict" [2].
>>>>>
>>>>> Feel free to add a... Tested-by: Sedat Dilek<sedat.dilek@gmail.com>
>>>>
>>>> I added created and tested phrase in my archive. ;-) Thank you a lot. I
>>>> hope there will be no this error in git7.
>>>>
>>>
>>> Did you test the proposed fix ?
>
> Eric, but where to get the proposed fix as a patch? I looked at kernel's
> bugzilla and there is no such thing. As for now I applied Sedat's reverse
> patch and now I am booted fine in git6 kernel.
>
> Regards,
>
> Piotr Hosowicz
>

For easy catching proposed patched to LKML look at <patchwork.kernel.org> [1].
There you find other mailing-lists and further patches.
Cut-N-Paste excerpts of Eric's email should also work :-).

- Sedat -

[1] https://patchwork.kernel.org/project/LKML/list/
[2] https://patchwork.kernel.org/patch/94961/
