Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1GaPUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 11:20:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53236 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1GaPUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 11:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110731110641.GG2209@sun>
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
	<20110731110641.GG2209@sun>
Date: Sun, 31 Jul 2011 17:20:15 +0200
Message-ID: <CAC9WiBgg+To8ggUvTqxOCy2hgb=XQCRH6D_0HFy4sEEoF8R0rw@mail.gmail.com>
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
From: Francis Moreau <francis.moro@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill

On Sun, Jul 31, 2011 at 1:06 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Sun, Jul 31, 2011 at 08:56:30AM +0200, Francis Moreau wrote:
>> Hello,
>>
>> I'm seeing those kernel message when resuming:
>>
>> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
>> [  524.973288] Do you have a strange power saving mode enabled?
>> [  524.973289] Dazed and confused, but trying to continue
>>
>> I don't know if it's important or not because the system seems to work
>> after but maybe it worths to report
>>
>
> Hi Francis, cpu please?
>

Still the same which causes some kvm-tools madness ;)

$ cat /proc/cpuinfo

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 460  @ 2.53GHz
stepping	: 5
cpu MHz		: 1197.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3
cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida arat dts tpr_shadow
vnmi flexpriority ept vpid
bogomips	: 5053.42
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 460  @ 2.53GHz
stepping	: 5
cpu MHz		: 1197.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 2
apicid		: 4
initial apicid	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3
cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida arat dts tpr_shadow
vnmi flexpriority ept vpid
bogomips	: 5053.72
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 460  @ 2.53GHz
stepping	: 5
cpu MHz		: 1197.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3
cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida arat dts tpr_shadow
vnmi flexpriority ept vpid
bogomips	: 5053.70
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 460  @ 2.53GHz
stepping	: 5
cpu MHz		: 1197.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 2
apicid		: 5
initial apicid	: 5
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3
cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida arat dts tpr_shadow
vnmi flexpriority ept vpid
bogomips	: 5053.74
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:



-- 
Francis
