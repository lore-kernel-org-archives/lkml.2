Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab2K1PU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:20:29 -0500
Received: from nm30-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.126]:38918 "EHLO
	nm30-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754738Ab2K1PUZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:20:25 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 23749.11463.bm@omp1010.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=OrTrp8KqIAG1R/+xGsompegCtlCpP4YKRhPipSm4E6R3B+Jso9yF662K9sKyElHr5PdI05FGu0aQUinCcfy/NDAUjoD0gQSfqX3WTs9NiMgmk3konxIpSUfMtULPRk7fxabYnWiI+XCxaU1qFcCN/sCipsSuTb5SI5w2WgVDzkM=;
X-YMail-OSG: OWHurzUVM1kcqoGl19k3tULmlpRraSHhduEVPN9_yqYBQ.j
 GouC9kWqW48x6C.CgyJqZ13nVF02wZOxDMMpaY8LUhfTT5h0mpEEW4wfDbKi
 raoVb8QbiaP0e9WhTNbp1VSaUA3PGWvC8xFKN_Jv9LjP9kpEr82mBcAt_Pjc
 jOuTl8NJXGjBTArBaiAhql46qMbzcR3KWqQHUiNt1i1gFyaV2MSajNIsttml
 Gq8DbB9ITW2cac6ftU21ReDKzJDohu_mKybmpM9taBHB3FeWbw8gIC7ZvhXU
 K3G4R8QkXftGIDlFWzl_L3K8qrb2BiD1a3UFnFMrd6lxVtlagqKOEJzyG1cx
 8k7JMm7b41XhpwnaYggw.h_pBOCO_2fpbF2C4rburoz04iUeK8HXydp16Mw_
 V_Tphr63bs5iZlcgXuwCvjNYS3NBGPbR8g48X0cJJfXQRha8wMXyBAIfM9yc
 8TghQBm4fATUJbcv.ooj.jlkPfZA72FL2JIgkzeGbiCvM5dVWTiif5SaG342
 1Kmp7f.oaMPaqd1MfiXx8SCerohrby0r2OsJVrxPD_czZX0g5wHJ2rc4xXx4
 VV3BWFX.aRUByDh8YrCczDKFx.ZBWrpVP8kSCKZOHh3xesLAzadbbPEEiGSz
 WVreq2bEUke3.b2vKpN.y_sHpgNwJhiLJzwoKVO9pDkfZuxpL_dQHA6UkFtw
 UkWV7J35scJbhw8xWAHRV3Ao_._gqTtHErBC7Hv37gDR8BjyKYI9tGo4-
