Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab1FEJkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 05:40:18 -0400
Received: from higgs.elka.pw.edu.pl ([194.29.160.5]:46271 "EHLO
	higgs.elka.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab1FEJkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 05:40:16 -0400
X-Comment: RFC 2476 MSA function at elektron.elka.pw.edu.pl logged sender identity as: wzabolot
Message-ID: <4DEB4EF2.5050102@elektron.elka.pw.edu.pl>
Date: Sun, 05 Jun 2011 11:40:02 +0200
From: "wzabolot@elektron.elka.pw.edu.pl" <W.Zabolotny@elka.pw.edu.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel panic with 2.6.39.1 - switching off HT in BIOS helps
References: <4DEA8FDD.1060905@elektron.elka.pw.edu.pl> <4DEAA677.2010404@elektron.elka.pw.edu.pl> <4DEAAB42.8070704@elektron.elka.pw.edu.pl>
In-Reply-To: <4DEAAB42.8070704@elektron.elka.pw.edu.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I've just stated, that the machine, in which I've experienced the 
problem boots correctly also without "acpi=off", when I switch off
HyperThreading (HT) in BIOS. As kernel works correctly on machine
with "true SMP" (Intel Core2 Duo), it seems that the problem must be 
related to HT specific part of kernel:

first report and thread:  http://thread.gmane.org/gmane.linux.kernel/1150275
gzipped .config: 
http://cache.gmane.org//gmane/linux/kernel/1150276-001.bin )

Full output of the /proc/cpuinfo (under 2.6.37.3 kernel):
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Pentium(R) 4 CPU 2.80GHz
stepping	: 9
cpu MHz		: 2793.414
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr
bogomips	: 5589.61
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Pentium(R) 4 CPU 2.80GHz
stepping	: 9
cpu MHz		: 2793.414
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 1
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid xtpr
bogomips	: 5588.73
clflush size	: 64
cache_alignment	: 128
address sizes	: 36 bits physical, 32 bits virtual
power management:

