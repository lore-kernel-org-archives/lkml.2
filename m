Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab1ANPVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:21:05 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55019 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab1ANPU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:20:57 -0500
Message-ID: <4D3069CC.7090901@us.ibm.com>
Date: Fri, 14 Jan 2011 09:20:44 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
Reply-To: maynardj@us.ibm.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Andi Kleen <andi@firstfloor.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH] oprofile: Add support for missing Intel core i7 models
References: <1294958291-5626-1-git-send-email-sbohrer@rgmadvisors.com> <20110113235503.GY4739@erda.amd.com> <20110114002435.GR25713@one.firstfloor.org> <20110114022950.GC4739@erda.amd.com>
In-Reply-To: <20110114022950.GC4739@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2011 8:29 PM, Robert Richter wrote:
> On 13.01.11 19:24:35, Andi Kleen wrote:
>> On Fri, Jan 14, 2011 at 12:55:03AM +0100, Robert Richter wrote:
>>> On 13.01.11 17:38:11, Shawn Bohrer wrote:
>>>> Added missing core i7 models found in "Intel 64 and IA-32 Architectures
>>>> Software Developer's Manual Volume 3B: System Programming Guide",
>>>> Table B-1.  Tested with oprofile 0.9.6 on a:
>>>>
>>>> model      : 44
>>>> model name : Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz
>>>>
>>>> Signed-off-by: Shawn Bohrer<sbohrer@rgmadvisors.com>
>>>
>>> Andi,
>>>
>>> please ACK.
>>
>> NACK -- first it's wrong because that's a westmere and westmere
>> has a different event list. And the new way is to fall back to arch-perfmon
>> and handle the CPUID in user space. This has been already implemented.
>> So the fix is to upgrade user space.
>
> Andi,
>
> thanks for looking at this.
>
> Will it be the general way in the future not to add model detection
> for new Intel cpus to kernel code and instead use arch_perfmon? Are
> the user land patches for cpu detection already in the oprofile
> repository? I assume oprofile 0.9.6 is not up-to-date and needs to be
> patched.
Yes, as Andi said above, the processor detection via cpuid has already been 
implemented and accepted to oprofile userspace -- thanks to Will Cohen.

-Maynard
>
> -Robert
>

