Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab0GPWdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 18:33:53 -0400
Received: from ironport4.lbl.gov ([128.3.41.45]:38737 "EHLO ironport4.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252Ab0GPWdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 18:33:51 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jul 2010 18:33:51 EDT
X-Ironport-SBRS: 4.4
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjQCAN54QEzRVaA0kGdsb2JhbACfZggVAQEBAQkJDAcRAx+yRY4YhSQEg34
X-IronPort-AV: E=Sophos;i="4.55,216,1278313200"; 
   d="scan'208";a="24503733"
Message-ID: <4C40DC10.8050400@lbl.gov>
Date: Fri, 16 Jul 2010 15:24:16 -0700
From: Thomas Davis <tadavis@lbl.gov>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Peter Feuerer <peter@piie.net>
CC: Borislav Petkov <bp@alien8.de>, Branislav Gajdos <brianzee@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: acerhdf.c - unsupported notebook
References: <AANLkTin0mv0Z5vozJHkfVYCJTWMvj9JZnP_FcQ6vZBRV@mail.gmail.com> <20100713124840.GA16427@a1.tnic> <AANLkTimBhWKo0zxW6fX5RgLLAQVIdItS5RKpvxqkDlis@mail.gmail.com> <20100713151329.GA17516@a1.tnic> <cone.1279041124.439539.3902.1000@deskpiie>
In-Reply-To: <cone.1279041124.439539.3902.1000@deskpiie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 10:12 AM, Peter Feuerer wrote:
>
> Boris, I agree, we really should check the cpu specs. A quick search got
> me to this page:
> http://www.hardwaresecrets.com/article/Maximum-CPU-Temperature/143/5
> where we clearly see, that the core 2 have much lower critical
> temperatures. I added all those 1410* and 1810T* entries on behalf of
> people telling they'd have the fan control working with these lines for
> some weeks without problems and I didn't care about searching for the
> netbooks specifications. My fault.
>
> I would propose to enhance the bios_tbl by the default temperatures.
> What do you think?
>

I'm the person who figured out how the EC worked on the acer 1410, and 
sent the first patches in to make acer-hdf work on my 1410.

The bios turns the fan on full blast, and never throttles it.  there is 
another 3rd party application, for Windows7 that also does the same thing.

The CPU is CULV; ie:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Genuine Intel(R) CPU           U2300  @ 1.20GHz
stepping        : 10
cpu MHz         : 1197.118
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall 
nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm xsave lahf_lm tpr_shadow 
vnmi flexpriority
bogomips        : 2394.03
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


thomas
