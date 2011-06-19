Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab1FSCrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 22:47:17 -0400
Received: from nm12-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.11]:22028
	"HELO nm12-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751883Ab1FSCrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 22:47:15 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jun 2011 22:47:15 EDT
X-Yahoo-Newman-Id: 154406.43130.bm@omp1030.access.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:Message-ID:Organization:User-Agent:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=zByIUXe67T0+VXY3q4w9NDoc+Q4tnzXQiy6kWwhAKaSpWX+/XUOnbXFQ0rxkrcou7zW0Gwfvi24jrA/nGomGBmkthog+VkumBq6PETfzkcaJs7sggT/W5v5AkDCjauLCbJgGHMrKf27ET6RWVGMrJOm2w4vZaBLwD0h4LlTuIjM=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: ZMDa.4sVM1mtoHlRS7Dfxxc3LvjrzPxrgR.vAdWXm04DXG.
 i5fo.jPLWSdCexqlbJPNiwOjXlCHW_fo_yONxECep4atd58ZVAeXGWNqnQAW
 pPrGTNJeAtGcc7.F.F4cuRtajvpqxArFYS6TBNkBzi5QXy1YAu9qotm1C8ma
 .Au6icTpd.eQeFUSS5fGPvXcwXtdaBz6OP66Ukzq2wQVWGF1X9IKgkIffpSr
 t1QGtgszMTogrVJabQtNJD6Uh4yZrhitYeZqmEjqd8BYOL.WrZx5073FYzoQ
 nJ6l_zKX2NlLE8LLxHflnj4iHGxQ87PO.tB533zxSwHfqmuNCM3CU9cnmuEj
 VLkJ6O2ahhpaRUiLMl_pqGHvbFs1WtJzaHW0A9No-
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [3.0-rc2+][REGRESSION] using VirtualBox 64bit CPU detecton broke?
Date: Sat, 18 Jun 2011 22:40:06 -0400
Message-ID: <1552308.8jIRfYQQ5e@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.6.0 (Linux/3.0-0.rc3.git5.1.fc16.x86_64; KDE/4.6.80; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Folks, 

For some reason after 3.0-rc1 VirtualBox will not boot any 64bit operating 
systems even though this CPU is 64bit. I'm not sure if this is a VirtualBox 
issue or something changed in kernel that broke this.

Can anyone else confirm this as well? My current kernel is 
3.0-0.rc3.git5.1.fc16.x86_64

I don't suspect it's a Fedora specific patch that is causing this, but I'm not 
sure.

/proc/cpuinfo:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz
stepping        : 10
cpu MHz         : 800.000
cache size      : 6144 KB
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
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm 
constant_tsc arch_perfmon pebs bts nopl aperfmperf pni dtes64 monitor ds_cpl 
vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm ida dts tpr_shadow 
vnmi flexpriority
bogomips        : 5053.73
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


