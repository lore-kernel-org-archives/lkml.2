Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab0EaBig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 21:38:36 -0400
Received: from mga10.intel.com ([192.55.52.92]:29909 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755298Ab0EaBif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 21:38:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,330,1272870000"; 
   d="scan'208";a="803259552"
Date: Mon, 31 May 2010 09:39:50 +0800
From: Huaxu Wan <huaxu.wan@linux.intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Huaxu Wan <huaxu.wan@linux.intel.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, huaxu.wan@intel.com, khali@linux-fr.org
Subject: Re: [PATCH 2/2] hwmon: (coretemp) Get TjMax value from MSR
Message-ID: <20100531013950.GA8265@owl>
References: <20100507095945.GB12190@owl>
 <1275111551.3427.4.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275111551.3427.4.camel@maxim-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:39 Sat 29 May, Maxim Levitsky wrote:
> On Fri, 2010-05-07 at 17:59 +0800, Huaxu Wan wrote: 
> > The MSR IA32_TEMPERATURE_TARGET contains the TjMax value in the newer
> > processers.
> 
> I know that TjMax on my system is 85, and now coretemp reports wrong
> temperatures.
> First of all BIOS using stupid tricks actualy reports CPU temperature
> through ACPI, and assuming it was correct TjMax is 85.
> It also shuts down the system if I 'lie' to it that cpu temperature is
> 85C.

>From the list at [1], the TjMax(Tjunction) of T5450 is 100C. Does anyone
here can make a double check?

[1] http://ark.intel.com/Product.aspx?id=30787&processor=T5450&spec-codes=SLA4F

Thanks
Huaxu



> 
> Coretemp was working correctly in 2.6.34
> 
> cat /proc/cpuinfo
> 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz
> stepping	: 13
> cpu MHz		: 1667.000
> cache size	: 2048 KB
> physical id	: 0
> siblings	: 2
> core id		: 0
> cpu cores	: 2
> apicid		: 0
> initial apicid	: 0
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm lahf_lm
> bogomips	: 3324.70
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> processor	: 1
> vendor_id	: GenuineIntel
> cpu family	: 6
> model		: 15
> model name	: Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz
> stepping	: 13
> cpu MHz		: 1667.000
> cache size	: 2048 KB
> physical id	: 0
> siblings	: 2
> core id		: 1
> cpu cores	: 2
> apicid		: 1
> initial apicid	: 1
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 10
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor ds_cpl est tm2 ssse3 cx16 xtpr pdcm lahf_lm
> bogomips	: 3324.99
> clflush size	: 64
> cache_alignment	: 64
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> 
> Best regards,
> 	Maxim Levitsky
> 
