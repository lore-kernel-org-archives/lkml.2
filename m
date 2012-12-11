Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab2LKCf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 21:35:29 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56497 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2LKCfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:35:24 -0500
Message-ID: <50C69BD7.1030300@linux.vnet.ibm.com>
Date: Tue, 11 Dec 2012 10:35:03 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: TIP tree's master branch failed to boot up
References: <50C56A13.9040604@linux.vnet.ibm.com> <50C591B0.10408@linux.vnet.ibm.com> <20121210105449.GC7264@gmail.com>
In-Reply-To: <20121210105449.GC7264@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121102-9264-0000-0000-000002D3A04F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 06:54 PM, Ingo Molnar wrote:
> 
> I've Cc:-ed hpa, he merged the x86/microcode bits.
> 
> Michael Wang, I've excluded x86/microcode from the latest 
> version of the -tip tree which I just pushed out:
> 
>   4e00fd4c93e0 Merge branch 'x86/cleanups'
> 
> Can you confirm that your server boots now?

Yes, it works.

Regards,
Michael Wang

> 
> Thanks,
> 
> 	Ingo
> 
> * Michael Wang <wangyun@linux.vnet.ibm.com> wrote:
> 
>> On 12/10/2012 12:50 PM, Michael Wang wrote:
>>> Hi, Folks
>>>
>>> I'm testing with the latest tip tree's master branch 3.7.0-rc8 and
>>> failed to boot up my server, it's hung at very beginning and I could not
>>> catch any useful log, is there any one else got this problem or I'm the
>>> only one?.
>>
>> And bisect catch below commit:
>>
>> commit 56e7dba100a50f674627a3764fd4da4a6ec93295
>> Merge: ea8432f 16544f8
>> Author: Ingo Molnar <mingo@kernel.org>
>> Date:   Fri Dec 7 12:13:11 2012 +0100
>>
>>     Merge branch 'x86/microcode'
>>
>> Regards,
>> Michael Wang
>>
>>
>>>
>>> Regards,
>>> Michael Wang
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 

