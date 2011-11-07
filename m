Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab1KGNRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 08:17:07 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63524 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1KGNRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 08:17:05 -0500
Message-ID: <4EB7DA4C.3080504@codemonkey.ws>
Date: Mon, 07 Nov 2011 07:17:00 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Blue Swirl <blauwirbel@gmail.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Alexander Graf <agraf@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Avi Kivity <avi@redhat.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
References: <4EB67486.1070105@redhat.com>	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>	<4EB67D17.7000701@redhat.com>	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>	<4EB680D9.2070706@redhat.com>	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>	<877C82F4-F07C-44AA-8722-3AF57CFC4597@suse.de>	<CAOJsxLFhB8V94VWbDgM6d_rgcy8XQNEfYBKYG1eh6oUMiQicEA@mail.gmail.com>	<4EB7B1A9.9000409@redhat.com>	<alpine.LFD.2.02.1111071333350.2815@tux.localdomain> <20111107115734.GA30222@elte.hu>
In-Reply-To: <20111107115734.GA30222@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 05:57 AM, Ingo Molnar wrote:
>
> * Pekka Enberg<penberg@cs.helsinki.fi>  wrote:
>
>> On Mon, 7 Nov 2011, Gerd Hoffmann wrote:
>>>> It's not just about code, it's as much about culture and development process.
>>>
>>> Indeed.  The BSDs have both kernel and the base system in a single
>>> repository.  There are probably good reasons for (and against) it.
>>>
>>> In Linux we don't have that culture.  No tool (except perf) lives
>>> in the kernel repo.  I fail to see why kvm-tool is that much
>>> different from udev, util-linux, iproute, filesystem tools, that
>>> it should be included.
>>
>> You seem to think perf is an exception - I think it's going to be
>> the future norm for userspace components that are very close to the
>> kernel. That's in fact what Ingo was arguing for when he suggested
>> QEMU to be merged to the kernel tree.
>
> Yep, and the answer i got from the Qemu folks when i suggested that
> merge was a polite "buzz off", along the lines of: "We don't want to
> do that, but feel free to write your own tool, leave Qemu alone."

At least it was polite :-)

>
> Now that people have done exactly that some Qemu folks not only have
> changed their objection from "write your own tool" to "erm, write
> your own tool but do it the way *we* prefer you to do it" - they also
> started contributing *against* the KVM tool with predictable, once
> every 3 months objections against its upstream merge...
>
> That's not very nice and not very constructive.

I think it's fair to have an objection to upstream merge but I think these 
threads are not terribly constructive right now as it's just rehashing the same 
arguments.

I've been thinking about the idea of merging more userspace tools into the 
kernel.  I understand the basic reasoning.  The kernel has a strong, established 
development process.  It has good infrastructure and a robust hierarchy of 
maintainers.

Good infrastructure can make a big difference to the success of a project. 
Expanding the kernel infrastructure to more projects does seem like an obvious 
thing to do when you think about it in that way.

The approach other projects have taken to this is to form a formal incubator. 
Apache is a good example of this.  There are clear (written) rules about what it 
takes for a project to join.  Once a project joins, there's a clear governance 
structure.  The project gets to consume all of the Apache infrastructure resources.

Other foundations have a release cadence to ensure that multiple components form 
a cohesive individual release (oVirt).

I think you are trying to do this in a more organic way by just merging things 
into the main git tree.  Have you thought about creating a more formal kernel 
incubator program?

Regards,

Anthony Liguori
