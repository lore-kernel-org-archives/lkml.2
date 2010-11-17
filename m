Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0KQFWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:22:23 -0500
Received: from [120.204.251.227] ([120.204.251.227]:32717 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751718Ab0KQFWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:22:22 -0500
Message-ID: <4CE36652.50305@leadcoretech.com>
Date: Wed, 17 Nov 2010 13:21:22 +0800
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101028 Lightning/1.0b2 Lanikai/3.1.6
MIME-Version: 1.0
To: Anca Emanuel <anca.emanuel@gmail.com>
CC: Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] mm: vmscan implement per-zone shrinkers
References: <20101109123246.GA11477@amd>	<20101114182614.BEE5.A69D9226@jp.fujitsu.com>	<20101115092452.BEF1.A69D9226@jp.fujitsu.com>	<20101116074717.GB3460@amd>	<AANLkTi=BhuVn8F3ioTyR8S=J3LfJbuhYsMoHf9f=bvRn@mail.gmail.com>	<4CE23B3B.5050804@leadcoretech.com>	<AANLkTi=10NspL2fw66De8osjUC+2xnxsLpw+x=oNQQTv@mail.gmail.com>	<4CE23F33.5060401@leadcoretech.com>	<AANLkTi=Da76M+s92ZZnfw7ySjp3WWfDjW6n5G=hHheKB@mail.gmail.com>	<4CE340BC.1010701@leadcoretech.com> <AANLkTi==W_KHL3pd8Cq=ojV=aAAOxi4c=ZkHSednOVyH@mail.gmail.com>
In-Reply-To: <AANLkTi==W_KHL3pd8Cq=ojV=aAAOxi4c=ZkHSednOVyH@mail.gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2010 05:22:20.0358 (UTC) FILETIME=[685E6E60:01CB8617]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>
>>>> hi KOSAKI Motohiro,
>>>>
>>>> is it any test suite or test scripts for test page-reclaim performance?
>>>>
>>>> Best,
>>>> Figo.zhang
>>>>
>>>
>>> There is http://www.phoronix.com
>>
>> it is not focus on page-reclaim test, or specially for MM.
>>>
>>
>>
> 
> If you want some special test, you have to ask Michael Larabel for that.
> http://www.phoronix-test-suite.com/

yes, i see, the phoronix-test-suite is test such as ffmpeg, games. not
focus on MM.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
> Don't email:<a href=ilto:"dont@kvack.org">  email@kvack.org</a>
> 

