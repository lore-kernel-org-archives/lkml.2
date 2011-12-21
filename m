Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1LUXvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 18:51:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38808 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab1LUXu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 18:50:59 -0500
Message-ID: <4EF270CC.9040908@zytor.com>
Date: Wed, 21 Dec 2011 15:50:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <greg@kroah.com>, Thomas Renninger <trenn@suse.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, axboe@kernel.dk,
        herbert@gondor.hengli.com.au, ying.huang@intel.com, lenb@kernel.org
Subject: Re: [PATCH 9/8] CPU: Introduce ARCH_HAS_CPU_AUTOPROBE and X86 parts
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org> <1324338394-4670-9-git-send-email-andi@firstfloor.org> <201112211602.26845.trenn@suse.de> <CAPXgP12xDOjaEoRDdjYSSoLFCmpUOCZjoLFuyZHdnEMVsKGa0w@mail.gmail.com> <20111221232934.GC23559@kroah.com> <4EF26D63.10006@zytor.com> <CAPXgP12-6whMqYK-WbRURumrrzwBd9Z8gTdV4=5WY25Jkq2ZLg@mail.gmail.com>
In-Reply-To: <CAPXgP12-6whMqYK-WbRURumrrzwBd9Z8gTdV4=5WY25Jkq2ZLg@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 03:46 PM, Kay Sievers wrote:
> On Thu, Dec 22, 2011 at 00:36, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 12/21/2011 03:29 PM, Greg KH wrote:
> 
>>>> Greg, Andi's upcoming CPU modaliases are temporarily hooked into the
>>>> 'cpuid' class devices to make them work with userspace, which isn't
>>>> possible with the weird sysdev stuff.
>>>>
>>>> We don't want to depend on the 'cpuid' class, but hook into the real
>>>> 'cpu' subsystem. This switches them over after we have the
>>>> sysdev-cpu-conversion stuff merged.
>>>
>>> Ok, but what does this mean now for my tree as I've taken your patches?
>>
>> If I understand Kay right it means that once this tree and the patches from
>> Kay are both upstream we can apply the cleanup patch.
>>
>> Kay, is that correct?
> 
> Correct.
> 
> Andi added the modalias stuff to the 'cpuid' class because that has
> the proper userspace hookup. But we want to have the modalias at the
> real 'cpu' devices.
> 
> Thomas' patch (the above) moves them over, now that we can do that
> with the weird sysdev stuff gone.
> 

But we need Greg's stuff upstream first, right?  So the sequence becomes
a) merge Greg's tree b) merge this tree c) merge the cleanup.

	-hpa

