Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab1JXTpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 15:45:04 -0400
Received: from smith.tjhsst.edu ([198.38.16.131]:55468 "EHLO smith.tjhsst.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab1JXTpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 15:45:01 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Oct 2011 15:45:01 EDT
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Mon, 24 Oct 2011 15:34:57 -0400
From: 2013pfoley <2013pfoley@tjhsst.edu>
To: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Cc: Andrew Hamilton <ahamilto@tjhsst.edu>
Subject: Xen dom0 linux kernel 3.1 boot failure =?UTF-8?Q?ptwr=5Femulate?=
 =?UTF-8?Q?=3A=20could=20not=20get=5Fpage=5Ffrom=5Fl=31e?=
Message-ID: <05c3da5dc6158197e28d62e853ac2f04@tjhsst.edu>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi,

 I'm having xen dom0 crash during bootup when using the linux 3.1 kernel 
 however it worked when using the linux 2.6.34 kernel.
 I tried using xen-unstable but got the exact same error as with xen 
 4.1.1.

 xen-unstable changeset:   23981:6c583d35d76d
 linux kernel 3.1.0

 I've included the backtrace below.
 let me know if you need any more info.

 Peter


 root (hd0,0)
  Filesystem type is ext2fs, partition type 0x83
 kernel /boot/xen2.gz com2=9600,8n1 console=com2 loglvl=all 
 guest_loglvl=all nor
 eboot
    [Multiboot-elf, <0x100000:0x19ae10:0x5c1f0>, shtab=0x2f7078, 
 entry=0x100000]
 module /boot/kernel-xen-git root=/dev/sda2 bonding.mode=4 
 bonding.miimon=100 co
 nsole=hvc0 debug initcall_debug earlyprintk=xen
    [Multiboot-module @ 0x2f8000, 0x1410eb7 bytes]














  __  __            _  _    ____                     _        _     _
  \ \/ /___ _ __   | || |  |___ \    _   _ _ __  ___| |_ __ _| |__ | | 
 ___
   \  // _ \ '_ \  | || |_   __) |__| | | | '_ \/ __| __/ _` | '_ \| |/ 
 _ \
   /  \  __/ | | | |__   _| / __/|__| |_| | | | \__ \ || (_| | |_) | |  
 __/
  /_/\_\___|_| |_|    |_|(_)_____|   \__,_|_| 
 |_|___/\__\__,_|_.__/|_|\___|
 
 (XEN) Xen version 4.2-unstable (2013pfoley@csl.tjhsst.edu) (gcc version 
 4.5.3 (Gentoo 4.5.3-r1 p1.0, pie-0.4.5) ) Fri Oct 21 15:10:43 EDT 2011
 (XEN) Latest ChangeSet: Thu Oct 20 15:36:01 2011 +0100 
 23981:6c583d35d76d
 (XEN) Bootloader: GNU GRUB 0.97
 (XEN) Command line: com2=9600,8n1 console=com2 loglvl=all 
 guest_loglvl=all noreboot
 (XEN) Video information:
 (XEN)  VGA is text mode 80x25, font 8x16
 (XEN)  VBE/DDC methods: none; EDID transfer time: 2 seconds
 (XEN)  EDID info not retrieved because no DDC retrieval method detected
 (XEN) Disc information:
 (XEN)  Found 1 MBR signatures
 (XEN)  Found 1 EDD information structures
 (XEN) Xen-e820 RAM map:
 (XEN)  0000000000000000 - 000000000009f400 (usable)
 (XEN)  000000000009f400 - 00000000000a0000 (reserved)
 (XEN)  00000000000f0000 - 0000000000100000 (reserved)
 (XEN)  0000000000100000 - 00000000df61f000 (usable)
 (XEN)  00000000df61f000 - 00000000df62c000 (ACPI data)
 (XEN)  00000000df62c000 - 00000000df62d000 (usable)
 (XEN)  00000000df62d000 - 00000000e4000000 (reserved)
 (XEN)  00000000fec00000 - 00000000fee10000 (reserved)
 (XEN)  00000000ff800000 - 0000000100000000 (reserved)
 (XEN)  0000000100000000 - 000000061ffff000 (usable)
 (XEN) ACPI: RSDP 000F4F00, 0024 (r2 HP    )
 (XEN) ACPI: XSDT DF620340, 00B4 (r1 HP     ProLiant        2   �     
 162E)
 (XEN) ACPI: FACP DF620440, 00F4 (r3 HP     ProLiant        2   �     
 162E)
 (XEN) ACPI: DSDT DF620540, 200D (r1 HP         DSDT        1 INTL 
 20030228)
 (XEN) ACPI: FACS DF61F100, 0040
 (XEN) ACPI: SPCR DF61F140, 0050 (r1 HP     SPCRRBSU        1   �     
 162E)
 (XEN) ACPI: MCFG DF61F1C0, 003C (r1 HP     ProLiant        1            
 0)
 (XEN) ACPI: HPET DF61F200, 0038 (r1 HP     ProLiant        2   �     
 162E)
 (XEN) ACPI: FFFF DF61F240, 0064 (r2 HP     ProLiant        2   �     
 162E)
 (XEN) ACPI: SPMI DF61F2C0, 0040 (r5 HP     ProLiant        1   �     
 162E)
 (XEN) ACPI: ERST DF61F300, 01D0 (r1 HP     ProLiant        1   �     
 162E)
 (XEN) ACPI: APIC DF61F500, 015E (r1 HP     ProLiant        2            
 0)
 (XEN) ACPI: SRAT DF61F680, 0570 (r1 HP     Proliant        1   �     
 162E)
 (XEN) ACPI: FFFF DF61FC00, 0176 (r1 HP     ProLiant        1   �     
 162E)
 (XEN) ACPI: BERT DF61FD80, 0030 (r1 HP     ProLiant        1   �     
 162E)
 (XEN) ACPI: HEST DF61FDC0, 00BC (r1 HP     ProLiant        1   �     
 162E)
 (XEN) ACPI: DMAR DF61FE80, 0154 (r1 HP     ProLiant        1   �     
 162E)
 (XEN) ACPI: SSDT DF622580, 0125 (r3     HP  CRSPCI0        2   HP       
 1)
 (XEN) ACPI: SSDT DF6226C0, 0255 (r3     HP  riser1a        2 INTL 
 20061109)
 (XEN) ACPI: SSDT DF622940, 03BB (r1     HP      pcc        1 INTL 
 20090625)
 (XEN) ACPI: SSDT DF622D00, 0377 (r1     HP     pmab        1 INTL 
 20090625)
 (XEN) ACPI: SSDT DF623080, 2B64 (r1  INTEL PPM RCM         1 INTL 
 20061109)
 (XEN) System RAM: 24565MB (25155320kB)
 (XEN) SRAT: PXM 0 -> APIC 0 -> Node 0
 (XEN) SRAT: PXM 0 -> APIC 1 -> Node 0
 (XEN) SRAT: PXM 0 -> APIC 2 -> Node 0
 (XEN) SRAT: PXM 0 -> APIC 3 -> Node 0
 (XEN) SRAT: PXM 0 -> APIC 4 -> Node 0
 (XEN) SRAT: PXM 0 -> APIC 5 -> Node 0
 (XEN) SRAT: PXM 0 -> APIC 6 -> Node 0
 (XEN) SRAT: PXM 0 -> APIC 7 -> Node 0
 (XEN) SRAT: PXM 1 -> APIC 16 -> Node 1
 (XEN) SRAT: PXM 1 -> APIC 17 -> Node 1
 (XEN) SRAT: PXM 1 -> APIC 18 -> Node 1
 (XEN) SRAT: PXM 1 -> APIC 19 -> Node 1
 (XEN) SRAT: PXM 1 -> APIC 20 -> Node 1
 (XEN) SRAT: PXM 1 -> APIC 21 -> Node 1
 (XEN) SRAT: PXM 1 -> APIC 22 -> Node 1
 (XEN) SRAT: PXM 1 -> APIC 23 -> Node 1
 (XEN) SRAT: Node 0 PXM 0 0-e0000000
 (XEN) SRAT: Node 0 PXM 0 100000000-320000000
 (XEN) SRAT: Node 1 PXM 1 320000000-620000000
 (XEN) NUMA: Using 17 for the hash shift.
 (XEN) Domain heap initialised DMA width 31 bits
 (XEN) found SMP MP-table at 000f4f80
 (XEN) DMI 2.7 present.
 (XEN) Using APIC driver default
 (XEN) ACPI: PM-Timer IO Port: 0x908
 (XEN) ACPI: ACPI SLEEP INFO: pm1x_cnt[904,0], pm1x_evt[900,0]
 (XEN) ACPI:                  wakeup_vec[df61f10c], vec_size[20]
 (XEN) ACPI: Local APIC address 0xfee00000
 (XEN) ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
 (XEN) Processor #0 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
 (XEN) Processor #16 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
 (XEN) Processor #4 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
 (XEN) Processor #20 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
 (XEN) Processor #2 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
 (XEN) Processor #18 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
 (XEN) Processor #6 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] enabled)
 (XEN) Processor #22 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
 (XEN) Processor #1 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
 (XEN) Processor #17 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
 (XEN) Processor #5 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
 (XEN) Processor #21 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
 (XEN) Processor #3 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
 (XEN) Processor #19 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
 (XEN) Processor #7 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] disabled)
 (XEN) ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
 (XEN) Processor #23 7:10 APIC version 21
 (XEN) ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] disabled)
 (XEN) ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
 (XEN) Overriding APIC driver with bigsmp
 (XEN) ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
 (XEN) IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
 (XEN) ACPI: IOAPIC (id[0x00] address[0xfec80000] gsi_base[24])
 (XEN) IOAPIC[1]: apic_id 0, version 32, address 0xfec80000, GSI 24-47
 (XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
 (XEN) ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
 (XEN) ACPI: IRQ0 used by override.
 (XEN) ACPI: IRQ2 used by override.
 (XEN) ACPI: IRQ9 used by override.
 (XEN) Enabling APIC mode:  Phys.  Using 2 I/O APICs
 (XEN) ACPI: HPET id: 0x8086a201 base: 0xfed00000
 (XEN) ERST table is invalid
 (XEN) Using ACPI (MADT) for SMP configuration information
 (XEN) IRQ limits: 48 GSI, 3040 MSI/MSI-X
 (XEN) Using scheduler: SMP Credit Scheduler (credit)
 (XEN) Detected 2266.778 MHz processor.
 (XEN) Initing memory sharing.
 (XEN) mce_intel.c:1219: MCA Capability: BCAST 1 SER 0 CMCI 1 firstbank 
 0 extended MCE MSR 0
 (XEN) Intel machine check reporting enabled
 (XEN) PCI: MCFG configuration 0: base e0000000 segment 0000 buses 00 - 
 3f
 (XEN) PCI: MCFG area at e0000000 reserved in E820
 (XEN) PCI: Using MCFG for segment 0000 bus 00-3f
 (XEN) Intel VT-d Snoop Control not enabled.
 (XEN) Intel VT-d Dom0 DMA Passthrough not enabled.
 (XEN) Intel VT-d Queued Invalidation enabled.
 (XEN) Intel VT-d Interrupt Remapping enabled.
 (XEN) Intel VT-d Shared EPT tables not enabled.
 (XEN) I/O virtualisation enabled
 (XEN)  - Dom0 mode: Relaxed
 (XEN) ENABLING IO-APIC IRQs
 (XEN)  -> Using new ACK method
 (XEN) ..TIMER: vector=0xF0 apic1=0 pin1=2 apic2=-1 pin2=-1
 (XEN) Platform timer is 14.318MHz HPET
 (XEN) Allocated console ring of 128 KiB.
 (XEN) VMX: Supported advanced features:
 (XEN)  - APIC MMIO access virtualisation
 (XEN)  - APIC TPR shadow
 (XEN)  - Extended Page Tables (EPT)
 (XEN)  - Virtual-Processor Identifiers (VPID)
 (XEN)  - Virtual NMI
 (XEN)  - MSR direct-access bitmap
 (XEN) EPT supports 2MB super page.
 (XEN) HVM: ASIDs enabled.
 (XEN) HVM: VMX enabled
 (XEN) HVM: Hardware Assisted Paging detected.
 (XEN) Brought up 16 CPUs
 (XEN) HPET's MSI mode hasn't been supported when Interrupt Remapping is 
 enabled.
 (XEN) ACPI sleep modes: S3
 (XEN) mcheck_poll: Machine check polling timer started.
 (XEN) *** LOADING DOMAIN 0 ***
 (XEN) elf_parse_binary: phdr: paddr=0x1000000 memsz=0xa69000
 (XEN) elf_parse_binary: phdr: paddr=0x1c00000 memsz=0x990e0
 (XEN) elf_parse_binary: phdr: paddr=0x1c9a000 memsz=0x13400
 (XEN) elf_parse_binary: phdr: paddr=0x1cae000 memsz=0x2d4000
 (XEN) elf_parse_binary: memory: 0x1000000 -> 0x1f82000
 (XEN) elf_xen_parse_note: GUEST_OS = "linux"
 (XEN) elf_xen_parse_note: GUEST_VERSION = "2.6"
 (XEN) elf_xen_parse_note: XEN_VERSION = "xen-3.0"
 (XEN) elf_xen_parse_note: VIRT_BASE = 0xffffffff80000000
 (XEN) elf_xen_parse_note: ENTRY = 0xffffffff81cae200
 (XEN) elf_xen_parse_note: HYPERCALL_PAGE = 0xffffffff81001000
 (XEN) elf_xen_parse_note: FEATURES = 
 "!writable_page_tables|pae_pgdir_above_4gb"
 (XEN) elf_xen_parse_note: PAE_MODE = "yes"
 (XEN) elf_xen_parse_note: LOADER = "generic"
 (XEN) elf_xen_parse_note: unknown xen elf note (0xd)
 (XEN) elf_xen_parse_note: SUSPEND_CANCEL = 0x1
 (XEN) elf_xen_parse_note: HV_START_LOW = 0xffff800000000000
 (XEN) elf_xen_parse_note: PADDR_OFFSET = 0x0
 (XEN) elf_xen_addr_calc_check: addresses:
 (XEN)     virt_base        = 0xffffffff80000000
 (XEN)     elf_paddr_offset = 0x0
 (XEN)     virt_offset      = 0xffffffff80000000
 (XEN)     virt_kstart      = 0xffffffff81000000
 (XEN)     virt_kend        = 0xffffffff81f82000
 (XEN)     virt_entry       = 0xffffffff81cae200
 (XEN)     p2m_base         = 0xffffffffffffffff
 (XEN)  Xen  kernel: 64-bit, lsb, compat32
 (XEN)  Dom0 kernel: 64-bit, PAE, lsb, paddr 0x1000000 -> 0x1f82000
 (XEN) PHYSICAL MEMORY ARRANGEMENT:
 (XEN)  Dom0 alloc.:   0000000608000000->0000000610000000 (6140612 pages 
 to be allocated)
 (XEN) VIRTUAL MEMORY ARRANGEMENT:
 (XEN)  Loaded kernel: ffffffff81000000->ffffffff81f82000
 (XEN)  Init. ramdisk: ffffffff81f82000->ffffffff81f82000
 (XEN)  Phys-Mach map: ffffffff81f82000->ffffffff84e9b620
 (XEN)  Start info:    ffffffff84e9c000->ffffffff84e9c4b4
 (XEN)  Page tables:   ffffffff84e9d000->ffffffff84ec8000
 (XEN)  Boot stack:    ffffffff84ec8000->ffffffff84ec9000
 (XEN)  TOTAL:         ffffffff80000000->ffffffff85000000
 (XEN)  ENTRY ADDRESS: ffffffff81cae200
 (XEN) Dom0 has maximum 16 VCPUs
 (XEN) elf_load_binary: phdr 0 at 0xffffffff81000000 -> 
 0xffffffff81a69000
 (XEN) elf_load_binary: phdr 1 at 0xffffffff81c00000 -> 
 0xffffffff81c990e0
 (XEN) elf_load_binary: phdr 2 at 0xffffffff81c9a000 -> 
 0xffffffff81cad400
 (XEN) elf_load_binary: phdr 3 at 0xffffffff81cae000 -> 
 0xffffffff81d54000
 (XEN) Scrubbing Free RAM: .done.
 (XEN) Std. Loglevel: All
 (XEN) Guest Loglevel: All
 (XEN) *** Serial input -> DOM0 (type 'CTRL-a' three times to switch 
 input to Xen)
 (XEN) Freed 244kB init memory.
 mapping kernel into physical memory
 Xen: setup ISA identity maps
 about to get started...
 [    0.000000] Initializing cgroup subsys cpuset
 [    0.000000] Initializing cgroup subsys cpu
 [    0.000000] Linux version 3.1.0 (root@galapagos) (gcc version 4.5.3 
 (Gentoo 4.5.3-r1 p1.0, pie-0.4.5) ) #4 SMP Mon Oct 24 15:03:22 EDT 2011
 [    0.000000] Command line: root=/dev/sda2 bonding.mode=4 
 bonding.miimon=100 console=hvc0 debug initcall_debug earlyprintk=xen
 [    0.000000] Freeing  e4000-fec00 pfn range: 109568 pages freed
 [    0.000000] Freeing  fee10-ff800 pfn range: 2544 pages freed
 [    0.000000] released 112112 pages of unused memory
 [    0.000000] 1-1 mapping on a0->100
 [    0.000000] 1-1 mapping on df61f->df62c
 [    0.000000] 1-1 mapping on df62d->100000
 [    0.000000] Set 133696 page(s) to 1-1 mapping.
 [    0.000000] BIOS-provided physical RAM map:
 [    0.000000]  Xen: 0000000000000000 - 000000000009f000 (usable)
 [    0.000000]  Xen: 000000000009f400 - 0000000000100000 (reserved)
 [    0.000000]  Xen: 0000000000100000 - 00000000df61f000 (usable)
 [    0.000000]  Xen: 00000000df61f000 - 00000000df62c000 (ACPI data)
 [    0.000000]  Xen: 00000000df62c000 - 00000000df62d000 (usable)
 [    0.000000]  Xen: 00000000df62d000 - 00000000e4000000 (reserved)
 [    0.000000]  Xen: 00000000fec00000 - 00000000fee10000 (reserved)
 [    0.000000]  Xen: 00000000ff800000 - 0000000100000000 (reserved)
 [    0.000000]  Xen: 0000000100000000 - 000000063b5ef000 (usable)
 [    0.000000] bootconsole [xenboot0] enabled
 [    0.000000] NX (Execute Disable) protection: active
 [    0.000000] DMI 2.7 present.
 [    0.000000] DMI: HP ProLiant DL380 G6, BIOS P62 05/05/2011
 [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 
 (usable) ==> (reserved)
 [    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 
 (usable)
 [    0.000000] No AGP bridge found
 [    0.000000] last_pfn = 0x63b5ef max_arch_pfn = 0x400000000
 [    0.000000] last_pfn = 0xdf62d max_arch_pfn = 0x400000000
 [    0.000000] found SMP MP-table at [ffff8800000f4f80] f4f80
 (XEN) mm.c:945:d0 Error getting mfn 100 (pfn 5555555555555555) from L1 
 entry 8000000000100461 for l1e_owner=0, pg_owner=0
 (XEN) mm.c:5046:d0 ptwr_emulate: could not get_page_from_l1e()
 [    0.000000] BUG: unable to handle kernel NULL pointer dereference at 
          (null)
 [    0.000000] IP: [<ffffffff81008a5a>] xen_set_pte+0x3a/0x1f0
 [    0.000000] PGD 0
 [    0.000000] Oops: 0003 [#1] SMP
 [    0.000000] CPU 0
 [    0.000000] Modules linked in:
 [    0.000000]
 [    0.000000] Pid: 0, comm: swapper Not tainted 3.1.0 #4 HP ProLiant 
 DL380 G6
 [    0.000000] RIP: e030:[<ffffffff81008a5a>]  [<ffffffff81008a5a>] 
 xen_set_pte+0x3a/0x1f0
 [    0.000000] RSP: e02b:ffffffff81c01d50  EFLAGS: 00010097
 [    0.000000] RAX: 0000000000000000 RBX: ffffffff81d573c0 RCX: 
 0000000000000001
 [    0.000000] RDX: 0000000010000001 RSI: 8000000000100461 RDI: 
 ffffffff81d573c0
 [    0.000000] RBP: ffffffff81c01d90 R08: 0000000000000000 R09: 
 00000000000f4f90
 [    0.000000] R10: 00000000deadbeef R11: 0000000000000010 R12: 
 8000000000100461
 [    0.000000] R13: 8000000000100463 R14: 8000000000000563 R15: 
 0000000000100000
 [    0.000000] FS:  0000000000000000(0000) GS:ffffffff81c9a000(0000) 
 knlGS:0000000000000000
 [    0.000000] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
 [    0.000000] CR2: 0000000000000000 CR3: 0000000001c05000 CR4: 
 0000000000002660
 [    0.000000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
 0000000000000000
 [    0.000000] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 
 0000000000000000
 [    0.000000] Process swapper (pid: 0, threadinfo ffffffff81c00000, 
 task ffffffff81c0d020)
 [    0.000000] Stack:
 [    0.000000]  ffffffff81004ef1 0000000000000010 00000000deadbeef 
 ffffffff81d573c0
 [    0.000000]  0000000000000100 8000000000100463 8000000000000563 
 0000000000100000
 [    0.000000]  ffffffff81c01dc0 ffffffff81cb299f 0000000000100000 
 ffffffffff478000
 [    0.000000] Call Trace:
 [    0.000000]  [<ffffffff81004ef1>] ? 
 __raw_callee_save_xen_pte_val+0x11/0x1e
 [    0.000000]  [<ffffffff81cb299f>] xen_set_pte_init+0x7f/0x87
 [    0.000000]  [<ffffffff81cc2a99>] __early_set_fixmap+0x73/0xbc
 [    0.000000]  [<ffffffff81cc2c01>] __early_ioremap+0x11f/0x1ad
 [    0.000000]  [<ffffffff81cc2f07>] early_ioremap+0x13/0x15
 [    0.000000]  [<ffffffff81cbc2ad>] get_mpc_size+0x14/0x4c
 [    0.000000]  [<ffffffff81cbc3b1>] smp_scan_config+0xcc/0xfa
 [    0.000000]  [<ffffffff81cf3300>] ? 
 firmware_map_add_hotplug+0xa4/0xa4
 [    0.000000]  [<ffffffff81cbcfb3>] default_find_smp_config+0x36/0x5a
 [    0.000000]  [<ffffffff81cb4770>] setup_arch+0x539/0xad7
 [    0.000000]  [<ffffffff81009ecf>] ? 
 __raw_callee_save_xen_restore_fl+0x11/0x1e
 [    0.000000]  [<ffffffff81cf3300>] ? 
 firmware_map_add_hotplug+0xa4/0xa4
 [    0.000000]  [<ffffffff81709534>] ? printk+0x3c/0x3e
 [    0.000000]  [<ffffffff8170c2ea>] ? 
 _raw_spin_unlock_irqrestore+0x1a/0x20
 [    0.000000]  [<ffffffff81cf3300>] ? 
 firmware_map_add_hotplug+0xa4/0xa4
 [    0.000000]  [<ffffffff81cae93b>] start_kernel+0x8e/0x359
 [    0.000000]  [<ffffffff81cae347>] 
 x86_64_start_reservations+0x132/0x136
 [    0.000000]  [<ffffffff81cb1eac>] xen_start_kernel+0x5ef/0x5f6
 [    0.000000] Code: 89 5d d8 4c 89 65 e0 48 89 fb 4c 89 6d e8 4c 89 75 
 f0 49 89 f4 85 c0 4c 89 7d f8 0f 85 17 01 00 00 e8 2b 06 03 00 83 f8 01 
 74 1e <4c> 89 23 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b
 [    0.000000] RIP  [<ffffffff81008a5a>] xen_set_pte+0x3a/0x1f0
 [    0.000000]  RSP <ffffffff81c01d50>
 [    0.000000] CR2: 0000000000000000
 [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
 [    0.000000] Kernel panic - not syncing: Attempted to kill the idle 
 task!
 [    0.000000] Pid: 0, comm: swapper Tainted: G      D     3.1.0 #4
 [    0.000000] Call Trace:
 [    0.000000]  [<ffffffff817093d8>] panic+0x8c/0x1ac
 [    0.000000]  [<ffffffff8105db63>] do_exit+0x803/0x950
 [    0.000000]  [<ffffffff8170c2ea>] ? 
 _raw_spin_unlock_irqrestore+0x1a/0x20
 [    0.000000]  [<ffffffff8105b3b5>] ? kmsg_dump+0x45/0x100
 [    0.000000]  [<ffffffff8170d46f>] oops_end+0xaf/0xf0
 [    0.000000]  [<ffffffff8103e050>] no_context+0xf0/0x260
 [    0.000000]  [<ffffffff8103e2dd>] __bad_area_nosemaphore+0x11d/0x220
 [    0.000000]  [<ffffffff8103e3ee>] bad_area_nosemaphore+0xe/0x10
 [    0.000000]  [<ffffffff8170fd8b>] do_page_fault+0x36b/0x510
 [    0.000000]  [<ffffffff81009ecf>] ? 
 __raw_callee_save_xen_restore_fl+0x11/0x1e
 [    0.000000]  [<ffffffff8170c7b5>] page_fault+0x25/0x30
 [    0.000000]  [<ffffffff81008a5a>] ? xen_set_pte+0x3a/0x1f0
 [    0.000000]  [<ffffffff81004ef1>] ? 
 __raw_callee_save_xen_pte_val+0x11/0x1e
 [    0.000000]  [<ffffffff81cb299f>] xen_set_pte_init+0x7f/0x87
 [    0.000000]  [<ffffffff81cc2a99>] __early_set_fixmap+0x73/0xbc
 [    0.000000]  [<ffffffff81cc2c01>] __early_ioremap+0x11f/0x1ad
 [    0.000000]  [<ffffffff81cc2f07>] early_ioremap+0x13/0x15
 [    0.000000]  [<ffffffff81cbc2ad>] get_mpc_size+0x14/0x4c
 [    0.000000]  [<ffffffff81cbc3b1>] smp_scan_config+0xcc/0xfa
 [    0.000000]  [<ffffffff81cf3300>] ? 
 firmware_map_add_hotplug+0xa4/0xa4
 [    0.000000]  [<ffffffff81cbcfb3>] default_find_smp_config+0x36/0x5a
 [    0.000000]  [<ffffffff81cb4770>] setup_arch+0x539/0xad7
 [    0.000000]  [<ffffffff81009ecf>] ? 
 __raw_callee_save_xen_restore_fl+0x11/0x1e
 [    0.000000]  [<ffffffff81cf3300>] ? 
 firmware_map_add_hotplug+0xa4/0xa4
 [    0.000000]  [<ffffffff81709534>] ? printk+0x3c/0x3e
 [    0.000000]  [<ffffffff8170c2ea>] ? 
 _raw_spin_unlock_irqrestore+0x1a/0x20
 [    0.000000]  [<ffffffff81cf3300>] ? 
 firmware_map_add_hotplug+0xa4/0xa4
 [    0.000000]  [<ffffffff81cae93b>] start_kernel+0x8e/0x359
 [    0.000000]  [<ffffffff81cae347>] 
 x86_64_start_reservations+0x132/0x136
 [    0.000000]  [<ffffffff81cb1eac>] xen_start_kernel+0x5ef/0x5f6
 (XEN) Domain 0 crashed: 'noreboot' set - not rebooting.

