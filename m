Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950Ab2FGOwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 10:52:34 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:37518 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab2FGOwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 10:52:32 -0400
MIME-Version: 1.0
Reply-To: rus@sfinxsoft.com
In-Reply-To: <20120607142459.GB5053@x1.osrc.amd.com>
References: <CAKgfjTktMLc5bfqhCOKy0evssxggofNQqLT-gQqBkHcBvOgF0g@mail.gmail.com>
 <CAKgfjTnvCAT=3JFxmDTsui_hguiiBfHQfMmErv9wt6QG_30hKA@mail.gmail.com> <20120607142459.GB5053@x1.osrc.amd.com>
From: Rus <rus@sfinxsoft.com>
Date: Thu, 7 Jun 2012 17:51:51 +0300
X-Google-Sender-Auth: MEMu3aFu1mV8nEmbYgr0wV5WBkc
Message-ID: <CAKgfjTn3KXmDio0F0M3syeHnDc=ByKZu1ipe7S+75KRcCBy0QA@mail.gmail.com>
Subject: Re: 3.[34].x Reproducable [Firmware bug] message upon warm boot only
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

>> Cold boot do not show this message. The hardware is Asus M5A97 PRO
>> (latest 1208 Bios) and FX-8150 CPU, 24GB RAM, the only system on this
>> box is Linux.
>
> Can you send /proc/cpuinfo from that box?
>

The /proc/cpuinfo :

.........
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 21
model		: 1
model name	: AMD FX(tm)-8150 Eight-Core Processor
stepping	: 2
microcode	: 0x6000626
cpu MHz		: 3600.000
cache size	: 2048 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 16
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid
aperfmperf pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 popcnt aes
xsave avx lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a
misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 nodeid_msr
topoext perfctr_core arat cpb hw_pstate npt lbrv svm_lock nrip_save
tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold
bogomips	: 7224.00
TLB size	: 1536 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual power management: ts
ttp tm 100mhzsteps hwpstate cpb
.....

>> Is this message harmless or this is some problem with hardware/bios/Linux ?
>
> Mostly harmless, fix is already upstream: f227d306cf3 and also on its
> way to stable. You can try 3.5-rc1 on the box (it should be pretty
> stable on AMD) or wait for the stable backport.

Ok, compiling ... will report soon. The reason I've asked - this
particular brand new box is freezing once at a 2-3 days without any
output - no oops, no sysrq, nothing. So I'm trying to investigate what
is the problem. The previous kernels (3.3.x) have the serious problem
with iommu - the onboard USB3.0 and Ethernet did not work at all on
them. The 3.4.x is better, but seems like still freezing.

Thanks

>
> Thanks.
>
> --
> Regards/Gruss,
> Boris.



-- 
SfinxSoft
http://sfinxsoft.com
