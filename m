Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab1EOKxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 06:53:50 -0400
Received: from nm22.bullet.mail.bf1.yahoo.com ([98.139.212.181]:35167 "HELO
	nm22.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752989Ab1EOKxt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 06:53:49 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 May 2011 06:53:47 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 199981.52029.bm@omp1003.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=krDE8XkyGCkReYXBuNs6rh0x1THJMswTvM7T4SYIwUGB6byDAvg9Ql1DpYu3UX5N9LVn9MMhOOMCxplggGZ5TYBn+3+rVf18oukyXp2In8P9QLuC5Z4dPvba08IGpR8gpx/BkwNFm2TpTNw2aL+P0KVcZzlgbe2wwX0s1ye1XxY=;
Message-ID: <936833.81097.qm@web161805.mail.bf1.yahoo.com>
X-YMail-OSG: uwTo4OkVM1kWOvpeVmRumUY6s6WSn2Bdh16RKmnJMEN8FJY
 tv91mUMV_UttxBRIaqVav.9EnEsyYpWn.GfejeptCsQUtbr.3IgwSKdobRTP
 _bQWbYIq2Ws5_Lxbg9aMCOnpRqQE5TGIARuADbFuqvL0ILy6Up6qAdL3PmkV
 UUXMyr7nRZOtVBC.gFLsbNvIvwOkrT5L5P9GP4AOW9fE1FykBXn.EDQMIukK
 sGSyjiY30Cz2SX_smc9.oEeFfF5kSFVn4rP1tOMjzwdNHwXvIBbss989CrNa
 6UpG6hBBJnAS7_4xujvTxzZbO2Xt9rFIjRaGuoFcGGSAS0gxcCYMCaQg.Wp.
 Bse3S0sf761d91bShVmi03aJENrWN.Wi0C9iK0WWZpI9Q0EblprlKlScXqxc
 JFQpB_HvD6JVFqL2kTpqTX5j8nZSG0dFDPVvkBfettqdmaNosjCQF1ZIqp22
 VVIwfWN39E0r5Ps.2zwE5PAydClhRdk9_X4jBoVfXLYyg46QnQjvI7EYGnxq
 zDCPfFqxC1K0aWL2u3sQeNQG50rSckf58wg6y9HSt1EYTiga24vGS_OqXI3W
 M9korlULSpkfdS99e.5SAi7RZ_3JVbhmkhcgl4kA6dzK.Ai8bKoS4uzwxM1J
 jALIgkb2EHYCDEDrxHevMeIzjTJC0MMwktJVQocWzvzW7guNwR9doTgCGXs8
 dLiVJhEGjWbJRriWWIXZp6nAgFb9f7pibmaQRQtPa2K1WCNYFAzaIZvfTpbO
 tp7Q8pfn0vzxYsXKKheuJtQ5WpUKPE4vSQffuCeKP9jrRw2NJZuXvEjfnOLi
 FsI7aA8Htnnm3P94MNfWLr5UBcCATQW6C8qekeDjbzYPAMVBi7z5y5Vz17FG
 I_TC8OU74JJgoS1ujZgWkCFuSzQbwEf6bghXluTLawVv35TGw1C9atzzmj1P
 FzuvilRea5tgIp_ErP5UDC0zwKNmhS.VYbJLEgHTW3ARhYoNY5dnsvEG0uX_
 Cdi_VheFKmD9hB9pTOdQ.DtyULB2t9GyUZsD.VBrZ3sk8mM_0KMj6wt_JZPq
 CVjSsTfR1GN0KDWaqd.etqDMlN5dnsbpR89YlHiIQA6aGaA.hXMUTRnh0hSS
 dyA5eCbLOZhFp5.JPfCHP6p22_cDLroCG3Tx7mPdweJd69EHxCHKcZxn3gKu
 0LSbN0kgMHIUKwpLmk1kHKAuJG58o8wU0Jju3mYx9Hqx12afAZ7oy2NccGLe
 QJ5Vj0HJ9gzZR.4WNbveRxIt1_NJ7XDvGLQSDpiKrzjI6kH5TIqCTszGXOC2
 vejYsmY0DC0FaT8jVpUAM2NQWYyZZ5AACnPQ9GaYyoZosY8sDB.vkOA7j_Q_
 7tXgMl2wSwA1cbHPJXFL6SKO0h9mAbFW7FalqdyKsIHUBLc.1XwvG_AMdQWR
 6
X-Mailer: YahooMailWebService/0.8.111.303096
Date: Sun, 15 May 2011 03:47:45 -0700 (PDT)
From: Mikko Vinni <mmvinni@yahoo.com>
Reply-To: Mikko Vinni <mmvinni@yahoo.com>
Subject: pci 0000:0a:00.0: Refused to change power state, currently in D3
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in an HP Pavilion dv5 laptop model dv5-1250eo always at resume
from s2ram the following messages are printed:

pci 0000:0a:00.0: Refused to change power state, currently in D3
pci 0000:0a:00.1: Refused to change power state, currently in D3
pci 0000:0a:00.2: Refused to change power state, currently in D3
pci 0000:0a:00.3: Refused to change power state, currently in D3
pci 0000:0a:00.4: Refused to change power state, currently in D3


lspci:

00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
00:02.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (ext gfx port 0)
00:04.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 0)
00:05.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 1)
00:06.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (PCIE port 2)
00:0a.0 PCI bridge: Advanced Micro Devices [AMD] RS780/RS880 PCI to PCI bridge (PCIE port 5)
00:11.0 SATA controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
00:12.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:12.1 USB Controller: ATI Technologies Inc SB7x0 USB OHCI1 Controller
00:12.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:13.0 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:13.1 USB Controller: ATI Technologies Inc SB7x0 USB OHCI1 Controller
00:13.2 USB Controller: ATI Technologies Inc SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
00:14.1 IDE interface: ATI Technologies Inc SB7x0/SB8x0/SB9x0 IDE Controller
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia (Intel HDA)
00:14.3 ISA bridge: ATI Technologies Inc SB7x0/SB8x0/SB9x0 LPC host controller
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 11h Processor HyperTransport Configuration (rev 40)
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 11h Processor Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 11h Processor DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 11h Processor Miscellaneous Control
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 11h Processor Link Control
01:00.0 VGA compatible controller: ATI Technologies Inc Mobility Radeon HD 3400 Series
01:00.1 Audio device: ATI Technologies Inc RV620 Audio device [Radeon HD 34xx Series]
08:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless Network Adapter (rev 01)
09:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
0a:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host Controller
0a:00.1 System peripheral: JMicron Technology Corp. SD/MMC Host Controller
0a:00.2 SD Host controller: JMicron Technology Corp. Standard SD Host Controller
0a:00.3 System peripheral: JMicron Technology Corp. MS Host Controller
0a:00.4 System peripheral: JMicron Technology Corp. xD Host Controller


