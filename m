Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab1GYV4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:56:15 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:60395 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751290Ab1GYV4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:56:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JimhgwBE9WaIFe1zj1avjUwM7fYHTR17Mz6C0ILiG8BFhzOThrjseECYeLjNJ9o7ZaeU7ijNz8joFXpgFhCimszdBl+XiJesjslDuRgX4PwQDpDGhJTyrbQ09R0bB20b;
Date: Mon, 25 Jul 2011 14:56:06 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Subject: [PATCH] Documentation: general cleanup of kernel-parameters.txt
Message-Id: <20110725145606.39255bcd.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

General cleanups to kernel-parameters.txt:
- add missing $ARCH that are being used/referenced
- alphabetize the parameter restrictions list
- spell "IA-64" as listed in arch/ia64/Kconfig instead of "IA64"
- remove trailing whitespace
- use hyphen in 32-bit etc.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 Documentation/kernel-parameters.txt |   42 +++++++++++++-------------
 1 file changed, 22 insertions(+), 20 deletions(-)

--- lnx-300.orig/Documentation/kernel-parameters.txt
+++ lnx-300/Documentation/kernel-parameters.txt
@@ -40,6 +40,7 @@ parameter is applicable:
 	ALSA	ALSA sound support is enabled.
 	APIC	APIC support is enabled.
 	APM	Advanced Power Management support is enabled.
+	ARM	ARM architecture is enabled.
 	AVR32	AVR32 architecture is enabled.
 	AX25	Appropriate AX.25 support is enabled.
 	BLACKFIN Blackfin architecture is enabled.
@@ -49,6 +50,7 @@ parameter is applicable:
 	EFI	EFI Partitioning (GPT) is enabled
 	EIDE	EIDE/ATAPI support is enabled.
 	FB	The frame buffer device is enabled.
+	FTRACE	Function tracing enabled.
 	GCOV	GCOV profiling is enabled.
 	HW	Appropriate hardware is enabled.
 	IA-64	IA-64 architecture is enabled.
@@ -69,6 +71,7 @@ parameter is applicable:
 			Documentation/m68k/kernel-options.txt.
 	MCA	MCA bus support is enabled.
 	MDA	MDA console support is enabled.
+	MIPS	MIPS architecture is enabled.
 	MOUSE	Appropriate mouse support is enabled.
 	MSI	Message Signaled Interrupts (PCI).
 	MTD	MTD (Memory Technology Device) support is enabled.
@@ -100,7 +103,6 @@ parameter is applicable:
 	SPARC	Sparc architecture is enabled.
 	SWSUSP	Software suspend (hibernation) is enabled.
 	SUSPEND	System suspend states are enabled.
-	FTRACE	Function tracing enabled.
 	TPM	TPM drivers are enabled.
 	TS	Appropriate touchscreen support is enabled.
 	UMS	USB Mass Storage support is enabled.
@@ -115,7 +117,7 @@ parameter is applicable:
 	X86-64	X86-64 architecture is enabled.
 			More X86-64 boot options can be found in
 			Documentation/x86/x86_64/boot-options.txt .
-	X86	Either 32bit or 64bit x86 (same as X86-32+X86-64)
+	X86	Either 32-bit or 64-bit x86 (same as X86-32+X86-64)
 	XEN	Xen support is enabled
 
 In addition, the following text indicates that the option:
@@ -371,7 +373,7 @@ bytes respectively. Such letter suffixes
 	atkbd.softrepeat= [HW]
 			Use software keyboard repeat
 
-	autotest	[IA64]
+	autotest	[IA-64]
 
 	baycom_epp=	[HW,AX25]
 			Format: <io>,<mode>
@@ -673,8 +675,8 @@ bytes respectively. Such letter suffixes
 		uart[8250],mmio32,<addr>[,options]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address.
-			MMIO inter-register address stride is either 8bit (mmio)
-                        or 32bit (mmio32).
+			MMIO inter-register address stride is either 8-bit
+			(mmio) or 32-bit (mmio32).
 			The options are the same as for ttyS, above.
 
 	earlyprintk=	[X86,SH,BLACKFIN]
@@ -717,7 +719,7 @@ bytes respectively. Such letter suffixes
 			See Documentation/block/as-iosched.txt and
 			Documentation/block/deadline-iosched.txt for details.
 
-	elfcorehdr=	[IA64,PPC,SH,X86]
+	elfcorehdr=	[IA-64,PPC,SH,X86]
 			Specifies physical address of start of kernel core
 			image elf header. Generally kexec loader will
 			pass this option to capture kernel.
