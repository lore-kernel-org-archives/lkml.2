Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab1DLRze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:55:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17248 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab1DLRzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:55:32 -0400
Message-ID: <4DA491C6.90403@kernel.org>
Date: Tue, 12 Apr 2011 10:54:14 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH -v2] x86: Remove dma32_reserve_bootmem
References: <4D90CBE5.6090706@kernel.org>	<20110412091145.2bc5e6a9@jbarnes-desktop>	<4DA489F0.4000003@kernel.org> <20110412104716.5388849d@jbarnes-desktop>
In-Reply-To: <20110412104716.5388849d@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DA49206.0090,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2011 10:47 AM, Jesse Barnes wrote:
> On Tue, 12 Apr 2011 10:20:48 -0700
> Yinghai Lu<yinghai@kernel.org>  wrote:
>
>>
>> That is workaround for holding dma32 buf when early bootmem could use up
>> those range on system that have lots of RAM.
>>
>> Now x86 is using memblock, and even nobootmem wrapper do top-down allocation.
>>
>> So We could remove those not needed code now.
>>
>> -v2: rebase on pci-next
>>
>> Signed-off-by: Yinghai Lu<yinghai@kernel.org>
>>
>
> Hm, still didn't apply cleanly, I guess the patch got corrupted.  I
> fixed it up by hand and applied to linux-next though, thanks.

sorry for that. looks like recent thunderbird upgrade convert TAB to space..

Thanks

Yinghai Lu
