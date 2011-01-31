Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab1AaT3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:29:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65114 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1AaT3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:29:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rrxD1in8l6pq7lSRK8O+eP7EakgPhwX5l/hjX60e3Jb9uAwLWQvuS4tCTVSm0i6fBE
         EIAwSD/QRFmJx9am/9vZGrtkJJ+sRoOuip8ZC0eItQGEZa7NNJ09ezT0RGSwF7AJsPU6
         rPoRE02UM2qZv+B/nEwywfV6S2GsD9Q1mmGfI=
MIME-Version: 1.0
In-Reply-To: <4D470A8B.70700@metafoo.de>
References: <20110131135417.GC3883@oksana.dev.rtsoft.ru> <4D46FC2A.6010402@metafoo.de>
 <20110131182704.GA13244@oksana.dev.rtsoft.ru> <4D470A8B.70700@metafoo.de>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Mon, 31 Jan 2011 20:28:40 +0100
Message-ID: <AANLkTik8v9pW_hPQ7B6LwLv5i2mq5GRRUc_HzOzcuGqZ@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bq27x00_battery: Some fixes
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/31 Lars-Peter Clausen <lars@metafoo.de>:
> On 01/31/2011 07:27 PM, Anton Vorontsov wrote:
>> On Mon, Jan 31, 2011 at 07:15:06PM +0100, Lars-Peter Clausen wrote:
>>> On 01/31/2011 02:54 PM, Anton Vorontsov wrote:
>>>> The same is for this patch.
>>>>
>>>> Comments, Reviewed-by or Acked-by?
>>>>
>>>> p.s. FWIW, I already asked Pali to factor out bq27x00_battery_time()
>>>>      fix to a separate patch.
>>>>
>>>
>>> Hi
>>>
>>> I have a larger series pending which adds support for the bq27000 chip and polling to
>>> the bq27x00 driver. Since this series does some refactoring of the bq27x00 driver, it
>>> might make sense to rebase this (and the other) patch ontop of that series instead of
>>> the other way around.
>>
>> Pali was first to send out his work, so I think that it would make
>> sense to ask you to rebase your work on top. Especially since Pali's
>> patches were somewhat reviewed already.
>
> I suspect it to be substantial more work to rebase mine on top of his. That's why I'm
> asking for a exception in this case. I would be willing to adjust his patches, so
> they can be applied on top of mine.
>
>>
>> I hope Pali will resend the fixed versions quickly enough so
>> that I'll apply the patches asap and you'll easily use git
>> for rebasing.
>>
>
> git won't help in this case, because my patches basically rewrite the parts changed
> by Palis patches. It would be one merge conflict after another, I guess.
>
>> Thanks!
>>
>
>

Can you then merge my changes with your in git?

-- 
Pali Rohár
pali.rohar@gmail.com