(first reported to linux-mmc at http://thread.gmane.org/gmane.linux.kernel.mmc/7988,
because the card reader is one of the non-functioning devices after resume)

What could be causing such a problem?

The following log is from 2.6.39-rc7 + some code from mmc-next, but this
is not a new problem. I can reproduce it easily for example with the
default 2.6.32 kernel from Ubuntu 10.10.

Initializing cgroup subsys cpu
Linux version 2.6.39-rc7-CUST-00160-g8b7376d-dirty (mikko@koni) (gcc version 4.6.0 20110429 (prerelease) (GCC) ) #160 SMP PREEMPT Thu May 12 20:02:29 EEST 2011
Command line: BOOT_IMAGE=Arch_GitKernel ro root=803 ro root=/dev/sda3 init=/bin/systemd no_console_suspend
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bfd70000 (usable)
 BIOS-e820: 00000000bfd70000 - 00000000bfdbf000 (reserved)
 BIOS-e820: 00000000bfdbf000 - 00000000bfe58000 (usable)
 BIOS-e820: 00000000bfe58000 - 00000000bfebf000 (ACPI NVS)
 BIOS-e820: 00000000bfebf000 - 00000000bfeed000 (usable)
 BIOS-e820: 00000000bfeed000 - 00000000bfeff000 (ACPI data)
 BIOS-e820: 00000000bfeff000 - 00000000bff00000 (usable)
 BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
NX (Execute Disable) protection: active
DMI 2.4 present.
DMI: Hewlett-Packard HP Pavilion dv5 Notebook PC/3600, BIOS F.32 03/02/2009
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x140000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 00FFF00000 mask FFFFF00000 write-protect
  1 base 0000000000 mask FF80000000 write-back
  2 base 0080000000 mask FFC0000000 write-back
  3 base 0100000000 mask FFC0000000 write-back
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000140000000 aka 5120M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xbff00 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff88000009a000] 9a000 size 20480
init_memory_mapping: 0000000000000000-00000000bff00000
 0000000000 - 00bfe00000 page 2M
 00bfe00000 - 00bff00000 page 4k
kernel direct mapping tables up to bff00000 @ bfee8000-bfeed000
init_memory_mapping: 0000000100000000-0000000140000000
 0100000000 - 0140000000 page 2M
kernel direct mapping tables up to 140000000 @ 13fffa000-140000000
RAMDISK: 7fea4000 - 80000000
ACPI: RSDP 00000000000fe020 00024 (v02 HP    )
ACPI: XSDT 00000000bfefe120 0005C (v01 HPQOEM SLIC-MPC 00000003      01000013)
ACPI: FACP 00000000bfefd000 000F4 (v04 HP     3600     00000003 MSFT 01000013)
ACPI: DSDT 00000000bfef0000 09825 (v01 HP     3600     F0000000 MSFT 01000013)
ACPI: FACS 00000000bfe61000 00040
ACPI: HPET 00000000bfefc000 00038 (v01 HP     3600     00000001 MSFT 01000013)
ACPI: APIC 00000000bfefb000 00084 (v02 HP     3600     00000001 MSFT 01000013)
ACPI: MCFG 00000000bfefa000 0003C (v01 HP     3600     00000001 MSFT 01000013)
ACPI: BOOT 00000000bfeef000 00028 (v01 HP     3600     00000001 MSFT 01000013)
ACPI: SLIC 00000000bfeee000 00176 (v01 HPQOEM SLIC-MPC 06040000  LTP 00000001)
ACPI: SSDT 00000000bfeed000 002B4 (v01 AMD    PowerNow 00000001 AMD  00000001)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880130000000-ffff8801337fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000bfd70
    0: 0x000bfdbf -> 0x000bfe58
    0: 0x000bfebf -> 0x000bfeed
    0: 0x000bfeff -> 0x000bff00
    0: 0x00100000 -> 0x00140000
On node 0 totalpages: 1048007
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3922 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 767600 pages, LIFO batch:31
  Normal zone: 3584 pages used for memmap
  Normal zone: 258560 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x1002a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 2 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000bfd70000 - 00000000bfdbf000
