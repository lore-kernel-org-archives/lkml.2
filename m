Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab0CZEQ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 00:16:27 -0400
Received: from smtp-out4.blueyonder.co.uk ([195.188.213.7]:55139 "EHLO
	smtp-out4.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917Ab0CZEQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 00:16:24 -0400
Message-ID: <4BAC3515.4030708@blueyonder.co.uk>
Date: Fri, 26 Mar 2010 04:16:21 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-2.1 Thunderbird/3.0.3 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-x86_64@vger.kernel.org
Subject: Re: Fwd: Re: Boot failure 2.6.33 - 2.6.33-git12 - 2.6.34-rc2 inclusive
References: <4B9A4337.9030609@blueyonder.co.uk> <4BA233A9.1030407@blueyonder.co.uk>
In-Reply-To: <4BA233A9.1030407@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem still exists at 2.6.34-rc2-git2.
Motherboard/CPU/memory has been changed to Asus Crosshair III/AMD
Phenom(tm) II X4 965 Processor/8GB DDR3. Rebuilt kernel on the new
motherboard.
I notice that a kernel that boots generates far more output than I see
with kernels up to 2.6.34-rc2-git2, tried and rebuilt without netconsole.

Here is the full output
========================
==== 4 Penguins appear, then the following output and the freeze ====
Console: switching to colour frame buffer device 160x64
fb0: VESA VGA frame buffer device
Initializing Nozomi driver 2.1d (build date: Mar 25 2010 13:37:52)
Non-volatile memory driver 1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 8 ports, IRQ sharing disables
Console [netcon0] enabled
netconsole: network logging started
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
registered taskstats version 1
Kmemleak: kernel memory leak detector initialized
Kmemleak: Automatic memory scanning thread started
No TPM chip found, activating TPM-bypass!
Freeing unused kernel memory: 688K freed
Write Protecting kernel memory read-only data: 6144K
Testing CPA: undo ffffffff81000000 - ffffffff81600000
Testing CPA: again
Freeing unused kernel memory: 964K freed
Freeing unused kernel memory: 212K freed
init[1] segfault at ffffffff8100eea8 ip ffffffff8100eea8 sp
00007fff62e804b8 error 15
kernel panic - not syncing: Attempted to kill init!
Pid: 1,comm: init not tainted 2.6.33-git12-smp #2
Call Trace:
[<ffffffff81300876>] panic+0x73/0xfa
[<ffffffff8104b45c>] do_exit+0x6d/0x713
[<ffffffff8104bd85>] do_group_exit+0x72/0x9b
[<ffffffff8105917e>] get_signal_to_deliver+0x356/0x375
[<ffffffff8130310b>] ? _raw_spin_unlock_irqrestore+0x2f/0x34
[<ffffffff81007fc3>] do_signal+0x6d/0x660
[<ffffffff81300939>] ? printk+0x3c/0x43
[<ffffffff8100eea8>] ? rdtsc_barrier+0x0/0xc
[<ffffffff81300939>] ? printk+0x3c/0x43
[<ffffffff8102b78c>] ? __bad_area_nosemaphore+0x183/0x1ad
[<ffffffff8100eea8>] ? rdtsc_barrier+0x0/0xc
[<ffffffff810085fc>] do_notify_resume+0x27/0x69
[<ffffffff8130351c>] retint_signal+0x48/0x8c
[<ffffffff8100eea8>] ? rdtsc_barrier+0x0/0xc
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

