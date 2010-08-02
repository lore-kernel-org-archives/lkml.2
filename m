Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab0HBQdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:33:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43580 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab0HBQdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:33:51 -0400
Message-ID: <4C56F317.7030008@zytor.com>
Date: Mon, 02 Aug 2010 09:32:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
References: <20100803022310.bec3ba79.sfr@canb.auug.org.au> <20100802162810.GB4755@flint.arm.linux.org.uk>
In-Reply-To: <20100802162810.GB4755@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 09:28 AM, Russell King wrote:
> On Tue, Aug 03, 2010 at 02:23:10AM +1000, Stephen Rothwell wrote:
>> Hi all,
>>
>> Lots (if not all) of the arm builds failed for next-20100802 with these
>> errors:
>>
>> arch/arm/mm/init.c: In function 'arm_bootmem_init':
>> arch/arm/mm/init.c:184: error: implicit declaration of function 'memblock_start_pfn'
>> arch/arm/mm/init.c:186: error: implicit declaration of function 'memblock_end_pfn'
>> arch/arm/mm/init.c:188: error: implicit declaration of function 'memblock_size_bytes'
>>
>> Caused by commit 53e16bfaf19346f59b3502e207aa66c61332075c ("memblock:
>> Introduce for_each_memblock() and new accessors, and use it") interacting
>> with commit 2778f62056ada442414392d7ccd41188bb631619 ("ARM: initial LMB
>> trial") and some others from the arm tree.
> 
> Please, no, don't break the memblock code now.  I'm not reworking the
> ARM implementation just as the merge window has opened - especially
> as the ARM implementation has now been pulled into other people's
> trees.
> 
> If there's changes to memblock which haven't been in linux-next (which,
> as this is a new failure, that is most definitely the case), then they
> shouldn't be going into this merge window.
> 

Ben, what's your tack on this?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
