Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab0KKIeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 03:34:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39026 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab0KKIeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 03:34:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Vu5FOQIkWtwBqZ0qxZ8c3PCQyolRypAuXKEndEsZq55X4wUM0C4ZxUwlWZa+AwKMSz
         HtwudCa9JS9y9Kng5sBMW95j6wjr+7MSjxobULpvFuY+k55cKsWnUbGU0wwwMd/k/0KB
         m65kPia0zLDuEFnmnRVJbuPwlq14moR5pDuqM=
MIME-Version: 1.0
In-Reply-To: <AANLkTim+BAYKWqiJzSQQLc4e_yNkMsNNnEp5u8YgC2Fk@mail.gmail.com>
References: <AANLkTinwAL8dFsDbd-ZTQEcEziq6jZk82KPzNqMVxnOx@mail.gmail.com>
	<AANLkTim+BAYKWqiJzSQQLc4e_yNkMsNNnEp5u8YgC2Fk@mail.gmail.com>
Date: Thu, 11 Nov 2010 17:34:15 +0900
X-Google-Sender-Auth: LbBGMu99fbicG1uL-SdW5a8lPoI
Message-ID: <AANLkTimXfstwyBzoXjY=iX+QBQSswy4_Rq5TjApqkYqJ@mail.gmail.com>
Subject: Re: [Questions] How to run 'perf top' on ARM to profile kernel
 functions with modules loaded
From: Kyungmin Park <kmpark@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 4:52 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> 2010/11/11 Ming Lei <tom.leiming@gmail.com>:
>> Hi,
>>
>> 'perf top' can't display any functions when modules are loaded on ARM.
>
> Sorry, should be can't display any kernel functions when modules are loaded
> on ARM.
>
> Also, when modules are loaded, 'perf report' can't display functions names,
> follows result of 'perf report':
>

Hi,

I tried to build the perf as static and build success on ARM. But
there's no display and no top results also.
How do you build the perf on ARM? any hints or clues?

Thank you,
Kyungmin Park
> root@beagleboard:~# perf report
> # Events: 4K cycles
> #
> # Overhead      Command      Shared Object                  Symbol
> # ........  ...........  .................  ......................
> #
>    97.36%      swapper  [musb_hdrc]        [k]  10466c4
>     2.19%         perf  [musb_hdrc]        [k]  10da070
>     0.09%  ksoftirqd/0  [musb_hdrc]        [k]  10db998
>     0.06%         perf  libc-2.9.so        [.] memchr
>     0.04%         perf  libc-2.9.so        [.]    663c0
>     0.02%         perf  perf               [.]     2e80
>     0.02%         perf  libc-2.9.so        [.] closedir
>     0.02%         perf  libc-2.9.so        [.] __read
>     0.02%  flush-179:0  [musb_hdrc]        [k]  10ff124
>     0.02%         perf  libc-2.9.so        [.] memset
>     0.02%         perf  libc-2.9.so        [.] __memcpy_chk
>     0.02%         perf  perf               [.] event__synthesize_comm
>     0.02%         perf           ffff0fc4  [.] ffff0fc4
>     0.02%         perf  perf               [.] hex2u64
>     0.02%         perf  libc-2.9.so        [.] _IO_vfprintf
>     0.02%         perf  libc-2.9.so        [.] fgets
>     0.02%         perf  libpthread-2.9.so  [.] flockfile
>     0.02%         perf  perf               [.] kallsyms__parse
>     0.02%         perf  libc-2.9.so        [.] _IO_getline_info
>
> Any suggestions or comments?
>
> thanks,
> --
> Lei Ming
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
