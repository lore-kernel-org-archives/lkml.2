Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab2LPS3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 13:29:04 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34934 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093Ab2LPS3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 13:29:02 -0500
X-Sasl-enc: k648z1w2vzEZPWn3AsSXorho4r60tVQbPH4Y3tf3qbK/ 1355682541
Message-ID: <50CE12EB.1050804@itwm.fraunhofer.de>
Date: Sun, 16 Dec 2012 19:28:59 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [regression] 3.7 ends in APIC panic
References: <50CB3EAB.309@itwm.fraunhofer.de> <CAE9FiQVFSx7sJhYbREk+gfdgxO6uMgHWdDv1tbkU=VXqfH4iAg@mail.gmail.com> <CAE9FiQUyj65jB4bPkJQHGRZEkhOry736g362-m145vNYRRSdAQ@mail.gmail.com> <50CE0C82.20708@itwm.fraunhofer.de> <CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com>
In-Reply-To: <CAE9FiQUJ-TZCCOki3XfMOgOvOL=TiApJGQdHcHNAPmYKRtVk6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2012 07:07 PM, Yinghai Lu wrote:
> On Sun, Dec 16, 2012 at 10:01 AM, Bernd Schubert
> <bernd.schubert@itwm.fraunhofer.de> wrote:
>>> can you post your .config for v3.7 ?
>>>
>>> wonder if you have x2apic in .config
>>
>> Which setting is it? Config is attached.
> 
> your config does not have
> 
> CONFIG_X86_X2APIC=y
> 
> set.
> 
> please enable that.
> 
> your BIOS pre-enable x2apic somehow, so you must have x2apic enabled in kernel.
> 
> it x2apic really can not be re-enabled by kernel, kernel would disable
> x2apic automatically.

Thanks! CONFIG_X86_X2APIC depends on
CONFIG_IRQ_REMAP, which I disabled as it is marked as experimental and
as this is my desktop system. So CONFIG_X86_X2APIC also got unset
automatically.

Will test a new kernel build in the morning.


Thanks,
Bernd
