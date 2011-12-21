Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1LUXga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 18:36:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38712 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1LUXg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 18:36:28 -0500
Message-ID: <4EF26D63.10006@zytor.com>
Date: Wed, 21 Dec 2011 15:36:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, Thomas Renninger <trenn@suse.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, axboe@kernel.dk,
        herbert@gondor.hengli.com.au, ying.huang@intel.com, lenb@kernel.org
Subject: Re: [PATCH 9/8] CPU: Introduce ARCH_HAS_CPU_AUTOPROBE and X86 parts
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org> <1324338394-4670-9-git-send-email-andi@firstfloor.org> <201112211602.26845.trenn@suse.de> <CAPXgP12xDOjaEoRDdjYSSoLFCmpUOCZjoLFuyZHdnEMVsKGa0w@mail.gmail.com> <20111221232934.GC23559@kroah.com>
In-Reply-To: <20111221232934.GC23559@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 03:29 PM, Greg KH wrote:
> On Wed, Dec 21, 2011 at 04:32:28PM +0100, Kay Sievers wrote:
>> 2011/12/21 Thomas Renninger<trenn@suse.de>:
>>
>> Cool. That sounds good. Nice work. Thanks.
>>
>> Adding Greg, so he's in the loop.
>>
>> Greg, Andi's upcoming CPU modaliases are temporarily hooked into the
>> 'cpuid' class devices to make them work with userspace, which isn't
>> possible with the weird sysdev stuff.
>>
>> We don't want to depend on the 'cpuid' class, but hook into the real
>> 'cpu' subsystem. This switches them over after we have the
>> sysdev-cpu-conversion stuff merged.
>
> Ok, but what does this mean now for my tree as I've taken your patches?
>

If I understand Kay right it means that once this tree and the patches 
from Kay are both upstream we can apply the cleanup patch.

Kay, is that correct?

	-hpa

