Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab2B1IcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:32:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51132 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab2B1IcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:32:04 -0500
References: <1330041476-719-1-git-send-email-kjwinchester@gmail.com> <20120227115905.GB9943@elte.hu> <CAELBVzDQx-geNELEvHYheSL0hKbaXfUAvjperNcPELThT9bqWg@mail.gmail.com> <4F4C4D5C.70908@zytor.com> <20120228082422.GG21106@elte.hu>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120228082422.GG21106@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/5] x86: Cleanup and simplify cpu-specific data
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 28 Feb 2012 00:31:02 -0800
To: Ingo Molnar <mingo@elte.hu>
CC: Kevin Winchester <kjwinchester@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Message-ID: <ad7809d2-4c66-4d55-929b-2c1ae76f1420@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better yet, fix the problem...

Ingo Molnar <mingo@elte.hu> wrote:

>
>* H. Peter Anvin <hpa@zytor.com> wrote:
>
>> >In function ‘copy_from_user’,
>> >     inlined from ‘pktgen_if_write’ at net/core/pktgen.c:877:20:
>>
>>/home/kevin/linux/linux-2.6/arch/x86/include/asm/uaccess_32.h:211:26:
>> >error: call to ‘copy_from_user_overflow’ declared with attribute
>> >error: copy_from_user() buffer size is not provably correct
>> >make[2]: *** [net/core/pktgen.o] Error 1
>> >
>> >On:
>> >
>> >gcc (GCC) 4.6.2 20120120 (prerelease)
>> >
>> >Is that my fault, or something else?
>> >
>> >Kevin
>> >
>> 
>> That comes from compiling with warnings as errors.  Not that someone
>> shouldn't look at that kind of problem.
>
>Can probably be worked around by disabling:
>
>CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
