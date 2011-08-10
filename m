Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab1HJVQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 17:16:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42014 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab1HJVQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 17:16:15 -0400
References: <cover.1312988155.git.luto@mit.edu> <8449fb3abf89851fd6b2260972666a6f82542284.1312988155.git.luto@mit.edu> <4E42BDFF.5060507@zytor.com> <CAObL_7Ge7PDSqt8sfBAODDnuA34oCsA4Lat24RXGe1DPAKdXqA@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CAObL_7Ge7PDSqt8sfBAODDnuA34oCsA4Lat24RXGe1DPAKdXqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 3/3] x86-64: Rework vsyscall emulation and add vsyscall= parameter
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 10 Aug 2011 16:14:29 -0500
To: Andrew Lutomirski <luto@mit.edu>
CC: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>
Message-ID: <ad7e51af-a4cf-4b30-972f-8704ef748d24@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lutomirski <luto@mit.edu> wrote:

>On Wed, Aug 10, 2011 at 1:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 08/10/2011 10:15 AM, Andy Lutomirski wrote:
>>> There are three choices:
>>>
>>> vsyscall=native: Vsyscalls are native code that issues the
>>> corresponding syscalls.
>>>
>>> vsyscall=emulate (default): Vsyscalls are emulated by instruction
>>> fault traps, tested in the bad_area path.  The actual contents of
>>> the vsyscall page is the same as the vsyscall=native case except
>>> that it's marked NX.  This way programs that make assumptions about
>>> what the code in the page does will not be confused when they read
>>> that code.
>>>
>>> vsyscall=none: Trying to execute a vsyscall will segfault.
>>>
>>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>>
>> Hi Andy,
>>
>> This patch doesn't apply.  What is your baseline for this patch?
>
>My baseline was a commit that probably only lives in my tree, but the
>patches should apply cleanly on top of
>c149a665ac488e0dac22a42287f45ad1bda06ff1, which is the current
>tip/x86/vdso.
>
>--Andy

Please rebase your patch on the current -linus since it appears to have changed since x86/vdso was merged.

    -hpa
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
