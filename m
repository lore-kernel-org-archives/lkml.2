Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab1DMSjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:39:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60709 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671Ab1DMSjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 14:39:48 -0400
Message-ID: <4DA5EDE1.3030600@zytor.com>
Date: Wed, 13 Apr 2011 11:39:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org>
In-Reply-To: <20110413172147.GI19819@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 10:21 AM, Joerg Roedel wrote:
> On Wed, Apr 13, 2011 at 08:46:09AM +0200, Ingo Molnar wrote:
>> Could you please send the before/after bootlog (in particular all memory init 
>> messages included) and your .config?
>>
>>  before:  f005fe12b90c: x86-64: Move out cleanup higmap [_brk_end, _end) out of init_memory_mapping()
>>   after:  d2137d5af425: Merge branch 'linus' into x86/bootmem
>>
>> I've Cc:-ed more people who might have an idea about it.
> 
> Okay, I have done some more bisecting and debugging today.
> 

First of all, *huge* thanks for this effort.  At least we need to track
down the bits that need to be reverted -- it is past rc3, and it's time
to see what we should revert and tell the submitter to try again next cycle.

This looks to be the same issue as in bugzilla 33012:

	https://bugzilla.kernel.org/show_bug.cgi?id=33012

... so it would be good if we could keep the information in there.

	-hpa
