Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab1INJtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 05:49:53 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:59699 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab1INJtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 05:49:51 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Sep 2011 05:49:50 EDT
Message-ID: <4E707742.7050809@gmail.com>
Date: Wed, 14 Sep 2011 17:43:30 +0800
From: Shan Hai <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: linux-next: build warning after merge of the tip tree
References: <20110914163455.fcc47a7aba8604c690988473@canb.auug.org.au> <alpine.LFD.2.02.1109141137260.2723@ionos>
In-Reply-To: <alpine.LFD.2.02.1109141137260.2723@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2011 05:37 PM, Thomas Gleixner wrote:
> On Wed, 14 Sep 2011, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> After merging the tip tree, today's linux-next build (powerpc allnoconfig)
>> produced this warning:
>>
>> lib/atomic64.c: In function 'lock_addr':
>> lib/atomic64.c:42:2: warning: return from incompatible pointer type
>>
>> Introduced by commit f59ca05871a0 ("locking, lib/atomic64: Annotate
>> atomic64_lock::lock as raw").  This function (which is declared to return
>> "spinlock_t *") is now returning "raw_spinlock_t *".
> My bad, it seems I picked the wrong version of the patch.

Hi Thomas,

Please pick the V4 patch, the last one which I have sent to you,
I am sorry for the subject line it indicates V3 :(

Thanks
Shan Hai
