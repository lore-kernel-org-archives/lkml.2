Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1BNTpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:45:43 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:39067 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1BNTpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:45:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<m1hbce46fw.fsf@fess.ebiederm.org>
	<AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
	<m1bp2ly41q.fsf@fess.ebiederm.org>
	<AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
	<AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
	<AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
	<m14o87wev8.fsf@fess.ebiederm.org>
	<AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
	<m1r5bbthan.fsf@fess.ebiederm.org> <m1fwrrtc0m.fsf@fess.ebiederm.org>
	<m139nqsk3q.fsf@fess.ebiederm.org>
	<AANLkTikt-PhqRHT8+Zp+ZuGoVNaP8G3yqxMHpGZ_Z98w@mail.gmail.com>
	<AANLkTimwbkQQkwcX19NVcmSfv5O1dP9oeEBegbQLSh60@mail.gmail.com>
	<AANLkTi=CZ8v99yojSb0Ci=5N9dVFr-vDeZM1_Amx_scj@mail.gmail.com>
Date: Mon, 14 Feb 2011 11:44:47 -0800
In-Reply-To: <AANLkTi=CZ8v99yojSb0Ci=5N9dVFr-vDeZM1_Amx_scj@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 14 Feb 2011 10:08:41 -0800")
Message-ID: <m1wrl2pfio.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX197rpk6+wTukeDl+oRKlwwSDdztbZzLCW4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.0 LOTS_OF_MONEY Huge... sums of money
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Feb 14, 2011 at 9:49 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Btw, can you just make that 'vmlinux' image [..]
>
> .. actually, since you have lots of modules, the .config file is a
> much better option. If it's in some module, the vmlinux file won't
> contain it.
>
> (Although best guess would be for it to be some core data structure,
> so who knows?)

Yeah I will get you the whole pile of rpms with everything in them
in a bit.  

Meanwhile.

With CONFIG_DEBUG_PAGEALLOC I don't have a kernel that successfully
boots.  I am having trouble reading the output, and it doesn't look like
it is consistently failing in the same place.

My three boot attempts with CONFIG_DEBUG_PAGEALLOC are below.

Eric


