Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab0CROHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:07:42 -0400
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:50984 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673Ab0CROHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:07:40 -0400
Message-ID: <4BA233A9.1030407@blueyonder.co.uk>
Date: Thu, 18 Mar 2010 14:07:37 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.7 Thunderbird/3.0.3 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
To: linux-x86_64@vger.kernel.org,
       LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: Re: Boot failure 2.6.33 - 2.6.33-git12 inclusive
References: <4B9A4337.9030609@blueyonder.co.uk>
In-Reply-To: <4B9A4337.9030609@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still no response to this problem and I still have it with
2.6.34-rc1-git6. I also upgraded to the latest 2402 motherboard BIOS.
Regards
Sid.


On 12/03/10 13:35, Sid Boyce wrote:
> 
> 
> -------- Original Message --------
> Subject: Re: Boot failure 2.6.33 - 2.6.33-git12 inclusive
> Date: Fri, 12 Mar 2010 11:01:55 +0800
> From: Américo Wang <xiyou.wangcong@gmail.com>
> To: sboyce@blueyonder.co.uk
> CC: Kernel Testers List <kernel-testers@vger.kernel.org>, "Rafael J.
> Wysocki" <rjw@sisk.pl>, 	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
> <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
> 
> On Fri, Mar 12, 2010 at 6:49 AM, Sid Boyce <sboyce@blueyonder.co.uk> wrote:
>> Same problem up to 2.6.33-git15 and 2.6.34-rc1. No response since posted
>> to LKML last week.
>> --------------------------------------------------
> 
> 
> You need to Cc x86 people. Added.
> 
> 
>>
>> Asus Crosshair II motherboard, 4xCPU 8Gig storage fails, the M2N32-SLI
>> 2x CPU, 4 Gig and laptop 2x CPU, 2 Gig have no problems running
>> 2.6.33-git11 - all AMD CPU's.
>> Lockup requiring a hard reset.
>>
>> TCP cubic registered
>> registered taskstats version 1
>> Kmemleak: kernel memory leak detector initialized
>> Kmemleak: Automatic memory scanning thread started
>> No TPM chip found, activating TPM-bypass!
>> Freeing unused kernel memory: 688K freed
>> Write Protecting kernel memory read-only data: 6144K
>> Testing CPA: undo ffffffff81000000 - ffffffff81600000
>> Testing CPA: again
>> Freeing unused kernel memory: 964K freed
>> Freeing unused kernel memory: 212K freed
>> init[1] segfault at ffffffff8100eea8 ip ffffffff8100eea8 sp
>> 00007fff62e804b8 error 15
>> kernel panic - not syncing: Attempted to kill init!
>> Pid: 1,comm: init not tainted 2.6.33-git12-smp #2
>> Call Trace:
>> [<ffffffff81300876>] panic+0x73/0xfa
>> [<ffffffff8104b45c>] do_exit+0x6d/0x713
>> [<ffffffff8104bd85>] do_group_exit+0x72/0x9b
>> [<ffffffff8105917e>] get_signal_to_deliver+0x356/0x375
>> [<ffffffff8130310b>] ? _raw_spin_unlock_irqrestore+0x2f/0x34
>> [<ffffffff81007fc3>] do_signal+0x6d/0x660
>> [<ffffffff81300939>] ? printk+0x3c/0x43
>> [<ffffffff8100eea8>] ? rdtsc_barrier+0x0/0xc
>> [<ffffffff81300939>] ? printk+0x3c/0x43
>> [<ffffffff8102b78c>] ? __bad_area_nosemaphore+0x183/0x1ad
>> [<ffffffff8100eea8>] ? rdtsc_barrier+0x0/0xc
>> [<ffffffff810085fc>] do_notify_resume+0x27/0x69
>> [<ffffffff8130351c>] retint_signal+0x48/0x8c
>> [<ffffffff8100eea8>] ? rdtsc_barrier+0x0/0xc
>>
>> Regards
>> Sid.
>> --


-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

