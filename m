Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab0HCJSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:18:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53427 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab0HCJSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:18:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hjZx+AW6+8V0ogvA8aeldzw9VPVbaXxrTh6FNwPyqfrpKb7/cTViZrImCuSFWP7e7b
         vINWrU2pHvpn1ubqIQsTQcfeD74qcbRORoAOKzwnjd6JqyjWHW1hxAv6j9pFdl51FkxA
         UylrpyUscKbhWBHLVMj8lPA6pU5wIMuCDvWbI=
MIME-Version: 1.0
In-Reply-To: <1280826924.4c57de2c3a6b0@imp.free.fr>
References: <AANLkTinGoUml9PQ8w7flukqwF9V1ae-YafiDVQy6Q8gC@mail.gmail.com>
	<AANLkTimgn1Xa0YIwjC6xOfNDjlqJSQYy65ZvqCtlMWHD@mail.gmail.com>
	<1279100846.8592.53.camel@e102109-lin.cambridge.arm.com>
	<4C3D89AC.4040303@cs.helsinki.fi>
	<1279205891.6664.46.camel@e102109-lin.cambridge.arm.com>
	<AANLkTikJeA-bZEk652QwwT4iY21v5tr6RCzcZAZGgS8D@mail.gmail.com>
	<4C3F2F52.2050101@cs.helsinki.fi>
	<20100715162805.GA10240@brouette>
	<20100715191638.GA3694@brouette>
	<AANLkTim7SURv8DPTLC2JwOJvv1WMAR4mmyBp9XqXw_Py@mail.gmail.com>
	<20100715200012.GA4175@brouette>
	<AANLkTilnLXVSkWfnaPtpzxH-C3-5h1mnBz3O0vAFHG32@mail.gmail.com>
	<1280826359.1923.440.camel@laptop>
	<AANLkTi=VuLwcmjTpOeK-OzgiWeycu14hJpfUuH9cKnUj@mail.gmail.com>
	<1280826924.4c57de2c3a6b0@imp.free.fr>
Date: Tue, 3 Aug 2010 11:18:12 +0200
Message-ID: <AANLkTimM_jTTRVsJdht9gyBiiBw758nP4_pw-dx5OtZn@mail.gmail.com>
Subject: Re: kmemleak, cpu usage jump out of nowhere
From: Zeno Davatz <zdavatz@gmail.com>
To: damien.wyart@free.fr
Cc: Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        mingo@elte.hu, yinghai@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 11:15 AM,  <damien.wyart@free.fr> wrote:
>> > Vacation.. but now I'm back ;-)
>> >
>> > Even something simple as: perf top -r 1 (make sure you're root in order
>> > to run with real-time prios) could give a clue as to what is consuming
>> > all your cpu-time.
>> >
>> > Or did the issue get sorted already?
>>
>> Thank you for the hint.
>>
>> I am on 2.6.35 now and all seems to be fine again.
>
> Are you 100% sure you compiled it with CONFIG_NO_BOOTMEM enabled?
>
> I did not test 2.6.35 yet but I did not see anything related to this bug
> commited since the discussion so I am very surprised the problem disappeared by
> itself...
>
> Will be on vacation very soon, so not sure I will have time to test 2.6.35
> before leaving.

Yes: I got:

# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set

in my .config.

Linux zenogentoo 2.6.35 #122 SMP Mon Aug 2 10:26:05 CEST 2010 i686
Intel(R) Core(TM) i7 CPU 960 @ 3.20GHz GenuineIntel GNU/Linux

Best
Zeno