PM: Registered nosave memory: 00000000bfe58000 - 00000000bfebf000
PM: Registered nosave memory: 00000000bfeed000 - 00000000bfeff000
PM: Registered nosave memory: 00000000bff00000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000e4000000
PM: Registered nosave memory: 00000000e4000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
PM: Registered nosave memory: 00000000fec01000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000fff00000
PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
Allocating PCI resources starting at bff00000 (gap: bff00000:20100000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff88013fc00000 s76608 r8192 d21696 u524288
pcpu-alloc: s76608 r8192 d21696 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1030082
Kernel command line: BOOT_IMAGE=Arch_GitKernel ro root=803 ro root=/dev/sda3 init=/bin/systemd no_console_suspend
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 4052264k/5242880k available (3925k kernel code, 1050852k absent, 139764k reserved, 2667k data, 524k init)
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Preemptable hierarchical RCU implementation.
    RCU-based detection of stalled CPUs is disabled.
    Verbose stalled-CPUs detection is disabled.
NR_IRQS:384
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2100.043 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4201.08 BogoMIPS (lpj=7000143)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 256
tseg: 00bff00000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
ACPI: Core revision 20110316
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Athlon(tm) X2 Dual-Core QL-64 stepping 01
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
MCE: In-kernel MCE decoding enabled.
Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 9a000
TSC synchronization [CPU#0 -> CPU#1]:
Measured 206343626 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed
Brought up 2 CPUs
Total of 2 processors activated (8393.38 BogoMIPS).
devtmpfs: initialized
PM: Registering ACPI NVS region at bfe58000 (421888 bytes)
Time:  7:43:02  Date: 05/14/11
NET: Registered protocol family 16
TOM: 00000000c0000000 aka 3072M
Fam 10h mmconf [e0000000, e0ffffff]
TOM2: 0000000140000000 aka 5120M
Extended Config Space enabled on 0 nodes
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000c3fff]
pci_root PNP0A08:00: host bridge window [mem 0x000c4000-0x000c7fff]
pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000cbfff]
pci_root PNP0A08:00: host bridge window [mem 0x000cc000-0x000cffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
pci_root PNP0A08:00: host bridge window [mem 0x000e8000-0x000ebfff]
pci_root PNP0A08:00: host bridge window [mem 0x000ec000-0x000effff]
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
pci_root PNP0A08:00: host bridge window [mem 0xe4000000-0xffffffff]
pci 0000:00:00.0: [1022:9600] type 0 class 0x000600
pci 0000:00:02.0: [1022:9603] type 1 class 0x000604
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:04.0: [1022:9604] type 1 class 0x000604
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:05.0: [1022:9605] type 1 class 0x000604
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:06.0: [1022:9606] type 1 class 0x000604
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:0a.0: [1022:9609] type 1 class 0x000604
pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
pci 0000:00:11.0: reg 10: [io  0x6038-0x603f]
pci 0000:00:11.0: reg 14: [io  0x604c-0x604f]
pci 0000:00:11.0: reg 18: [io  0x6030-0x6037]
pci 0000:00:11.0: reg 1c: [io  0x6048-0x604b]
pci 0000:00:11.0: reg 20: [io  0x6010-0x601f]
pci 0000:00:11.0: reg 24: [mem 0xd2408000-0xd24083ff]
pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
pci 0000:00:12.0: reg 10: [mem 0xd2407000-0xd2407fff]
pci 0000:00:12.1: [1002:4398] type 0 class 0x000c03
pci 0000:00:12.1: reg 10: [mem 0xd2406000-0xd2406fff]
pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
pci 0000:00:12.2: reg 10: [mem 0xd2408500-0xd24085ff]
pci 0000:00:12.2: supports D1 D2
pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:12.2: PME# disabled
pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
pci 0000:00:13.0: reg 10: [mem 0xd2405000-0xd2405fff]
pci 0000:00:13.1: [1002:4398] type 0 class 0x000c03
pci 0000:00:13.1: reg 10: [mem 0xd2404000-0xd2404fff]
pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
pci 0000:00:13.2: reg 10: [mem 0xd2408400-0xd24084ff]
pci 0000:00:13.2: supports D1 D2
pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.2: PME# disabled
pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
pci 0000:00:14.1: [1002:439c] type 0 class 0x000101
pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:14.1: reg 20: [io  0x6000-0x600f]
pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
pci 0000:00:14.2: reg 10: [mem 0xd2400000-0xd2403fff 64bit]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
pci 0000:00:18.0: [1022:1300] type 0 class 0x000600
pci 0000:00:18.1: [1022:1301] type 0 class 0x000600
pci 0000:00:18.2: [1022:1302] type 0 class 0x000600
pci 0000:00:18.3: [1022:1303] type 0 class 0x000600
pci 0000:00:18.4: [1022:1304] type 0 class 0x000600
pci 0000:01:00.0: [1002:95c4] type 0 class 0x000300
pci 0000:01:00.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
pci 0000:01:00.0: reg 14: [io  0x5000-0x50ff]
pci 0000:01:00.0: reg 18: [mem 0xd2300000-0xd230ffff]
pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: [1002:aa28] type 0 class 0x000403
pci 0000:01:00.1: reg 10: [mem 0xd2310000-0xd2313fff]
pci 0000:01:00.1: supports D1 D2
pci 0000:00:02.0: PCI bridge to [bus 01-01]
pci 0000:00:02.0:   bridge window [io  0x5000-0x5fff]
pci 0000:00:02.0:   bridge window [mem 0xd2300000-0xd23fffff]
pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:00:04.0: PCI bridge to [bus 02-07]
pci 0000:00:04.0:   bridge window [io  0x3000-0x4fff]
pci 0000:00:04.0:   bridge window [mem 0xd1300000-0xd22fffff]
pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
pci 0000:08:00.0: [168c:001c] type 0 class 0x000200
pci 0000:08:00.0: reg 10: [mem 0xd1200000-0xd120ffff 64bit]
pci 0000:08:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:05.0: PCI bridge to [bus 08-08]
pci 0000:00:05.0:   bridge window [io  0xfffffffffffff000-0x0000] (disabled)
pci 0000:00:05.0:   bridge window [mem 0xd1200000-0xd12fffff]
pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:09:00.0: [10ec:8168] type 0 class 0x000200
pci 0000:09:00.0: reg 10: [io  0x2000-0x20ff]
pci 0000:09:00.0: reg 18: [mem 0xd1010000-0xd1010fff 64bit pref]
pci 0000:09:00.0: reg 20: [mem 0xd1000000-0xd100ffff 64bit pref]
pci 0000:09:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
pci 0000:09:00.0: supports D1 D2
pci 0000:09:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:09:00.0: PME# disabled
pci 0000:00:06.0: PCI bridge to [bus 09-09]
pci 0000:00:06.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:06.0:   bridge window [mem 0xd1000000-0xd10fffff 64bit pref]
pci 0000:0a:00.0: [197b:2380] type 0 class 0x000c00
pci 0000:0a:00.0: reg 10: [mem 0xd1100000-0xd11007ff]
pci 0000:0a:00.0: reg 14: [mem 0xd1100d00-0xd1100d7f]
pci 0000:0a:00.0: reg 20: [mem 0xd1100c80-0xd1100cff]
pci 0000:0a:00.0: reg 24: [mem 0xd1100c00-0xd1100c7f]
pci 0000:0a:00.1: [197b:2382] type 0 class 0x000880
pci 0000:0a:00.1: reg 10: [mem 0xd1100b00-0xd1100bff]
pci 0000:0a:00.2: [197b:2381] type 0 class 0x000805
pci 0000:0a:00.2: reg 10: [mem 0xd1100a00-0xd1100aff]
pci 0000:0a:00.3: [197b:2383] type 0 class 0x000880
pci 0000:0a:00.3: reg 10: [mem 0xd1100900-0xd11009ff]
pci 0000:0a:00.4: [197b:2384] type 0 class 0x000880
pci 0000:0a:00.4: reg 10: [mem 0xd1100800-0xd11008ff]
pci 0000:00:0a.0: PCI bridge to [bus 0a-0a]
pci 0000:00:0a.0:   bridge window [io  0xfffffffffffff000-0x0000] (disabled)
pci 0000:00:0a.0:   bridge window [mem 0xd1100000-0xd11fffff]
pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:14.4: PCI bridge to [bus 80-8f] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000c3fff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000c4000-0x000c7fff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000c8000-0x000cbfff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000cc000-0x000cffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000e8000-0x000ebfff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0x000ec000-0x000effff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
pci 0000:00:14.4:   bridge window [mem 0xe4000000-0xffffffff] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB2_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB4_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB5_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB10._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
 pci0000:00: ACPI _OSC control (0x19) granted
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
reserve RAM buffer: 00000000bfd70000 - 00000000bfffffff 
reserve RAM buffer: 00000000bfe58000 - 00000000bfffffff 
reserve RAM buffer: 00000000bfeed000 - 00000000bfffffff 
reserve RAM buffer: 00000000bff00000 - 00000000bfffffff 
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
Switching to clocksource hpet
Switched to NOHz mode on CPU #0
pnp: PnP ACPI init
Switched to NOHz mode on CPU #1
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c0000-0x000c3fff window]
pnp 00:00: [mem 0x000c4000-0x000c7fff window]
pnp 00:00: [mem 0x000c8000-0x000cbfff window]
pnp 00:00: [mem 0x000cc000-0x000cffff window]
pnp 00:00: [mem 0x000d0000-0x000d3fff window]
pnp 00:00: [mem 0x000d4000-0x000d7fff window]
pnp 00:00: [mem 0x000d8000-0x000dbfff window]
pnp 00:00: [mem 0x000dc000-0x000dffff window]
pnp 00:00: [mem 0x000e0000-0x000e3fff window]
pnp 00:00: [mem 0x000e4000-0x000e7fff window]
pnp 00:00: [mem 0x000e8000-0x000ebfff window]
pnp 00:00: [mem 0x000ec000-0x000effff window]
pnp 00:00: [mem 0xc0000000-0xdfffffff window]
pnp 00:00: [mem 0xe4000000-0xffffffff window]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [mem 0xfec00000-0xfec00fff]
pnp 00:01: [mem 0xfee00000-0xfee00fff]
system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: [irq 0 disabled]
pnp 00:02: [irq 8]
pnp 00:02: [mem 0xfed00000-0xfed003ff]
pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:03: [io  0x0000-0x000f]
pnp 00:03: [io  0x0081-0x008f]
pnp 00:03: [io  0x00c0-0x00df]
pnp 00:03: [dma 4]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: [io  0x00f0-0x00fe]
pnp 00:04: [irq 13]
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: [io  0x0070-0x0071]
pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:06: [io  0x0061]
pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [irq 1]
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: [irq 12]
pnp 00:08: Plug and Play ACPI device, IDs SYN0150 SYN0100 SYN0002 PNP0f13 (active)
pnp 00:09: [io  0x0010-0x001f]
pnp 00:09: [io  0x002e-0x002f]
pnp 00:09: [io  0x0072-0x0073]
pnp 00:09: [io  0x0080]
pnp 00:09: [io  0x00b0-0x00b1]
pnp 00:09: [io  0x0092]
pnp 00:09: [io  0x0400-0x04cf]
pnp 00:09: [io  0x04d0-0x04d1]
pnp 00:09: [io  0x04d6]
pnp 00:09: [io  0x0680-0x06ff]
pnp 00:09: [io  0x077a]
pnp 00:09: [io  0x0c00-0x0c01]
pnp 00:09: [io  0x0c14]
pnp 00:09: [io  0x0c50-0x0c52]
pnp 00:09: [io  0x0c6c]
pnp 00:09: [io  0x0c6f]
pnp 00:09: [io  0x0cd0-0x0cdb]
system 00:09: [io  0x0400-0x04cf] has been reserved
system 00:09: [io  0x04d0-0x04d1] has been reserved
system 00:09: [io  0x04d6] has been reserved
system 00:09: [io  0x0680-0x06ff] has been reserved
system 00:09: [io  0x077a] has been reserved
system 00:09: [io  0x0c00-0x0c01] has been reserved
system 00:09: [io  0x0c14] has been reserved
system 00:09: [io  0x0c50-0x0c52] has been reserved
system 00:09: [io  0x0c6c] has been reserved
system 00:09: [io  0x0c6f] has been reserved
system 00:09: [io  0x0cd0-0x0cdb] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: [mem 0x000e0000-0x000fffff]
pnp 00:0a: [mem 0xfff00000-0xffffffff]
system 00:0a: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:0a: [mem 0xfff00000-0xffffffff] has been reserved
system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:0b: [io  0x0380-0x0383]
pnp 00:0b: [irq 4]
pnp 00:0b: Plug and Play ACPI device, IDs ENE0100 (active)
pnp 00:0c: [irq 23]
pnp 00:0c: Plug and Play ACPI device, IDs HPQ0004 (active)
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
pci 0000:09:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
pci 0000:00:06.0: BAR 14: assigned [mem 0xd2500000-0xd25fffff]
pci 0000:01:00.0: BAR 6: assigned [mem 0xd2320000-0xd233ffff pref]
pci 0000:00:02.0: PCI bridge to [bus 01-01]
pci 0000:00:02.0:   bridge window [io  0x5000-0x5fff]
pci 0000:00:02.0:   bridge window [mem 0xd2300000-0xd23fffff]
pci 0000:00:02.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
pci 0000:00:04.0: PCI bridge to [bus 02-07]
pci 0000:00:04.0:   bridge window [io  0x3000-0x4fff]
pci 0000:00:04.0:   bridge window [mem 0xd1300000-0xd22fffff]
pci 0000:00:04.0:   bridge window [mem 0xd0000000-0xd0ffffff 64bit pref]
pci 0000:00:05.0: PCI bridge to [bus 08-08]
pci 0000:00:05.0:   bridge window [io  disabled]
pci 0000:00:05.0:   bridge window [mem 0xd1200000-0xd12fffff]
pci 0000:00:05.0:   bridge window [mem pref disabled]
pci 0000:09:00.0: BAR 6: assigned [mem 0xd1020000-0xd102ffff pref]
pci 0000:00:06.0: PCI bridge to [bus 09-09]
pci 0000:00:06.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:06.0:   bridge window [mem 0xd2500000-0xd25fffff]
pci 0000:00:06.0:   bridge window [mem 0xd1000000-0xd10fffff 64bit pref]
pci 0000:00:0a.0: PCI bridge to [bus 0a-0a]
pci 0000:00:0a.0:   bridge window [io  disabled]
pci 0000:00:0a.0:   bridge window [mem 0xd1100000-0xd11fffff]
pci 0000:00:0a.0:   bridge window [mem pref disabled]
pci 0000:00:14.4: PCI bridge to [bus 80-8f]
pci 0000:00:14.4:   bridge window [io  0x1000-0x1fff]
pci 0000:00:14.4:   bridge window [mem disabled]
pci 0000:00:14.4:   bridge window [mem pref disabled]
pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:06.0: setting latency timer to 64
pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:0a.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
pci_bus 0000:00: resource 19 [mem 0xc0000000-0xdfffffff]
pci_bus 0000:00: resource 20 [mem 0xe4000000-0xffffffff]
pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
pci_bus 0000:01: resource 1 [mem 0xd2300000-0xd23fffff]
pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
pci_bus 0000:02: resource 0 [io  0x3000-0x4fff]
pci_bus 0000:02: resource 1 [mem 0xd1300000-0xd22fffff]
pci_bus 0000:02: resource 2 [mem 0xd0000000-0xd0ffffff 64bit pref]
pci_bus 0000:08: resource 1 [mem 0xd1200000-0xd12fffff]
pci_bus 0000:09: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:09: resource 1 [mem 0xd2500000-0xd25fffff]
pci_bus 0000:09: resource 2 [mem 0xd1000000-0xd10fffff 64bit pref]
pci_bus 0000:0a: resource 1 [mem 0xd1100000-0xd11fffff]
pci_bus 0000:80: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:80: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:80: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:80: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:80: resource 7 [mem 0x000c0000-0x000c3fff]
pci_bus 0000:80: resource 8 [mem 0x000c4000-0x000c7fff]
pci_bus 0000:80: resource 9 [mem 0x000c8000-0x000cbfff]
pci_bus 0000:80: resource 10 [mem 0x000cc000-0x000cffff]
pci_bus 0000:80: resource 11 [mem 0x000d0000-0x000d3fff]
pci_bus 0000:80: resource 12 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:80: resource 13 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:80: resource 14 [mem 0x000dc000-0x000dffff]
pci_bus 0000:80: resource 15 [mem 0x000e0000-0x000e3fff]
pci_bus 0000:80: resource 16 [mem 0x000e4000-0x000e7fff]
pci_bus 0000:80: resource 17 [mem 0x000e8000-0x000ebfff]
pci_bus 0000:80: resource 18 [mem 0x000ec000-0x000effff]
pci_bus 0000:80: resource 19 [mem 0xc0000000-0xdfffffff]
pci_bus 0000:80: resource 20 [mem 0xe4000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:01:00.0: Boot video device
PCI: CLS 64 bytes, default 64
Unpacking initramfs...
Freeing initrd memory: 1392k freed
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff8800bbd70000 - ffff8800bfd70000
software IO TLB at phys 0xbbd70000 - 0xbfd70000
Simple Boot Flag at 0x44 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1305358982.739:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7917
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:02.0: setting latency timer to 64
pcieport 0000:00:02.0: irq 40 for MSI/MSI-X
pcieport 0000:00:04.0: setting latency timer to 64
pcieport 0000:00:04.0: irq 41 for MSI/MSI-X
pcieport 0000:00:05.0: setting latency timer to 64
pcieport 0000:00:05.0: irq 42 for MSI/MSI-X
pcieport 0000:00:06.0: setting latency timer to 64
pcieport 0000:00:06.0: irq 43 for MSI/MSI-X
pcieport 0000:00:0a.0: setting latency timer to 64
pcieport 0000:00:0a.0: irq 44 for MSI/MSI-X
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 10
NET: Registered protocol family 17
PM: Hibernation image not present or could not be loaded.
registered taskstats version 1
  Magic number: 11:469:723
Freeing unused kernel memory: 524k freed
Write protecting the kernel read-only data: 6144k
Freeing unused kernel memory: 152k freed
Freeing unused kernel memory: 464k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
udev[77]: starting version 167
SCSI subsystem initialized
libata version 3.00 loaded.
pata_acpi 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pata_acpi 0000:00:14.1: setting latency timer to 64
scsi0 : pata_atiixp
scsi1 : pata_atiixp
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6000 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6008 irq 15
ahci 0000:00:11.0: version 3.0
ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
scsi6 : ahci
scsi7 : ahci
ata3: SATA max UDMA/133 abar m1024@0xd2408000 port 0xd2408100 irq 22
ata4: SATA max UDMA/133 abar m1024@0xd2408000 port 0xd2408180 irq 22
ata5: SATA max UDMA/133 abar m1024@0xd2408000 port 0xd2408200 irq 22
ata6: SATA max UDMA/133 abar m1024@0xd2408000 port 0xd2408280 irq 22
ata7: SATA max UDMA/133 abar m1024@0xd2408000 port 0xd2408300 irq 22
ata8: SATA max UDMA/133 abar m1024@0xd2408000 port 0xd2408380 irq 22
ata8: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
ata4: softreset failed (device not ready)
ata4: applying SB600 PMP SRST workaround and retrying
ata3: softreset failed (device not ready)
ata3: applying SB600 PMP SRST workaround and retrying
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-8: FUJITSU MHZ2320BH G2, 8909, max UDMA/100
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata3.00: configured for UDMA/100
scsi 2:0:0:0: Direct-Access     ATA      FUJITSU MHZ2320B 8909 PQ: 0 ANSI: 5
ata4.00: ATAPI: TSSTcorp CDDVDW TS-L633L, 0400, max UDMA/100
ata4.00: configured for UDMA/100
scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW TS-L633L  0400 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 2:0:0:0: [sda] Attached SCSI disk
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Marking nosave pages: 00000000bfd70000 - 00000000bfdbf000
PM: Marking nosave pages: 00000000bfe58000 - 00000000bfebf000
PM: Marking nosave pages: 00000000bfeed000 - 00000000bfeff000
PM: Marking nosave pages: 00000000bff00000 - 0000000100000000
PM: Basic memory bitmaps created
PM: Basic memory bitmaps freed
EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
systemd[1]: systemd 26 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX +SYSVINIT +LIBCRYPTSETUP; arch)
systemd[1]: Set hostname to <koni>.
ACPI: acpi_idle registered with cpuidle
powernow-k8: Found 1 AMD Athlon(tm) X2 Dual-Core QL-64 (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : pstate 0 (2100 MHz)
powernow-k8:    1 : pstate 1 (1050 MHz)
systemd-fsck[616]: /dev/sda3: clean, 311200/768544 files, 2875006/3072431 blocks (check after next mount)
EXT4-fs (sda3): re-mounted. Opts: commit=60
udev[631]: starting version 167
input: PC Speaker as /devices/platform/pcspkr/input/input1
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
ACPI: Power Button [PWRB]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
ACPI: Sleep Button [SLPB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input4
ACPI: Lid Switch [LID]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
ACPI: Power Button [PWRF]
[Firmware Bug]: Invalid critical threshold (0)
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (36 C)
cfg80211: Calling CRDA to update world regulatory domain
piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
acpi device:0a: registered as cooling_device2
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:07/LNXVIDEO:01/input/input6
ACPI: Video Device [DVGA] (multi-head: yes  rom: no  post: no)
ACPI: AC Adapter [ACAD] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
wmi: Mapper loaded
hp_accel: hardware type HPDV5_A found
lis3lv02d: 8 bits sensor found
input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input7
Registered led device: hp::hddprotect
hp_accel: driver loaded
rtc_cmos 00:05: RTC can wake from S4
sdhci-pci 0000:0a:00.1: SDHCI controller found [197b:2382] (rev 0)
sdhci-pci 0000:0a:00.1: found 1 slot(s)
sdhci-pci 0000:0a:00.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
...
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Entering mem sleep
r8169 0000:09:00.0: PME# disabled
sd 2:0:0:0: [sda] Synchronizing SCSI cache
sd 2:0:0:0: [sda] Stopping disk
i8042 aux 00:08: wake-up capability disabled by ACPI
i8042 kbd 00:07: wake-up capability enabled by ACPI
HDA Intel 0000:01:00.1: PCI INT B disabled
ACPI handle has no context!
HDA Intel 0000:00:14.2: PCI INT A disabled
ACPI handle has no context!
ahci 0000:00:11.0: PCI INT A disabled
[drm] Disabling audio support
radeon 0000:01:00.0: power state changed by ACPI to D3
PM: suspend of devices complete after 2092.293 msecs
PM: late suspend of devices complete after 53.532 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
CPU 1 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
Booting Node 0 Processor 1 APIC 0x1
smpboot cpu 1: start_ip = 9a000
Switched to NOHz mode on CPU #1
CPU1 is up
ACPI: Waking up from system sleep state S3
pcieport 0000:00:02.0: restoring config space at offset 0x7 (was 0x20005151, writing 0x5151)
pcieport 0000:00:02.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
pcieport 0000:00:04.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
pcieport 0000:00:05.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
pcieport 0000:00:06.0: restoring config space at offset 0x7 (was 0x20002121, writing 0x2121)
pcieport 0000:00:06.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
pcieport 0000:00:0a.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
ahci 0000:00:11.0: restoring config space at offset 0x1 (was 0x2300003, writing 0x2300007)
ohci_hcd 0000:00:12.0: restoring config space at offset 0x1 (was 0x2a00002, writing 0x2a00017)
ehci_hcd 0000:00:12.2: BAR 0: set to [mem 0xd2408500-0xd24085ff] (PCI address [0xd2408500-0xd24085ff])
ehci_hcd 0000:00:12.2: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00017)
ohci_hcd 0000:00:13.0: restoring config space at offset 0x1 (was 0x2a00002, writing 0x2a00017)
ehci_hcd 0000:00:13.2: BAR 0: set to [mem 0xd2408400-0xd24084ff] (PCI address [0xd2408400-0xd24084ff])
ehci_hcd 0000:00:13.2: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00017)
radeon 0000:01:00.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
r8169 0000:09:00.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100407)
pci 0000:0a:00.0: Refused to change power state, currently in D3
pci 0000:0a:00.0: restoring config space at offset 0xf (was 0xffffffff, writing 0x10a)
pci 0000:0a:00.0: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
pci 0000:0a:00.0: restoring config space at offset 0xd (was 0xffffffff, writing 0x44)
pci 0000:0a:00.0: restoring config space at offset 0xc (was 0xffffffff, writing 0x0)
pci 0000:0a:00.0: restoring config space at offset 0xb (was 0xffffffff, writing 0x3600103c)
pci 0000:0a:00.0: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
pci 0000:0a:00.0: restoring config space at offset 0x9 (was 0xffffffff, writing 0xd1100c00)
pci 0000:0a:00.0: restoring config space at offset 0x8 (was 0xffffffff, writing 0xd1100c80)
pci 0000:0a:00.0: restoring config space at offset 0x7 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.0: restoring config space at offset 0x6 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.0: restoring config space at offset 0x5 (was 0xffffffff, writing 0xd1100d00)
pci 0000:0a:00.0: restoring config space at offset 0x4 (was 0xffffffff, writing 0xd1100000)
pci 0000:0a:00.0: restoring config space at offset 0x3 (was 0xffffffff, writing 0x800000)
pci 0000:0a:00.0: restoring config space at offset 0x2 (was 0xffffffff, writing 0xc001000)
pci 0000:0a:00.0: restoring config space at offset 0x1 (was 0xffffffff, writing 0x100007)
pci 0000:0a:00.0: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2380197b)
pci 0000:0a:00.1: Refused to change power state, currently in D3
pci 0000:0a:00.1: restoring config space at offset 0xf (was 0xffffffff, writing 0x10a)
pci 0000:0a:00.1: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
pci 0000:0a:00.1: restoring config space at offset 0xd (was 0xffffffff, writing 0xa4)
pci 0000:0a:00.1: restoring config space at offset 0xc (was 0xffffffff, writing 0x0)
pci 0000:0a:00.1: restoring config space at offset 0xb (was 0xffffffff, writing 0x3600103c)
pci 0000:0a:00.1: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
pci 0000:0a:00.1: restoring config space at offset 0x9 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.1: restoring config space at offset 0x8 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.1: restoring config space at offset 0x7 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.1: restoring config space at offset 0x6 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.1: restoring config space at offset 0x5 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.1: restoring config space at offset 0x4 (was 0xffffffff, writing 0xd1100b00)
pci 0000:0a:00.1: restoring config space at offset 0x3 (was 0xffffffff, writing 0x800000)
pci 0000:0a:00.1: restoring config space at offset 0x2 (was 0xffffffff, writing 0x8800000)
pci 0000:0a:00.1: restoring config space at offset 0x1 (was 0xffffffff, writing 0x100003)
pci 0000:0a:00.1: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2382197b)
pci 0000:0a:00.2: Refused to change power state, currently in D3
pci 0000:0a:00.2: restoring config space at offset 0xf (was 0xffffffff, writing 0x10a)
pci 0000:0a:00.2: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
pci 0000:0a:00.2: restoring config space at offset 0xd (was 0xffffffff, writing 0xa4)
pci 0000:0a:00.2: restoring config space at offset 0xc (was 0xffffffff, writing 0x0)
pci 0000:0a:00.2: restoring config space at offset 0xb (was 0xffffffff, writing 0x3600103c)
pci 0000:0a:00.2: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
pci 0000:0a:00.2: restoring config space at offset 0x9 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.2: restoring config space at offset 0x8 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.2: restoring config space at offset 0x7 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.2: restoring config space at offset 0x6 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.2: restoring config space at offset 0x5 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.2: restoring config space at offset 0x4 (was 0xffffffff, writing 0xd1100a00)
pci 0000:0a:00.2: restoring config space at offset 0x3 (was 0xffffffff, writing 0x800000)
pci 0000:0a:00.2: restoring config space at offset 0x2 (was 0xffffffff, writing 0x8050100)
pci 0000:0a:00.2: restoring config space at offset 0x1 (was 0xffffffff, writing 0x100003)
pci 0000:0a:00.2: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2381197b)
pci 0000:0a:00.3: Refused to change power state, currently in D3
pci 0000:0a:00.3: restoring config space at offset 0xf (was 0xffffffff, writing 0x10a)
pci 0000:0a:00.3: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
pci 0000:0a:00.3: restoring config space at offset 0xd (was 0xffffffff, writing 0xa4)
pci 0000:0a:00.3: restoring config space at offset 0xc (was 0xffffffff, writing 0x0)
pci 0000:0a:00.3: restoring config space at offset 0xb (was 0xffffffff, writing 0x3600103c)
pci 0000:0a:00.3: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
pci 0000:0a:00.3: restoring config space at offset 0x9 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.3: restoring config space at offset 0x8 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.3: restoring config space at offset 0x7 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.3: restoring config space at offset 0x6 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.3: restoring config space at offset 0x5 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.3: restoring config space at offset 0x4 (was 0xffffffff, writing 0xd1100900)
pci 0000:0a:00.3: restoring config space at offset 0x3 (was 0xffffffff, writing 0x800000)
pci 0000:0a:00.3: restoring config space at offset 0x2 (was 0xffffffff, writing 0x8800000)
pci 0000:0a:00.3: restoring config space at offset 0x1 (was 0xffffffff, writing 0x100003)
pci 0000:0a:00.3: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2383197b)
pci 0000:0a:00.4: Refused to change power state, currently in D3
pci 0000:0a:00.4: restoring config space at offset 0xf (was 0xffffffff, writing 0x10a)
pci 0000:0a:00.4: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
pci 0000:0a:00.4: restoring config space at offset 0xd (was 0xffffffff, writing 0xa4)
pci 0000:0a:00.4: restoring config space at offset 0xc (was 0xffffffff, writing 0x0)
pci 0000:0a:00.4: restoring config space at offset 0xb (was 0xffffffff, writing 0x3600103c)
pci 0000:0a:00.4: restoring config space at offset 0xa (was 0xffffffff, writing 0x0)
pci 0000:0a:00.4: restoring config space at offset 0x9 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.4: restoring config space at offset 0x8 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.4: restoring config space at offset 0x7 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.4: restoring config space at offset 0x6 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.4: restoring config space at offset 0x5 (was 0xffffffff, writing 0x0)
pci 0000:0a:00.4: restoring config space at offset 0x4 (was 0xffffffff, writing 0xd1100800)
pci 0000:0a:00.4: restoring config space at offset 0x3 (was 0xffffffff, writing 0x800000)
pci 0000:0a:00.4: restoring config space at offset 0x2 (was 0xffffffff, writing 0x8800000)
pci 0000:0a:00.4: restoring config space at offset 0x1 (was 0xffffffff, writing 0x100007)
pci 0000:0a:00.4: restoring config space at offset 0x0 (was 0xffffffff, writing 0x2384197b)
PM: early resume of devices complete after 93.240 msecs
ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
HDA Intel 0000:01:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
HDA Intel 0000:01:00.1: setting latency timer to 64
HDA Intel 0000:01:00.1: irq 47 for MSI/MSI-X
sd 2:0:0:0: [sda] Starting disk
radeon 0000:01:00.0: power state changed by ACPI to D0
radeon 0000:01:00.0: power state changed by ACPI to D0
radeon 0000:01:00.0: setting latency timer to 64
radeon 0000:01:00.0: WB enabled
[drm] ring test succeeded in 0 usecs
[drm] ib test succeeded in 0 usecs
[drm] Enabling audio support
i8042 kbd 00:07: wake-up capability disabled by ACPI
usb 1-3: reset high speed USB device number 2 using ehci_hcd
ata8: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata7: SATA link down (SStatus 0 SControl 300)
ata4: softreset failed (device not ready)
ata4: applying SB600 PMP SRST workaround and retrying
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: configured for UDMA/100
ata3: softreset failed (device not ready)
ata3: applying SB600 PMP SRST workaround and retrying
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: configured for UDMA/100
PM: resume of devices complete after 5833.142 msecs
PM: Finishing wakeup.
Restarting tasks ... 
r8169 0000:09:00.0: PME# enabled
done.
video LNXVIDEO:01: Restoring backlight state
EXT4-fs (sda3): re-mounted. Opts: commit=60,commit=0
EXT4-fs (sda5): re-mounted. Opts: commit=30,commit=0


A perhaps funny after-effect of the s2ram problem is that
s2disk after that leads to -1 being written all around
in the affected pci area after resume:

...
ACPI: Waking up from system sleep state S4
...
pci 0000:0a:00.0: restoring config space at offset 0xf (was 0x10a, writing 0xffffffff)
pci 0000:0a:00.0: restoring config space at offset 0xe (was 0x0, writing 0xffffffff)
...

I haven't tested whether firewire or the card reader, for example, works
with such config space.


Greetings,

Mikko
