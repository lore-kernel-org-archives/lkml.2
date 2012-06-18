Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2FRQzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:55:05 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:53722 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752544Ab2FRQzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:55:03 -0400
Message-ID: <4FDF5D50.7030505@xenotime.net>
Date: Mon, 18 Jun 2012 09:54:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Fengguang Wu <fengguang.wu@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: error: implicit declarations of BUG/BUG_ON/WARN_ON/WARN_ON_ONCE
References: <20120615143303.3b88edcbc3efc7b1bf81839b@canb.auug.org.au> <20120615065231.GA12272@localhost> <4FDB6261.2030400@xenotime.net>
In-Reply-To: <4FDB6261.2030400@xenotime.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 09:27 AM, Randy Dunlap wrote:

> On 06/14/2012 11:52 PM, Fengguang Wu wrote:
> 
>> On Fri, Jun 15, 2012 at 02:33:03PM +1000, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20120614:
>>>
>>> My fixes tree contains:
>>> 	fix bug.h's inclusion of kernel.h
>>
>> I got these errors with the attached randconfig. Not sure which change
>> triggers them.
> 
> Ditto.  When CONFIG_BUG is not enabled.


This problem is still in linux-next of 20120618...


> 
>>   CC      arch/x86/kernel/asm-offsets.s
>> In file included from /c/kernel-tests/mm/arch/x86/include/asm/atomic.h:6:0,
>>                  from /c/kernel-tests/mm/include/linux/atomic.h:4,
>>                  from /c/kernel-tests/mm/include/linux/crypto.h:20,
>>                  from /c/kernel-tests/mm/arch/x86/kernel/asm-offsets.c:8:
>> /c/kernel-tests/mm/arch/x86/include/asm/processor.h: In function ‘get_aperfmperf’:
>> /c/kernel-tests/mm/arch/x86/include/asm/processor.h:937:2: error: implicit declaration of function ‘WARN_ON_ONCE’ [-Werror=implicit-function-declaration]
>> In file included from /c/kernel-tests/mm/include/linux/thread_info.h:54:0,
>>                  from /c/kernel-tests/mm/include/linux/preempt.h:9,
>>                  from /c/kernel-tests/mm/include/linux/spinlock.h:50,
>>                  from /c/kernel-tests/mm/include/linux/mmzone.h:7,
>>                  from /c/kernel-tests/mm/include/linux/gfp.h:4,
>>                  from /c/kernel-tests/mm/include/linux/slab.h:12,
>>                  from /c/kernel-tests/mm/include/linux/crypto.h:24,
>>                  from /c/kernel-tests/mm/arch/x86/kernel/asm-offsets.c:8:
>> /c/kernel-tests/mm/arch/x86/include/asm/thread_info.h: In function ‘set_restore_sigmask’:
>> /c/kernel-tests/mm/arch/x86/include/asm/thread_info.h:250:2: error: implicit declaration of function ‘WARN_ON’ [-Werror=implicit-function-declaration]
>> In file included from /c/kernel-tests/mm/include/linux/mmzone.h:717:0,
>>                  from /c/kernel-tests/mm/include/linux/gfp.h:4,
>>                  from /c/kernel-tests/mm/include/linux/slab.h:12,
>>                  from /c/kernel-tests/mm/include/linux/crypto.h:24,
>>                  from /c/kernel-tests/mm/arch/x86/kernel/asm-offsets.c:8:
>> /c/kernel-tests/mm/include/linux/memory_hotplug.h: In function ‘generic_alloc_nodedata’:
>> /c/kernel-tests/mm/include/linux/memory_hotplug.h:152:2: error: implicit declaration of function ‘BUG’ [-Werror=implicit-function-declaration]                                               
>> In file included from /c/kernel-tests/mm/arch/x86/include/asm/apic.h:12:0,                                                                
>>                  from /c/kernel-tests/mm/arch/x86/include/asm/smp.h:13,
>>                  from /c/kernel-tests/mm/include/linux/smp.h:38,
>>                  from /c/kernel-tests/mm/include/linux/topology.h:33,
>>                  from /c/kernel-tests/mm/include/linux/gfp.h:7,
>>                  from /c/kernel-tests/mm/include/linux/slab.h:12,
>>                  from /c/kernel-tests/mm/include/linux/crypto.h:24,
>>                  from /c/kernel-tests/mm/arch/x86/kernel/asm-offsets.c:8:
>> /c/kernel-tests/mm/arch/x86/include/asm/fixmap.h: In function ‘virt_to_fix’:
>> /c/kernel-tests/mm/arch/x86/include/asm/fixmap.h:220:2: error: implicit declaration of function ‘BUG_ON’ [-Werror=implicit-function-declaration]
>>   HOSTLD  scripts/genksyms/genksyms
>> cc1: some warnings being treated as errors
>> make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
>> make[1]: *** [prepare0] Error 2
>> make[1]: *** Waiting for unfinished jobs....
>>
>> Thanks,
>> Fengguang
> 
> 
> 



-- 
~Randy