X-Rocket-MIMEInfo: 001.001,T2theSBpIHNlbmQgYWxsIG15IGRtZXNnIGZvciBkZXRhaWxzOgoKWyAgICAwLjAwMDAwMF0gSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgY3B1c2V0ClsgICAgMC4wMDAwMDBdIEluaXRpYWxpemluZyBjZ3JvdXAgc3Vic3lzIGNwdQpbICAgIDAuMDAwMDAwXSBMaW51eCB2ZXJzaW9uIDMuNi43LTEtQVJDSCAodG9iaWFzQFQtUE9XQS1MWCkgKGdjYyB2ZXJzaW9uIDQuNy4yIAooR0NDKSApICMxIFNNUCBQUkVFTVBUIFN1biBOb3YgMTggMTA6MTE6MjIgQ0VUIDIwMTIKWyAgICAwLjAwMDAwMF0gQ29tbWFuZCABMAEBAQE-
X-Mailer: YahooMailClassic/15.0.8 YahooMailWebService/0.8.127.475
Message-ID: <1354116022.1115.YahooMailClassic@web163006.mail.bf1.yahoo.com>
Date: Wed, 28 Nov 2012 07:20:22 -0800 (PST)
From: Denis Lotarev <dlotarev@yahoo.com>
Subject: Re: [FIRMWARE BUG] Lenovo x120e
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <len.brown@intel.com>
In-Reply-To: <20121128151247.GA14635@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay i send all my dmesg for details:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.7-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.2 
(GCC) ) #1 SMP PREEMPT Sun Nov 18 10:11:22 CET 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-linux root=UUID=3094a7ea-b
702-40e1-8781-c0966efee582 ro quiet elevator=noop nomodeset init=/usr/lib/system
d/systemd
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000c6e79fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c6e7a000-0x00000000c7289fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000c728a000-0x00000000c7309fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000c730a000-0x00000000c7369fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000c736a000-0x00000000c7d7ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c7d80000-0x00000000c7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fecfffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed80fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000019effffff] usable
[init@initbox ~]$ cat 1232 
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.7-1-ARCH (tobias@T-POWA-LX) (gcc version 4.7.2 (GCC) ) #1 SMP PREEMPT Sun Nov 18 10:11:22 CET 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-linux root=UUID=3094a7ea-b702-40e1-8781-c0966efee582 ro quiet elevator=noop nomodeset init=/usr/lib/systemd/systemd
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000c6e79fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c6e7a000-0x00000000c7289fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000c728a000-0x00000000c7309fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000c730a000-0x00000000c7369fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000c736a000-0x00000000c7d7ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c7d80000-0x00000000c7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fecfffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed80fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000019effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: LENOVO 0596RZ4/0596RZ4, BIOS 8FET32WW (1.16 ) 11/03/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x19f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FF8000000 write-back
[    0.000000]   3 base 0FFF90000 mask FFFFF0000 uncachable
[    0.000000]   4 base 0FED80000 mask FFFFFF000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000] TOM2: 000000019f000000 aka 6640M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xc7d80 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fbcc0-0x000fbccf] mapped at [ffff8800000fbcc0]
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0xc7d7ffff]
[    0.000000]  [mem 0x00000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xc7bfffff] page 2M
[    0.000000]  [mem 0xc7c00000-0xc7d7ffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xc7d7ffff @ [mem 0x1fffd000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x19effffff]
[    0.000000]  [mem 0x100000000-0x17fffffff] page 1G
[    0.000000]  [mem 0x180000000-0x19effffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x19effffff @ [mem 0xc7d7e000-0xc7d7ffff]
[    0.000000] RAMDISK: [mem 0x37a2e000-0x37d0efff]
[    0.000000] ACPI: RSDP 00000000000f00e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000c7369120 00074 (v01 LENOVO TP-8F    00000003 PTEC 00000002)
[    0.000000] ACPI: FACP 00000000c7357000 000F4 (v04 LENOVO TP-8F    00001160 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000c7359000 0EBDC (v01 LENOVO TP-8F    00001000 PTEC 00001160)
[    0.000000] ACPI: FACS 00000000c72f5000 00040
[    0.000000] ACPI: SLIC 00000000c7368000 00176 (v01 LENOVO TP-8F    00001160 PTEC 00000001)
[    0.000000] ACPI: HPET 00000000c7356000 00038 (v01 LENOVO TP-8F    00001160 PTL  00000002)
[    0.000000] ACPI: APIC 00000000c7355000 0005E (v02 LENOVO TP-8F    00001160 PTL  00000002)
[    0.000000] ACPI: MCFG 00000000c7354000 0003C (v01 LENOVO TP-8F    00001160 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000c7353000 0003E (v01 LENOVO TP-8F    00001160 PTL  00000002)
[    0.000000] ACPI: UEFI 00000000c7352000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000c7351000 003DE (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 00000000c734f000 012FA (v02    AMD     ALIB 00000001 MSFT 04000000)
[    0.000000] ACPI: UEFI 00000000c734e000 0012A (v01 LENOVO TP-8F    00001160 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000019effffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x19effffff]
[    0.000000]   NODE_DATA [mem 0x19effc000-0x19effffff]
[    0.000000]  [ffffea0000000000-ffffea00067fffff] PMD -> [ffff880198c00000-ffff88019e5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x19effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xc6e79fff]
[    0.000000]   node   0: [mem 0xc736a000-0xc7d7ffff]
[    0.000000]   node   0: [mem 0x100000000-0x19effffff]
[    0.000000] On node 0 totalpages: 1468445
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3911 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 16320 pages used for memmap
[    0.000000]   DMA32 zone: 796880 pages, LIFO batch:31
[    0.000000]   Normal zone: 10176 pages used for memmap
[    0.000000]   Normal zone: 641088 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000c6e7a000 - 00000000c728a000
[    0.000000] PM: Registered nosave memory: 00000000c728a000 - 00000000c730a000
[    0.000000] PM: Registered nosave memory: 00000000c730a000 - 00000000c736a000
[    0.000000] PM: Registered nosave memory: 00000000c7d80000 - 00000000c8000000
[    0.000000] PM: Registered nosave memory: 00000000c8000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed80000
[    0.000000] PM: Registered nosave memory: 00000000fed80000 - 00000000fed81000
[    0.000000] PM: Registered nosave memory: 00000000fed81000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] e820: [mem 0xc8000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88019ec00000 s84608 r8192 d21888 u1048576
[    0.000000] pcpu-alloc: s84608 r8192 d21888 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1441879
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-linux root=UUID=3094a7ea-b702-40e1-8781-c0966efee582 ro quiet elevator=noop nomodeset init=/usr/lib/systemd/systemd
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 5701144k/6799360k available (4727k kernel code, 925580k absent, 172636k reserved, 4143k data, 772k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 23592960 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 1596.524 MHz processor
[    0.000006] Calibrating delay loop (skipped), value calculated using timer frequency.. 3194.09 BogoMIPS (lpj=5321746)
[    0.000012] pid_max: default: 32768 minimum: 301
[    0.000070] Security Framework initialized
[    0.000078] AppArmor: AppArmor disabled by boot time parameter
[    0.001153] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.007346] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.010181] Mount-cache hash table entries: 256
[    0.010604] Initializing cgroup subsys cpuacct
[    0.010611] Initializing cgroup subsys memory
[    0.010630] Initializing cgroup subsys devices
[    0.010632] Initializing cgroup subsys freezer
[    0.010635] Initializing cgroup subsys net_cls
[    0.010638] Initializing cgroup subsys blkio
[    0.010687] tseg: 00c7d80000
[    0.010691] CPU: Physical Processor ID: 0
[    0.010692] CPU: Processor Core ID: 0
[    0.010696] mce: CPU supports 6 MCE banks
[    0.010713] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
tlb_flushall_shift is 0xffffffff
[    0.012934] ACPI: Core revision 20120711
[    1.132648] ftrace: allocating 18348 entries in 72 pages
[    1.150499] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    1.183496] smpboot: CPU0: AMD E-350 Processor stepping 00
[    1.288661] Performance Events: AMD PMU driver.
[    1.288669] ... version:                0
[    1.288671] ... bit width:              48
[    1.288673] ... generic registers:      4
[    1.288676] ... value mask:             0000ffffffffffff
[    1.288678] ... max period:             00007fffffffffff
[    1.288680] ... fixed-purpose events:   0
[    1.288682] ... event mask:             000000000000000f
[    1.315557] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    1.328784] smpboot: Booting Node   0, Processors  #1 OK
[    1.342171] Brought up 2 CPUs
[    1.342180] smpboot: Total of 2 processors activated (6388.18 BogoMIPS)
[    1.343393] devtmpfs: initialized
[    1.347080] PM: Registering ACPI NVS region [mem 0xc728a000-0xc7309fff] (524288 bytes)
[    1.349215] NET: Registered protocol family 16
[    1.349704] ACPI: bus type pci registered
[    1.349895] PCI: MMCONFIG for domain 0000 [bus 00-1f] at [mem 0xf8000000-0xf9ffffff] (base 0xf8000000)
[    1.349900] PCI: not using MMCONFIG
[    1.349903] PCI: Using configuration type 1 for base access
[    1.349905] PCI: Using configuration type 1 for extended access
[    1.350231] mtrr: your CPUs had inconsistent variable MTRR settings
[    1.350234] mtrr: probably your BIOS does not setup all CPUs.
[    1.350236] mtrr: corrected configuration.
[    1.351251] bio: create slab <bio-0> at 0
[    1.351612] ACPI: Added _OSI(Module Device)
[    1.351619] ACPI: Added _OSI(Processor Device)
[    1.351622] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.351625] ACPI: Added _OSI(Processor Aggregator Device)
[    1.354663] ACPI: EC: Look up EC in DSDT
[    1.363732] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.368936] ACPI: Interpreter enabled
[    1.368951] ACPI: (supports S0 S3 S4 S5)
[    1.368991] ACPI: Using IOAPIC for interrupt routing
[    1.369270] PCI: MMCONFIG for domain 0000 [bus 00-1f] at [mem 0xf8000000-0xf9ffffff] (base 0xf8000000)
[    1.369801] PCI: MMCONFIG at [mem 0xf8000000-0xf9ffffff] reserved in ACPI motherboard resources
[    1.373696] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    1.380763] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    1.384027] ACPI: EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    1.384355] ACPI: No dock devices found.
[    1.384364] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.385603] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.387426] pci_root PNP0A08:00: ignoring host bridge window [mem 0x000ce000-0x000cffff] (conflicts with Video ROM [mem 0x000c0000-0x000ce1ff])
[    1.387439] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-1f] only partially covers this bridge
[    1.387501] PCI host bridge to bus 0000:00
[    1.387509] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
[    1.387513] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.387518] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.387522] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c1fff]
[    1.387525] pci_bus 0000:00: root bus resource [mem 0x000c2000-0x000c3fff]
[    1.387533] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c5fff]
[    1.387537] pci_bus 0000:00: root bus resource [mem 0x000c6000-0x000c7fff]
[    1.387540] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000c9fff]
[    1.387544] pci_bus 0000:00: root bus resource [mem 0x000ca000-0x000cbfff]
[    1.387548] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cdfff]
[    1.387552] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d1fff]
[    1.387555] pci_bus 0000:00: root bus resource [mem 0x000d2000-0x000d3fff]
[    1.387559] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d5fff]
[    1.387563] pci_bus 0000:00: root bus resource [mem 0x000d6000-0x000d7fff]
[    1.387566] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000d9fff]
[    1.387570] pci_bus 0000:00: root bus resource [mem 0x000da000-0x000dbfff]
[    1.387574] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000ddfff]
[    1.387577] pci_bus 0000:00: root bus resource [mem 0x000de000-0x000dffff]
[    1.387581] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e1fff]
[    1.387585] pci_bus 0000:00: root bus resource [mem 0x000e2000-0x000e3fff]
[    1.387589] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e5fff]
[    1.387592] pci_bus 0000:00: root bus resource [mem 0x000e6000-0x000e7fff]
[    1.387596] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000e9fff]
[    1.387600] pci_bus 0000:00: root bus resource [mem 0x000ea000-0x000ebfff]
[    1.387603] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000edfff]
[    1.387607] pci_bus 0000:00: root bus resource [mem 0x000ee000-0x000effff]
[    1.387611] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xf7ffffff]
[    1.387615] pci_bus 0000:00: root bus resource [mem 0xf8000000-0xffffffff]
[    1.387618] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.387622] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.387639] pci 0000:00:00.0: [1022:1510] type 00 class 0x060000
[    1.387700] pci 0000:00:01.0: [1002:9802] type 00 class 0x030000
[    1.387715] pci 0000:00:01.0: reg 10: [mem 0xe0000000-0xefffffff pref]
[    1.387726] pci 0000:00:01.0: reg 14: [io  0x3000-0x30ff]
[    1.387736] pci 0000:00:01.0: reg 18: [mem 0xf0200000-0xf023ffff]
[    1.387799] pci 0000:00:01.0: supports D1 D2
[    1.387824] pci 0000:00:01.1: [1002:1314] type 00 class 0x040300
[    1.387837] pci 0000:00:01.1: reg 10: [mem 0xf0244000-0xf0247fff]
[    1.387911] pci 0000:00:01.1: supports D1 D2
[    1.387962] pci 0000:00:06.0: [1022:1514] type 01 class 0x060400
[    1.388042] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    1.388093] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    1.388120] pci 0000:00:11.0: reg 10: [io  0x3118-0x311f]
[    1.388134] pci 0000:00:11.0: reg 14: [io  0x3124-0x3127]
[    1.388148] pci 0000:00:11.0: reg 18: [io  0x3110-0x3117]
[    1.388162] pci 0000:00:11.0: reg 1c: [io  0x3120-0x3123]
[    1.388176] pci 0000:00:11.0: reg 20: [io  0x3100-0x310f]
[    1.388190] pci 0000:00:11.0: reg 24: [mem 0xf024a000-0xf024a3ff]
[    1.388272] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    1.388291] pci 0000:00:12.0: reg 10: [mem 0xf0249000-0xf0249fff]
[    1.388388] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    1.388415] pci 0000:00:12.2: reg 10: [mem 0xf024a500-0xf024a5ff]
[    1.388525] pci 0000:00:12.2: supports D1 D2
[    1.388528] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    1.388566] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    1.388593] pci 0000:00:13.0: reg 10: [mem 0xf0248000-0xf0248fff]
[    1.388693] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    1.388719] pci 0000:00:13.2: reg 10: [mem 0xf024a400-0xf024a4ff]
[    1.388829] pci 0000:00:13.2: supports D1 D2
[    1.388833] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    1.388868] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    1.388976] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    1.389007] pci 0000:00:14.2: reg 10: [mem 0xf0240000-0xf0243fff 64bit]
[    1.389095] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    1.389118] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    1.389221] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    1.389293] pci 0000:00:15.0: [1002:43a0] type 01 class 0x060400
[    1.389400] pci 0000:00:15.0: supports D1 D2
[    1.389437] pci 0000:00:15.1: [1002:43a1] type 01 class 0x060400
[    1.389545] pci 0000:00:15.1: supports D1 D2
[    1.389591] pci 0000:00:18.0: [1022:1700] type 00 class 0x060000
[    1.389642] pci 0000:00:18.1: [1022:1701] type 00 class 0x060000
[    1.389686] pci 0000:00:18.2: [1022:1702] type 00 class 0x060000
[    1.389734] pci 0000:00:18.3: [1022:1703] type 00 class 0x060000
[    1.389793] pci 0000:00:18.4: [1022:1704] type 00 class 0x060000
[    1.389837] pci 0000:00:18.5: [1022:1718] type 00 class 0x060000
[    1.389882] pci 0000:00:18.6: [1022:1716] type 00 class 0x060000
[    1.389926] pci 0000:00:18.7: [1022:1719] type 00 class 0x060000
[    1.390028] pci_bus 0000:01: busn_res: [bus 01] is inserted under [bus 00-ff]
[    1.390058] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    1.390078] pci 0000:01:00.0: reg 10: [io  0x2000-0x20ff]
[    1.390109] pci 0000:01:00.0: reg 18: [mem 0xf0004000-0xf0004fff 64bit pref]
[    1.390130] pci 0000:01:00.0: reg 20: [mem 0xf0000000-0xf0003fff 64bit pref]
[    1.390145] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    1.390215] pci 0000:01:00.0: supports D1 D2
[    1.390219] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.395504] pci 0000:00:06.0: PCI bridge to [bus 01]
[    1.395529] pci 0000:00:06.0:   bridge window [io  0x2000-0x2fff]
[    1.395541] pci 0000:00:06.0:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
[    1.395618] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 00-ff]
[    1.395683] pci 0000:00:14.4: PCI bridge to [bus 02] (subtractive decode)
[    1.395698] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.395702] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000c1fff] (subtractive decode)
[    1.395706] pci 0000:00:14.4:   bridge window [mem 0x000c2000-0x000c3fff] (subtractive decode)
[    1.395710] pci 0000:00:14.4:   bridge window [mem 0x000c4000-0x000c5fff] (subtractive decode)
[    1.395714] pci 0000:00:14.4:   bridge window [mem 0x000c6000-0x000c7fff] (subtractive decode)
[    1.395718] pci 0000:00:14.4:   bridge window [mem 0x000c8000-0x000c9fff] (subtractive decode)
[    1.395721] pci 0000:00:14.4:   bridge window [mem 0x000ca000-0x000cbfff] (subtractive decode)
[    1.395725] pci 0000:00:14.4:   bridge window [mem 0x000cc000-0x000cdfff] (subtractive decode)
[    1.395729] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d1fff] (subtractive decode)
[    1.395733] pci 0000:00:14.4:   bridge window [mem 0x000d2000-0x000d3fff] (subtractive decode)
[    1.395737] pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d5fff] (subtractive decode)
[    1.395740] pci 0000:00:14.4:   bridge window [mem 0x000d6000-0x000d7fff] (subtractive decode)
[    1.395744] pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000d9fff] (subtractive decode)
[    1.395748] pci 0000:00:14.4:   bridge window [mem 0x000da000-0x000dbfff] (subtractive decode)
[    1.395752] pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000ddfff] (subtractive decode)
[    1.395755] pci 0000:00:14.4:   bridge window [mem 0x000de000-0x000dffff] (subtractive decode)
[    1.395759] pci 0000:00:14.4:   bridge window [mem 0x000e0000-0x000e1fff] (subtractive decode)
[    1.395763] pci 0000:00:14.4:   bridge window [mem 0x000e2000-0x000e3fff] (subtractive decode)
[    1.395767] pci 0000:00:14.4:   bridge window [mem 0x000e4000-0x000e5fff] (subtractive decode)
[    1.395771] pci 0000:00:14.4:   bridge window [mem 0x000e6000-0x000e7fff] (subtractive decode)
[    1.395774] pci 0000:00:14.4:   bridge window [mem 0x000e8000-0x000e9fff] (subtractive decode)
[    1.395778] pci 0000:00:14.4:   bridge window [mem 0x000ea000-0x000ebfff] (subtractive decode)
[    1.395782] pci 0000:00:14.4:   bridge window [mem 0x000ec000-0x000edfff] (subtractive decode)
[    1.395786] pci 0000:00:14.4:   bridge window [mem 0x000ee000-0x000effff] (subtractive decode)
[    1.395790] pci 0000:00:14.4:   bridge window [mem 0xe0000000-0xf7ffffff] (subtractive decode)
[    1.395794] pci 0000:00:14.4:   bridge window [mem 0xf8000000-0xffffffff] (subtractive decode)
[    1.395797] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.395801] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.395886] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-ff]
[    1.395892] pci 0000:00:15.0: PCI bridge to [bus 03]
[    1.395986] pci_bus 0000:04: busn_res: [bus 04] is inserted under [bus 00-ff]
[    1.396020] pci 0000:04:00.0: [168c:002b] type 00 class 0x028000
[    1.396057] pci 0000:04:00.0: reg 10: [mem 0xf0100000-0xf010ffff 64bit]
[    1.396209] pci 0000:04:00.0: supports D1
[    1.396213] pci 0000:04:00.0: PME# supported from D0 D1 D3hot D3cold
[    1.402206] pci 0000:00:15.1: PCI bridge to [bus 04]
[    1.402229] pci 0000:00:15.1:   bridge window [mem 0xf0100000-0xf01fffff]
[    1.402278] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.402580] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PB6_._PRT]
[    1.402744] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    1.402853] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SPB0._PRT]
[    1.402927] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SPB1._PRT]
[    1.403281]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.403697]  pci0000:00: ACPI _OSC control (0x1d) granted
[    1.413037] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0
[    1.413200] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0
[    1.413367] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0
[    1.413532] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0
[    1.413674] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0
[    1.413797] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0
[    1.413919] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0
[    1.414033] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0
[    1.414421] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    1.414446] vgaarb: loaded
[    1.414449] vgaarb: bridge control possible 0000:00:01.0
[    1.414549] PCI: Using ACPI for IRQ routing
[    1.415798] PCI: pci_cache_line_size set to 64 bytes
[    1.415940] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    1.415944] e820: reserve RAM buffer [mem 0xc6e7a000-0xc7ffffff]
[    1.415947] e820: reserve RAM buffer [mem 0xc7d80000-0xc7ffffff]
[    1.415950] e820: reserve RAM buffer [mem 0x19f000000-0x19fffffff]
[    1.416145] NetLabel: Initializing
[    1.416148] NetLabel:  domain hash size = 128
[    1.416150] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.416173] NetLabel:  unlabeled traffic allowed by default
[    1.416252] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.416260] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    1.418289] Switching to clocksource hpet
[    1.430217] pnp: PnP ACPI init
[    1.430254] ACPI: bus type pnp registered
[    1.431261] pnp 00:00: [bus 00-ff]
[    1.431267] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.431271] pnp 00:00: [mem 0x000c0000-0x000c1fff window]
[    1.431275] pnp 00:00: [mem 0x000c2000-0x000c3fff window]
[    1.431279] pnp 00:00: [mem 0x000c4000-0x000c5fff window]
[    1.431287] pnp 00:00: [mem 0x000c6000-0x000c7fff window]
[    1.431291] pnp 00:00: [mem 0x000c8000-0x000c9fff window]
[    1.431295] pnp 00:00: [mem 0x000ca000-0x000cbfff window]
[    1.431298] pnp 00:00: [mem 0x000cc000-0x000cdfff window]
[    1.431302] pnp 00:00: [mem 0x000ce000-0x000cffff window]
[    1.431305] pnp 00:00: [mem 0x000d0000-0x000d1fff window]
[    1.431309] pnp 00:00: [mem 0x000d2000-0x000d3fff window]
[    1.431312] pnp 00:00: [mem 0x000d4000-0x000d5fff window]
[    1.431316] pnp 00:00: [mem 0x000d6000-0x000d7fff window]
[    1.431319] pnp 00:00: [mem 0x000d8000-0x000d9fff window]
[    1.431323] pnp 00:00: [mem 0x000da000-0x000dbfff window]
[    1.431326] pnp 00:00: [mem 0x000dc000-0x000ddfff window]
[    1.431330] pnp 00:00: [mem 0x000de000-0x000dffff window]
[    1.431333] pnp 00:00: [mem 0x000e0000-0x000e1fff window]
[    1.431337] pnp 00:00: [mem 0x000e2000-0x000e3fff window]
[    1.431340] pnp 00:00: [mem 0x000e4000-0x000e5fff window]
[    1.431343] pnp 00:00: [mem 0x000e6000-0x000e7fff window]
[    1.431347] pnp 00:00: [mem 0x000e8000-0x000e9fff window]
[    1.431350] pnp 00:00: [mem 0x000ea000-0x000ebfff window]
[    1.431354] pnp 00:00: [mem 0x000ec000-0x000edfff window]
[    1.431357] pnp 00:00: [mem 0x000ee000-0x000effff window]
[    1.431361] pnp 00:00: [mem 0xe0000000-0xf7ffffff window]
[    1.431364] pnp 00:00: [mem 0xf8000000-0xffffffff window]
[    1.431368] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.431372] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.431376] pnp 00:00: [io  0x0d00-0xffff window]
[    1.431495] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.431586] pnp 00:01: [io  0x0f50-0x0f51]
[    1.431590] pnp 00:01: [mem 0xfec00000-0xfec00fff]
[    1.431594] pnp 00:01: [mem 0xfee00000-0xfee00fff]
[    1.431597] pnp 00:01: [mem 0xf8000000-0xf9ffffff]
[    1.431688] system 00:01: [io  0x0f50-0x0f51] has been reserved
[    1.431695] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.431699] system 00:01: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.431703] system 00:01: [mem 0xf8000000-0xf9ffffff] has been reserved
[    1.431710] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.432500] pnp 00:02: [io  0x0000-0x001f]
[    1.432505] pnp 00:02: [io  0x0081-0x008f]
[    1.432508] pnp 00:02: [io  0x00c0-0x00de]
[    1.432511] pnp 00:02: [io  0x040b]
[    1.432514] pnp 00:02: [io  0x04d6]
[    1.432518] pnp 00:02: [dma 4]
[    1.432584] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.432601] pnp 00:03: [io  0x00f0-0x00fe]
[    1.432667] pnp 00:03: [irq 13]
[    1.432723] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.432742] pnp 00:04: [io  0x0070-0x0071]
[    1.432798] pnp 00:04: [irq 8]
[    1.432857] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.432873] pnp 00:05: [io  0x0061]
[    1.432933] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.432953] pnp 00:06: [io  0x0060]
[    1.432960] pnp 00:06: [io  0x0064]
[    1.433011] pnp 00:06: [irq 1]
[    1.433068] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.433152] pnp 00:07: [irq 12]
[    1.433217] pnp 00:07: Plug and Play ACPI device, IDs LEN0017 PNP0f13 (active)
[    1.433243] pnp 00:08: [io  0x0022-0x0023]
[    1.433246] pnp 00:08: [io  0x002e-0x002f]
[    1.433250] pnp 00:08: [io  0x0072-0x0073]
[    1.433253] pnp 00:08: [io  0x0080]
[    1.433256] pnp 00:08: [io  0x0092]
[    1.433259] pnp 00:08: [io  0x00b0-0x00b1]
[    1.433262] pnp 00:08: [io  0x00b2]
[    1.433266] pnp 00:08: [io  0x00b8]
[    1.433269] pnp 00:08: [io  0x00bc]
[    1.433272] pnp 00:08: [io  0x00f0]
[    1.433275] pnp 00:08: [io  0x04d0-0x04d1]
[    1.433278] pnp 00:08: [io  0x0530-0x0537]
[    1.433282] pnp 00:08: [io  0x0800-0x0827]
[    1.433285] pnp 00:08: [io  0x0830]
[    1.433288] pnp 00:08: [io  0x0840-0x0847]
[    1.433291] pnp 00:08: [io  0x0b00-0x0b1f]
[    1.433294] pnp 00:08: [io  0x0b20-0x0b3f]
[    1.433298] pnp 00:08: [io  0x0c00-0x0c01]
[    1.433301] pnp 00:08: [io  0x0c14]
[    1.433304] pnp 00:08: [io  0x0c50-0x0c52]
[    1.433307] pnp 00:08: [io  0x0cd0-0x0cd1]
[    1.433311] pnp 00:08: [io  0x0cd2-0x0cd3]
[    1.433314] pnp 00:08: [io  0x0cd4-0x0cd5]
[    1.433317] pnp 00:08: [io  0x0cd6-0x0cd7]
[    1.433320] pnp 00:08: [io  0x0cd8-0x0cdf]
[    1.433323] pnp 00:08: [io  0x0cf9]
[    1.433327] pnp 00:08: [io  0x8100-0x81ff window]
[    1.433331] pnp 00:08: [io  0x8200-0x82ff window]
[    1.433444] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    1.433448] system 00:08: [io  0x0530-0x0537] has been reserved
[    1.433453] system 00:08: [io  0x0800-0x0827] has been reserved
[    1.433457] system 00:08: [io  0x0830] has been reserved
[    1.433461] system 00:08: [io  0x0840-0x0847] has been reserved
[    1.433469] system 00:08: [io  0x0b00-0x0b1f] has been reserved
[    1.433473] system 00:08: [io  0x0b20-0x0b3f] has been reserved
[    1.433477] system 00:08: [io  0x0c00-0x0c01] has been reserved
[    1.433481] system 00:08: [io  0x0c14] has been reserved
[    1.433485] system 00:08: [io  0x0c50-0x0c52] has been reserved
[    1.433489] system 00:08: [io  0x0cd0-0x0cd1] has been reserved
[    1.433493] system 00:08: [io  0x0cd2-0x0cd3] has been reserved
[    1.433497] system 00:08: [io  0x0cd4-0x0cd5] has been reserved
[    1.433501] system 00:08: [io  0x0cd6-0x0cd7] has been reserved
[    1.433505] system 00:08: [io  0x0cd8-0x0cdf] has been reserved
[    1.433509] system 00:08: [io  0x0cf9] could not be reserved
[    1.433514] system 00:08: [io  0x8100-0x81ff window] has been reserved
[    1.433518] system 00:08: [io  0x8200-0x82ff window] has been reserved
[    1.433525] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.433681] pnp 00:09: [mem 0x000e0000-0x000fffff]
[    1.433685] pnp 00:09: [mem 0xffe00000-0xffffffff]
[    1.433689] pnp 00:09: [mem 0x00000000-0xffffffffffffffff disabled]
[    1.433693] pnp 00:09: [mem 0xfec10000-0xfec1001f]
[    1.433696] pnp 00:09: [mem 0xfed00000-0xfed003ff]
[    1.433700] pnp 00:09: [mem 0xfed61000-0xfed613ff]
[    1.433703] pnp 00:09: [mem 0xfed80000-0xfed80fff]
[    1.433737] pnp 00:09: [Firmware Bug]: [mem 0x00000000-0xffffffffffffffff disabled] covers only part of AMD MMCONFIG area [mem 0xf8000000-0xf9ffffff]; adding more reservations
[    1.433805] system 00:09: [mem 0x000e0000-0x000fffff] could not be reserved
[    1.433810] system 00:09: [mem 0xffe00000-0xffffffff] has been reserved
[    1.433814] system 00:09: [mem 0xfec10000-0xfec1001f] has been reserved
[    1.433818] system 00:09: [mem 0xfed00000-0xfed003ff] has been reserved
[    1.433822] system 00:09: [mem 0xfed61000-0xfed613ff] has been reserved
[    1.433826] system 00:09: [mem 0xfed80000-0xfed80fff] has been reserved
[    1.433832] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.435214] pnp: PnP ACPI: found 10 devices
[    1.435224] ACPI: ACPI bus type pnp unregistered
[    1.446238] pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    1.446356] pci 0000:00:15.1: bridge window [io  0x1000-0x0fff] to [bus 04] add_size 1000
[    1.446362] pci 0000:00:15.1: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 04] add_size 200000
[    1.446377] pci 0000:00:15.1: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    1.446382] pci 0000:00:15.1: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    1.446398] pci 0000:00:06.0: BAR 14: assigned [mem 0xf0300000-0xf03fffff]
[    1.446412] pci 0000:00:15.1: BAR 15: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    1.446420] pci 0000:00:15.1: BAR 13: assigned [io  0x1000-0x1fff]
[    1.446427] pci 0000:01:00.0: BAR 6: assigned [mem 0xf0020000-0xf003ffff pref]
[    1.446433] pci 0000:00:06.0: PCI bridge to [bus 01]
[    1.446439] pci 0000:00:06.0:   bridge window [io  0x2000-0x2fff]
[    1.446446] pci 0000:00:06.0:   bridge window [mem 0xf0300000-0xf03fffff]
[    1.446452] pci 0000:00:06.0:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
[    1.446459] pci 0000:00:14.4: PCI bridge to [bus 02]
[    1.446523] pci 0000:00:15.0: PCI bridge to [bus 03]
[    1.446540] pci 0000:00:15.1: PCI bridge to [bus 04]
[    1.446545] pci 0000:00:15.1:   bridge window [io  0x1000-0x1fff]
[    1.446553] pci 0000:00:15.1:   bridge window [mem 0xf0100000-0xf01fffff]
[    1.446560] pci 0000:00:15.1:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    1.446633] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
[    1.446638] pci_bus 0000:00: resource 5 [mem 0x000c0000-0x000c1fff]
[    1.446642] pci_bus 0000:00: resource 6 [mem 0x000c2000-0x000c3fff]
[    1.446645] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000c5fff]
[    1.446649] pci_bus 0000:00: resource 8 [mem 0x000c6000-0x000c7fff]
[    1.446653] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000c9fff]
[    1.446657] pci_bus 0000:00: resource 10 [mem 0x000ca000-0x000cbfff]
[    1.446660] pci_bus 0000:00: resource 11 [mem 0x000cc000-0x000cdfff]
[    1.446664] pci_bus 0000:00: resource 12 [mem 0x000d0000-0x000d1fff]
[    1.446668] pci_bus 0000:00: resource 13 [mem 0x000d2000-0x000d3fff]
[    1.446671] pci_bus 0000:00: resource 14 [mem 0x000d4000-0x000d5fff]
[    1.446675] pci_bus 0000:00: resource 15 [mem 0x000d6000-0x000d7fff]
[    1.446678] pci_bus 0000:00: resource 16 [mem 0x000d8000-0x000d9fff]
[    1.446682] pci_bus 0000:00: resource 17 [mem 0x000da000-0x000dbfff]
[    1.446686] pci_bus 0000:00: resource 18 [mem 0x000dc000-0x000ddfff]
[    1.446689] pci_bus 0000:00: resource 19 [mem 0x000de000-0x000dffff]
[    1.446693] pci_bus 0000:00: resource 20 [mem 0x000e0000-0x000e1fff]
[    1.446697] pci_bus 0000:00: resource 21 [mem 0x000e2000-0x000e3fff]
[    1.446700] pci_bus 0000:00: resource 22 [mem 0x000e4000-0x000e5fff]
[    1.446704] pci_bus 0000:00: resource 23 [mem 0x000e6000-0x000e7fff]
[    1.446707] pci_bus 0000:00: resource 24 [mem 0x000e8000-0x000e9fff]
[    1.446711] pci_bus 0000:00: resource 25 [mem 0x000ea000-0x000ebfff]
[    1.446715] pci_bus 0000:00: resource 26 [mem 0x000ec000-0x000edfff]
[    1.446719] pci_bus 0000:00: resource 27 [mem 0x000ee000-0x000effff]
[    1.446723] pci_bus 0000:00: resource 28 [mem 0xe0000000-0xf7ffffff]
[    1.446726] pci_bus 0000:00: resource 29 [mem 0xf8000000-0xffffffff]
[    1.446730] pci_bus 0000:00: resource 30 [io  0x0000-0x0cf7]
[    1.446734] pci_bus 0000:00: resource 31 [io  0x0d00-0xffff]
[    1.446738] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    1.446742] pci_bus 0000:01: resource 1 [mem 0xf0300000-0xf03fffff]
[    1.446746] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf00fffff 64bit pref]
[    1.446750] pci_bus 0000:02: resource 4 [mem 0x000a0000-0x000bffff]
[    1.446754] pci_bus 0000:02: resource 5 [mem 0x000c0000-0x000c1fff]
[    1.446758] pci_bus 0000:02: resource 6 [mem 0x000c2000-0x000c3fff]
[    1.446761] pci_bus 0000:02: resource 7 [mem 0x000c4000-0x000c5fff]
[    1.446765] pci_bus 0000:02: resource 8 [mem 0x000c6000-0x000c7fff]
[    1.446768] pci_bus 0000:02: resource 9 [mem 0x000c8000-0x000c9fff]
[    1.446772] pci_bus 0000:02: resource 10 [mem 0x000ca000-0x000cbfff]
[    1.446776] pci_bus 0000:02: resource 11 [mem 0x000cc000-0x000cdfff]
[    1.446780] pci_bus 0000:02: resource 12 [mem 0x000d0000-0x000d1fff]
[    1.446783] pci_bus 0000:02: resource 13 [mem 0x000d2000-0x000d3fff]
[    1.446787] pci_bus 0000:02: resource 14 [mem 0x000d4000-0x000d5fff]
[    1.446790] pci_bus 0000:02: resource 15 [mem 0x000d6000-0x000d7fff]
[    1.446794] pci_bus 0000:02: resource 16 [mem 0x000d8000-0x000d9fff]
[    1.446798] pci_bus 0000:02: resource 17 [mem 0x000da000-0x000dbfff]
[    1.446801] pci_bus 0000:02: resource 18 [mem 0x000dc000-0x000ddfff]
[    1.446805] pci_bus 0000:02: resource 19 [mem 0x000de000-0x000dffff]
[    1.446809] pci_bus 0000:02: resource 20 [mem 0x000e0000-0x000e1fff]
[    1.446812] pci_bus 0000:02: resource 21 [mem 0x000e2000-0x000e3fff]
[    1.446816] pci_bus 0000:02: resource 22 [mem 0x000e4000-0x000e5fff]
[    1.446819] pci_bus 0000:02: resource 23 [mem 0x000e6000-0x000e7fff]
[    1.446823] pci_bus 0000:02: resource 24 [mem 0x000e8000-0x000e9fff]
[    1.446827] pci_bus 0000:02: resource 25 [mem 0x000ea000-0x000ebfff]
[    1.446830] pci_bus 0000:02: resource 26 [mem 0x000ec000-0x000edfff]
[    1.446834] pci_bus 0000:02: resource 27 [mem 0x000ee000-0x000effff]
[    1.446838] pci_bus 0000:02: resource 28 [mem 0xe0000000-0xf7ffffff]
[    1.446841] pci_bus 0000:02: resource 29 [mem 0xf8000000-0xffffffff]
[    1.446845] pci_bus 0000:02: resource 30 [io  0x0000-0x0cf7]
[    1.446849] pci_bus 0000:02: resource 31 [io  0x0d00-0xffff]
[    1.446853] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    1.446857] pci_bus 0000:04: resource 1 [mem 0xf0100000-0xf01fffff]
[    1.446861] pci_bus 0000:04: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    1.446924] NET: Registered protocol family 2
[    1.448144] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.453835] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.454537] TCP: Hash tables configured (established 524288 bind 65536)
[    1.454637] TCP: reno registered
[    1.454671] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.454789] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.455036] NET: Registered protocol family 1
[    1.455108] pci 0000:00:01.0: Boot video device
[    1.588841] PCI: CLS 32 bytes, default 64
[    1.588962] Unpacking initramfs...
[    1.695879] Freeing initrd memory: 2948k freed
[    1.697873] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.697881] software IO TLB [mem 0xc2e7a000-0xc6e79fff] (64MB) mapped at [ffff8800c2e7a000-ffff8800c6e79fff]
[    1.698355] LVT offset 0 assigned for vector 0x400
[    1.698489] perf: AMD IBS detected (0x000000ff)
[    1.698969] audit: initializing netlink socket (disabled)
[    1.698997] type=2000 audit(1354111515.479:1): initialized
[    1.718405] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.722900] VFS: Disk quotas dquot_6.5.2
[    1.722998] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.723510] msgmni has been set to 11140
[    1.724108] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.724222] io scheduler noop registered (default)
[    1.724231] io scheduler deadline registered
[    1.724371] io scheduler cfq registered
[    1.724621] pcieport 0000:00:06.0: irq 40 for MSI/MSI-X
[    1.724839] pcieport 0000:00:15.0: irq 41 for MSI/MSI-X
[    1.725041] pcieport 0000:00:15.1: irq 42 for MSI/MSI-X
[    1.725256] pcieport 0000:00:06.0: Signaling PME through PCIe PME interrupt
[    1.725261] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.725267] pcie_pme 0000:00:06.0:pcie01: service driver pcie_pme loaded
[    1.725350] pcieport 0000:00:15.0: Signaling PME through PCIe PME interrupt
[    1.725358] pcie_pme 0000:00:15.0:pcie01: service driver pcie_pme loaded
[    1.725388] pcieport 0000:00:15.1: Signaling PME through PCIe PME interrupt
[    1.725393] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    1.725399] pcie_pme 0000:00:15.1:pcie01: service driver pcie_pme loaded
[    1.725523] vesafb: mode is 1024x768x32, linelength=4096, pages=0
[    1.725525] vesafb: scrolling: redraw
[    1.725530] vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
[    1.725876] vesafb: framebuffer at 0xe0000000, mapped to 0xffffc90003600000, using 3072k, total 3072k
[    1.785335] Console: switching to colour frame buffer device 128x48
[    1.844482] fb0: VESA VGA frame buffer device
[    1.844543] GHES: HEST is not enabled!
[    1.844922] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.847057] Linux agpgart interface v0.103
[    1.847222] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    1.850877] i8042: Detected active multiplexing controller, rev 1.1
[    1.852470] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.852540] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.852583] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.852628] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.852673] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.853336] mousedev: PS/2 mouse device common for all mice
[    1.853591] rtc_cmos 00:04: RTC can wake from S4
[    1.854001] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.854094] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    1.854120] cpuidle: using governor ladder
[    1.854124] cpuidle: using governor menu
[    1.854412] drop_monitor: Initializing network drop monitor service
[    1.854545] TCP: cubic registered
[    1.854736] NET: Registered protocol family 10
[    1.855087] NET: Registered protocol family 17
[    1.855107] Key type dns_resolver registered
[    1.855699] PM: Hibernation image not present or could not be loaded.
[    1.855729] registered taskstats version 1
[    1.856891] rtc_cmos 00:04: setting system clock to 2012-11-28 14:05:17 UTC (1354111517)
[    1.859271] Freeing unused kernel memory: 772k freed
[    1.859718] Write protecting the kernel read-only data: 8192k
[    1.868185] Freeing unused kernel memory: 1408k freed
[    1.872657] Freeing unused kernel memory: 568k freed
[    1.890854] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.894024] systemd-udevd[42]: starting version 195
[    1.967669] SCSI subsystem initialized
[    1.970725] ACPI: bus type scsi registered
[    1.970918] libata version 3.00 loaded.
[    1.974988] ACPI: bus type usb registered
[    1.975053] usbcore: registered new interface driver usbfs
[    1.975074] usbcore: registered new interface driver hub
[    1.977500] usbcore: registered new device driver usb
[    1.978512] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.979010] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.979026] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.979048] QUIRK: Enable AMD PLL fix
[    1.979053] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.979155] ehci_hcd 0000:00:12.2: debug port 1
[    1.979199] ehci_hcd 0000:00:12.2: irq 17, io mem 0xf024a500
[    1.988163] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.988543] hub 1-0:1.0: USB hub found
[    1.988553] hub 1-0:1.0: 5 ports detected
[    1.989740] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.989759] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    1.989770] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.989866] ehci_hcd 0000:00:13.2: debug port 1
[    1.989888] ehci_hcd 0000:00:13.2: irq 17, io mem 0xf024a400
[    1.998119] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.998499] hub 2-0:1.0: USB hub found
[    1.998509] hub 2-0:1.0: 5 ports detected
[    1.998813] ahci 0000:00:11.0: version 3.0
[    1.999088] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 1 ports 3 Gbps 0x1 impl SATA mode
[    1.999095] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio ccc 
[    1.999372] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.000104] scsi0 : ahci
[    2.001023] ata1: SATA max UDMA/133 abar m1024@0xf024a000 port 0xf024a100 irq 19
[    2.001557] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.001572] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    2.001636] ohci_hcd 0000:00:12.0: irq 18, io mem 0xf0249000
[    2.059687] hub 3-0:1.0: USB hub found
[    2.059705] hub 3-0:1.0: 5 ports detected
[    2.059987] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.060000] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 4
[    2.060038] ohci_hcd 0000:00:13.0: irq 18, io mem 0xf0248000
[    2.116206] hub 4-0:1.0: USB hub found
[    2.116223] hub 4-0:1.0: 5 ports detected
[    2.401503] usb 1-5: new high-speed USB device number 3 using ehci_hcd
[    2.488119] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.500554] ata1.00: ATA-8: OCZ-AGILITY3, 2.22, max UDMA/133
[    2.500568] ata1.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.510166] ata1.00: configured for UDMA/133
[    2.510665] scsi 0:0:0:0: Direct-Access     ATA      OCZ-AGILITY3     2.22 PQ: 0 ANSI: 5
[    2.515626] sd 0:0:0:0: [sda] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[    2.515769] sd 0:0:0:0: [sda] Write Protect is off
[    2.515775] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.515820] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.516538]  sda: sda1 sda2
[    2.517136] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.644701] usb 2-2: new high-speed USB device number 2 using ehci_hcd
[    2.697872] tsc: Refined TSC clocksource calibration: 1596.599 MHz
[    2.697887] Switching to clocksource tsc
[    2.891047] usb 2-5: new high-speed USB device number 3 using ehci_hcd
[    3.267630] usb 3-4: new full-speed USB device number 2 using ohci_hcd
[   12.572200] EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem
[   12.574714] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[   12.673811] systemd[1]: systemd 196 running in system mode. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ; arch)
[   12.674848] systemd[1]: Set hostname to <initbox>.
[   12.812193] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[   12.812320] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   12.812350] systemd[1]: Starting Arch Daemons.
[   12.812376] systemd[1]: Reached target Arch Daemons.
[   12.812396] systemd[1]: Starting Remote File Systems.
[   12.812417] systemd[1]: Reached target Remote File Systems.
[   12.812438] systemd[1]: Starting Syslog Socket.
[   12.812520] systemd[1]: Listening on Syslog Socket.
[   12.812542] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[   12.812589] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[   12.812608] systemd[1]: Starting Delayed Shutdown Socket.
[   12.812659] systemd[1]: Listening on Delayed Shutdown Socket.
[   12.812682] systemd[1]: Starting Encrypted Volumes.
[   12.812703] systemd[1]: Reached target Encrypted Volumes.
[   12.812767] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[   12.812982] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[   12.813138] systemd[1]: Starting udev Kernel Socket.
[   12.813191] systemd[1]: Listening on udev Kernel Socket.
[   12.813286] systemd[1]: Starting udev Control Socket.
[   12.813346] systemd[1]: Listening on udev Control Socket.
[   12.813376] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[   12.813459] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[   12.813479] systemd[1]: Starting Swap.
[   12.813500] systemd[1]: Reached target Swap.
[   12.813523] systemd[1]: Expecting device dev-sda2.device...
[   12.813553] systemd[1]: Starting Journal Socket.
[   12.813641] systemd[1]: Listening on Journal Socket.
[   12.813679] systemd[1]: Started File System Check on Root Device.
[   12.813702] systemd[1]: Starting Remount Root and Kernel File Systems...
[   12.839439] systemd[1]: Starting udev Coldplug all Devices...
[   12.843084] systemd[1]: Mounting Huge Pages File System...
[   12.853471] systemd[1]: Started Set Up Additional Binary Formats.
[   12.853542] systemd[1]: Mounting POSIX Message Queue File System...
[   12.859549] EXT4-fs (sda1): re-mounted. Opts: discard
[   12.865725] systemd[1]: Starting Setup Virtual Console...
[   12.879645] systemd[1]: Mounting Debug File System...
[   12.890134] systemd[1]: Starting Apply Kernel Variables...
[   12.899491] systemd[1]: Starting udev Kernel Device Manager...
[   12.914466] systemd[1]: Starting Load Kernel Modules...
[   12.932609] systemd-udevd[106]: starting version 196
[   12.934544] systemd[1]: Starting Journal Service...
[   12.952366] systemd[1]: Started Journal Service.
[   12.952509] systemd[1]: Starting Syslog.
[   12.952532] systemd[1]: Reached target Syslog.
[   12.953312] systemd[1]: Started udev Kernel Device Manager.
[   12.965848] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[   12.965857] ACPI: Power Button [PWRB]
[   12.966032] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[   12.966036] ACPI: Sleep Button [SLPB]
[   12.966169] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input3
[   12.966568] ACPI: Lid Switch [LID]
[   12.966674] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[   12.966679] ACPI: Power Button [PWRF]
[   12.968788] systemd[1]: Started Remount Root and Kernel File Systems.
[   12.970026] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
[   12.970028] AMD IOMMUv2 functionality not available on this system
[   12.992444] systemd[1]: Mounted Huge Pages File System.
[   12.992653] systemd[1]: Mounted POSIX Message Queue File System.
[   13.012124] systemd[1]: Started Setup Virtual Console.
[   13.012472] systemd[1]: Mounted Debug File System.
[   13.035456] systemd[1]: Started Apply Kernel Variables.
[   13.035582] systemd[1]: Starting Local File Systems (Pre).
[   13.035610] systemd[1]: Reached target Local File Systems (Pre).
[   13.035643] systemd[1]: Mounting /var/log...
[   13.036206] systemd[1]: var-log.mount: Directory /var/log to mount over is not empty, mounting anyway. (To see the over-mounted files, please manually mount the underlying file system to a secondary location.)
[   13.072121] systemd[1]: Mounting /tmp...
[   13.087949] fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
[   13.087960] Disabling lock debugging due to kernel taint
[   13.108724] systemd[1]: Starting Load Random Seed...
[   13.117807] <6>[fglrx] Maximum main memory to use for locked dma buffers: 5383 MBytes.
[   13.118086] <6>[fglrx]   vendor: 1002 device: 9802 count: 1
[   13.118809] <6>[fglrx] ioport: bar 1, base 0x3000, size: 0x100
[   13.119340] <6>[fglrx] Kernel PAT support is enabled
[   13.119376] <6>[fglrx] module loaded - fglrx 9.1.11 [Oct 18 2012] with 1 minors
[   13.125909] systemd[1]: Mounted /tmp.
[   13.125995] systemd[1]: Mounted /var/log.
[   13.141660] FS-Cache: Loaded
[   13.165374] RPC: Registered named UNIX socket transport module.
[   13.165383] RPC: Registered udp transport module.
[   13.165385] RPC: Registered tcp transport module.
[   13.165388] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   13.176701] FS-Cache: Netfs 'nfs' registered for caching
[   13.206968] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   13.207272] r8169 0000:01:00.0: irq 43 for MSI/MSI-X
[   13.207580] r8169 0000:01:00.0: eth0: RTL8168d/8111d at 0xffffc900041fe000, e8:9a:8f:81:e8:d8, XID 083000c0 IRQ 43
[   13.207586] r8169 0000:01:00.0: eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[   13.210618] ACPI: acpi_idle registered with cpuidle
[   13.233165] ACPI Warning: 0x0000000000000b00-0x0000000000000b07 SystemIO conflicts with Region \_SB_.PCI0.SMB_.SMB0 1 (20120711/utaddress-251)
[   13.233183] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   13.236347] ACPI: AC Adapter [ACAD] (off-line)
[   13.252827] snd_hda_intel 0000:00:01.1: irq 44 for MSI/MSI-X
[   13.258692] wmi: Mapper loaded
[   13.272799] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[   13.301876] acpi device:34: registered as cooling_device2
[   13.302032] ACPI: Video Device [VGA1] (multi-head: yes  rom: no  post: no)
[   13.303672] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input5
[   13.307391] ACPI: Battery Slot [BAT1] (battery present)
[   13.307892] thermal LNXTHERM:00: registered as thermal_zone0
[   13.307897] ACPI: Thermal Zone [THZ0] (64 C)
[   13.334240] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/sound/card1/input6
[   13.347618] usbcore: registered new interface driver uas
[   13.359520] cfg80211: Calling CRDA to update world regulatory domain
[   13.366359] hda_codec: CX20582 (Pebble): BIOS auto-probing.
[   13.367337] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/input/input7
[   13.410060] Initializing USB Mass Storage driver...
[   13.410271] usbcore: registered new interface driver usb-storage
[   13.410274] USB Mass Storage support registered.
[   13.423077] cdc_acm 1-5:1.1: ttyACM0: USB ACM device
[   13.423173] Bluetooth: Core ver 2.16
[   13.423227] NET: Registered protocol family 31
[   13.423230] Bluetooth: HCI device and connection manager initialized
[   13.423235] Bluetooth: HCI socket layer initialized
[   13.423238] Bluetooth: L2CAP socket layer initialized
[   13.423247] Bluetooth: SCO socket layer initialized
[   13.424859] cdc_acm 1-5:1.3: ttyACM1: USB ACM device
[   13.426413] cdc_acm 1-5:1.9: ttyACM2: USB ACM device
[   13.427746] usbcore: registered new interface driver cdc_acm
[   13.427754] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[   13.430074] cdc_wdm 1-5:1.5: cdc-wdm0: USB WDM device
[   13.430726] cdc_wdm 1-5:1.6: cdc-wdm1: USB WDM device
[   13.430785] usbcore: registered new interface driver cdc_wdm
[   13.436588] input: HDA ATI SB Mic as /devices/pci0000:00/0000:00:14.2/sound/card0/input8
[   13.440770] input: HDA ATI SB Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input9
[   13.444086] usbcore: registered new interface driver btusb
[   13.446065] usb 2-2: USB disconnect, device number 2
[   13.453231] scsi1 : usb-storage 2-2:1.0
[   13.453814] Non-volatile memory driver v1.3
[   13.453831] Linux media interface: v0.10
[   13.454044] usbcore: registered new interface driver ums-realtek
[   13.463533] thinkpad_acpi: ThinkPad ACPI Extras v0.24
[   13.463540] thinkpad_acpi: http://ibm-acpi.sf.net/
[   13.463543] thinkpad_acpi: ThinkPad BIOS 8FET32WW (1.16 ), EC unknown
[   13.463546] thinkpad_acpi: Lenovo ThinkPad X120e, model 0596RZ4
[   13.465842] thinkpad_acpi: detected a 8-level brightness capable ThinkPad
[   13.466746] thinkpad_acpi: radio switch found; radios are enabled
[   13.466775] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
[   13.466807] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[   13.466810] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[   13.469792] cdc_ether 1-5:1.7: wwan0: register 'cdc_ether' at usb-0000:00:12.2-5, Mobile Broadband Network Device, 02:80:37:ec:02:00
[   13.470970] usbcore: registered new interface driver cdc_ether
[   13.481562] Linux video capture interface: v2.00
[   13.503101] microcode: CPU0: patch_level=0x05000028
[   13.516317] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is unblocked
[   13.519383] uvcvideo: Found UVC 1.00 device Integrated Camera (064e:e201)
[   13.523763] input: Integrated Camera as /devices/pci0000:00/0000:00:13.2/usb2/2-5/2-5:1.0/input/input10
[   13.523916] usbcore: registered new interface driver uvcvideo
[   13.523920] USB Video Class driver (1.1.1)
[   13.577083] thinkpad_acpi: rfkill switch tpacpi_wwan_sw: radio is unblocked
[   13.577196] Registered led device: tpacpi::power
[   13.577230] Registered led device: tpacpi::standby
[   13.577267] Registered led device: tpacpi::thinkvantage
[   13.579333] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
[   13.579513] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[   13.585597] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input11
[   13.612252] ath: EEPROM regdomain: 0x67
[   13.612260] ath: EEPROM indicates we should expect a direct regpair map
[   13.612266] ath: Country alpha2 being used: 00
[   13.612268] ath: Regpair used: 0x67
[   13.636229] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
[   13.636671] Registered led device: ath9k-phy0
[   13.636706] ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xffffc900035e0000, irq=17
[   13.719951] microcode: CPU1: patch_level=0x05000028
[   13.771761] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   13.809227] kvm: disabled by bios
[   13.819356] powernow-k8: Found 1 AMD E-350 Processor (2 cpu cores) (version 2.20.00)
[   13.819434] powernow-k8:    0 : pstate 0 (1600 MHz)
[   13.819437] powernow-k8:    1 : pstate 1 (1280 MHz)
[   13.819440] powernow-k8:    2 : pstate 2 (800 MHz)
[   14.369291] psmouse serio4: synaptics: Touchpad model: 1, fw: 7.5, id: 0x1e0b1, caps: 0xd000b3/0x340000/0xa0400, board id: 1403, fw id: 749625
[   14.369317] psmouse serio4: synaptics: serio: Synaptics pass-through port at isa0060/serio4/input0
[   14.406737] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input12
[   19.810413] psmouse serio5: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   20.018735] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio4/serio5/input/input13
[   26.149334] EXT4-fs (sda2): mounting ext2 file system using the ext4 subsystem
[   26.152315] EXT4-fs (sda2): mounted filesystem without journal. Opts: discard
[   26.189179] systemd-journald[110]: Received SIGUSR1
[   27.146667] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   27.802035] fglrx_pci 0000:00:01.0: irq 45 for MSI/MSI-X
[   27.803604] <6>[fglrx] Firegl kernel thread PID: 280
[   27.803961] <6>[fglrx] Firegl kernel thread PID: 281
[   27.804234] <6>[fglrx] Firegl kernel thread PID: 282
[   27.804518] <6>[fglrx] IRQ 45 Enabled
[   27.820415] <6>[fglrx] Gart USWC size:1280 M.
[   27.820420] <6>[fglrx] Gart cacheable size:508 M.
[   27.820428] <6>[fglrx] Reserved FB block: Shared offset:0, size:1000000 
[   27.820431] <6>[fglrx] Reserved FB block: Unshared offset:fbfc000, size:404000 
[   27.820435] <6>[fglrx] Reserved FB block: Unshared offset:17ff4000, size:c000 
[   27.878301] <6>[fglrx] ATIF platform detected with notification ID: 0x81
[   32.342996] r8169 0000:01:00.0: eth0: link down
[   32.343112] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   35.488584] fuse init (API version 7.20)
[   35.818920] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   35.957506] r8169 0000:01:00.0: eth0: link down
[   35.957591] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   36.099190] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   39.425843] wlan0: authenticate with 00:14:85:80:88:6b
[   39.454486] wlan0: send auth to 00:14:85:80:88:6b (try 1/3)
[   39.458365] wlan0: authenticated
[   39.474538] wlan0: associate with 00:14:85:80:88:6b (try 1/3)
[   39.479637] wlan0: RX AssocResp from 00:14:85:80:88:6b (capab=0x411 status=0 aid=3)
[   39.479786] wlan0: associated
[   39.479867] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready


