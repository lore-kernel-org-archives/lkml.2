Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab1IHAyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:54:00 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:28010 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757660Ab1IHAx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:53:58 -0400
Message-ID: <4E680036.8000106@blueyonder.co.uk>
Date: Thu, 08 Sep 2011 00:37:26 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.x memleaks
References: <4E66414E.8060100@blueyonder.co.uk> <CAM_iQpX4tWS7VbPvrFTqEGv0GzfTm+sygPhqDz+yHVUGSEGhXA@mail.gmail.com>
In-Reply-To: <CAM_iQpX4tWS7VbPvrFTqEGv0GzfTm+sygPhqDz+yHVUGSEGhXA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=TwUyvNu_jswA:10 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=8nJEP1OIZ-IA:10 a=a5Gf7U6LAAAA:8 a=D19gQVrFAAAA:8 a=bgUkVmbCD3rZoZhqrOMA:9 a=H7ef0AUhDHS4QfnJdc4A:7 a=wPNLvfGTeEIA:10 a=yHIqe9kG5mgA:10 a=H8twRXSqR9_13TLB:21 a=am6pqy2MG2WeHlqw:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/11 11:58, Américo Wang wrote:
> On Tue, Sep 6, 2011 at 11:50 PM, Sid Boyce<sboyce@blueyonder.co.uk>  wrote:
>> Since 3.0 I have been seeing memleaks, right up to 3.1.0-rc5. This is
>> typical.
>> AMD x86_64, X2, X4's and openSUSE 12.1 Milestones.
>> unreferenced object 0xffff88022f007000 (size 512):
>> Â comm "swapper", pid 1, jiffies 4294667649 (age 17727.056s)
>> Â hex dump (first 32 bytes):
>> Â  Â 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 Â ................
>> Â  Â 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 Â ................
>> Â backtrace:
>> Â  Â [<ffffffff81490ba6>] kmemleak_alloc+0x56/0xb0
>> Â  Â [<ffffffff8113ca4c>] kmem_cache_alloc_node_trace+0x9c/0x1d0
>> Â  Â [<ffffffff81041ea7>] __sdt_alloc+0xa7/0x1e0
>> Â  Â [<ffffffff81042014>] __visit_domain_allocation_hell+0x34/0xc0
>> Â  Â [<ffffffff8104d489>] build_sched_domains+0x29/0x2e0
>> Â  Â [<ffffffff81c4c5de>] sched_init_smp+0x7d/0x168
>> Â  Â [<ffffffff81c36cca>] kernel_init+0xb8/0x159
>> Â  Â [<ffffffff814bfbb4>] kernel_thread_helper+0x4/0x10
>> Â  Â [<ffffffffffffffff>] 0xffffffffffffffff
> Hello,
>
> This should be fixed by: https://lkml.org/lkml/2011/8/29/218
>
> Thanks!
>
I applied the patch to 3.1-rc5 and it's still the same.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

