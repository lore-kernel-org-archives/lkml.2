Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab0G1HPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:15:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41555 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab0G1HPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=sAb7jo7Q6Q7O8VfKS07p5flz24VBNvYKnf2XMXV0o6emLLEVpy2lTYO04yyCzN57MB
         m7e1ZmUO+4e0kBcRRgpOExrcs8wI9ba0sqrloeDVN5m9Fe9q54WydPeu7ebXRUtEIxfJ
         q2PUuYNKJyiBmj5Z+4czsz5C3W1mDmgytiB1k=
MIME-Version: 1.0
In-Reply-To: <20100728135850.7A92.A69D9226@jp.fujitsu.com>
References: <20100727200804.2F40.A69D9226@jp.fujitsu.com> <AANLkTin47_htYK8eV-6C4QkRK_U__qYeWX16Ly=YK-0w@mail.gmail.com> 
	<20100728135850.7A92.A69D9226@jp.fujitsu.com>
From: dave b <db.pub.mail@gmail.com>
Date: Wed, 28 Jul 2010 17:14:52 +1000
Message-ID: <AANLkTi=fk8B-TnC6m3AoLT7k_G239rMaQA1COwHLxwRM@mail.gmail.com>
Subject: Re: PROBLEM: oom killer and swap weirdness on 2.6.3* kernels
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 July 2010 15:06, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> On 27 July 2010 21:14, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> On 27 July 2010 18:09, dave b <db.pub.mail@gmail.com> wrote:
>> >> > On 27 July 2010 16:09, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> >> >>> > Do you mean the issue will be gone if disabling intel graphics?
>> >> >>> It may be a general issue or it could just be specific :)
>> >> >
>> >> > I will try with the latest ubuntu and report how that goes (that will
>> >> > be using fairly new xorg etc.) it is likely to be hidden issue just
>> >> > with the intel graphics driver. However, my concern is that it isn't -
>> >> > and it is about how shared graphics memory is handled :)
>> >>
>> >>
>> >> Ok my desktop still stalled and no oom killer was invoked when I added
>> >> swap to a live-cd of 10.04 amd64.
>> >>
>> >> *Without* *swap* *on* - the oom killer was invoked - here is a copy of it.
>> >
>> > This stack seems similar following bug. can you please try to disable intel graphics
>> > driver?
>> >
>> > https://bugzilla.kernel.org/show_bug.cgi?id=14933
>>
>> Ok I am not sure how to do that :)
>> I could revert the patch and see if it 'fixes' this :)
>
> Oops, no, revert is not good action. the patch is correct.
> probably my explanation was not clear. sorry.
>
> I did hope to disable 'driver' (i.e. using vga), not disable the patch.

Oh you mean in xorg, I will also blacklist the module. Sure that patch
might not it but in 2.6.26 the problem isn't there :)