--- On Wed, 11/28/12, Borislav Petkov <bp@alien8.de> wrote:

> From: Borislav Petkov <bp@alien8.de>
> Subject: Re: [FIRMWARE BUG] Lenovo x120e
> To: "Denis Lotarev" <dlotarev@yahoo.com>
> Cc: linux-kernel@vger.kernel.org, "Zhang Rui" <rui.zhang@intel.com>, "Len Brown" <len.brown@intel.com>
> Date: Wednesday, November 28, 2012, 6:12 PM
> On Wed, Nov 28, 2012 at 05:27:45AM
> -0800, Denis Lotarev wrote:
> > Im using kernel (Linux initbox 3.6.7-1-ARCH #1 SMP
> PREEMPT Sun Nov 18 10:11:22 CET 2012 x86_64 GNU/Linux) and i
> see some problems at booting... So dmesg output with BUG
> lines:
> > 
> > $ dmesg |grep Bug
> > [    1.363154] [Firmware Bug]: ACPI: BIOS
> _OSI(Linux) query ignored
> > [    1.373784] [Firmware Bug]: ACPI: No _BQC
> method, cannot determine initial brightness
> > [    1.380827] [Firmware Bug]: ACPI: No _BQC
> method, cannot determine initial brightness
> > [    1.433354] pnp 00:09: [Firmware Bug]:
> [mem 0x00000000-0xffffffffffffffff disabled] covers only
> part of AMD MMCONFIG area [mem 0xf8000000-0xf9ffffff];
> adding more reservations
> > [    3.349658] [Firmware Bug]: ACPI: No _BQC
> method, cannot determine initial brightness
> 
> Nothing to worry about, just ACPI in BIOS is not
> implementing _BQC
> method with which you can query the initial brightness level
> of the
> display device. Frankly, I'm not getting any smarter from
> the commit
> message as to what it even got added for:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=98758faffc86ee6fe9504eeab75481ee7c1aa860
> 
> "kinda firmware bug"?? :-)
> 
> Maybe Zhang/Len can shed more light on the matter.
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
