Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0ENFTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:19:32 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:42648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0ENFTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:19:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VaxtcweWzBg8Pr1/8ipdljggvN8IyUKX1W2AtsjKZgO/aOG09rLCnGV63PP0dZ+BoU
         a17bKevuZqbrvTNEkX2XAidktq3p+nRcgN2WC0c72O8Djute+QF59LPJaZD9gV7U10lA
         AHHFKPHaJi9Wv3TNYiUc09OF1Hmz4+5ah4qck=
Message-ID: <4BECDD5D.9010609@gmail.com>
Date: Thu, 13 May 2010 22:19:25 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
References: <4BEC7A84.3010503@gmail.com> <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com> 	<AANLkTim7fnKebMoEu1DjD3S-15ZqlTUez3Lpp0wGVJQ6@mail.gmail.com> <AANLkTimmctk1GWOTlW8Han7E3gJVgqJjUAMeqYnvyuHn@mail.gmail.com>
In-Reply-To: <AANLkTimmctk1GWOTlW8Han7E3gJVgqJjUAMeqYnvyuHn@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/10 22:07, Luis R. Rodriguez wrote:
> On Thu, May 13, 2010 at 9:55 PM, Pekka Enberg<penberg@cs.helsinki.fi>  wrote:
>> Hi Luis,
>>
>> On Fri, May 14, 2010 at 2:01 AM, Luis R. Rodriguez
>> <lrodriguez@atheros.com>  wrote:
>>> On Thu, May 13, 2010 at 3:17 PM, Justin P. Mattock
>>> <justinmattock@gmail.com>  wrote:
>>>> not sure what this is, but while at a convention
>>>> I was trying to access the internet and(below is
>>>> full dmesg) this showed up.
>>>>
>>>> After receiving this, I sat and tried to re-create
>>>> my steps to reproduce but had no luck(was even going
>>>> todo a bisect n the spot if I could re-create).
>>>
>>> OK this stuff is hard to reproduce it seems.. you have an Atheros
>>> AR5418 MAC/BB Rev:2 AR5133 RF Rev:81, what kconfig option do you use
>>> to get the poison stuff? I am just surprised we haven't seen it
>>> ourselves yet. Let me make sure all of us get this kconfig option
>>> enabled.
>>
>> CONFIG_SLUB_DEBUG and then either CONFIG_SLUB_DEBUG_ON or pass
>> 'slub_debug' as kernel parameter.
>
> Ah OK I had CONFIG_SLUB_DEBUG but not  CONFIG_SLUB_DEBUG_ON, will
> enable it from here on.
>
>    Luis
>

I enable these options as well..
(then see If I can(hopefully)re-create this
then I'll bisect it).

Justin P. Mattock
