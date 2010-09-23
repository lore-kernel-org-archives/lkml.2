Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab0IWUsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:48:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38320 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab0IWUsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:48:40 -0400
Message-ID: <4C9BBD0C.6070905@zytor.com>
Date: Thu, 23 Sep 2010 13:48:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "Glove box" BIOS patch causes boot flicker
References: <alpine.LNX.2.01.1009220135380.25692@obet.zrqbmnf.qr> <4C994F0B.6030004@linux.intel.com> <alpine.LNX.2.01.1009232052230.16976@obet.zrqbmnf.qr> <4C9BB1C5.80808@zytor.com> <alpine.LNX.2.01.1009232243110.21529@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1009232243110.21529@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 01:46 PM, Jan Engelhardt wrote:
> 
> On Thursday 2010-09-23 22:00, H. Peter Anvin wrote:
>> On 09/23/2010 11:54 AM, Jan Engelhardt wrote:
>>> On Wednesday 2010-09-22 02:34, H. Peter Anvin wrote:
>>>
>>>> There were some minor bugs (typos) in the conversion to the glove box 
>>>> coding style. The ones we have found have been fixed, so the first 
>>>> thing is to try the current mainline or the current tip tree.  
>>>> Otherwise I would look for issues where either the wrong register is 
>>>> changed, or something like a variable is changed instead of a field.
>>>
>>> I tried v2.6.36-rc5 now, and it looks better. The cursor position is 
>>> retained as desired. The mode switch is still there, albeit much 
>>> shorter than it used to be.
>>
>> The mode switch was there in the original code.
> 
> That may very well be so, but there clearly is distinguished behavior 
> w.r.t. that in 2.6.36 compared to .30.

Yes, but that caused regressions from the old assembly code.

	-hpa

