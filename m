Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab1AEHkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 02:40:47 -0500
Received: from claw.goop.org ([74.207.240.146]:37599 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab1AEHkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 02:40:45 -0500
Message-ID: <4D242070.3070602@goop.org>
Date: Wed, 05 Jan 2011 18:40:32 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 1/2] apic: Move hypervisor detection of x2apic to hypervisor.h
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com> <201101041657.36123.sheng@linux.intel.com> <20110104092418.GA31281@elte.hu> <201101050952.00104.sheng@linux.intel.com>
In-Reply-To: <201101050952.00104.sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 12:51 PM, Sheng Yang wrote:
> On Tuesday 04 January 2011 17:24:18 Ingo Molnar wrote:
>> * Sheng Yang <sheng@linux.intel.com> wrote:
>>> On Wednesday 22 December 2010 02:15:44 Avi Kivity wrote:
>>>> On 12/21/2010 07:15 PM, Jeremy Fitzhardinge wrote:
>>>>> On 12/20/2010 10:18 PM, Sheng Yang wrote:
>>>>>>  Then we can reuse it for Xen later.
>>>>> You should probably get someone kvm-ish to ack this too.
>>>> Looks good to me.
>>> Ingo,
>>>
>>> Comments?
>> Acked-by: Ingo Molnar <mingo@elte.hu>
>>
>> I suspect these patches want to be carried in the Xen tree, right? Shouldnt
>> cause too bad conflicts, as long as the Xen tree is pushed after the x86
>> tree in the merge window.
> Jeremy?

Sure, I'm OK with that, but I'm on vacation until the 15th.  Konrad, can
you pick this up?

Thanks,
    J

