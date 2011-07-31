Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab1GaLTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 07:19:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60589 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab1GaLTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 07:19:33 -0400
Message-ID: <4E353A41.2010405@gmail.com>
Date: Sun, 31 Jul 2011 13:19:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110716 Thunderbird/6.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Francis Moreau <francis.moro@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com> <20110731110641.GG2209@sun>
In-Reply-To: <20110731110641.GG2209@sun>
X-Enigmail-Version: 1.3a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2011 01:06 PM, Cyrill Gorcunov wrote:
> On Sun, Jul 31, 2011 at 08:56:30AM +0200, Francis Moreau wrote:
>> Hello,
>>
>> I'm seeing those kernel message when resuming:
>>
>> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
>> [  524.973288] Do you have a strange power saving mode enabled?
>> [  524.973289] Dazed and confused, but trying to continue
>>
>> I don't know if it's important or not because the system seems to work
>> after but maybe it worths to report
>>
> 
> Hi Francis, cpu please?

Hi, I'm seeing those too. For a longer time though. Please see
https://bugzilla.novell.com/show_bug.cgi?id=678882#c16

I suspect NMI watchdog rewrite caused this.

# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz
stepping        : 11
cpu MHz         : 2993.060
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts nopl aperfmperf pni
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm lahf_lm dts
tpr_shadow vnmi flexpriority
bogomips        : 5986.12
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6850  @ 3.00GHz
stepping        : 11
cpu MHz         : 2993.060
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx lm constant_tsc arch_perfmon pebs bts nopl aperfmperf pni
dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm lahf_lm dts
tpr_shadow vnmi flexpriority
bogomips        : 5984.98
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

thanks,
-- 
js