@@ -783,7 +785,7 @@ bytes respectively. Such letter suffixes
 			tracer at boot up. function-list is a comma separated
 			list of functions. This list can be changed at run
 			time by the set_ftrace_filter file in the debugfs
-			tracing directory. 
+			tracing directory.
 
 	ftrace_notrace=[function-list]
 			[FTRACE] Do not trace the functions specified in
@@ -821,7 +823,7 @@ bytes respectively. Such letter suffixes
 
 	hashdist=	[KNL,NUMA] Large hashes allocated during boot
 			are distributed across NUMA nodes.  Defaults on
-			for 64bit NUMA, off otherwise.
+			for 64-bit NUMA, off otherwise.
 			Format: 0 | 1 (for off | on)
 
 	hcl=		[IA-64] SGI's Hardware Graph compatibility layer
@@ -990,10 +992,10 @@ bytes respectively. Such letter suffixes
 			DMA.
 		forcedac [x86_64]
 			With this option iommu will not optimize to look
-			for io virtual address below 32 bit forcing dual
+			for io virtual address below 32-bit forcing dual
 			address cycle on pci bus for cards supporting greater
-			than 32 bit addressing. The default is to look
-			for translation below 32 bit and if not available
+			than 32-bit addressing. The default is to look
+			for translation below 32-bit and if not available
 			then look in the higher range.
 		strict [Default Off]
 			With this option on every unmap_single operation will
@@ -1009,7 +1011,7 @@ bytes respectively. Such letter suffixes
 			off	disable Interrupt Remapping
 			nosid	disable Source ID checking
 
-	inttest=	[IA64]
+	inttest=	[IA-64]
 
 	iomem=		Disable strict checking of access to MMIO memory
 		strict	regions from userspace.
@@ -1026,7 +1028,7 @@ bytes respectively. Such letter suffixes
 		nomerge
 		forcesac
 		soft
-		pt	[x86, IA64]
+		pt	[x86, IA-64]
 
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
@@ -1157,7 +1159,7 @@ bytes respectively. Such letter suffixes
 
 	kvm-amd.npt=	[KVM,AMD] Disable nested paging (virtualized MMU)
 			for all guests.
-			Default is 1 (enabled) if in 64bit or 32bit-PAE mode
+			Default is 1 (enabled) if in 64-bit or 32-bit PAE mode.
 
 	kvm-intel.bypass_guest_pf=
 			[KVM,Intel] Disables bypassing of guest page faults
@@ -1198,10 +1200,10 @@ bytes respectively. Such letter suffixes
 			libata.dma=0	  Disable all PATA and SATA DMA
 			libata.dma=1	  PATA and SATA Disk DMA only
 			libata.dma=2	  ATAPI (CDROM) DMA only
-			libata.dma=4	  Compact Flash DMA only 
+			libata.dma=4	  Compact Flash DMA only
 			Combinations also work, so libata.dma=3 enables DMA
 			for disks and CDROMs, but not CFs.
-	
+
 	libata.ignore_hpa=	[LIBATA] Ignore HPA limit
 			libata.ignore_hpa=0	  keep BIOS limits (default)
 			libata.ignore_hpa=1	  ignore limits, using full disk
@@ -1327,7 +1329,7 @@ bytes respectively. Such letter suffixes
 	ltpc=		[NET]
 			Format: <io>,<irq>,<dma>
 
-	machvec=	[IA64] Force the use of a particular machine-vector
+	machvec=	[IA-64] Force the use of a particular machine-vector
 			(machvec) in a generic kernel.
 			Example: machvec=hpzx1_swiotlb
 
@@ -1730,7 +1732,7 @@ bytes respectively. Such letter suffixes
 
 	nointroute	[IA-64]
 
-	nojitter	[IA64] Disables jitter checking for ITC timers.
+	nojitter	[IA-64] Disables jitter checking for ITC timers.
 
 	no-kvmclock	[X86,KVM] Disable paravirtualized KVM clock driver
 
@@ -1792,7 +1794,7 @@ bytes respectively. Such letter suffixes
 
 	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
 
-	nptcg=		[IA64] Override max number of concurrent global TLB
+	nptcg=		[IA-64] Override max number of concurrent global TLB
 			purges which is reported from either PAL_VM_SUMMARY or
 			SAL PALO.
 
@@ -2067,7 +2069,7 @@ bytes respectively. Such letter suffixes
 			Format: { parport<nr> | timid | 0 }
 			See also Documentation/parport.txt.
 
-	pmtmr=		[X86] Manual setup of pmtmr I/O Port. 
+	pmtmr=		[X86] Manual setup of pmtmr I/O Port.
 			Override pmtimer IOPort with a hex value.
 			e.g. pmtmr=0x508
 
