Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab0GIQ1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:27:39 -0400
Received: from ottmail.xandros.com ([142.46.212.35]:54823 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570Ab0GIQ1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:27:38 -0400
Date: Fri, 9 Jul 2010 12:27:43 -0400
From: Woody Suwalski <terraluna977@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <4C374DFF.7050008@gmail.com>
In-Reply-To: <20100709085831.758d9ee9@virtuousgeek.org>
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com>
References: <4C373084.8000503@gmail.com>
References: <20100709085831.758d9ee9@virtuousgeek.org>
Subject: Re: Yet another 2.6.35 regression (AGP)?
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SeaMonkey/2.0.4
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Fri, 9 Jul 2010 10:21:56 -0400
> Woody Suwalski<terraluna977@gmail.com>  wrote:
>
>    
>> I have found one system, where 2.6.35 does not work (as tested with rc3
>> and rc4)
>> That Intel system has no problems in 2.6.33.x nor 2.6.34.0.
>>
>> The problem seems to be in AGP - I can boot if I specify "agp=off" - but
>> of course only in text mode...
>> There seems to be a hard lock-up, so the only way to show the crash is
>> by picture 8-)
>>
>> Since I do not build kernel on that machine, I did not do any bisect
>> tests, however if someone is interested in digging deeper, I can try...
>> Preferably a patch to try out ;-)
>>
>> This bug seems to be different then
>> https://bugzilla.kernel.org/show_bug.cgi?id=16179
>>
>> Should it be blamed on BIOS (the conflict indicated just before the crash)?
>>      
> Well even if the BIOS is doing something bad, if we handled it in
> earlier kernels we should handle it today.  So this sounds like a
> regression.
>
> A bisect should help if it was working before, can you do that?
>
>    
OK, I have never really done the brute-force bissecting, but there is 
always first time...
Will try to do it over the weekend...

Unless U will be visiting Ottawa  and want to do it yourself ;-)

Woody

