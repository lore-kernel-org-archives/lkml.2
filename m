Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab2FLPPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:15:32 -0400
Received: from nm28-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.234]:20084 "HELO
	nm28-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751725Ab2FLPPa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:15:30 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 734450.46668.bm@omp1044.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2eW/lRTaALPoccMsnqJRSq59mw2NLWKM3AOBAohPr5rgkv2+HnoAq5YzDwPMR4+c/7GwnYf3B9UL7Y4dYHeCeD1kXgzcVzhaoW0LJZxicc4V+2GEWIABVOPN9eI09/nWD/fY9+6kUeh4f2n5uzCKHsCtPMZ81YhqHg5GOdqdZ1g=;
X-YMail-OSG: wZAQh9oVM1mirvJkxGMDlV5gF5Gm7I612eTBDcnq0iZWWPX
 UwDNdCSyc1cgV7X5VcDbqibQrZK28hqLiZxbI3fHiKS0if7GiUKB0_UHUK1x
 izDpXxnsWhwKrvUt_r44EqWsyRRuwlMA7StFRXq0h6KrcW.jgnfVwJ8qrxnZ
 agS9_j6ZnBNE142anP8KWRDYKzO3B7SZM44Aro_YtBQQ4r1aKvBszk3GknBI
 qaBUKmfd5H1Qy78AVLMZmPxCJDdpFybfIcAEepntxJygj15Vh_osF5H7ypGA
 5Akz5IGt6hsjGRmkcdm2428qf4C4SW4kgRR2a0cGQKqJGnHQEhen9qhqcjVU
 TVAexZVZ40OKI73cP1g5I.UUOD0rvQ1h5GOp8cblVywDsUG3uKkCfIWyE5Y6
 SvxpQcOfOwtH6lgf1rv7pTX2jyuKNbIrII9KuF3f_tNCiul0r8vEmCIskl1I
 HIxSQjQ--
X-Mailer: YahooMailWebService/0.8.118.349524
References: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com> <20120612103954.GB10124@x1.osrc.amd.com> <1339508890.39685.YahooMailNeo@web111705.mail.gq1.yahoo.com> <4FD75C84.7020105@canonical.com>
Message-ID: <1339514128.5023.YahooMailNeo@web111708.mail.gq1.yahoo.com>
Date: Tue, 12 Jun 2012 08:15:28 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: CPU MTRRs and linux kernel
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "\"linux-kernel@vger.kernel.org\"" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <4FD75C84.7020105@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>And the latest kernel is 2.6.32-41.89 by now...

Sorry 3.4.2 ???
 

// Naderan *Mahmood;


----- Original Message -----
From: Stefan Bader <stefan.bader@canonical.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: Borislav Petkov <bp@alien8.de>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; Andreas Herrmann <andreas.herrmann3@amd.com>
Sent: Tuesday, June 12, 2012 7:43 PM
Subject: Re: CPU MTRRs and linux kernel

On 12.06.2012 15:48, Mahmood Naderan wrote:
> Thanks Borislav,
> I want to know, should I upgrade to the latest kernel or it is possible to download the source of 2.6.32-24 from repository and modify cleanup.c and then recompile?
> 
Just update to the latest kernel. 2.6.32-24.39 is way old. The fix Boris
mentioned was in 2.6.32-27.49. And the latest kernel is 2.6.32-41.89 by now...

-Stefan

> ~MN
> 
> ----- Original Message -----
> From: Borislav Petkov <bp@alien8.de>
> To: Mahmood Naderan <nt_mahmood@yahoo.com>
> Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; Andreas Herrmann <andreas.herrmann3@amd.com>
> Sent: Tuesday, June 12, 2012 3:09 PM
> Subject: Re: CPU MTRRs and linux kernel
> 
> On Tue, Jun 12, 2012 at 02:37:40AM -0700, Mahmood Naderan wrote:
>> Hi everybody,
>> Abour rhis warnning in boot log:
>>
>> WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 61952MB of RAM
>>
>>  
>> I
>>   searched a lot however didn't find a clear solution. Does AMD new 
>> processors (62XX) have problems with new kernels or old kernels??
>> Mine is:
>>
>> Linux n1 2.6.32-24-server #39-Ubuntu SMP Wed Jul 28 06:21:40 UTC 2010 x86_64 GNU/Linux
>>
>> Should I upgrade?
> 
> Yes, fix is below and it got backported to -stable AFAICT but obviously
> the ubuntus don't have it in the kernel you cite above.
> 
> 
> commit 3fdbf004c1706480a7c7fac3c9d836fa6df20d7d
> Author: Andreas Herrmann <andreas.herrmann3@amd.com>
> Date:   Thu Sep 30 14:32:35 2010 +0200
> 
>     x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future AMD CPUs
>    
>     Instead of adapting the CPU family check in amd_special_default_mtrr()
>     for each new CPU family assume that all new AMD CPUs support the
>     necessary bits in SYS_CFG MSR.
>    
>     Tom2Enabled is architectural (defined in APM Vol.2).
>     Tom2ForceMemTypeWB is defined in all BKDGs starting with K8 NPT.
>     In pre K8-NPT BKDG this bit is reserved (read as zero).
>    
>     W/o this adaption Linux would unnecessarily complain about bad MTRR
>     settings on every new AMD CPU family, e.g.
>    
>     [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 4863MB of RAM.
>    
>     Cc: stable@kernel.org # .32.x, .35.x
>     Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
>     LKML-Reference: <20100930123235.GB20545@loge.amd.com>
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
> index c5f59d071425..ac140c7be396 100644
> --- a/arch/x86/kernel/cpu/mtrr/cleanup.c
> +++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
> @@ -827,7 +827,7 @@ int __init amd_special_default_mtrr(void)
> 
>         if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
>                 return 0;
> -       if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
> +       if (boot_cpu_data.x86 < 0xf)
>                 return 0;
>         /* In case some hypervisor doesn't pass SYSCFG through: */
>         if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)
> 
