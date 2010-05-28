Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab0E1DCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 23:02:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48409 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0E1DCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 23:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=IeDdHGZfBhbzC0pxJ5VfFTpbGlo51RyYhUI1jnzvLJsU6mAQPXVH9OSsENVxsRMRC0
         7pQ8+H3oShwSyg6gWHVk1EVij7u4FTNgaOBCX9XDZZNeghvsCazj83oyZyWgLqltR3wr
         YjhdX1M3C9hE8I8NAi6tj1us3FuqBOJFC4gsI=
MIME-Version: 1.0
Date: Fri, 28 May 2010 02:54:38 +0000
Message-ID: <AANLkTim8vaJMBOoJeo74fTXWRV2l6JdyCWAOO2UeBFQg@mail.gmail.com>
Subject: build error
From: ranjith kumar <ranjithproxy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi
On my PC "uname -a" prints
Linux localhost.localdomain 2.6.29.4-167.fc11.i686.PAE #1 SMP Wed May
27 17:28:22 EDT 2009 i686 i686 i386 GNU/Linux

1)I tried to build many  linux kernel versions. But I always end up
error lik "file not recognized: File truncated"

For example when I tried to build linux-2.6.34(copied /boot/config
file, make oldconfig, make all), I got the follwing error:
 CC [M]  drivers/mtd/ubi/eba.o
  CC [M]  drivers/mtd/ubi/io.o
  CC [M]  drivers/mtd/ubi/wl.o
  CC [M]  drivers/mtd/ubi/scan.o
  CC [M]  drivers/mtd/ubi/misc.o
  LD [M]  drivers/mtd/ubi/ubi.o
drivers/mtd/ubi/eba.o: file not recognized: File truncated
make[3]: *** [drivers/mtd/ubi/ubi.o] Error 1
make[2]: *** [drivers/mtd/ubi] Error 2
make[1]: *** [drivers/mtd] Error 2
make: *** [drivers] Error 2

How to solve the problem?
2)And how to know processor family of my PC?
 1. 386 (M386)
  2. 486 (M486)
  3. 586/K5/5x86/6x86/6x86MX (M586)
  4. Pentium-Classic (M586TSC)
  5. Pentium-MMX (M586MMX)
> 6. Pentium-Pro (M686)
  7. Pentium-II/Celeron(pre-Coppermine) (MPENTIUMII)
  8. Pentium-III/Celeron(Coppermine)/Pentium-III Xeon (MPENTIUMIII)
  9. Pentium M (MPENTIUMM)
  10. Pentium-4/Celeron(P4-based)/Pentium-4 M/older Xeon (MPENTIUM4)
  11. K6/K6-II/K6-III (MK6)
  12. Athlon/Duron/K7 (MK7)
  13. Opteron/Athlon64/Hammer/K8 (MK8)
  14. Crusoe (MCRUSOE)
  15. Efficeon (MEFFICEON)
  16. Winchip-C6 (MWINCHIPC6)
  17. Winchip-2/Winchip-2A/Winchip-3 (MWINCHIP3D)
  18. GeodeGX1 (MGEODEGX1)
  19. Geode GX/LX (MGEODE_LX)
  20. CyrixIII/VIA-C3 (MCYRIXIII)
  21. VIA C3-2 (Nehemiah) (MVIAC3_2)
  22. VIA C7 (MVIAC7)
  23. Core 2/newer Xeon (MCORE2)
  24. Intel Atom (MATOM) (NEW)

cat /proc/cpuinfo command on my PC gives the following output:
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz
stepping	: 13
cpu MHz		: 1000.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl est tm2
ssse3 cx16 xtpr pdcm lahf_lm
bogomips	: 3325.21
clflush size	: 64
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz
stepping	: 13
cpu MHz		: 1000.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm
constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl est tm2
ssse3 cx16 xtpr pdcm lahf_lm
bogomips	: 3324.84
clflush size	: 64
power management:

Thanks in advance.
