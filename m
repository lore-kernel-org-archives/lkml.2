Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0HYTR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 15:17:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50962 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0HYTR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 15:17:56 -0400
Message-ID: <4C756BA0.2090700@zytor.com>
Date: Wed, 25 Aug 2010 12:14:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Haicheng Li <haicheng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [BUGFIX][PATCH 1/2] x86, mem: separate x86_64 vmalloc_sync_all()
 into separate functions
References: <4C6E4ECD.1090607@linux.intel.com> <87r5hni19y.fsf@basil.nowhere.org>
In-Reply-To: <87r5hni19y.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 12:45 AM, Andi Kleen wrote:
> Haicheng Li <haicheng.li@linux.intel.com> writes:
> 
>> hello,
>>
>> Resend these two patches for bug fixing:
>>
>> The bug is that when memory hotplug-adding happens for a large enough area that a new PGD entry is
>> needed for the direct mapping, the PGDs of other processes would not get updated. This leads to some
>> CPUs oopsing when they have to access the unmapped areas, e.g. onlining CPUs on the new added node.
> 
> The patches look good to me. Can we please move forward with this?
> 
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> 

The patches are mangled so they don't apply even with patch -l --
Haicheng, could you send me another copy, as an attachment if necessary?

	-hpa
