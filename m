Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2L1BKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 20:10:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60024 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab2L1BKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 20:10:12 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQV2+AaGjyQBD=f8kKWDucbcnrk_UNHPi3Y=HtQCuYcYAQ@mail.gmail.com>
References: <20121227182232.GA10054@x1.alien8.de> <CAE9FiQXpAB_AFtHF_NN7yr2iP2OOLgMir8MNvYUUc15k83_3zg@mail.gmail.com> <50DCE160.2040707@zytor.com> <CAE9FiQV2+AaGjyQBD=f8kKWDucbcnrk_UNHPi3Y=HtQCuYcYAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86, realmode: set real_mode permissions early
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 27 Dec 2012 17:09:42 -0800
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <bbda41ab-0b8c-45f9-a7e4-be05e7c9388d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems ok.

Yinghai Lu <yinghai@kernel.org> wrote:

>On Thu, Dec 27, 2012 at 4:01 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 12/27/2012 03:56 PM, Yinghai Lu wrote:
>>>>
>>>>
>>>> I'm looking at this patch in the -v8 branch: you need to update the
>>>> comment above that function to say that trampoline code needs to be
>>>> marked X now earlier.
>>>
>>>
>>> Not sure if we really need to add such comment in the code.
>>>
>>> Peter, what is your idea about this?
>>>
>>
>> It would be good to note why the early_initcall is the right phase.
>>
>
>How about:
>
>---
>Trampoline will be executed by APs with SMP,
>So we need to set it EXEC in do_pre_smp_initcalls and it is
>early_initcall.
>---

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