ERROR: kmemcheck: Fatal error
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff810df982>] perf_event_update_userpage+0x42/0xe0
Oops: 0002 [#1] SMP 
last sysfs file: 
Stack:
Call Trace:
 <NMI> 
 <<EOE>> 
 <#DB> 
 <<EOE>> 
Code: 48 89 fb 48 c7 c7 c0 a3 a1 81 48 83 ec 18 48 c7 04 24 40 f9 0d 81 e8 be 79 fa ff 48 8b 83 e8 02 00 00 48 85 c0 74 57 48 8b 40 58 <83> 40 08 01 31 d2 f6 83 30 01 00 00 01 8b 4b 58 8b b3 10 01 00 
RIP  [<ffffffff810df982>] perf_event_update_userpage+0x42/0xe0
CR2: 0000000000000008
Kernel panic - not syncing: Attempted to kill init!



Then when I crank the loglevel up to 8 I see.
..........................................................................................................
root (hd0,0)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 ro root=
LABEL=/ rhgb quiet crashkernel=128M rd_NO_PLYMOUTH console=tty0 console=ttyS0,9
600 LANG=en_US.UTF-8 loglevel=8
   [Linux-bzImage, setup=0x3800, size=0x3ebb90]
initrd /boot/initramfs-2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64.img
   [Linux-initrd @ 0x36d47000, 0x12a8eb7 bytes]

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 (arastra@local288.aristanetworks.com) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #1 SMP Mon Feb 14 09:30:51 PST 2011
Command line: ro root=LABEL=/ rhgb quiet crashkernel=128M rd_NO_PLYMOUTH console=tty0 console=ttyS0,9600 LANG=en_US.UTF-8 loglevel=8
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cfef0000 (usable)
 BIOS-e820: 00000000cfef0000 - 00000000cff04000 (ACPI data)
 BIOS-e820: 00000000cff04000 - 00000000cff05000 (ACPI NVS)
 BIOS-e820: 00000000cff05000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000002b0000000 (usable)
NX (Execute Disable) protection: active
DMI present.
DMI: X7DWU/X7DWU, BIOS  1.2 11/04/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x2b0000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-E3FFF uncachable
  E4000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 00D0000000 mask 3FF0000000 uncachable
  1 base 00E0000000 mask 3FE0000000 uncachable
  2 base 0000000000 mask 3E00000000 write-back
  3 base 0200000000 mask 3F80000000 write-back
  4 base 0280000000 mask 3FE0000000 write-back
  5 base 02A0000000 mask 3FF0000000 write-back
  6 base 00CFF80000 mask 3FFFF80000 uncachable
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000cff80000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xcfef0 max_arch_pfn = 0x400000000
found SMP MP-table at [ffff8800000f68b0] f68b0
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000cfef0000
 0000000000 - 00cfef0000 page 4k
kernel direct mapping tables up to cfef0000 @ 1f97b000-20000000
init_memory_mapping: 0000000100000000-00000002b0000000
 0100000000 - 02b0000000 page 4k
kernel direct mapping tables up to 2b0000000 @ ce964000-cfef0000
RAMDISK: 36d47000 - 37ff0000
Reserving 128MB of memory at 736MB for crashkernel (System RAM: 11008MB)
ACPI: RSDP 00000000000f6880 00024 (v02 PTLTD )
ACPI: XSDT 00000000cfefcef6 000D4 (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
ACPI: FACP 00000000cff033a8 000F4 (v03 INTEL  STOAKLEY 06040000 PTL  00000003)
ACPI: DSDT 00000000cfefeab8 0487C (v01  Intel SEABURG  06040000 MSFT 03000001)
ACPI: FACS 00000000cff04fc0 00040
ACPI: _MAR 00000000cff0349c 00030 (v01 Intel  OEMDMAR  06040000 LOHR 00000001)
ACPI: TCPA 00000000cff034cc 00032 (v01 Intel  STOAKLEY 06040000 LOHR 0000005A)
ACPI: APIC 00000000cff034fe 000C8 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
ACPI: MCFG 00000000cff035c6 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
ACPI: HPET 00000000cff03602 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
ACPI: BOOT 00000000cff0363a 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
ACPI: SPCR 00000000cff03662 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
ACPI: ERST 00000000cff036b2 00590 (v01 SMCI   ERSTTBL  06040000 SMCI 00000001)
ACPI: HEST 00000000cff03c42 000A8 (v01 SMCI   HESTTBL  06040000 SMCI 00000001)
ACPI: BERT 00000000cff03cea 00030 (v01 SMCI   BERTTBL  06040000 SMCI 00000001)
ACPI: EINJ 00000000cff03d1a 00170 (v01 SMCI   EINJTBL  06040000 SMCI 00000001)
ACPI: SLIC 00000000cff03e8a 00176 (v01 OEM_ID OEMTABLE 06040000  LTP 00000000)
ACPI: SSDT 00000000cfefe859 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe7b3 000A6 (v01  PmRef  Cpu7Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe70d 000A6 (v01  PmRef  Cpu6Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe667 000A6 (v01  PmRef  Cpu5Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe5c1 000A6 (v01  PmRef  Cpu4Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe51b 000A6 (v01  PmRef  Cpu3Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe475 000A6 (v01  PmRef  Cpu2Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe3cf 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefcfca 01405 (v01  PmRef    CpuPm 00003000 INTL 20050228)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-00000002b0000000
Initmem setup node 0 0000000000000000-00000002b0000000
  NODE_DATA [00000002affec000 - 00000002afffffff]
 [ffffea0000000000-ffffea000abfffff] PMD -> [ffff8802a5e00000-ffff8802afdfffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x002b0000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009d
    0: 0x00000100 -> 0x000cfef0
    0: 0x00100000 -> 0x002b0000
On node 0 totalpages: 2621053
  DMA zone: 64 pages used for memmap
  DMA zone: 6 pages reserved
  DMA zone: 3911 pages, LIFO batch:0
  DMA32 zone: 16320 pages used for memmap
  DMA32 zone: 831280 pages, LIFO batch:31
  Normal zone: 27648 pages used for memmap
  Normal zone: 1741824 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec89000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec89000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 8 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 64
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000cfef0000 - 00000000cff04000
PM: Registered nosave memory: 00000000cff04000 - 00000000cff05000
PM: Registered nosave memory: 00000000cff05000 - 00000000d0000000
PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff8800cfc00000 s77056 r8192 d21248 u262144
pcpu-alloc: s77056 r8192 d21248 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2577015
Policy zone: Normal
Kernel command line: ro root=LABEL=/ rhgb quiet crashkernel=128M rd_NO_PLYMOUTH console=tty0 console=ttyS0,9600 LANG=en_US.UTF-8 loglevel=8
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 10058856k/11272192k available (4972k kernel code, 787980k absent, 425356k reserved, 5824k data, 1308k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:4352 nr_irqs:1152 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 5855 kB
 per task-struct memory footprint: 1920 bytes
allocated 104857600 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2500.101 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5000.20 BogoMIPS (lpj=10000404)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20110112
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           E5420  @ 2.50GHz stepping 06
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
kmemcheck: Limiting number of CPUs to 1.
kmemcheck: Initialized
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 1 CPUs
Total of 1 processors activated (5000.20 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-09] at [mem 0xe0000000-0xe09fffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xe09fffff] reserved in E820
PCI: Using configuration type 1 for base access
------------[ cut here ]------------
------------[ cut here ]------------
WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xb9/0xd0()
Hardware name: X7DWU
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1
Call Trace:
 <NMI>  [<ffffffff8104eeaa>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff8104eef5>] ? warn_slowpath_null+0x15/0x20
 [<ffffffff81037d39>] ? kmemcheck_fault+0xb9/0xd0
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d15a5>] ? page_fault+0x25/0x30
 [<ffffffff81318f57>] ? vt_console_print+0xa7/0x390
 [<ffffffff81318f1c>] ? vt_console_print+0x6c/0x390
 [<ffffffff8104f025>] ? __call_console_drivers+0x75/0x90
 [<ffffffff8104f085>] ? _call_console_drivers+0x45/0x70
 [<ffffffff8104f59e>] ? console_unlock+0x11e/0x250
 [<ffffffff8104f9ee>] ? vprintk+0x1fe/0x4c0
 [<ffffffff81037d39>] ? kmemcheck_fault+0xb9/0xd0
 [<ffffffff814cd50c>] ? printk+0x3c/0x40
 [<ffffffff81037d39>] ? kmemcheck_fault+0xb9/0xd0
 [<ffffffff8104ee68>] ? warn_slowpath_common+0x38/0xb0
 [<ffffffff8104eef5>] ? warn_slowpath_null+0x15/0x20
 [<ffffffff81037d39>] ? kmemcheck_fault+0xb9/0xd0
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d15a5>] ? page_fault+0x25/0x30
 [<ffffffff81011bf8>] ? x86_perf_event_update+0x28/0xc0
 [<ffffffff81015ffc>] ? intel_pmu_handle_irq+0x1fc/0x4b0
 [<ffffffff814d2b78>] ? perf_event_nmi_handler+0x58/0xe0
 [<ffffffff814d507d>] ? notifier_call_chain+0x4d/0x70
 [<ffffffff814d5107>] ? __atomic_notifier_call_chain+0x67/0xa0
 [<ffffffff814d50a0>] ? __atomic_notifier_call_chain+0x0/0xa0
 [<ffffffff811a72cc>] ? sysfs_new_dirent+0x3c/0x120
 [<ffffffff814d5151>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff814d518e>] ? notify_die+0x2e/0x30
 [<ffffffff814d1d92>] ? do_nmi+0xd2/0x290
 [<ffffffff814d18f0>] ? nmi+0x20/0x39
 [<ffffffff811a72cc>] ? sysfs_new_dirent+0x3c/0x120
 [<ffffffff8112e60e>] ? kmem_cache_alloc+0x3e/0x160
 [<ffffffff814d1580>] ? page_fault+0x0/0x30
 <<EOE>>  [<ffffffff8112e626>] ? kmem_cache_alloc+0x56/0x160
 [<ffffffff811a72cc>] ? sysfs_new_dirent+0x3c/0x120
 [<ffffffff811a6838>] ? sysfs_add_file_mode+0x38/0xc0
 [<ffffffff811a68cc>] ? sysfs_add_file+0xc/0x10
 [<ffffffff811a69a1>] ? sysfs_create_file+0x21/0x30
 [<ffffffff81338314>] ? device_create_file+0x14/0x20
 [<ffffffff81338cb8>] ? device_add+0x128/0x650
 [<ffffffff813391f9>] ? device_register+0x19/0x20
 [<ffffffff813392fb>] ? device_create_vargs+0xfb/0x130
 [<ffffffff81abdc97>] ? default_bdi_init+0x0/0xaf
 [<ffffffff8110308f>] ? bdi_register+0x6f/0x1c0
 [<ffffffff8127c183>] ? prop_local_init_percpu+0x43/0x50
 [<ffffffff81abdc97>] ? default_bdi_init+0x0/0xaf
 [<ffffffff81abdd36>] ? default_bdi_init+0x9f/0xaf
 [<ffffffff810002ff>] ? do_one_initcall+0x3f/0x180
 [<ffffffff81aa0dc6>] ? kernel_init+0x17c/0x205
 [<ffffffff81003c24>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff814d1394>] ? restore_args+0x0/0x30
 [<ffffffff81aa0c4a>] ? kernel_init+0x0/0x205
 [<ffffffff81003c20>] ? kernel_thread_helper+0x0/0x10
---[ end trace a7919e7f17c0a725 ]---
WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xb9/0xd0()
Hardware name: X7DWU
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1
Call Trace:
 <NMI>  [<ffffffff8104eeaa>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff8104eef5>] ? warn_slowpath_null+0x15/0x20
 [<ffffffff81037d39>] ? kmemcheck_fault+0xb9/0xd0
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d15a5>] ? page_fault+0x25/0x30
 [<ffffffff81011bf8>] ? x86_perf_event_update+0x28/0xc0
 [<ffffffff81015ffc>] ? intel_pmu_handle_irq+0x1fc/0x4b0
 [<ffffffff814d2b78>] ? perf_event_nmi_handler+0x58/0xe0
 [<ffffffff814d507d>] ? notifier_call_chain+0x4d/0x70
 [<ffffffff814d5107>] ? __atomic_notifier_call_chain+0x67/0xa0
 [<ffffffff814d50a0>] ? __atomic_notifier_call_chain+0x0/0xa0
 [<ffffffff811a72cc>] ? sysfs_new_dirent+0x3c/0x120
 [<ffffffff814d5151>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff814d518e>] ? notify_die+0x2e/0x30
 [<ffffffff814d1d92>] ? do_nmi+0xd2/0x290
 [<ffffffff814d18f0>] ? nmi+0x20/0x39
 [<ffffffff811a72cc>] ? sysfs_new_dirent+0x3c/0x120
 [<ffffffff8112e60e>] ? kmem_cache_alloc+0x3e/0x160
 [<ffffffff814d1580>] ? page_fault+0x0/0x30
 <<EOE>>  [<ffffffff8112e626>] ? kmem_cache_alloc+0x56/0x160
 [<ffffffff811a72cc>] ? sysfs_new_dirent+0x3c/0x120
 [<ffffffff811a6838>] ? sysfs_add_file_mode+0x38/0xc0
 [<ffffffff811a68cc>] ? sysfs_add_file+0xc/0x10
 [<ffffffff811a69a1>] ? sysfs_create_file+0x21/0x30
 [<ffffffff81338314>] ? device_create_file+0x14/0x20
 [<ffffffff81338cb8>] ? device_add+0x128/0x650
 [<ffffffff813391f9>] ? device_register+0x19/0x20
 [<ffffffff813392fb>] ? device_create_vargs+0xfb/0x130
 [<ffffffff81abdc97>] ? default_bdi_init+0x0/0xaf
 [<ffffffff8110308f>] ? bdi_register+0x6f/0x1c0
 [<ffffffff8127c183>] ? prop_local_init_percpu+0x43/0x50
 [<ffffffff81abdc97>] ? default_bdi_init+0x0/0xaf
 [<ffffffff81abdd36>] ? default_bdi_init+0x9f/0xaf
 [<ffffffff810002ff>] ? do_one_initcall+0x3f/0x180
 [<ffffffff81aa0dc6>] ? kernel_init+0x17c/0x205
 [<ffffffff81003c24>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff814d1394>] ? restore_args+0x0/0x30
 [<ffffffff81aa0c4a>] ? kernel_init+0x0/0x205
 [<ffffffff81003c20>] ? kernel_thread_helper+0x0/0x10
---[ end trace a7919e7f17c0a726 ]---
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
\_SB_:_OSC evaluation returned wrong type
_OSC request data:1 7 
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
HEST: Table parsing has been initialized.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A03:00: host bridge window [mem 0x000cc000-0x000cffff]
pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000d3fff]
pci_root PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff]
pci_root PNP0A03:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A03:00: host bridge window [mem 0x000dc000-0x000dffff]
pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xfebfffff]
pci 0000:00:00.0: [8086:4003] type 0 class 0x000600
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: [8086:4021] type 1 class 0x000604
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: [8086:4023] type 1 class 0x000604
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:05.0: [8086:4025] type 1 class 0x000604
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:07.0: [8086:4027] type 1 class 0x000604
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:09.0: [8086:4029] type 1 class 0x000604
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0f.0: [8086:402f] type 0 class 0x000880
pci 0000:00:0f.0: reg 10: [mem 0xfe700000-0xfe703fff 64bit]
pci 0000:00:10.0: [8086:4030] type 0 class 0x000600
pci 0000:00:10.1: [8086:4030] type 0 class 0x000600
pci 0000:00:10.2: [8086:4030] type 0 class 0x000600
pci 0000:00:10.3: [8086:4030] type 0 class 0x000600
pci 0000:00:10.4: [8086:4030] type 0 class 0x000600
pci 0000:00:11.0: [8086:4031] type 0 class 0x000600
pci 0000:00:15.0: [8086:4035] type 0 class 0x000600
pci 0000:00:15.1: [8086:4035] type 0 class 0x000600
pci 0000:00:16.0: [8086:4036] type 0 class 0x000600
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2465 lockdep_trace_alloc+0xcc/0xe0()
Hardware name: X7DWU
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1
Call Trace:
 [<ffffffff8104eeaa>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff8104eef5>] ? warn_slowpath_null+0x15/0x20
 [<ffffffff810883dc>] ? lockdep_trace_alloc+0xcc/0xe0
 [<ffffffff8112ca3c>] ? __kmalloc+0x4c/0x190
 [<ffffffff81284f77>] ? kvasprintf+0x57/0x90
 [<ffffffff81284f77>] ? kvasprintf+0x57/0x90
 [<ffffffff81279eda>] ? kobject_set_name_vargs+0x3a/0x80
 [<ffffffff81337cbc>] ? dev_set_name+0x3c/0x40
 [<ffffffff81297301>] ? pci_setup_device+0x131/0x410
 [<ffffffff814bc873>] ? pci_scan_single_device+0xf3/0x160
 [<ffffffff81296820>] ? next_trad_fn+0x0/0x10
 [<ffffffff8129777c>] ? pci_scan_slot+0xac/0x130
 [<ffffffff814be568>] ? pci_scan_child_bus+0x29/0xb1
 [<ffffffff81296565>] ? pci_bus_add_resource+0x55/0xa0
 [<ffffffff814c395e>] ? pci_acpi_scan_root+0x2a4/0x2fb
 [<ffffffff814c0e0a>] ? acpi_pci_root_add+0x197/0x33a
 [<ffffffff812ca5a7>] ? acpi_device_probe+0x0/0x185
 [<ffffffff812ca5f2>] ? acpi_device_probe+0x4b/0x185
 [<ffffffff8133bc36>] ? driver_probe_device+0x96/0x1c0
 [<ffffffff8133be03>] ? __driver_attach+0xa3/0xb0
 [<ffffffff8133bd60>] ? __driver_attach+0x0/0xb0
 [<ffffffff8133a8fe>] ? bus_for_each_dev+0x5e/0x90
 [<ffffffff8133b899>] ? driver_attach+0x19/0x20
 [<ffffffff8133b443>] ? bus_add_driver+0xc3/0x280
 [<ffffffff81acc931>] ? acpi_pci_root_init+0x0/0x2d
 [<ffffffff8133c081>] ? driver_register+0x71/0x140
 [<ffffffff81acc931>] ? acpi_pci_root_init+0x0/0x2d
 [<ffffffff812cad36>] ? acpi_bus_register_driver+0x3e/0x40
 [<ffffffff81acc956>] ? acpi_pci_root_init+0x25/0x2d
 [<ffffffff810002ff>] ? do_one_initcall+0x3f/0x180
 [<ffffffff81aa0dc6>] ? kernel_init+0x17c/0x205
 [<ffffffff81003c24>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff814d1394>] ? restore_args+0x0/0x30
 [<ffffffff81aa0c4a>] ? kernel_init+0x0/0x205
 [<ffffffff81003c20>] ? kernel_thread_helper+0x0/0x10
---[ end trace a7919e7f17c0a727 ]---
pci 0000:00:16.1: [8086:4036] type 0 class 0x000600
ERROR: kmemcheck: Fatal error

Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1 X7DWU/X7DWU
RIP: 0010:[<ffffffff8112c880>]  [<ffffffff8112c880>] kmem_cache_alloc_trace+0x90/0x160
RSP: 0018:ffff880299ccbaf0  EFLAGS: 00010106
RAX: ffff880299edd000 RBX: ffff8802a58039c0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 00000000007fffff RDI: ffff880299ede000
RBP: ffff880299ccbb30 R08: 0000000000000000 R09: ffff880299edd000
R10: 0000000000000002 R11: 0000000000000001 R12: ffff880299edd000
R13: 00000000000080d0 R14: 0000000000000286 R15: ffffffff81296b2f
FS:  0000000000000000(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff880299c98810 CR3: 0000000001a03000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff810370c4>] kmemcheck_error_save_bug+0x74/0xb0
 [<ffffffff8103790b>] kmemcheck_show+0x8b/0xa0
 [<ffffffff81037d0a>] kmemcheck_fault+0x8a/0xd0
 [<ffffffff814d4eed>] do_page_fault+0x41d/0x560
 [<ffffffff814d15a5>] page_fault+0x25/0x30
 [<ffffffff81296b2f>] alloc_pci_dev+0x1f/0x40
 [<ffffffff814bc84b>] pci_scan_single_device+0xcb/0x160
 [<ffffffff8129777c>] pci_scan_slot+0xac/0x130
 [<ffffffff814be568>] pci_scan_child_bus+0x29/0xb1
 [<ffffffff814c395e>] pci_acpi_scan_root+0x2a4/0x2fb
 [<ffffffff814c0e0a>] acpi_pci_root_add+0x197/0x33a
 [<ffffffff812ca5f2>] acpi_device_probe+0x4b/0x185
 [<ffffffff8133bc36>] driver_probe_device+0x96/0x1c0
 [<ffffffff8133be03>] __driver_attach+0xa3/0xb0
 [<ffffffff8133a8fe>] bus_for_each_dev+0x5e/0x90
 [<ffffffff8133b899>] driver_attach+0x19/0x20
 [<ffffffff8133b443>] bus_add_driver+0xc3/0x280
 [<ffffffff8133c081>] driver_register+0x71/0x140
 [<ffffffff812cad36>] acpi_bus_register_driver+0x3e/0x40
 [<ffffffff81acc956>] acpi_pci_root_init+0x25/0x2d
 [<ffffffff810002ff>] do_one_initcall+0x3f/0x180
 [<ffffffff81aa0dc6>] kernel_init+0x17c/0x205
 [<ffffffff81003c24>] kernel_thread_helper+0x4/0x10
 [<ffffffffffffffff>] 0xffffffffffffffff
pci 0000:00:1d.0: [8086:2688] type 0 class 0x000c03
pci 0000:00:1d.0: reg 20: [io  0x1800-0x181f]
pci 0000:00:1d.1: [8086:2689] type 0 class 0x000c03
pci 0000:00:1d.1: reg 20: [io  0x1820-0x183f]
pci 0000:00:1d.2: [8086:268a] type 0 class 0x000c03
pci 0000:00:1d.2: reg 20: [io  0x1840-0x185f]
pci 0000:00:1d.3: [8086:268b] type 0 class 0x000c03
pci 0000:00:1d.3: reg 20: [io  0x1860-0x187f]
pci 0000:00:1d.7: [8086:268c] type 0 class 0x000c03
pci 0000:00:1d.7: reg 10: [mem 0xdc904000-0xdc9043ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
pci 0000:00:1f.0: [8086:2670] type 0 class 0x000601
pci 0000:00:1f.1: [8086:269e] type 0 class 0x000101
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0x1880-0x188f]
pci 0000:00:1f.2: [8086:2680] type 0 class 0x000101
pci 0000:00:1f.2: reg 10: [io  0x18c0-0x18c7]
pci 0000:00:1f.2: reg 14: [io  0x18b8-0x18bb]
pci 0000:00:1f.2: reg 18: [io  0x18b0-0x18b7]
pci 0000:00:1f.2: reg 1c: [io  0x1894-0x1897]
pci 0000:00:1f.2: reg 20: [io  0x18a0-0x18af]
pci 0000:00:1f.2: reg 24: [mem 0xdc904400-0xdc9047ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:269b] type 0 class 0x000c05
pci 0000:00:1f.3: reg 20: [io  0x1100-0x111f]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:02:00.0: [8086:3500] type 1 class 0x000604
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.3: [8086:350c] type 1 class 0x000604
pci 0000:02:00.3: PME# supported from D0 D3hot D3cold
pci 0000:02:00.3: PME# disabled
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:03.0: PCI bridge to [bus 02-05]
pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:03.0:   bridge window [mem 0xdc500000-0xdc5fffff]
pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:00.0: [8086:3510] type 1 class 0x000604
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:02:00.0: PCI bridge to [bus 03-04]
pci 0000:02:00.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:02:00.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:02:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:00.0: PCI bridge to [bus 04-04]
pci 0000:03:00.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:03:00.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:03:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:02:00.3: PCI bridge to [bus 05-05]
pci 0000:02:00.3:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:02:00.3:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:02:00.3:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:06:00.0: [4040:0100] type 0 class 0x000200
pci 0000:06:00.0: reg 10: [mem 0xdc000000-0xdc1fffff 64bit]
pci 0000:06:00.0: reg 20: [mem 0xd8000000-0xd9ffffff 64bit]
pci 0000:06:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:06:00.1: [4040:0100] type 0 class 0x000200
pci 0000:06:00.1: reg 10: [mem 0xdc200000-0xdc3fffff 64bit]
pci 0000:06:00.1: reg 20: [mem 0xda000000-0xdbffffff 64bit]
pci 0000:06:00.1: PME# supported from D0 D3hot D3cold
pci 0000:06:00.1: PME# disabled
pci 0000:00:05.0: PCI bridge to [bus 06-06]
pci 0000:00:05.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:05.0:   bridge window [mem 0xd8000000-0xdc3fffff]
pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:07.0: PCI bridge to [bus 07-07]
pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:08:00.0: [8086:10a7] type 0 class 0x000200
pci 0000:08:00.0: reg 10: [mem 0xdc420000-0xdc43ffff]
pci 0000:08:00.0: reg 14: [mem 0xdc400000-0xdc41ffff]
pci 0000:08:00.0: reg 18: [io  0x2000-0x201f]
pci 0000:08:00.0: reg 1c: [mem 0xdc480000-0xdc483fff]
pci 0000:08:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
pci 0000:08:00.0: PME# disabled
pci 0000:08:00.1: [8086:10a7] type 0 class 0x000200
pci 0000:08:00.1: reg 10: [mem 0xdc460000-0xdc47ffff]
pci 0000:08:00.1: reg 14: [mem 0xdc440000-0xdc45ffff]
pci 0000:08:00.1: reg 18: [io  0x2020-0x203f]
pci 0000:08:00.1: reg 1c: [mem 0xdc484000-0xdc487fff]
pci 0000:08:00.1: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:08:00.1: PME# supported from D0 D3hot D3cold
pci 0000:08:00.1: PME# disabled
pci 0000:00:09.0: PCI bridge to [bus 08-08]
pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:09.0:   bridge window [mem 0xdc400000-0xdc4fffff]
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:09:01.0: [1002:515e] type 0 class 0x000300
pci 0000:09:01.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
pci 0000:09:01.0: reg 14: [io  0x3000-0x30ff]
pci 0000:09:01.0: reg 18: [mem 0xdc600000-0xdc60ffff]
pci 0000:09:01.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:09:01.0: supports D1 D2
pci 0000:00:1e.0: PCI bridge to [bus 09-09] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1e.0:   bridge window [mem 0xdc600000-0xdc6fffff]
pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000cc000-0x000cffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xfebfffff] (subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3.BMF0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3.BMF0.BPD0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
BUG: unable to handle kernel NULL pointer dereference at 0000000000000200
IP: [<ffffffff8101484b>] intel_pmu_enable_all+0xab/0x110
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:

Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1 X7DWU/X7DWU
RIP: 0010:[<ffffffff8101484b>]  [<ffffffff8101484b>] intel_pmu_enable_all+0xab/0x110
RSP: 0018:ffff8800cfc07cf8  EFLAGS: 00010292
RAX: ffff880299cd0000 RBX: ffff880299c98800 RCX: 0000000000000002
RDX: ffff880299cd0000 RSI: 0000000000000001 RDI: 0000000000000246
RBP: ffff8800cfc07d28 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff80000001 R14: 0000000080000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff8802a58182e4 CR3: 0000000001a03000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
BUG: unable to handle kernel paging request at 0000000181037f51
IP: [<ffffffff81038420>] kmemcheck_shadow_set+0x10/0x20
PGD 0 
Oops: 0002 [#2] SMP 
last sysfs file: 
CPU 0 
Modules linked in:

Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1 X7DWU/X7DWU
RIP: 0010:[<ffffffff81038420>]  [<ffffffff81038420>] kmemcheck_shadow_set+0x10/0x20
RSP: 0018:ffff8800cfc079d8  EFLAGS: 00010082
RAX: 000000020206ffa6 RBX: 0000000181037f51 RCX: ffff880299c98000
RDX: 0000000081038055 RSI: 0000000081038054 RDI: 0000000181037f51
RBP: ffff8800cfc079d8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800cfc079d8
R13: ffffffff81038055 R14: ffff880299c98000 R15: ffff880299c98ae8
FS:  0000000000000000(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff880299c98910 CR3: 0000000001a03000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff880299cca000, task ffff880299cd0000)

RIP  [<ffff8800cfc079c8>] 0xffff8800cfc079c8
 RSP <00000001cfc079d8>
CR2: 0000000181037f51
---[ end trace a7919e7f17c0a728 ]---
swapper used greatest stack depth: 2752 bytes left
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1
Call Trace:
 <NMI>  [<ffffffff814cd3b6>] ? panic+0x79/0x193
 [<ffffffff810533eb>] ? do_exit+0x7fb/0x8d0
 [<ffffffff814d23d5>] ? oops_end+0xa5/0xf0
 [<ffffffff81030c70>] ? no_context+0xf0/0x260
 [<ffffffff81030f05>] ? __bad_area_nosemaphore+0x125/0x1e0
 [<ffffffff81038055>] ? kmemcheck_shadow_lookup+0x45/0x70
 [<ffffffff81030fce>] ? bad_area_nosemaphore+0xe/0x10
 [<ffffffff814d4f52>] ? do_page_fault+0x482/0x560
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff81038055>] ? kmemcheck_shadow_lookup+0x45/0x70
 [<ffffffff814d15a5>] ? page_fault+0x25/0x30
 [<ffffffff81038055>] ? kmemcheck_shadow_lookup+0x45/0x70
 [<ffffffff81037f51>] ? kmemcheck_pte_lookup+0x11/0x50
 [<ffffffff81038055>] ? kmemcheck_shadow_lookup+0x45/0x70
 [<ffffffff81037177>] ? kmemcheck_read_strict+0x47/0xb0
 [<ffffffff81011bf8>] ? x86_perf_event_update+0x28/0xc0
 [<ffffffff81037225>] ? kmemcheck_read+0x45/0x70
 [<ffffffff81037f51>] ? kmemcheck_pte_lookup+0x11/0x50
 [<ffffffff810372e6>] ? kmemcheck_show_addr+0x46/0x70
 [<ffffffff810377c9>] ? kmemcheck_show_all+0x39/0x60
 [<ffffffff810378bc>] ? kmemcheck_show+0x3c/0xa0
 [<ffffffff81037d0a>] ? kmemcheck_fault+0x8a/0xd0
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d1850>] ? error_exit+0x30/0xb0
 [<ffffffff810df9ed>] ? perf_event_update_userpage+0xad/0xe0
 [<ffffffff810df940>] ? perf_event_update_userpage+0x0/0xe0
 [<ffffffff81011c36>] ? x86_perf_event_update+0x66/0xc0
 [<ffffffff81014849>] ? intel_pmu_enable_all+0xa9/0x110
 [<ffffffff8101606e>] ? intel_pmu_handle_irq+0x26e/0x4b0
 [<ffffffff814d2b78>] ? perf_event_nmi_handler+0x58/0xe0
 [<ffffffff814d507d>] ? notifier_call_chain+0x4d/0x70
 [<ffffffff814d5121>] ? __atomic_notifier_call_chain+0x81/0xa0
 [<ffffffff814d50a0>] ? __atomic_notifier_call_chain+0x0/0xa0
 [<ffffffff81322f90>] ? serial8250_console_putchar+0x0/0x40
 [<ffffffff814d5151>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff814d518e>] ? notify_die+0x2e/0x30
 [<ffffffff814d1d3d>] ? do_nmi+0x7d/0x290
 [<ffffffff814d18f0>] ? nmi+0x20/0x39
 [<ffffffff81322f90>] ? serial8250_console_putchar+0x0/0x40
 [<ffffffff81322863>] ? io_serial_in+0x13/0x20
 <<EOE>> 
...................................................................................
root (hd0,0)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 ro root=
LABEL=/ rhgb quiet crashkernel=128M rd_NO_PLYMOUTH console=tty0 console=ttyS0,9
600 LANG=en_US.UTF-8 loglevel=8
   [Linux-bzImage, setup=0x3800, size=0x3ebb90]
initrd /boot/initramfs-2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64.img
   [Linux-initrd @ 0x36d47000, 0x12a8eb7 bytes]

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 (arastra@local288.aristanetworks.com) (gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC) ) #1 SMP Mon Feb 14 09:30:51 PST 2011
Command line: ro root=LABEL=/ rhgb quiet crashkernel=128M rd_NO_PLYMOUTH console=tty0 console=ttyS0,9600 LANG=en_US.UTF-8 loglevel=8
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cfef0000 (usable)
 BIOS-e820: 00000000cfef0000 - 00000000cff04000 (ACPI data)
 BIOS-e820: 00000000cff04000 - 00000000cff05000 (ACPI NVS)
 BIOS-e820: 00000000cff05000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000002b0000000 (usable)
NX (Execute Disable) protection: active
DMI present.
DMI: X7DWU/X7DWU, BIOS  1.2 11/04/2008
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x2b0000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-E3FFF uncachable
  E4000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 00D0000000 mask 3FF0000000 uncachable
  1 base 00E0000000 mask 3FE0000000 uncachable
  2 base 0000000000 mask 3E00000000 write-back
  3 base 0200000000 mask 3F80000000 write-back
  4 base 0280000000 mask 3FE0000000 write-back
  5 base 02A0000000 mask 3FF0000000 write-back
  6 base 00CFF80000 mask 3FFFF80000 uncachable
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000cff80000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xcfef0 max_arch_pfn = 0x400000000
found SMP MP-table at [ffff8800000f68b0] f68b0
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-00000000cfef0000
 0000000000 - 00cfef0000 page 4k
kernel direct mapping tables up to cfef0000 @ 1f97b000-20000000
init_memory_mapping: 0000000100000000-00000002b0000000
 0100000000 - 02b0000000 page 4k
kernel direct mapping tables up to 2b0000000 @ ce964000-cfef0000
RAMDISK: 36d47000 - 37ff0000
Reserving 128MB of memory at 736MB for crashkernel (System RAM: 11008MB)
ACPI: RSDP 00000000000f6880 00024 (v02 PTLTD )
ACPI: XSDT 00000000cfefcef6 000D4 (v01 PTLTD  ? XSDT   06040000  LTP 00000000)
ACPI: FACP 00000000cff033a8 000F4 (v03 INTEL  STOAKLEY 06040000 PTL  00000003)
ACPI: DSDT 00000000cfefeab8 0487C (v01  Intel SEABURG  06040000 MSFT 03000001)
ACPI: FACS 00000000cff04fc0 00040
ACPI: _MAR 00000000cff0349c 00030 (v01 Intel  OEMDMAR  06040000 LOHR 00000001)
ACPI: TCPA 00000000cff034cc 00032 (v01 Intel  STOAKLEY 06040000 LOHR 0000005A)
ACPI: APIC 00000000cff034fe 000C8 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
ACPI: MCFG 00000000cff035c6 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
ACPI: HPET 00000000cff03602 00038 (v01 PTLTD  HPETTBL  06040000  LTP 00000001)
ACPI: BOOT 00000000cff0363a 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
ACPI: SPCR 00000000cff03662 00050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
ACPI: ERST 00000000cff036b2 00590 (v01 SMCI   ERSTTBL  06040000 SMCI 00000001)
ACPI: HEST 00000000cff03c42 000A8 (v01 SMCI   HESTTBL  06040000 SMCI 00000001)
ACPI: BERT 00000000cff03cea 00030 (v01 SMCI   BERTTBL  06040000 SMCI 00000001)
ACPI: EINJ 00000000cff03d1a 00170 (v01 SMCI   EINJTBL  06040000 SMCI 00000001)
ACPI: SLIC 00000000cff03e8a 00176 (v01 OEM_ID OEMTABLE 06040000  LTP 00000000)
ACPI: SSDT 00000000cfefe859 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe7b3 000A6 (v01  PmRef  Cpu7Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe70d 000A6 (v01  PmRef  Cpu6Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe667 000A6 (v01  PmRef  Cpu5Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe5c1 000A6 (v01  PmRef  Cpu4Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe51b 000A6 (v01  PmRef  Cpu3Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe475 000A6 (v01  PmRef  Cpu2Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefe3cf 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
ACPI: SSDT 00000000cfefcfca 01405 (v01  PmRef    CpuPm 00003000 INTL 20050228)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-00000002b0000000
Initmem setup node 0 0000000000000000-00000002b0000000
  NODE_DATA [00000002affec000 - 00000002afffffff]
 [ffffea0000000000-ffffea000abfffff] PMD -> [ffff8802a5e00000-ffff8802afdfffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x002b0000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009d
    0: 0x00000100 -> 0x000cfef0
    0: 0x00100000 -> 0x002b0000
On node 0 totalpages: 2621053
  DMA zone: 64 pages used for memmap
  DMA zone: 6 pages reserved
  DMA zone: 3911 pages, LIFO batch:0
  DMA32 zone: 16320 pages used for memmap
  DMA32 zone: 831280 pages, LIFO batch:31
  Normal zone: 27648 pages used for memmap
  Normal zone: 1741824 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec89000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec89000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 8 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 64
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000cfef0000 - 00000000cff04000
PM: Registered nosave memory: 00000000cff04000 - 00000000cff05000
PM: Registered nosave memory: 00000000cff05000 - 00000000d0000000
PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
Allocating PCI resources starting at d0000000 (gap: d0000000:10000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff8800cfc00000 s77056 r8192 d21248 u262144
pcpu-alloc: s77056 r8192 d21248 u262144 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2577015
Policy zone: Normal
Kernel command line: ro root=LABEL=/ rhgb quiet crashkernel=128M rd_NO_PLYMOUTH console=tty0 console=ttyS0,9600 LANG=en_US.UTF-8 loglevel=8
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 10058856k/11272192k available (4972k kernel code, 787980k absent, 425356k reserved, 5824k data, 1308k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:4352 nr_irqs:1152 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 5855 kB
 per task-struct memory footprint: 1920 bytes
allocated 104857600 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2500.222 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5000.44 BogoMIPS (lpj=10000888)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys blkio
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20110112
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           E5420  @ 2.50GHz stepping 06
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
kmemcheck: Limiting number of CPUs to 1.
kmemcheck: Initialized
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 1 CPUs
Total of 1 processors activated (5000.44 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-09] at [mem 0xe0000000-0xe09fffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xe09fffff] reserved in E820
PCI: Using configuration type 1 for base access
------------[ cut here ]------------
------------[ cut here ]------------
WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xb9/0xd0()
Hardware name: X7DWU
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1
Call Trace:
 <NMI>  [<ffffffff8104eeaa>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff8104eef5>] ? warn_slowpath_null+0x15/0x20
 [<ffffffff81037d39>] ? kmemcheck_fault+0xb9/0xd0
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d15a5>] ? page_fault+0x25/0x30
 [<ffffffff81318f57>] ? vt_console_print+0xa7/0x390
 [<ffffffff81318f1c>] ? vt_console_print+0x6c/0x390
 [<ffffffff8104f025>] ? __call_console_drivers+0x75/0x90
 [<ffffffff8104f085>] ? _call_console_drivers+0x45/0x70
 [<ffffffff8104f59e>] ? console_unlock+0x11e/0x250
 [<ffffffff8104f9ee>] ? vprintk+0x1fe/0x4c0
 [<ffffffff81037d39>] ? kmemcheck_fault+0xb9/0xd0
 [<ffffffff814cd50c>] ? printk+0x3c/0x40
 [<ffffffff81037d39>] ? kmemcheck_fault+0xb9/0xd0
 [<ffffffff8104ee68>] ? warn_slowpath_common+0x38/0xb0
 [<ffffffff8104eef5>] ? warn_slowpath_null+0x15/0x20
 [<ffffffff81037d39>] ? kmemcheck_fault+0xb9/0xd0
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d15a5>] ? page_fault+0x25/0x30
 [<ffffffff81011bf8>] ? x86_perf_event_update+0x28/0xc0
 [<ffffffff81015ffc>] ? intel_pmu_handle_irq+0x1fc/0x4b0
 [<ffffffff814d2b78>] ? perf_event_nmi_handler+0x58/0xe0
 [<ffffffff814d507d>] ? notifier_call_chain+0x4d/0x70
 [<ffffffff814d5107>] ? __atomic_notifier_call_chain+0x67/0xa0
 [<ffffffff814d50a0>] ? __atomic_notifier_call_chain+0x0/0xa0
 [<ffffffff814d5151>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff814d518e>] ? notify_die+0x2e/0x30
 [<ffffffff814d1d92>] ? do_nmi+0xd2/0x290
 [<ffffffff814d18f0>] ? nmi+0x20/0x39
 [<ffffffff810372ee>] ? kmemcheck_show_addr+0x4e/0x70
 <<EOE>>  [<ffffffff810377c9>] ? kmemcheck_show_all+0x39/0x60
 [<ffffffff810378bc>] ? kmemcheck_show+0x3c/0xa0
 [<ffffffff81037d0a>] ? kmemcheck_fault+0x8a/0xd0
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff810378bc>] ? kmemcheck_show+0x3c/0xa0
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d15a5>] ? page_fault+0x25/0x30
 [<ffffffff811004fb>] ? kstrdup+0x4b/0x70
 [<ffffffff811a739c>] ? sysfs_new_dirent+0x10c/0x120
 [<ffffffff811a8123>] ? sysfs_do_create_link+0x93/0x230
 [<ffffffff814d1850>] ? error_exit+0x30/0xb0
 [<ffffffff811a82ce>] ? sysfs_create_link+0xe/0x10
 [<ffffffff81338f0b>] ? device_add+0x37b/0x650
 [<ffffffff813391f9>] ? device_register+0x19/0x20
 [<ffffffff813392fb>] ? device_create_vargs+0xfb/0x130
 [<ffffffff81abdc97>] ? default_bdi_init+0x0/0xaf
 [<ffffffff8110308f>] ? bdi_register+0x6f/0x1c0
 [<ffffffff8127c183>] ? prop_local_init_percpu+0x43/0x50
 [<ffffffff81abdc97>] ? default_bdi_init+0x0/0xaf
 [<ffffffff81abdd36>] ? default_bdi_init+0x9f/0xaf
 [<ffffffff810002ff>] ? do_one_initcall+0x3f/0x180
 [<ffffffff81aa0dc6>] ? kernel_init+0x17c/0x205
 [<ffffffff81003c24>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff814d1394>] ? restore_args+0x0/0x30
 [<ffffffff81aa0c4a>] ? kernel_init+0x0/0x205
 [<ffffffff81003c20>] ? kernel_thread_helper+0x0/0x10
---[ end trace a7919e7f17c0a725 ]---
WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xb9/0xd0()
Hardware name: X7DWU
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1
Call Trace:
 <NMI>  [<ffffffff8104eeaa>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff8104eef5>] ? warn_slowpath_null+0x15/0x20
 [<ffffffff81037d39>] ? kmemcheck_fault+0xb9/0xd0
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d15a5>] ? page_fault+0x25/0x30
 [<ffffffff81011bf8>] ? x86_perf_event_update+0x28/0xc0
 [<ffffffff81015ffc>] ? intel_pmu_handle_irq+0x1fc/0x4b0
 [<ffffffff814d2b78>] ? perf_event_nmi_handler+0x58/0xe0
 [<ffffffff814d507d>] ? notifier_call_chain+0x4d/0x70
 [<ffffffff814d5107>] ? __atomic_notifier_call_chain+0x67/0xa0
 [<ffffffff814d50a0>] ? __atomic_notifier_call_chain+0x0/0xa0
 [<ffffffff814d5151>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff814d518e>] ? notify_die+0x2e/0x30
 [<ffffffff814d1d92>] ? do_nmi+0xd2/0x290
 [<ffffffff814d18f0>] ? nmi+0x20/0x39
 [<ffffffff810372ee>] ? kmemcheck_show_addr+0x4e/0x70
 <<EOE>>  [<ffffffff810377c9>] ? kmemcheck_show_all+0x39/0x60
 [<ffffffff810378bc>] ? kmemcheck_show+0x3c/0xa0
 [<ffffffff81037d0a>] ? kmemcheck_fault+0x8a/0xd0
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff810378bc>] ? kmemcheck_show+0x3c/0xa0
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d15a5>] ? page_fault+0x25/0x30
 [<ffffffff811004fb>] ? kstrdup+0x4b/0x70
 [<ffffffff811a739c>] ? sysfs_new_dirent+0x10c/0x120
 [<ffffffff811a8123>] ? sysfs_do_create_link+0x93/0x230
 [<ffffffff814d1850>] ? error_exit+0x30/0xb0
 [<ffffffff811a82ce>] ? sysfs_create_link+0xe/0x10
 [<ffffffff81338f0b>] ? device_add+0x37b/0x650
 [<ffffffff813391f9>] ? device_register+0x19/0x20
 [<ffffffff813392fb>] ? device_create_vargs+0xfb/0x130
 [<ffffffff81abdc97>] ? default_bdi_init+0x0/0xaf
 [<ffffffff8110308f>] ? bdi_register+0x6f/0x1c0
 [<ffffffff8127c183>] ? prop_local_init_percpu+0x43/0x50
 [<ffffffff81abdc97>] ? default_bdi_init+0x0/0xaf
 [<ffffffff81abdd36>] ? default_bdi_init+0x9f/0xaf
 [<ffffffff810002ff>] ? do_one_initcall+0x3f/0x180
 [<ffffffff81aa0dc6>] ? kernel_init+0x17c/0x205
 [<ffffffff81003c24>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff814d1394>] ? restore_args+0x0/0x30
 [<ffffffff81aa0c4a>] ? kernel_init+0x0/0x205
 [<ffffffff81003c20>] ? kernel_thread_helper+0x0/0x10
---[ end trace a7919e7f17c0a726 ]---
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2465 lockdep_trace_alloc+0xcc/0xe0()
Hardware name: X7DWU
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1
Call Trace:
 [<ffffffff8104eeaa>] ? warn_slowpath_common+0x7a/0xb0
 [<ffffffff811a72cc>] ? sysfs_new_dirent+0x3c/0x120
 [<ffffffff8104eef5>] ? warn_slowpath_null+0x15/0x20
 [<ffffffff810883dc>] ? lockdep_trace_alloc+0xcc/0xe0
 [<ffffffff8112e5f8>] ? kmem_cache_alloc+0x28/0x160
 [<ffffffff811a72cc>] ? sysfs_new_dirent+0x3c/0x120
 [<ffffffff811a8123>] ? sysfs_do_create_link+0x93/0x230
 [<ffffffff814d1850>] ? error_exit+0x30/0xb0
 [<ffffffff811a82ce>] ? sysfs_create_link+0xe/0x10
 [<ffffffff81338f0b>] ? device_add+0x37b/0x650
 [<ffffffff813391f9>] ? device_register+0x19/0x20
 [<ffffffff813392fb>] ? device_create_vargs+0xfb/0x130
 [<ffffffff81abdc97>] ? default_bdi_init+0x0/0xaf
 [<ffffffff8110308f>] ? bdi_register+0x6f/0x1c0
 [<ffffffff8127c183>] ? prop_local_init_percpu+0x43/0x50
 [<ffffffff81abdc97>] ? default_bdi_init+0x0/0xaf
 [<ffffffff81abdd36>] ? default_bdi_init+0x9f/0xaf
 [<ffffffff810002ff>] ? do_one_initcall+0x3f/0x180
 [<ffffffff81aa0dc6>] ? kernel_init+0x17c/0x205
 [<ffffffff81003c24>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff814d1394>] ? restore_args+0x0/0x30
 [<ffffffff81aa0c4a>] ? kernel_init+0x0/0x205
 [<ffffffff81003c20>] ? kernel_thread_helper+0x0/0x10
---[ end trace a7919e7f17c0a727 ]---
ERROR: kmemcheck: Fatal error

Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1 X7DWU/X7DWU
RIP: 0010:[<ffffffff811004fb>]  [<ffffffff811004fb>] kstrdup+0x4b/0x70
RSP: 0018:ffff880299ccbc10  EFLAGS: 00010102
RAX: ffff8802a584f688 RBX: 0000000000000008 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffff8802a584f66c RDI: ffff8802a584f68c
RBP: ffff880299ccbc30 R08: 0000000000000000 R09: ffff8802a5850688
R10: ffff880000000000 R11: 0000000000000001 R12: ffff8802a584f668
R13: 00000000000000d0 R14: ffff8802a584f668 R15: 000000000000a1ff
FS:  0000000000000000(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff880299c98810 CR3: 0000000001a03000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff810370c4>] kmemcheck_error_save_bug+0x74/0xb0
 [<ffffffff8103790b>] kmemcheck_show+0x8b/0xa0
 [<ffffffff81037d0a>] kmemcheck_fault+0x8a/0xd0
 [<ffffffff814d4eed>] do_page_fault+0x41d/0x560
 [<ffffffff814d15a5>] page_fault+0x25/0x30
 [<ffffffff811a739c>] sysfs_new_dirent+0x10c/0x120
 [<ffffffff811a8123>] sysfs_do_create_link+0x93/0x230
 [<ffffffff811a82ce>] sysfs_create_link+0xe/0x10
 [<ffffffff81338f0b>] device_add+0x37b/0x650
 [<ffffffff813391f9>] device_register+0x19/0x20
 [<ffffffff813392fb>] device_create_vargs+0xfb/0x130
 [<ffffffff8110308f>] bdi_register+0x6f/0x1c0
 [<ffffffff81abdd36>] default_bdi_init+0x9f/0xaf
 [<ffffffff810002ff>] do_one_initcall+0x3f/0x180
 [<ffffffff81aa0dc6>] kernel_init+0x17c/0x205
 [<ffffffff81003c24>] kernel_thread_helper+0x4/0x10
 [<ffffffffffffffff>] 0xffffffffffffffff
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
\_SB_:_OSC evaluation returned wrong type
_OSC request data:1 7 
ERROR: kmemcheck: Fatal error

Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1 X7DWU/X7DWU
RIP: 0010:[<ffffffff8107664f>]  [<ffffffff8107664f>] down_timeout+0x2f/0x60
RSP: 0018:ffff880299ccbbd0  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff880299c6e0c0 RCX: 0000000000000000
RDX: 000000000000f101 RSI: 0000000000000000 RDI: ffff880299c6e0c0
RBP: ffff880299ccbbf0 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000286
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff880299c98810 CR3: 0000000001a03000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
 [<ffffffff810370c4>] kmemcheck_error_save_bug+0x74/0xb0
 [<ffffffff8103790b>] kmemcheck_show+0x8b/0xa0
 [<ffffffff81037d0a>] kmemcheck_fault+0x8a/0xd0
 [<ffffffff814d4eed>] do_page_fault+0x41d/0x560
 [<ffffffff814d15a5>] page_fault+0x25/0x30
 [<ffffffff812c7523>] acpi_os_wait_semaphore+0x96/0x13c
 [<ffffffff812f2f3b>] acpi_ut_acquire_mutex+0x84/0x101
 [<ffffffff812e8b2b>] acpi_ns_walk_namespace+0xea/0x17b
 [<ffffffff812e5c96>] acpi_walk_namespace+0x8e/0xc8
 [<ffffffff812e83cc>] acpi_ns_initialize_objects+0x93/0x185
 [<ffffffff812f0fbb>] acpi_initialize_objects+0x85/0xd3
 [<ffffffff81acbf3c>] acpi_bus_init+0x9f/0x1dd
 [<ffffffff81acc0eb>] acpi_init+0x71/0xd8
 [<ffffffff810002ff>] do_one_initcall+0x3f/0x180
 [<ffffffff81aa0dc6>] kernel_init+0x17c/0x205
 [<ffffffff81003c24>] kernel_thread_helper+0x4/0x10
 [<ffffffffffffffff>] 0xffffffffffffffff
BUG: unable to handle kernel NULL pointer dereference at 0000000000000064
IP: [<ffffffff810df97e>] perf_event_update_userpage+0x3e/0xe0
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:

Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1 X7DWU/X7DWU
RIP: 0010:[<ffffffff810df97e>]  [<ffffffff810df97e>] perf_event_update_userpage+0x3e/0xe0
RSP: 0018:ffff8800cfc07cc8  EFLAGS: 00010206
RAX: 000000000000000c RBX: ffff880299cbc4c8 RCX: 0000000000000007
RDX: 0000000000000000 RSI: 0000000000000156 RDI: 0000000000001000
RBP: ffff880299ccb8d0 R08: 0000000000000080 R09: ffffffff817a4b41
R10: ffff880000000001 R11: 0000000000000000 R12: 0000000000000008
R13: ffff880299e21208 R14: 0000000000000013 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff8802a58182e4 CR3: 0000000001a03000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
BUG: unable to handle kernel paging request at 0000000181037f51
IP: [<0000000181037f51>] 0x181037f51
PGD 0 
Oops: 0010 [#2] SMP 
last sysfs file: 
CPU 0 
Modules linked in:

Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1 X7DWU/X7DWU
RIP: 0010:[<0000000181037f51>]  [<0000000181037f51>] 0x181037f51
RSP: 0018:ffff8800cfc079b8  EFLAGS: 00010092
RAX: 0000000000000048 RBX: ffff8800cfc07c18 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000046
RBP: ffff8800cfc079c8 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffff8800cfc07cc8
R13: ffff8800cfc07c18 R14: ffff8800cfc079b8 R15: ffffffff81037f51
FS:  0000000000000000(0000) GS:ffff8800cfc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffff8802a58182e4 CR3: 0000000001a03000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff880299cca000, task ffff880299cd0000)
Stack:
 ffff8800cfc079d8 ffffffff81038055 ffff880299c98000 ffff880299c98ae8
 ffff8800cfc07a08 ffffffff81037177 ffff880299c98000 ffff8800cfc07c18
 ffff880299c98aef ffffffff810df972 ffff8800cfc07a38 ffffffff81037225
Call Trace:
 <NMI> 
 [<ffffffff81038055>] ? kmemcheck_shadow_lookup+0x45/0x70
 [<ffffffff81037177>] ? kmemcheck_read_strict+0x47/0xb0
 [<ffffffff810df972>] ? perf_event_update_userpage+0x32/0xe0
 [<ffffffff81037225>] ? kmemcheck_read+0x45/0x70
 [<ffffffff81037f51>] ? kmemcheck_pte_lookup+0x11/0x50
 [<ffffffff810372e6>] ? kmemcheck_show_addr+0x46/0x70
 [<ffffffff810377c9>] ? kmemcheck_show_all+0x39/0x60
 [<ffffffff810378bc>] ? kmemcheck_show+0x3c/0xa0
 [<ffffffff81037d0a>] ? kmemcheck_fault+0x8a/0xd0
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d1850>] ? error_exit+0x30/0xb0
 [<ffffffff810df9ed>] ? perf_event_update_userpage+0xad/0xe0
 [<ffffffff810df940>] ? perf_event_update_userpage+0x0/0xe0
 [<ffffffff81014849>] ? intel_pmu_enable_all+0xa9/0x110
 [<ffffffff8101606e>] ? intel_pmu_handle_irq+0x26e/0x4b0
 [<ffffffff814d2b78>] ? perf_event_nmi_handler+0x58/0xe0
 [<ffffffff814d507d>] ? notifier_call_chain+0x4d/0x70
 [<ffffffff814d5121>] ? __atomic_notifier_call_chain+0x81/0xa0
 [<ffffffff814d50a0>] ? __atomic_notifier_call_chain+0x0/0xa0
 [<ffffffff81322f90>] ? serial8250_console_putchar+0x0/0x40
 [<ffffffff814d5151>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff814d518e>] ? notify_die+0x2e/0x30
 [<ffffffff814d1d3d>] ? do_nmi+0x7d/0x290
 [<ffffffff814d18f0>] ? nmi+0x20/0x39
 [<ffffffff81322f90>] ? serial8250_console_putchar+0x0/0x40
 [<ffffffff81322863>] ? io_serial_in+0x13/0x20
 <<EOE>> 
Code:  Bad RIP value.
RIP  [<0000000181037f51>] 0x181037f51
 RSP <ffffffff81037f51>
CR2: 0000000181037f51
---[ end trace a7919e7f17c0a728 ]---
swapper used greatest stack depth: 3344 bytes left
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D W   2.6.38-rc4-357858.2010AroraKernelBeta.fc14.x86_64 #1
Call Trace:
 <NMI>  [<ffffffff814cd3b6>] ? panic+0x79/0x193
 [<ffffffff810533eb>] ? do_exit+0x7fb/0x8d0
 [<ffffffff814d23d5>] ? oops_end+0xa5/0xf0
 [<ffffffff81030c70>] ? no_context+0xf0/0x260
 [<ffffffff81030f05>] ? __bad_area_nosemaphore+0x125/0x1e0
 [<ffffffff81030fce>] ? bad_area_nosemaphore+0xe/0x10
 [<ffffffff814d4f52>] ? do_page_fault+0x482/0x560
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff81037f51>] ? kmemcheck_pte_lookup+0x11/0x50
 [<ffffffff814d15a5>] ? page_fault+0x25/0x30
 [<ffffffff81037f51>] ? kmemcheck_pte_lookup+0x11/0x50
 [<ffffffff81037f51>] ? kmemcheck_pte_lookup+0x11/0x50
 [<ffffffff81038055>] ? kmemcheck_shadow_lookup+0x45/0x70
 [<ffffffff81037177>] ? kmemcheck_read_strict+0x47/0xb0
 [<ffffffff810df972>] ? perf_event_update_userpage+0x32/0xe0
 [<ffffffff81037225>] ? kmemcheck_read+0x45/0x70
 [<ffffffff81037f51>] ? kmemcheck_pte_lookup+0x11/0x50
 [<ffffffff810372e6>] ? kmemcheck_show_addr+0x46/0x70
 [<ffffffff810377c9>] ? kmemcheck_show_all+0x39/0x60
 [<ffffffff810378bc>] ? kmemcheck_show+0x3c/0xa0
 [<ffffffff81037d0a>] ? kmemcheck_fault+0x8a/0xd0
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff814d4eed>] ? do_page_fault+0x41d/0x560
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d0528>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff814d1850>] ? error_exit+0x30/0xb0
 [<ffffffff810df9ed>] ? perf_event_update_userpage+0xad/0xe0
 [<ffffffff810df940>] ? perf_event_update_userpage+0x0/0xe0
 [<ffffffff81014849>] ? intel_pmu_enable_all+0xa9/0x110
 [<ffffffff8101606e>] ? intel_pmu_handle_irq+0x26e/0x4b0
 [<ffffffff814d2b78>] ? perf_event_nmi_handler+0x58/0xe0
 [<ffffffff814d507d>] ? notifier_call_chain+0x4d/0x70
 [<ffffffff814d5121>] ? __atomic_notifier_call_chain+0x81/0xa0
 [<ffffffff814d50a0>] ? __atomic_notifier_call_chain+0x0/0xa0
 [<ffffffff81322f90>] ? serial8250_console_putchar+0x0/0x40
 [<ffffffff814d5151>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff814d518e>] ? notify_die+0x2e/0x30
 [<ffffffff814d1d3d>] ? do_nmi+0x7d/0x290
 [<ffffffff814d18f0>] ? nmi+0x20/0x39
 [<ffffffff81322f90>] ? serial8250_console_putchar+0x0/0x40
 [<ffffffff81322863>] ? io_serial_in+0x13/0x20
 <<EOE>> 
