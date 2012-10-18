Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2JRHlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 03:41:35 -0400
Received: from mail.agmk.net ([91.192.224.71]:50631 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab2JRHlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 03:41:32 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2012 03:41:31 EDT
From: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, marcheu@chromium.org
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Date: Thu, 18 Oct 2012 09:32:41 +0200
Message-ID: <1724445.dN2yMEzN6d@localhost>
User-Agent: KMail/4.9.1 (Linux/3.6.2; KDE/4.9.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3600253.nEyvJli8FP"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart3600253.nEyvJli8FP
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi,

the new 3.7.0-rc1-00078-g8d2b6b3 kernel oopses during startup on my asu=
s laptop
with nvidia optimius crap and the builtin core-i7 graphics doesn't star=
t.
the 3.5/3.6 kernels work fine, so this looks like a fresh regression.

BR,
Pawe=C5=82.

--nextPart3600253.nEyvJli8FP
Content-Disposition: inline; filename="dmesg.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="dmesg.log"

Oct 18 07:52:20 localhost kernel: [    0.408507] Brought up 8 CPUs
Oct 18 07:52:20 localhost kernel: [    0.408616] smpboot: Total of 8 processors activated (31940.98 BogoMIPS)
Oct 18 07:52:20 localhost kernel: [    0.416717] devtmpfs: initialized
Oct 18 07:52:20 localhost kernel: [    0.420360] PM: Registering ACPI NVS region [mem 0xaaf09000-0xaafe7fff] (913408 bytes)
Oct 18 07:52:20 localhost kernel: [    0.421640] regulator-dummy: no parameters
Oct 18 07:52:20 localhost kernel: [    0.422014] NET: Registered protocol family 16
Oct 18 07:52:20 localhost kernel: [    0.422941] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
Oct 18 07:52:20 localhost kernel: [    0.423030] ACPI: bus type pci registered
Oct 18 07:52:20 localhost kernel: [    0.423385] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
Oct 18 07:52:20 localhost kernel: [    0.423468] PCI: MMCONFIG at [mem 0xe0000000-0xe3ffffff] reserved in E820
Oct 18 07:52:20 localhost kernel: [    0.438825] PCI: Using configuration type 1 for base access
Oct 18 07:52:20 localhost kernel: [    0.444903] bio: create slab <bio-0> at 0
Oct 18 07:52:20 localhost kernel: [    0.445253] ACPI: Added _OSI(Module Device)
Oct 18 07:52:20 localhost kernel: [    0.445312] ACPI: Added _OSI(Processor Device)
Oct 18 07:52:20 localhost kernel: [    0.445371] ACPI: Added _OSI(3.0 _SCP Extensions)
Oct 18 07:52:20 localhost kernel: [    0.445431] ACPI: Added _OSI(Processor Aggregator Device)
Oct 18 07:52:20 localhost kernel: [    0.453076] ACPI: EC: EC description table is found, configuring boot EC
Oct 18 07:52:20 localhost kernel: [    0.453144] ACPI: EC: Look up EC in DSDT
Oct 18 07:52:20 localhost kernel: [    0.461298] ACPI: Executed 1 blocks of module-level executable AML code
Oct 18 07:52:20 localhost kernel: [    0.469487] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
Oct 18 07:52:20 localhost kernel: [    0.538242] ACPI: SSDT 00000000aadcc718 00694 (v01  PmRef  Cpu0Cst 00003001 INTL 20091112)
Oct 18 07:52:20 localhost kernel: [    0.540314] ACPI: Dynamic OEM Table Load:
Oct 18 07:52:20 localhost kernel: [    0.540447] ACPI: SSDT           (null) 00694 (v01  PmRef  Cpu0Cst 00003001 INTL 20091112)
Oct 18 07:52:20 localhost kernel: [    0.554744] ACPI: SSDT 00000000aadcda98 00303 (v01  PmRef    ApIst 00003000 INTL 20091112)
Oct 18 07:52:20 localhost kernel: [    0.556875] ACPI: Dynamic OEM Table Load:
Oct 18 07:52:20 localhost kernel: [    0.557008] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20091112)
Oct 18 07:52:20 localhost kernel: [    0.571191] ACPI: SSDT 00000000aadcbd98 00119 (v01  PmRef    ApCst 00003000 INTL 20091112)
Oct 18 07:52:20 localhost kernel: [    0.573266] ACPI: Dynamic OEM Table Load:
Oct 18 07:52:20 localhost kernel: [    0.573399] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20091112)
Oct 18 07:52:20 localhost kernel: [    0.575625] ACPI: Interpreter enabled
Oct 18 07:52:20 localhost kernel: [    0.575687] ACPI: (supports S0 S1 S3 S4 S5)
Oct 18 07:52:20 localhost kernel: [    0.575981] ACPI: Using IOAPIC for interrupt routing
Oct 18 07:52:20 localhost kernel: [    0.698001] ACPI: EC: GPE = 0x1b, I/O: command/status = 0x66, data = 0x62
Oct 18 07:52:20 localhost kernel: [    0.698678] ACPI: No dock devices found.
Oct 18 07:52:20 localhost kernel: [    0.698738] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Oct 18 07:52:20 localhost kernel: [    0.699235] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
Oct 18 07:52:20 localhost kernel: [    0.700243] PCI host bridge to bus 0000:00
Oct 18 07:52:20 localhost kernel: [    0.700305] pci_bus 0000:00: root bus resource [bus 00-3e]
Oct 18 07:52:20 localhost kernel: [    0.700366] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
Oct 18 07:52:20 localhost kernel: [    0.700429] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
Oct 18 07:52:20 localhost kernel: [    0.700491] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
Oct 18 07:52:20 localhost kernel: [    0.700555] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
Oct 18 07:52:20 localhost kernel: [    0.700618] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
Oct 18 07:52:20 localhost kernel: [    0.700681] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
Oct 18 07:52:20 localhost kernel: [    0.700744] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
Oct 18 07:52:20 localhost kernel: [    0.700806] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
Oct 18 07:52:20 localhost kernel: [    0.700870] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
Oct 18 07:52:20 localhost kernel: [    0.700940] pci_bus 0000:00: root bus resource [mem 0xafa00000-0xfeafffff]
Oct 18 07:52:20 localhost kernel: [    0.701004] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
Oct 18 07:52:20 localhost kernel: [    0.701108] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
Oct 18 07:52:20 localhost kernel: [    0.701202] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
Oct 18 07:52:20 localhost kernel: [    0.701266] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
Oct 18 07:52:20 localhost kernel: [    0.701328] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
Oct 18 07:52:20 localhost kernel: [    0.701348] pci 0000:00:02.0: reg 10: [mem 0xdc400000-0xdc7fffff 64bit]
Oct 18 07:52:20 localhost kernel: [    0.701359] pci 0000:00:02.0: reg 18: [mem 0xb0000000-0xbfffffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    0.701366] pci 0000:00:02.0: reg 20: [io  0xe000-0xe03f]
Oct 18 07:52:20 localhost kernel: [    0.701477] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
Oct 18 07:52:20 localhost kernel: [    0.701519] pci 0000:00:16.0: reg 10: [mem 0xdf00a000-0xdf00a00f 64bit]
Oct 18 07:52:20 localhost kernel: [    0.701659] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
Oct 18 07:52:20 localhost kernel: [    0.701722] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
Oct 18 07:52:20 localhost kernel: [    0.701759] pci 0000:00:1a.0: reg 10: [mem 0xdf008000-0xdf0083ff]
Oct 18 07:52:20 localhost kernel: [    0.701926] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
Oct 18 07:52:20 localhost kernel: [    0.701974] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
Oct 18 07:52:20 localhost kernel: [    0.702002] pci 0000:00:1b.0: reg 10: [mem 0xdf000000-0xdf003fff 64bit]
Oct 18 07:52:20 localhost kernel: [    0.702139] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Oct 18 07:52:20 localhost kernel: [    0.702181] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
Oct 18 07:52:20 localhost kernel: [    0.702331] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Oct 18 07:52:20 localhost kernel: [    0.702376] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
Oct 18 07:52:20 localhost kernel: [    0.702525] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
Oct 18 07:52:20 localhost kernel: [    0.702571] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
Oct 18 07:52:20 localhost kernel: [    0.702718] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
Oct 18 07:52:20 localhost kernel: [    0.702765] pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
Oct 18 07:52:20 localhost kernel: [    0.702915] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
Oct 18 07:52:20 localhost kernel: [    0.702971] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
Oct 18 07:52:20 localhost kernel: [    0.703008] pci 0000:00:1d.0: reg 10: [mem 0xdf007000-0xdf0073ff]
Oct 18 07:52:20 localhost kernel: [    0.703176] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
Oct 18 07:52:20 localhost kernel: [    0.703220] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
Oct 18 07:52:20 localhost kernel: [    0.703434] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
Oct 18 07:52:20 localhost kernel: [    0.703471] pci 0000:00:1f.2: reg 10: [io  0xe0b0-0xe0b7]
Oct 18 07:52:20 localhost kernel: [    0.703485] pci 0000:00:1f.2: reg 14: [io  0xe0a0-0xe0a3]
Oct 18 07:52:20 localhost kernel: [    0.703500] pci 0000:00:1f.2: reg 18: [io  0xe090-0xe097]
Oct 18 07:52:20 localhost kernel: [    0.703515] pci 0000:00:1f.2: reg 1c: [io  0xe080-0xe083]
Oct 18 07:52:20 localhost kernel: [    0.703530] pci 0000:00:1f.2: reg 20: [io  0xe060-0xe07f]
Oct 18 07:52:20 localhost kernel: [    0.703545] pci 0000:00:1f.2: reg 24: [mem 0xdf006000-0xdf0067ff]
Oct 18 07:52:20 localhost kernel: [    0.703641] pci 0000:00:1f.2: PME# supported from D3hot
Oct 18 07:52:20 localhost kernel: [    0.703674] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
Oct 18 07:52:20 localhost kernel: [    0.703701] pci 0000:00:1f.3: reg 10: [mem 0xdf005000-0xdf0050ff 64bit]
Oct 18 07:52:20 localhost kernel: [    0.703742] pci 0000:00:1f.3: reg 20: [io  0xe040-0xe05f]
Oct 18 07:52:20 localhost kernel: [    0.703848] pci 0000:01:00.0: [10de:0df4] type 00 class 0x030000
Oct 18 07:52:20 localhost kernel: [    0.703861] pci 0000:01:00.0: reg 10: [mem 0xdb000000-0xdbffffff]
Oct 18 07:52:20 localhost kernel: [    0.703875] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xcfffffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    0.703889] pci 0000:01:00.0: reg 1c: [mem 0xd0000000-0xd1ffffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    0.703898] pci 0000:01:00.0: reg 24: [io  0xd000-0xd07f]
Oct 18 07:52:20 localhost kernel: [    0.703907] pci 0000:01:00.0: reg 30: [mem 0xdc000000-0xdc07ffff pref]
Oct 18 07:52:20 localhost kernel: [    0.710950] pci 0000:00:01.0: PCI bridge to [bus 01]
Oct 18 07:52:20 localhost kernel: [    0.711048] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
Oct 18 07:52:20 localhost kernel: [    0.711052] pci 0000:00:01.0:   bridge window [mem 0xdb000000-0xdc0fffff]
Oct 18 07:52:20 localhost kernel: [    0.711058] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    0.711140] pci 0000:00:1c.0: PCI bridge to [bus 02]
Oct 18 07:52:20 localhost kernel: [    0.711204] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
Oct 18 07:52:20 localhost kernel: [    0.711210] pci 0000:00:1c.0:   bridge window [mem 0xde600000-0xdeffffff]
Oct 18 07:52:20 localhost kernel: [    0.711220] pci 0000:00:1c.0:   bridge window [mem 0xd4200000-0xd4bfffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    0.711334] pci 0000:03:00.0: [168c:002b] type 00 class 0x028000
Oct 18 07:52:20 localhost kernel: [    0.711374] pci 0000:03:00.0: reg 10: [mem 0xddc00000-0xddc0ffff 64bit]
Oct 18 07:52:20 localhost kernel: [    0.711574] pci 0000:03:00.0: supports D1
Oct 18 07:52:20 localhost kernel: [    0.711576] pci 0000:03:00.0: PME# supported from D0 D1 D3hot D3cold
Oct 18 07:52:20 localhost kernel: [    0.717601] pci 0000:00:1c.1: PCI bridge to [bus 03]
Oct 18 07:52:20 localhost kernel: [    0.717704] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
Oct 18 07:52:20 localhost kernel: [    0.717711] pci 0000:00:1c.1:   bridge window [mem 0xddc00000-0xde5fffff]
Oct 18 07:52:20 localhost kernel: [    0.717721] pci 0000:00:1c.1:   bridge window [mem 0xd3700000-0xd40fffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    0.717836] pci 0000:04:00.0: [1b73:1000] type 00 class 0x0c0330
Oct 18 07:52:20 localhost kernel: [    0.717866] pci 0000:04:00.0: reg 10: [mem 0xdd200000-0xdd20ffff]
Oct 18 07:52:20 localhost kernel: [    0.718089] pci 0000:04:00.0: PME# supported from D0 D3hot
Oct 18 07:52:20 localhost kernel: [    0.724265] pci 0000:00:1c.3: PCI bridge to [bus 04]
Oct 18 07:52:20 localhost kernel: [    0.724367] pci 0000:00:1c.3:   bridge window [io  0xa000-0xafff]
Oct 18 07:52:20 localhost kernel: [    0.724375] pci 0000:00:1c.3:   bridge window [mem 0xdd200000-0xddbfffff]
Oct 18 07:52:20 localhost kernel: [    0.724386] pci 0000:00:1c.3:   bridge window [mem 0xd2c00000-0xd35fffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    0.724501] pci 0000:05:00.0: [1969:1083] type 00 class 0x020000
Oct 18 07:52:20 localhost kernel: [    0.724542] pci 0000:05:00.0: reg 10: [mem 0xdc800000-0xdc83ffff 64bit]
Oct 18 07:52:20 localhost kernel: [    0.724564] pci 0000:05:00.0: reg 18: [io  0x9000-0x907f]
Oct 18 07:52:20 localhost kernel: [    0.724757] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Oct 18 07:52:20 localhost kernel: [    0.730931] pci 0000:00:1c.5: PCI bridge to [bus 05]
Oct 18 07:52:20 localhost kernel: [    0.731032] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
Oct 18 07:52:20 localhost kernel: [    0.731039] pci 0000:00:1c.5:   bridge window [mem 0xdc800000-0xdd1fffff]
Oct 18 07:52:20 localhost kernel: [    0.731049] pci 0000:00:1c.5:   bridge window [mem 0xd2100000-0xd2afffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    0.731091] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Oct 18 07:52:20 localhost kernel: [    0.731473] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
Oct 18 07:52:20 localhost kernel: [    0.731542] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
Oct 18 07:52:20 localhost kernel: [    0.731615] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
Oct 18 07:52:20 localhost kernel: [    0.731687] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
Oct 18 07:52:20 localhost kernel: [    0.731791] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGR._PRT]
Oct 18 07:52:20 localhost kernel: [    0.731884]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
Oct 18 07:52:20 localhost kernel: [    0.731962]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
Oct 18 07:52:20 localhost kernel: [    1.435359] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
Oct 18 07:52:20 localhost kernel: [    1.435953] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 10 11 12 14 15)
Oct 18 07:52:20 localhost kernel: [    1.436544] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 *3 4 5 6 10 11 12 14 15)
Oct 18 07:52:20 localhost kernel: [    1.437130] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
Oct 18 07:52:20 localhost kernel: [    1.437729] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
Oct 18 07:52:20 localhost kernel: [    1.438414] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
Oct 18 07:52:20 localhost kernel: [    1.439092] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 *5 6 10 11 12 14 15)
Oct 18 07:52:20 localhost kernel: [    1.439682] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 *5 6 10 11 12 14 15)
Oct 18 07:52:20 localhost kernel: [    1.440757] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Oct 18 07:52:20 localhost kernel: [    1.440846] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
Oct 18 07:52:20 localhost kernel: [    1.440925] vgaarb: loaded
Oct 18 07:52:20 localhost kernel: [    1.440980] vgaarb: bridge control possible 0000:01:00.0
Oct 18 07:52:20 localhost kernel: [    1.441040] vgaarb: no bridge control possible 0000:00:02.0
Oct 18 07:52:20 localhost kernel: [    1.441919] PCI: Using ACPI for IRQ routing
Oct 18 07:52:20 localhost kernel: [    1.444906] PCI: pci_cache_line_size set to 64 bytes
Oct 18 07:52:20 localhost kernel: [    1.445016] e820: reserve RAM buffer [mem 0x0009e800-0x0009ffff]
Oct 18 07:52:20 localhost kernel: [    1.445019] e820: reserve RAM buffer [mem 0xaabd1000-0xabffffff]
Oct 18 07:52:20 localhost kernel: [    1.445022] e820: reserve RAM buffer [mem 0xaace6000-0xabffffff]
Oct 18 07:52:20 localhost kernel: [    1.445025] e820: reserve RAM buffer [mem 0xaacfa000-0xabffffff]
Oct 18 07:52:20 localhost kernel: [    1.445028] e820: reserve RAM buffer [mem 0xaad8f000-0xabffffff]
Oct 18 07:52:20 localhost kernel: [    1.445030] e820: reserve RAM buffer [mem 0xaadc8000-0xabffffff]
Oct 18 07:52:20 localhost kernel: [    1.445032] e820: reserve RAM buffer [mem 0xaaf09000-0xabffffff]
Oct 18 07:52:20 localhost kernel: [    1.445035] e820: reserve RAM buffer [mem 0xaaffd000-0xabffffff]
Oct 18 07:52:20 localhost kernel: [    1.445037] e820: reserve RAM buffer [mem 0x34fe00000-0x34fffffff]
Oct 18 07:52:20 localhost kernel: [    1.445636] NetLabel: Initializing
Oct 18 07:52:20 localhost kernel: [    1.445693] NetLabel:  domain hash size = 128
Oct 18 07:52:20 localhost kernel: [    1.445750] NetLabel:  protocols = UNLABELED CIPSOv4
Oct 18 07:52:20 localhost kernel: [    1.445851] NetLabel:  unlabeled traffic allowed by default
Oct 18 07:52:20 localhost kernel: [    1.445922] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
Oct 18 07:52:20 localhost kernel: [    1.446321] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Oct 18 07:52:20 localhost kernel: [    1.448406] Switching to clocksource hpet
Oct 18 07:52:20 localhost kernel: [    1.454041] pnp: PnP ACPI init
Oct 18 07:52:20 localhost kernel: [    1.454129] ACPI: bus type pnp registered
Oct 18 07:52:20 localhost kernel: [    1.454542] pnp 00:00: [bus 00-3e]
Oct 18 07:52:20 localhost kernel: [    1.454545] pnp 00:00: [io  0x0000-0x0cf7 window]
Oct 18 07:52:20 localhost kernel: [    1.454547] pnp 00:00: [io  0x0cf8-0x0cff]
Oct 18 07:52:20 localhost kernel: [    1.454550] pnp 00:00: [io  0x0d00-0xffff window]
Oct 18 07:52:20 localhost kernel: [    1.454552] pnp 00:00: [mem 0x000a0000-0x000bffff window]
Oct 18 07:52:20 localhost kernel: [    1.454554] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
Oct 18 07:52:20 localhost kernel: [    1.454556] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
Oct 18 07:52:20 localhost kernel: [    1.454559] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
Oct 18 07:52:20 localhost kernel: [    1.454561] pnp 00:00: [mem 0x000cc000-0x000cffff window]
Oct 18 07:52:20 localhost kernel: [    1.454563] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
Oct 18 07:52:20 localhost kernel: [    1.454565] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
Oct 18 07:52:20 localhost kernel: [    1.454567] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
Oct 18 07:52:20 localhost kernel: [    1.454569] pnp 00:00: [mem 0x000dc000-0x000dffff window]
Oct 18 07:52:20 localhost kernel: [    1.454571] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
Oct 18 07:52:20 localhost kernel: [    1.454573] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
Oct 18 07:52:20 localhost kernel: [    1.454576] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
Oct 18 07:52:20 localhost kernel: [    1.454578] pnp 00:00: [mem 0x000ec000-0x000effff window]
Oct 18 07:52:20 localhost kernel: [    1.454580] pnp 00:00: [mem 0x000f0000-0x000fffff window]
Oct 18 07:52:20 localhost kernel: [    1.454582] pnp 00:00: [mem 0xafa00000-0xfeafffff window]
Oct 18 07:52:20 localhost kernel: [    1.454584] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
Oct 18 07:52:20 localhost kernel: [    1.454731] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
Oct 18 07:52:20 localhost kernel: [    1.454755] pnp 00:01: [io  0x0000-0x001f]
Oct 18 07:52:20 localhost kernel: [    1.454757] pnp 00:01: [io  0x0081-0x0091]
Oct 18 07:52:20 localhost kernel: [    1.454761] pnp 00:01: [io  0x0093-0x009f]
Oct 18 07:52:20 localhost kernel: [    1.454764] pnp 00:01: [io  0x00c0-0x00df]
Oct 18 07:52:20 localhost kernel: [    1.454766] pnp 00:01: [dma 4]
Oct 18 07:52:20 localhost kernel: [    1.454859] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
Oct 18 07:52:20 localhost kernel: [    1.454872] pnp 00:02: [mem 0xff000000-0xffffffff]
Oct 18 07:52:20 localhost kernel: [    1.454960] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
Oct 18 07:52:20 localhost kernel: [    1.455067] pnp 00:03: [mem 0xfed00000-0xfed003ff]
Oct 18 07:52:20 localhost kernel: [    1.455159] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
Oct 18 07:52:20 localhost kernel: [    1.455192] pnp 00:04: [io  0x00f0]
Oct 18 07:52:20 localhost kernel: [    1.455205] pnp 00:04: [irq 13]
Oct 18 07:52:20 localhost kernel: [    1.455303] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
Oct 18 07:52:20 localhost kernel: [    1.455319] pnp 00:05: [io  0x002e-0x002f]
Oct 18 07:52:20 localhost kernel: [    1.455321] pnp 00:05: [io  0x004e-0x004f]
Oct 18 07:52:20 localhost kernel: [    1.455323] pnp 00:05: [io  0x0061]
Oct 18 07:52:20 localhost kernel: [    1.455325] pnp 00:05: [io  0x0063]
Oct 18 07:52:20 localhost kernel: [    1.455327] pnp 00:05: [io  0x0065]
Oct 18 07:52:20 localhost kernel: [    1.455329] pnp 00:05: [io  0x0067]
Oct 18 07:52:20 localhost kernel: [    1.455330] pnp 00:05: [io  0x0070]
Oct 18 07:52:20 localhost kernel: [    1.455332] pnp 00:05: [io  0x0080]
Oct 18 07:52:20 localhost kernel: [    1.455334] pnp 00:05: [io  0x0092]
Oct 18 07:52:20 localhost kernel: [    1.455336] pnp 00:05: [io  0x00b2-0x00b3]
Oct 18 07:52:20 localhost kernel: [    1.455338] pnp 00:05: [io  0x0680-0x069f]
Oct 18 07:52:20 localhost kernel: [    1.455340] pnp 00:05: [io  0x1000-0x100f]
Oct 18 07:52:20 localhost kernel: [    1.455342] pnp 00:05: [io  0xffff]
Oct 18 07:52:20 localhost kernel: [    1.455344] pnp 00:05: [io  0xffff]
Oct 18 07:52:20 localhost kernel: [    1.455346] pnp 00:05: [io  0x0400-0x0453]
Oct 18 07:52:20 localhost kernel: [    1.455348] pnp 00:05: [io  0x0458-0x047f]
Oct 18 07:52:20 localhost kernel: [    1.455350] pnp 00:05: [io  0x0500-0x057f]
Oct 18 07:52:20 localhost kernel: [    1.455352] pnp 00:05: [io  0x164e-0x164f]
Oct 18 07:52:20 localhost kernel: [    1.455474] system 00:05: [io  0x0680-0x069f] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.455537] system 00:05: [io  0x1000-0x100f] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.455600] system 00:05: [io  0xffff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.455661] system 00:05: [io  0xffff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.455721] system 00:05: [io  0x0400-0x0453] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.455783] system 00:05: [io  0x0458-0x047f] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.455845] system 00:05: [io  0x0500-0x057f] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.455907] system 00:05: [io  0x164e-0x164f] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.455973] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
Oct 18 07:52:20 localhost kernel: [    1.455987] pnp 00:06: [io  0x0070-0x0077]
Oct 18 07:52:20 localhost kernel: [    1.455996] pnp 00:06: [irq 8]
Oct 18 07:52:20 localhost kernel: [    1.456086] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
Oct 18 07:52:20 localhost kernel: [    1.456123] pnp 00:07: [io  0x0454-0x0457]
Oct 18 07:52:20 localhost kernel: [    1.456228] system 00:07: [io  0x0454-0x0457] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.456294] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
Oct 18 07:52:20 localhost kernel: [    1.456364] pnp 00:08: [irq 12]
Oct 18 07:52:20 localhost kernel: [    1.456460] pnp 00:08: Plug and Play ACPI device, IDs ETD0001 SYN0a00 SYN0002 PNP0f03 PNP0f13 PNP0f12 (active)
Oct 18 07:52:20 localhost kernel: [    1.456492] pnp 00:09: [io  0x0060]
Oct 18 07:52:20 localhost kernel: [    1.456494] pnp 00:09: [io  0x0064]
Oct 18 07:52:20 localhost kernel: [    1.456502] pnp 00:09: [irq 1]
Oct 18 07:52:20 localhost kernel: [    1.456593] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
Oct 18 07:52:20 localhost kernel: [    1.505513] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
Oct 18 07:52:20 localhost kernel: [    1.505516] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
Oct 18 07:52:20 localhost kernel: [    1.505518] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
Oct 18 07:52:20 localhost kernel: [    1.505520] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
Oct 18 07:52:20 localhost kernel: [    1.505522] pnp 00:0a: [mem 0xe0000000-0xe3ffffff]
Oct 18 07:52:20 localhost kernel: [    1.505524] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
Oct 18 07:52:20 localhost kernel: [    1.505526] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
Oct 18 07:52:20 localhost kernel: [    1.505529] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
Oct 18 07:52:20 localhost kernel: [    1.505533] pnp 00:0a: [mem 0xff000000-0xffffffff]
Oct 18 07:52:20 localhost kernel: [    1.505535] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
Oct 18 07:52:20 localhost kernel: [    1.505537] pnp 00:0a: [mem 0xafa00000-0xafa00fff]
Oct 18 07:52:20 localhost kernel: [    1.505684] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.505764] system 00:0a: [mem 0xfed10000-0xfed17fff] could not be reserved
Oct 18 07:52:20 localhost kernel: [    1.505828] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.505892] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.505955] system 00:0a: [mem 0xe0000000-0xe3ffffff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.506019] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.506082] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.506145] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.506209] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
Oct 18 07:52:20 localhost kernel: [    1.506273] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
Oct 18 07:52:20 localhost kernel: [    1.506337] system 00:0a: [mem 0xafa00000-0xafa00fff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.506403] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
Oct 18 07:52:20 localhost kernel: [    1.506449] pnp 00:0b: [mem 0xafa00000-0xafa00fff]
Oct 18 07:52:20 localhost kernel: [    1.506586] system 00:0b: [mem 0xafa00000-0xafa00fff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.506653] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
Oct 18 07:52:20 localhost kernel: [    1.506852] pnp 00:0c: [mem 0x20000000-0x201fffff]
Oct 18 07:52:20 localhost kernel: [    1.506855] pnp 00:0c: [mem 0x40000000-0x401fffff]
Oct 18 07:52:20 localhost kernel: [    1.506987] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.507052] system 00:0c: [mem 0x40000000-0x401fffff] has been reserved
Oct 18 07:52:20 localhost kernel: [    1.507618] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
Oct 18 07:52:20 localhost kernel: [    1.507636] pnp: PnP ACPI: found 13 devices
Oct 18 07:52:20 localhost kernel: [    1.507695] ACPI: ACPI bus type pnp unregistered
Oct 18 07:52:20 localhost kernel: [    1.521061] pci 0000:00:01.0: PCI bridge to [bus 01]
Oct 18 07:52:20 localhost kernel: [    1.521125] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
Oct 18 07:52:20 localhost kernel: [    1.521190] pci 0000:00:01.0:   bridge window [mem 0xdb000000-0xdc0fffff]
Oct 18 07:52:20 localhost kernel: [    1.521256] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    1.521336] pci 0000:00:1c.0: PCI bridge to [bus 02]
Oct 18 07:52:20 localhost kernel: [    1.521399] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
Oct 18 07:52:20 localhost kernel: [    1.521467] pci 0000:00:1c.0:   bridge window [mem 0xde600000-0xdeffffff]
Oct 18 07:52:20 localhost kernel: [    1.521534] pci 0000:00:1c.0:   bridge window [mem 0xd4200000-0xd4bfffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    1.521619] pci 0000:00:1c.1: PCI bridge to [bus 03]
Oct 18 07:52:20 localhost kernel: [    1.521681] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
Oct 18 07:52:20 localhost kernel: [    1.521748] pci 0000:00:1c.1:   bridge window [mem 0xddc00000-0xde5fffff]
Oct 18 07:52:20 localhost kernel: [    1.521828] pci 0000:00:1c.1:   bridge window [mem 0xd3700000-0xd40fffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    1.521914] pci 0000:00:1c.3: PCI bridge to [bus 04]
Oct 18 07:52:20 localhost kernel: [    1.521975] pci 0000:00:1c.3:   bridge window [io  0xa000-0xafff]
Oct 18 07:52:20 localhost kernel: [    1.522043] pci 0000:00:1c.3:   bridge window [mem 0xdd200000-0xddbfffff]
Oct 18 07:52:20 localhost kernel: [    1.522110] pci 0000:00:1c.3:   bridge window [mem 0xd2c00000-0xd35fffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    1.522195] pci 0000:00:1c.5: PCI bridge to [bus 05]
Oct 18 07:52:20 localhost kernel: [    1.522257] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
Oct 18 07:52:20 localhost kernel: [    1.522325] pci 0000:00:1c.5:   bridge window [mem 0xdc800000-0xdd1fffff]
Oct 18 07:52:20 localhost kernel: [    1.522391] pci 0000:00:1c.5:   bridge window [mem 0xd2100000-0xd2afffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    1.522532] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Oct 18 07:52:20 localhost kernel: [    1.522534] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Oct 18 07:52:20 localhost kernel: [    1.522536] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Oct 18 07:52:20 localhost kernel: [    1.522539] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
Oct 18 07:52:20 localhost kernel: [    1.522541] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
Oct 18 07:52:20 localhost kernel: [    1.522543] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
Oct 18 07:52:20 localhost kernel: [    1.522545] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
Oct 18 07:52:20 localhost kernel: [    1.522547] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
Oct 18 07:52:20 localhost kernel: [    1.522549] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
Oct 18 07:52:20 localhost kernel: [    1.522551] pci_bus 0000:00: resource 13 [mem 0xafa00000-0xfeafffff]
Oct 18 07:52:20 localhost kernel: [    1.522553] pci_bus 0000:00: resource 14 [mem 0xfed40000-0xfed44fff]
Oct 18 07:52:20 localhost kernel: [    1.522556] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
Oct 18 07:52:20 localhost kernel: [    1.522558] pci_bus 0000:01: resource 1 [mem 0xdb000000-0xdc0fffff]
Oct 18 07:52:20 localhost kernel: [    1.522560] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xd1ffffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    1.522562] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
Oct 18 07:52:20 localhost kernel: [    1.522564] pci_bus 0000:02: resource 1 [mem 0xde600000-0xdeffffff]
Oct 18 07:52:20 localhost kernel: [    1.522567] pci_bus 0000:02: resource 2 [mem 0xd4200000-0xd4bfffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    1.522569] pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
Oct 18 07:52:20 localhost kernel: [    1.522571] pci_bus 0000:03: resource 1 [mem 0xddc00000-0xde5fffff]
Oct 18 07:52:20 localhost kernel: [    1.522573] pci_bus 0000:03: resource 2 [mem 0xd3700000-0xd40fffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    1.522575] pci_bus 0000:04: resource 0 [io  0xa000-0xafff]
Oct 18 07:52:20 localhost kernel: [    1.522578] pci_bus 0000:04: resource 1 [mem 0xdd200000-0xddbfffff]
Oct 18 07:52:20 localhost kernel: [    1.522580] pci_bus 0000:04: resource 2 [mem 0xd2c00000-0xd35fffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    1.522582] pci_bus 0000:05: resource 0 [io  0x9000-0x9fff]
Oct 18 07:52:20 localhost kernel: [    1.522584] pci_bus 0000:05: resource 1 [mem 0xdc800000-0xdd1fffff]
Oct 18 07:52:20 localhost kernel: [    1.522586] pci_bus 0000:05: resource 2 [mem 0xd2100000-0xd2afffff 64bit pref]
Oct 18 07:52:20 localhost kernel: [    1.522655] NET: Registered protocol family 2
Oct 18 07:52:20 localhost kernel: [    1.523812] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Oct 18 07:52:20 localhost kernel: [    1.525614] TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
Oct 18 07:52:20 localhost kernel: [    1.530392] TCP: Hash tables configured (established 524288 bind 65536)
Oct 18 07:52:20 localhost kernel: [    1.530508] TCP: reno registered
Oct 18 07:52:20 localhost kernel: [    1.530686] UDP hash table entries: 8192 (order: 8, 1310720 bytes)
Oct 18 07:52:20 localhost kernel: [    1.532094] UDP-Lite hash table entries: 8192 (order: 8, 1310720 bytes)
Oct 18 07:52:20 localhost kernel: [    1.533552] NET: Registered protocol family 1
Oct 18 07:52:20 localhost kernel: [    1.533631] pci 0000:00:02.0: Boot video device
Oct 18 07:52:20 localhost kernel: [    1.781958] PCI: CLS 64 bytes, default 64
Oct 18 07:52:20 localhost kernel: [    1.782127] Trying to unpack rootfs image as initramfs...
Oct 18 07:52:20 localhost kernel: [    1.901238] Freeing initrd memory: 5912k freed
Oct 18 07:52:20 localhost kernel: [    1.902272] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Oct 18 07:52:20 localhost kernel: [    1.902340] software IO TLB [mem 0xa6bd1000-0xaabd0fff] (64MB) mapped at [ffff8800a6bd1000-ffff8800aabd0fff]
Oct 18 07:52:20 localhost kernel: [    1.903880] audit: initializing netlink socket (disabled)
Oct 18 07:52:20 localhost kernel: [    1.903998] type=2000 audit(1350539501.656:1): initialized
Oct 18 07:52:20 localhost kernel: [    1.938514] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Oct 18 07:52:20 localhost kernel: [    1.947111] VFS: Disk quotas dquot_6.5.2
Oct 18 07:52:20 localhost kernel: [    1.947318] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Oct 18 07:52:20 localhost kernel: [    1.947799] ROMFS MTD (C) 2007 Red Hat, Inc.
Oct 18 07:52:20 localhost kernel: [    1.947966] msgmni has been set to 23840
Oct 18 07:52:20 localhost kernel: [    1.948925] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
Oct 18 07:52:20 localhost kernel: [    1.949101] io scheduler noop registered
Oct 18 07:52:20 localhost kernel: [    1.949159] io scheduler deadline registered
Oct 18 07:52:20 localhost kernel: [    1.949427] io scheduler cfq registered (default)
Oct 18 07:52:20 localhost kernel: [    1.952293] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
Oct 18 07:52:20 localhost kernel: [    1.953308] intel_idle: MWAIT substates: 0x21120
Oct 18 07:52:20 localhost kernel: [    1.953311] intel_idle: v0.4 model 0x2A
Oct 18 07:52:20 localhost kernel: [    1.953312] intel_idle: lapic_timer_reliable_states 0xffffffff
Oct 18 07:52:20 localhost kernel: [    1.953500] GHES: HEST is not enabled!
Oct 18 07:52:20 localhost kernel: [    2.007889] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Oct 18 07:52:20 localhost kernel: [    2.009549] Linux agpgart interface v0.103
Oct 18 07:52:20 localhost kernel: [    2.014630] brd: module loaded
Oct 18 07:52:20 localhost kernel: [    2.014926] libphy: Fixed MDIO Bus: probed
Oct 18 07:52:20 localhost kernel: [    2.015241] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Oct 18 07:52:20 localhost kernel: [    2.016943] i8042: Detected active multiplexing controller, rev 1.1
Oct 18 07:52:20 localhost kernel: [    2.017809] serio: i8042 KBD port at 0x60,0x64 irq 1
Oct 18 07:52:20 localhost kernel: [    2.017934] serio: i8042 AUX0 port at 0x60,0x64 irq 12
Oct 18 07:52:20 localhost kernel: [    2.018012] serio: i8042 AUX1 port at 0x60,0x64 irq 12
Oct 18 07:52:20 localhost kernel: [    2.018284] serio: i8042 AUX2 port at 0x60,0x64 irq 12
Oct 18 07:52:20 localhost kernel: [    2.018469] serio: i8042 AUX3 port at 0x60,0x64 irq 12
Oct 18 07:52:20 localhost kernel: [    2.019008] mousedev: PS/2 mouse device common for all mice
Oct 18 07:52:20 localhost kernel: [    2.019192] rtc_cmos 00:06: RTC can wake from S4
Oct 18 07:52:20 localhost kernel: [    2.019657] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
Oct 18 07:52:20 localhost kernel: [    2.019758] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
Oct 18 07:52:20 localhost kernel: [    2.020281] cpuidle: using governor ladder
Oct 18 07:52:20 localhost kernel: [    2.021188] cpuidle: using governor menu
Oct 18 07:52:20 localhost kernel: [    2.021318] ledtrig-cpu: registered to indicate activity on CPUs
Oct 18 07:52:20 localhost kernel: [    2.022015] drop_monitor: Initializing network drop monitor service
Oct 18 07:52:20 localhost kernel: [    2.022304] TCP: cubic registered
Oct 18 07:52:20 localhost kernel: [    2.023528] NET: Registered protocol family 10
Oct 18 07:52:20 localhost kernel: [    2.024116] mip6: Mobile IPv6
Oct 18 07:52:20 localhost kernel: [    2.024176] NET: Registered protocol family 17
Oct 18 07:52:20 localhost kernel: [    2.024579] Key type dns_resolver registered
Oct 18 07:52:20 localhost kernel: [    2.027443] registered taskstats version 1
Oct 18 07:52:20 localhost kernel: [    2.028752] rtc_cmos 00:06: setting system clock to 2012-10-18 05:51:42 UTC (1350539502)
Oct 18 07:52:20 localhost kernel: [    2.031018] Freeing unused kernel memory: 656k freed
Oct 18 07:52:20 localhost kernel: [    2.031171] Write protecting the kernel read-only data: 8192k
Oct 18 07:52:20 localhost kernel: [    2.034893] Freeing unused kernel memory: 1256k freed
Oct 18 07:52:20 localhost kernel: [    2.035803] Freeing unused kernel memory: 172k freed
Oct 18 07:52:20 localhost kernel: [    2.043148] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
Oct 18 07:52:20 localhost kernel: [    2.054442] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
Oct 18 07:52:20 localhost kernel: [    2.054713] ACPI: Lid Switch [LID]
Oct 18 07:52:20 localhost kernel: [    2.054966] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
Oct 18 07:52:20 localhost kernel: [    2.055073] ACPI: Sleep Button [SLPB]
Oct 18 07:52:20 localhost kernel: [    2.055354] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
Oct 18 07:52:20 localhost kernel: [    2.055456] ACPI: Power Button [PWRF]
Oct 18 07:52:20 localhost kernel: [    2.060739] [drm] Initialized drm 1.1.0 20060810
Oct 18 07:52:20 localhost kernel: [    2.066383] pci 0000:00:00.0: Intel Sandybridge Chipset
Oct 18 07:52:20 localhost kernel: [    2.066636] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
Oct 18 07:52:20 localhost kernel: [    2.068408] pci 0000:00:00.0: detected 65536K stolen memory
Oct 18 07:52:20 localhost kernel: [    2.068679] i915 0000:00:02.0: setting latency timer to 64
Oct 18 07:52:20 localhost kernel: [    2.149519] i915 0000:00:02.0: irq 41 for MSI/MSI-X
Oct 18 07:52:20 localhost kernel: [    2.149536] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
Oct 18 07:52:20 localhost kernel: [    2.149600] [drm] Driver supports precise vblank timestamp query.
Oct 18 07:52:20 localhost kernel: [    2.150003] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
Oct 18 07:52:20 localhost kernel: [    2.150084] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
Oct 18 07:52:20 localhost kernel: [    2.321225] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
Oct 18 07:52:20 localhost kernel: [    2.447956] fbcon: inteldrmfb (fb0) is primary device
Oct 18 07:52:20 localhost kernel: [    2.904858] tsc: Refined TSC clocksource calibration: 1995.466 MHz
Oct 18 07:52:20 localhost kernel: [    2.904901] Switching to clocksource tsc
Oct 18 07:52:20 localhost kernel: [    3.191903] Console: switching to colour frame buffer device 200x56
Oct 18 07:52:20 localhost kernel: [    3.195656] fb0: inteldrmfb frame buffer device
Oct 18 07:52:20 localhost kernel: [    3.195679] drm: registered panic notifier
Oct 18 07:52:20 localhost kernel: [    3.201907] ACPI Warning: _BQC returned an invalid level (20120913/video-472)
Oct 18 07:52:20 localhost kernel: [    3.203141] acpi device:4f: registered as cooling_device0
Oct 18 07:52:20 localhost kernel: [    3.203228] ACPI: Video Device [GFX0] (multi-head: yes  rom: yes  post: no)
Oct 18 07:52:20 localhost kernel: [    3.203604] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:4b/LNXVIDEO:00/input/input4
Oct 18 07:52:20 localhost kernel: [    3.206940] ACPI Warning: _BQC returned an invalid level (20120913/video-472)
Oct 18 07:52:20 localhost kernel: [    3.207827] acpi device:51: registered as cooling_device1
Oct 18 07:52:20 localhost kernel: [    3.208204] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
Oct 18 07:52:20 localhost kernel: [    3.208489] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input5
Oct 18 07:52:20 localhost kernel: [    3.208720] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
Oct 18 07:52:20 localhost kernel: [    3.211575] SCSI subsystem initialized
Oct 18 07:52:20 localhost kernel: [    3.213425] ACPI: bus type scsi registered
Oct 18 07:52:20 localhost kernel: [    3.213685] libata version 3.00 loaded.
Oct 18 07:52:20 localhost kernel: [    3.215533] ahci 0000:00:1f.2: version 3.0
Oct 18 07:52:20 localhost kernel: [    3.215621] ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
Oct 18 07:52:20 localhost kernel: [    3.228064] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x7 impl SATA mode
Oct 18 07:52:20 localhost kernel: [    3.228120] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
Oct 18 07:52:20 localhost kernel: [    3.228162] ahci 0000:00:1f.2: setting latency timer to 64
Oct 18 07:52:20 localhost kernel: [    3.244419] scsi0 : ahci
Oct 18 07:52:20 localhost kernel: [    3.244865] scsi1 : ahci
Oct 18 07:52:20 localhost kernel: [    3.245091] scsi2 : ahci
Oct 18 07:52:20 localhost kernel: [    3.245312] scsi3 : ahci
Oct 18 07:52:20 localhost kernel: [    3.245537] scsi4 : ahci
Oct 18 07:52:20 localhost kernel: [    3.245759] scsi5 : ahci
Oct 18 07:52:20 localhost kernel: [    3.245950] ata1: SATA max UDMA/133 abar m2048@0xdf006000 port 0xdf006100 irq 42
Oct 18 07:52:20 localhost kernel: [    3.245987] ata2: SATA max UDMA/133 abar m2048@0xdf006000 port 0xdf006180 irq 42
Oct 18 07:52:20 localhost kernel: [    3.246023] ata3: SATA max UDMA/133 abar m2048@0xdf006000 port 0xdf006200 irq 42
Oct 18 07:52:20 localhost kernel: [    3.246057] ata4: DUMMY
Oct 18 07:52:20 localhost kernel: [    3.246071] ata5: DUMMY
Oct 18 07:52:20 localhost kernel: [    3.246084] ata6: DUMMY
Oct 18 07:52:20 localhost kernel: [    3.564651] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Oct 18 07:52:20 localhost kernel: [    3.569144] ata3.00: ACPI cmd ef/90:06:00:00:00:00 (SET FEATURES) succeeded
Oct 18 07:52:20 localhost kernel: [    3.569157] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Oct 18 07:52:20 localhost kernel: [    3.570458] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Oct 18 07:52:20 localhost kernel: [    3.571798] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Oct 18 07:52:20 localhost kernel: [    3.573127] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Oct 18 07:52:20 localhost kernel: [    3.574431] ata3.00: ATAPI: HL-DT-STDVDRAM GT34N, AS00, max UDMA/100
Oct 18 07:52:20 localhost kernel: [    3.577100] ata1.00: ACPI cmd ef/90:06:00:00:00:00 (SET FEATURES) succeeded
Oct 18 07:52:20 localhost kernel: [    3.577105] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Oct 18 07:52:20 localhost kernel: [    3.578392] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Oct 18 07:52:20 localhost kernel: [    3.579696] ata2.00: ACPI cmd ef/90:06:00:00:00:00 (SET FEATURES) succeeded
Oct 18 07:52:20 localhost kernel: [    3.579701] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Oct 18 07:52:20 localhost kernel: [    3.580968] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Oct 18 07:52:20 localhost kernel: [    3.583302] ata1.00: ATA-8: WDC WD5000BEVT-80A0RT0, 01.01A01, max UDMA/133
Oct 18 07:52:20 localhost kernel: [    3.584616] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Oct 18 07:52:20 localhost kernel: [    3.586002] ata3.00: ACPI cmd ef/90:06:00:00:00:00 (SET FEATURES) succeeded
Oct 18 07:52:20 localhost kernel: [    3.586007] ata3.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Oct 18 07:52:20 localhost kernel: [    3.587298] ata3.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Oct 18 07:52:20 localhost kernel: [    3.588643] ata1.00: failed to get Identify Device Data, Emask 0x1
Oct 18 07:52:20 localhost kernel: [    3.588927] ata2.00: ATA-8: WDC WD5000BEVT-80A0RT0, 01.01A01, max UDMA/133
Oct 18 07:52:20 localhost kernel: [    3.590236] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Oct 18 07:52:20 localhost kernel: [    3.591594] ata3.00: configured for UDMA/100
Oct 18 07:52:20 localhost kernel: [    3.593538] ata2.00: failed to get Identify Device Data, Emask 0x1
Oct 18 07:52:20 localhost kernel: [    3.593696] ata1.00: ACPI cmd ef/90:06:00:00:00:00 (SET FEATURES) succeeded
Oct 18 07:52:20 localhost kernel: [    3.593700] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Oct 18 07:52:20 localhost kernel: [    3.595023] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Oct 18 07:52:20 localhost kernel: [    3.599128] ata2.00: ACPI cmd ef/90:06:00:00:00:00 (SET FEATURES) succeeded
Oct 18 07:52:20 localhost kernel: [    3.599134] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
Oct 18 07:52:20 localhost kernel: [    3.600449] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
Oct 18 07:52:20 localhost kernel: [    3.601807] ata1.00: failed to get Identify Device Data, Emask 0x1
Oct 18 07:52:20 localhost kernel: [    3.601814] ata1.00: configured for UDMA/133
Oct 18 07:52:20 localhost kernel: [    3.604239] ata2.00: failed to get Identify Device Data, Emask 0x1
Oct 18 07:52:20 localhost kernel: [    3.604252] ata2.00: configured for UDMA/133
Oct 18 07:52:20 localhost kernel: [    3.608631] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000BEVT-8 01.0 PQ: 0 ANSI: 5
Oct 18 07:52:20 localhost kernel: [    3.612482] scsi 1:0:0:0: Direct-Access     ATA      WDC WD5000BEVT-8 01.0 PQ: 0 ANSI: 5
Oct 18 07:52:20 localhost kernel: [    3.612071] ACPI: Invalid Power Resource to register!
Oct 18 07:52:20 localhost kernel: [    3.615333] ACPI: Invalid Power Resource to register!<5>[    3.617361] scsi 2:0:0:0: CD-ROM            HL-DT-ST DVDRAM GT34N     AS00 PQ: 0 ANSI: 5
Oct 18 07:52:20 localhost kernel: [    3.623329] md: raid10 personality registered for level 10
Oct 18 07:52:20 localhost kernel: [    3.626732] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Oct 18 07:52:20 localhost kernel: [    3.626767] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Oct 18 07:52:20 localhost kernel: [    3.626890] sd 1:0:0:0: [sdb] Write Protect is off
Oct 18 07:52:20 localhost kernel: [    3.626893] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Oct 18 07:52:20 localhost kernel: [    3.626938] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 18 07:52:20 localhost kernel: [    3.631899] sd 0:0:0:0: [sda] Write Protect is off
Oct 18 07:52:20 localhost kernel: [    3.633156] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 18 07:52:20 localhost kernel: [    3.633188] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 18 07:52:20 localhost kernel: [    3.657899]  sdb: sdb1 sdb2
Oct 18 07:52:20 localhost kernel: [    3.660765] sd 1:0:0:0: [sdb] Attached SCSI disk
Oct 18 07:52:20 localhost kernel: [    3.670822]  sda: sda1 sda2
Oct 18 07:52:20 localhost kernel: [    3.673155] sd 0:0:0:0: [sda] Attached SCSI disk
Oct 18 07:52:20 localhost kernel: [    3.676438] device-mapper: uevent: version 1.0.3
Oct 18 07:52:20 localhost kernel: [    3.678187] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
Oct 18 07:52:20 localhost kernel: [    3.948957] md: md1 stopped.
Oct 18 07:52:20 localhost kernel: [    3.952235] md: bind<sdb2>
Oct 18 07:52:20 localhost kernel: [    3.953777] md: bind<sda2>
Oct 18 07:52:20 localhost kernel: [    3.955684] md/raid10:md1: active with 2 out of 2 devices
Oct 18 07:52:20 localhost kernel: [    3.956948] md1: detected capacity change from 0 to 499596132352
Oct 18 07:52:20 localhost kernel: [    3.985753]  md1: unknown partition table
Oct 18 07:52:20 localhost kernel: [    4.039180] bio: create slab <bio-1> at 1
Oct 18 07:52:20 localhost kernel: [    4.265948] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
Oct 18 07:52:20 localhost kernel: [    6.786776] thermal LNXTHERM:00: registered as thermal_zone0
Oct 18 07:52:20 localhost kernel: [    6.786780] ACPI: Thermal Zone [TZ00] (40 C)
Oct 18 07:52:20 localhost kernel: [    6.855492] ACPI: Requesting acpi_cpufreq
Oct 18 07:52:20 localhost kernel: [    6.860382] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
Oct 18 07:52:20 localhost kernel: [    6.860399] ACPI: Battery Slot [BAT0] (battery present)
Oct 18 07:52:20 localhost kernel: [    6.861819] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
Oct 18 07:52:20 localhost kernel: [    6.862049] ACPI: AC Adapter [AC0] (on-line)
Oct 18 07:52:20 localhost kernel: [    6.930343] wmi: Mapper loaded
Oct 18 07:52:20 localhost kernel: [    6.931725] mei 0000:00:16.0: setting latency timer to 64
Oct 18 07:52:20 localhost kernel: [    6.931889] mei 0000:00:16.0: irq 43 for MSI/MSI-X
Oct 18 07:52:20 localhost kernel: [    6.944949] mei 0000:00:16.0: wd: failed to find the client
Oct 18 07:52:20 localhost kernel: [    6.979204] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x14
Oct 18 07:52:20 localhost kernel: [    7.132518] ACPI: bus type usb registered
Oct 18 07:52:20 localhost kernel: [    7.132598] usbcore: registered new interface driver usbfs
Oct 18 07:52:20 localhost kernel: [    7.132705] usbcore: registered new interface driver hub
Oct 18 07:52:20 localhost kernel: [    7.132809] usbcore: registered new device driver usb
Oct 18 07:52:20 localhost kernel: [    7.167872] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x14
Oct 18 07:52:20 localhost kernel: [    7.168855] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x14
Oct 18 07:52:20 localhost kernel: [    7.169461] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x14
Oct 18 07:52:20 localhost kernel: [    7.170059] microcode: CPU4 sig=0x206a7, pf=0x10, revision=0x14
Oct 18 07:52:20 localhost kernel: [    7.170783] microcode: CPU5 sig=0x206a7, pf=0x10, revision=0x14
Oct 18 07:52:20 localhost kernel: [    7.171441] microcode: CPU6 sig=0x206a7, pf=0x10, revision=0x14
Oct 18 07:52:20 localhost kernel: [    7.171964] microcode: CPU7 sig=0x206a7, pf=0x10, revision=0x14
Oct 18 07:52:20 localhost kernel: [    7.172684] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Oct 18 07:52:20 localhost kernel: [    7.221330] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Oct 18 07:52:20 localhost kernel: [    7.221432] ehci_hcd 0000:00:1a.0: setting latency timer to 64
Oct 18 07:52:20 localhost kernel: [    7.221437] ehci_hcd 0000:00:1a.0: EHCI Host Controller
Oct 18 07:52:20 localhost kernel: [    7.221626] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
Oct 18 07:52:20 localhost kernel: [    7.225149] atl1c 0000:05:00.0: version 1.0.1.0-NAPI
Oct 18 07:52:20 localhost kernel: [    7.225610] ehci_hcd 0000:00:1a.0: debug port 2
Oct 18 07:52:20 localhost kernel: [    7.225621] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
Oct 18 07:52:20 localhost kernel: [    7.225652] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xdf008000
Oct 18 07:52:20 localhost kernel: [    7.233381] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
Oct 18 07:52:20 localhost kernel: [    7.233588] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Oct 18 07:52:20 localhost kernel: [    7.233591] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 18 07:52:20 localhost kernel: [    7.233593] usb usb1: Product: EHCI Host Controller
Oct 18 07:52:20 localhost kernel: [    7.233595] usb usb1: Manufacturer: Linux 3.7.0-rc1-00078-g8d2b6b3 ehci_hcd
Oct 18 07:52:20 localhost kernel: [    7.233597] usb usb1: SerialNumber: 0000:00:1a.0
Oct 18 07:52:20 localhost kernel: [    7.234443] hub 1-0:1.0: USB hub found
Oct 18 07:52:20 localhost kernel: [    7.234522] hub 1-0:1.0: 2 ports detected
Oct 18 07:52:20 localhost kernel: [    7.235224] ehci_hcd 0000:00:1d.0: setting latency timer to 64
Oct 18 07:52:20 localhost kernel: [    7.235229] ehci_hcd 0000:00:1d.0: EHCI Host Controller
Oct 18 07:52:20 localhost kernel: [    7.235239] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Oct 18 07:52:20 localhost kernel: [    7.239154] ehci_hcd 0000:00:1d.0: debug port 2
Oct 18 07:52:20 localhost kernel: [    7.239165] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
Oct 18 07:52:20 localhost kernel: [    7.239191] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xdf007000
Oct 18 07:52:20 localhost kernel: [    7.246697] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
Oct 18 07:52:20 localhost kernel: [    7.246792] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Oct 18 07:52:20 localhost kernel: [    7.246795] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 18 07:52:20 localhost kernel: [    7.246797] usb usb2: Product: EHCI Host Controller
Oct 18 07:52:20 localhost kernel: [    7.246799] usb usb2: Manufacturer: Linux 3.7.0-rc1-00078-g8d2b6b3 ehci_hcd
Oct 18 07:52:20 localhost kernel: [    7.246801] usb usb2: SerialNumber: 0000:00:1d.0
Oct 18 07:52:20 localhost kernel: [    7.247126] hub 2-0:1.0: USB hub found
Oct 18 07:52:20 localhost kernel: [    7.247139] hub 2-0:1.0: 2 ports detected
Oct 18 07:52:20 localhost kernel: [    7.394788] input: PC Speaker as /devices/platform/pcspkr/input/input6
Oct 18 07:52:20 localhost kernel: [    3.620421] ACPI: Invalid Power Resource to register!
Oct 18 07:52:20 localhost kernel: [    7.439313] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20120913/utaddress-251)
Oct 18 07:52:20 localhost kernel: [    7.439322] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 18 07:52:20 localhost kernel: [    7.439327] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \SBGP 1 (20120913/utaddress-251)
Oct 18 07:52:20 localhost kernel: [    7.439331] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 2 (20120913/utaddress-251)
Oct 18 07:52:20 localhost kernel: [    7.439336] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 18 07:52:20 localhost kernel: [    7.439337] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \SBGP 1 (20120913/utaddress-251)
Oct 18 07:52:20 localhost kernel: [    7.439341] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 2 (20120913/utaddress-251)
Oct 18 07:52:20 localhost kernel: [    7.439345] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 18 07:52:20 localhost kernel: [    7.439347] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \SBGP 1 (20120913/utaddress-251)
Oct 18 07:52:20 localhost kernel: [    7.439351] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 2 (20120913/utaddress-251)
Oct 18 07:52:20 localhost kernel: [    7.439355] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 18 07:52:20 localhost kernel: [    7.439356] lpc_ich: Resource conflict(s) found affecting gpio_ich
Oct 18 07:52:20 localhost kernel: [    7.539975] usb 1-1: new high-speed USB device number 2 using ehci_hcd
Oct 18 07:52:20 localhost kernel: [    7.592556] xhci_hcd 0000:04:00.0: xHCI Host Controller
Oct 18 07:52:20 localhost kernel: [    7.592573] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 3
Oct 18 07:52:20 localhost kernel: [    7.663594] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
Oct 18 07:52:20 localhost kernel: [    7.663598] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Oct 18 07:52:20 localhost kernel: [    7.664278] hub 1-1:1.0: USB hub found
Oct 18 07:52:20 localhost kernel: [    7.664451] hub 1-1:1.0: 6 ports detected
Oct 18 07:52:20 localhost kernel: [    7.728424] xhci_hcd 0000:04:00.0: irq 19, io mem 0xdd200000
Oct 18 07:52:20 localhost kernel: [    7.728486] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
Oct 18 07:52:20 localhost kernel: [    7.728489] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 18 07:52:20 localhost kernel: [    7.728491] usb usb3: Product: xHCI Host Controller
Oct 18 07:52:20 localhost kernel: [    7.728493] usb usb3: Manufacturer: Linux 3.7.0-rc1-00078-g8d2b6b3 xhci_hcd
Oct 18 07:52:20 localhost kernel: [    7.728495] usb usb3: SerialNumber: 0000:04:00.0
Oct 18 07:52:20 localhost kernel: [    7.728735] xHCI xhci_add_endpoint called for root hub
Oct 18 07:52:20 localhost kernel: [    7.728738] xHCI xhci_check_bandwidth called for root hub
Oct 18 07:52:20 localhost kernel: [    7.728799] hub 3-0:1.0: USB hub found
Oct 18 07:52:20 localhost kernel: [    7.728863] hub 3-0:1.0: 1 port detected
Oct 18 07:52:20 localhost kernel: [    7.729025] xhci_hcd 0000:04:00.0: xHCI Host Controller
Oct 18 07:52:20 localhost kernel: [    7.729033] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 4
Oct 18 07:52:20 localhost kernel: [    7.729098] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
Oct 18 07:52:20 localhost kernel: [    7.729101] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 18 07:52:20 localhost kernel: [    7.729103] usb usb4: Product: xHCI Host Controller
Oct 18 07:52:20 localhost kernel: [    7.729105] usb usb4: Manufacturer: Linux 3.7.0-rc1-00078-g8d2b6b3 xhci_hcd
Oct 18 07:52:20 localhost kernel: [    7.729107] usb usb4: SerialNumber: 0000:04:00.0
Oct 18 07:52:20 localhost kernel: [    7.729361] xHCI xhci_add_endpoint called for root hub
Oct 18 07:52:20 localhost kernel: [    7.729364] xHCI xhci_check_bandwidth called for root hub
Oct 18 07:52:20 localhost kernel: [    7.729424] hub 4-0:1.0: USB hub found
Oct 18 07:52:20 localhost kernel: [    7.729440] hub 4-0:1.0: 1 port detected
Oct 18 07:52:20 localhost kernel: [    7.734687] ACPI Warning: 0x000000000000e040-0x000000000000e05f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120913/utaddress-251)
Oct 18 07:52:20 localhost kernel: [    7.734695] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
Oct 18 07:52:20 localhost kernel: [    7.773219] usb 2-1: new high-speed USB device number 2 using ehci_hcd
Oct 18 07:52:20 localhost kernel: [    7.883748] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Oct 18 07:52:20 localhost kernel: [    7.883757] cdrom: Uniform CD-ROM driver Revision: 3.20
Oct 18 07:52:20 localhost kernel: [    7.884259] sr 2:0:0:0: Attached scsi CD-ROM sr0
Oct 18 07:52:20 localhost kernel: [    7.896884] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
Oct 18 07:52:20 localhost kernel: [    7.896894] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Oct 18 07:52:20 localhost kernel: [    7.897364] hub 2-1:1.0: USB hub found
Oct 18 07:52:20 localhost kernel: [    7.897482] hub 2-1:1.0: 6 ports detected
Oct 18 07:52:20 localhost kernel: [    7.966613] usb 1-1.1: new full-speed USB device number 3 using ehci_hcd
Oct 18 07:52:20 localhost kernel: [    8.050595] usb 1-1.1: New USB device found, idVendor=13d3, idProduct=3304
Oct 18 07:52:20 localhost kernel: [    8.050605] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Oct 18 07:52:20 localhost kernel: [    8.116581] usb 1-1.2: new high-speed USB device number 4 using ehci_hcd
Oct 18 07:52:20 localhost kernel: [    8.155369] cfg80211: Calling CRDA to update world regulatory domain
Oct 18 07:52:20 localhost kernel: [    8.175962] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Oct 18 07:52:20 localhost kernel: [    8.190365] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
Oct 18 07:52:20 localhost kernel: [    8.221687] asus_wmi: ASUS WMI generic driver loaded
Oct 18 07:52:20 localhost kernel: [    8.222584] asus_wmi: Initialization: 0x1asus_wmi: SFUN value: 0x1a0af7
Oct 18 07:52:20 localhost kernel: [    8.223501] input: Asus WMI hotkeys as /devices/platform/asus-nb-wmi/input/input7
Oct 18 07:52:20 localhost kernel: [    8.229097] asus_wmi: Backlight controlled by ACPI video driver
Oct 18 07:52:20 localhost kernel: [    8.238356] usb 1-1.2: New USB device found, idVendor=13d3, idProduct=5122
Oct 18 07:52:20 localhost kernel: [    8.238361] usb 1-1.2: New USB device strings: Mfr=2, Product=1, SerialNumber=3
Oct 18 07:52:20 localhost kernel: [    8.238364] usb 1-1.2: Product: USB2.0 UVC 2M WebCam
Oct 18 07:52:20 localhost kernel: [    8.238367] usb 1-1.2: Manufacturer: USB2.0 UVC 2M WebCam
Oct 18 07:52:20 localhost kernel: [    8.238369] usb 1-1.2: SerialNumber: USB2.0 UVC 2M WebCam
Oct 18 07:52:20 localhost kernel: [    8.309872] usb 2-1.2: new low-speed USB device number 3 using ehci_hcd
Oct 18 07:52:20 localhost kernel: [    8.323596] iTCO_vendor_support: vendor-support=0
Oct 18 07:52:20 localhost kernel: [    8.352047] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
Oct 18 07:52:20 localhost kernel: [    8.352186] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
Oct 18 07:52:20 localhost kernel: [    8.352283] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
Oct 18 07:52:20 localhost kernel: [    8.398720] usb 2-1.2: New USB device found, idVendor=046d, idProduct=c051
Oct 18 07:52:20 localhost kernel: [    8.398732] usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
Oct 18 07:52:20 localhost kernel: [    8.398738] usb 2-1.2: Product: USB-PS/2 Optical Mouse
Oct 18 07:52:20 localhost kernel: [    8.398743] usb 2-1.2: Manufacturer: Logitech
Oct 18 07:52:20 localhost kernel: [    8.402605] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
Oct 18 07:52:20 localhost kernel: [    8.402648] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
Oct 18 07:52:20 localhost kernel: [    8.403205] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Oct 18 07:52:20 localhost kernel: [    8.624068] psmouse serio4: elantech: assuming hardware version 2 (with firmware version 0x040201)
Oct 18 07:52:20 localhost kernel: [    8.653079] psmouse serio4: elantech: Synaptics capabilities query result 0x78, 0x14, 0x0b.
Oct 18 07:52:20 localhost kernel: [    8.758056] usbcore: registered new interface driver usbhid
Oct 18 07:52:20 localhost kernel: [    8.758059] usbhid: USB HID core driver
Oct 18 07:52:20 localhost kernel: [    8.761963] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio4/input/input11
Oct 18 07:52:20 localhost kernel: [    8.763302] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input12
Oct 18 07:52:20 localhost kernel: [    8.764046] hid-generic 0003:046D:C051.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1.2/input0
Oct 18 07:52:20 localhost kernel: [    8.783234] media: Linux media interface: v0.10
Oct 18 07:52:20 localhost kernel: [    8.867742] MXM: GUID detected in BIOS
Oct 18 07:52:20 localhost kernel: [    8.867985] VGA switcheroo: detected Optimus DSM method \_SB_.PCI0.PEGR.GFX0 handle
Oct 18 07:52:20 localhost kernel: [    8.868098] nouveau 0000:01:00.0: enabling device (0004 -> 0007)
Oct 18 07:52:20 localhost kernel: [    8.868782] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0c1a00a1
Oct 18 07:52:20 localhost kernel: [    8.868785] nouveau  [  DEVICE][0000:01:00.0] Chipset: GF108 (NVC1)
Oct 18 07:52:20 localhost kernel: [    8.868787] nouveau  [  DEVICE][0000:01:00.0] Family : NVC0
Oct 18 07:52:20 localhost kernel: [    8.872044] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
Oct 18 07:52:20 localhost kernel: [    8.881776] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
Oct 18 07:52:20 localhost kernel: [    8.881778] nouveau  [   VBIOS][0000:01:00.0] checking PROM for image...
Oct 18 07:52:20 localhost kernel: [    8.881836] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
Oct 18 07:52:20 localhost kernel: [    8.881838] nouveau  [   VBIOS][0000:01:00.0] checking ACPI for image...
Oct 18 07:52:20 localhost kernel: [    8.881920] ACPI Error: Field [ROMI] Base+Offset+Width 0+24+1 is beyond end of region [VROM] (length 24) (20120913/exfldio-210)
Oct 18 07:52:20 localhost kernel: [    8.881926] ACPI Error: Method parse/execution failed [\_SB_.PCI0.PEGR.GFX0._ROM] (Node ffff88033e47fe88), AE_AML_REGION_LIMIT (20120913/psparse-536)
Oct 18 07:52:20 localhost kernel: [    8.886284] failed to evaluate ROM got AE_AML_REGION_LIMIT
Oct 18 07:52:20 localhost kernel: [    8.886312] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
Oct 18 07:52:20 localhost kernel: [    8.888373] IP: [<ffffffffa0630395>] nouveau_bios_score+0x15/0xd0 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.889399] PGD 33cb71067 PUD 33cb72067 PMD 0 
Oct 18 07:52:20 localhost kernel: [    8.890412] Oops: 0000 [#1] SMP 
Oct 18 07:52:20 localhost kernel: [    8.891412] Modules linked in: ath9k_hw nouveau(+) media hid_generic usbhid videobuf2_vmalloc hid videobuf2_memops ath coretemp iTCO_wdt snd_hda_codec_hdmi iTCO_vendor_support ttm kvm_intel snd_hda_codec_realtek asus_nb_wmi asus_wmi acpi_cpufreq kvm sparse_keymap snd_hda_intel pci_hotplug snd_hda_codec cfg80211 psmouse sr_mod crc32c_intel snd_hwdep cdrom snd_pcm snd_timer i2c_i801 xhci_hcd hwmon mperf ghash_clmulni_intel snd lpc_ich rfkill serio_raw pcspkr cryptd ehci_hcd atl1c usbcore mxm_wmi soundcore usb_common microcode mei wmi snd_page_alloc evdev ac battery processor thermal ext4 mbcache jbd2 crc16 dm_mod sd_mod crc_t10dif raid10 md_mod ahci libahci libata scsi_mod i915 drm_kms_helper drm intel_agp i2c_algo_bit intel_gtt button i2c_core video
Oct 18 07:52:20 localhost kernel: [    8.896104] CPU 1 
Oct 18 07:52:20 localhost kernel: [    8.896115] Pid: 2760, comm: udevd Not tainted 3.7.0-rc1-00078-g8d2b6b3 #24 ASUSTeK Computer Inc. N73SV/N73SV
Oct 18 07:52:20 localhost kernel: [    8.898586] RIP: 0010:[<ffffffffa0630395>]  [<ffffffffa0630395>] nouveau_bios_score+0x15/0xd0 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.899934] RSP: 0018:ffff88033c065818  EFLAGS: 00010202
Oct 18 07:52:20 localhost kernel: [    8.901189] RAX: 0000000000000010 RBX: ffff88033c861300 RCX: 0000000000000006
Oct 18 07:52:20 localhost kernel: [    8.902446] RDX: 0000000000000006 RSI: 0000000000000001 RDI: ffff88033c861300
Oct 18 07:52:20 localhost kernel: [    8.903652] RBP: ffff88033c065828 R08: 0000000000000000 R09: 0000000000000000
Oct 18 07:52:20 localhost kernel: [    8.904814] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88033c0658a8
Oct 18 07:52:20 localhost kernel: [    8.905973] R13: ffff88033c065848 R14: 0000000000000000 R15: ffff8803367a8400
Oct 18 07:52:20 localhost kernel: [    8.907128] FS:  00007f790de45800(0000) GS:ffff88034fa20000(0000) knlGS:0000000000000000
Oct 18 07:52:20 localhost kernel: [    8.908285] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Oct 18 07:52:20 localhost kernel: [    8.909454] CR2: 0000000000000010 CR3: 000000033cb70000 CR4: 00000000000407e0
Oct 18 07:52:20 localhost kernel: [    8.910620] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct 18 07:52:20 localhost kernel: [    8.911773] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct 18 07:52:20 localhost kernel: [    8.912936] Process udevd (pid: 2760, threadinfo ffff88033c064000, task ffff88033bd5cd80)
Oct 18 07:52:20 localhost kernel: [    8.914123] Stack:
Oct 18 07:52:20 localhost kernel: [    8.915266]  ffff88033c065848 ffff88033c861300 ffff88033c065958 ffffffffa0630666
Oct 18 07:52:20 localhost kernel: [    8.916451]  ffff88033c065858 ffffffff8109431d 00004e494d415250 0000000000000000
Oct 18 07:52:20 localhost kernel: [    8.917641]  ffffffffa0630a00 0000000000000001 0000000000000000 0000000000000000
Oct 18 07:52:20 localhost kernel: [    8.918820] Call Trace:
Oct 18 07:52:20 localhost kernel: [    8.919984]  [<ffffffffa0630666>] nouveau_bios_shadow+0x216/0x390 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.921165]  [<ffffffff8109431d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
Oct 18 07:52:20 localhost kernel: [    8.922350]  [<ffffffffa0630a00>] ? nouveau_bios_shadow_prom+0x220/0x220 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.923572]  [<ffffffffa06307e0>] ? nouveau_bios_shadow+0x390/0x390 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.924745]  [<ffffffffa0630270>] ? nouveau_bios_shadow_pci+0xc0/0xc0 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.925913]  [<ffffffffa06301b0>] ? nouveau_bios_dtor+0x30/0x30 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.927063]  [<ffffffffa0630c45>] nouveau_bios_ctor+0x65/0x420 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.928221]  [<ffffffffa062d5f3>] nouveau_object_ctor+0x33/0xc0 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.929431]  [<ffffffffa063c75f>] nouveau_devobj_ctor+0x25f/0x740 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.930567]  [<ffffffff814b798a>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
Oct 18 07:52:20 localhost kernel: [    8.931716]  [<ffffffffa062d5f3>] nouveau_object_ctor+0x33/0xc0 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.932883]  [<ffffffffa062df4b>] nouveau_object_new+0x18b/0x240 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.934021]  [<ffffffffa0698ddd>] nouveau_drm_load+0x17d/0x560 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.935143]  [<ffffffff81329059>] ? device_register+0x19/0x20
Oct 18 07:52:20 localhost kernel: [    8.936314]  [<ffffffffa00385c9>] ? drm_get_minor+0x259/0x2f0 [drm]
Oct 18 07:52:20 localhost kernel: [    8.937457]  [<ffffffffa003abd6>] drm_get_pci_dev+0x186/0x2d0 [drm]
Oct 18 07:52:20 localhost kernel: [    8.938590]  [<ffffffff8128191d>] ? __pci_set_master+0x4d/0x80
Oct 18 07:52:20 localhost kernel: [    8.939736]  [<ffffffffa06d98cd>] nouveau_drm_probe+0x1ee/0x214 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.940866]  [<ffffffff81285e54>] local_pci_probe+0x74/0x100
Oct 18 07:52:20 localhost kernel: [    8.941989]  [<ffffffff81285ff1>] pci_device_probe+0x111/0x120
Oct 18 07:52:20 localhost kernel: [    8.943134]  [<ffffffff8132b706>] driver_probe_device+0x76/0x220
Oct 18 07:52:20 localhost kernel: [    8.944258]  [<ffffffff8132b953>] __driver_attach+0xa3/0xb0
Oct 18 07:52:20 localhost kernel: [    8.945363]  [<ffffffff8132b8b0>] ? driver_probe_device+0x220/0x220
Oct 18 07:52:20 localhost kernel: [    8.946629]  [<ffffffff813299cd>] bus_for_each_dev+0x4d/0x90
Oct 18 07:52:20 localhost kernel: [    8.947726]  [<ffffffff8132b179>] driver_attach+0x19/0x20
Oct 18 07:52:20 localhost kernel: [    8.948821]  [<ffffffff8132ae20>] bus_add_driver+0x1a0/0x270
Oct 18 07:52:20 localhost kernel: [    8.949905]  [<ffffffffa054b000>] ? 0xffffffffa054afff
Oct 18 07:52:20 localhost kernel: [    8.950968]  [<ffffffff8132bfc2>] driver_register+0x72/0x170
Oct 18 07:52:20 localhost kernel: [    8.951994]  [<ffffffffa054b000>] ? 0xffffffffa054afff
Oct 18 07:52:20 localhost kernel: [    8.953083]  [<ffffffff81284c6c>] __pci_register_driver+0x5c/0x70
Oct 18 07:52:20 localhost kernel: [    8.954179]  [<ffffffffa003ae3a>] drm_pci_init+0x11a/0x130 [drm]
Oct 18 07:52:20 localhost kernel: [    8.955264]  [<ffffffff81325f40>] ? vga_switcheroo_register_handler+0x40/0x90
Oct 18 07:52:20 localhost kernel: [    8.956319]  [<ffffffffa054b000>] ? 0xffffffffa054afff
Oct 18 07:52:20 localhost kernel: [    8.957282]  [<ffffffffa054b04d>] nouveau_drm_init+0x4d/0x1000 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.958206]  [<ffffffff810002da>] do_one_initcall+0x11a/0x170
Oct 18 07:52:20 localhost kernel: [    8.959096]  [<ffffffff810a0dbb>] sys_init_module+0xbb/0x220
Oct 18 07:52:20 localhost kernel: [    8.959960]  [<ffffffff814bf856>] system_call_fastpath+0x1a/0x1f
Oct 18 07:52:20 localhost kernel: [    8.960808] Code: c8 00 00 00 48 63 f8 e9 6d ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 53 48 83 ec 08 48 8b 87 d0 00 00 00 48 85 c0 74 05 <80> 38 55 74 26 31 c0 48 c7 c1 16 35 6e a0 ba 03 00 00 00 48 c7 
Oct 18 07:52:20 localhost kernel: [    8.962850] RIP  [<ffffffffa0630395>] nouveau_bios_score+0x15/0xd0 [nouveau]
Oct 18 07:52:20 localhost kernel: [    8.963803]  RSP <ffff88033c065818>
Oct 18 07:52:20 localhost kernel: [    8.964737] CR2: 0000000000000010
Oct 18 07:52:20 localhost kernel: [    8.965680] ---[ end trace 5fce019b56fa0528 ]---
Oct 18 07:52:20 localhost kernel: [    9.021854] Linux video capture interface: v2.00
Oct 18 07:52:20 localhost kernel: [    9.166609] Bluetooth: Core ver 2.16
Oct 18 07:52:20 localhost kernel: [    9.167613] NET: Registered protocol family 31
Oct 18 07:52:20 localhost kernel: [    9.168590] Bluetooth: HCI device and connection manager initialized
Oct 18 07:52:20 localhost kernel: [    9.169612] Bluetooth: HCI socket layer initialized
Oct 18 07:52:20 localhost kernel: [    9.170594] Bluetooth: L2CAP socket layer initialized
Oct 18 07:52:20 localhost kernel: [    9.171578] Bluetooth: SCO socket layer initialized
Oct 18 07:52:20 localhost kernel: [    9.424721] ath: EEPROM regdomain: 0x60
Oct 18 07:52:20 localhost kernel: [    9.425869] ath: EEPROM indicates we should expect a direct regpair map
Oct 18 07:52:20 localhost kernel: [    9.426884] ath: Country alpha2 being used: 00
Oct 18 07:52:20 localhost kernel: [    9.427752] ath: Regpair used: 0x60
Oct 18 07:52:20 localhost kernel: [    9.445768] uvcvideo: Found UVC 1.00 device USB2.0 UVC 2M WebCam (13d3:5122)
Oct 18 07:52:20 localhost kernel: [    9.457539] input: USB2.0 UVC 2M WebCam as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input13
Oct 18 07:52:20 localhost kernel: [    9.458637] usbcore: registered new interface driver uvcvideo
Oct 18 07:52:20 localhost kernel: [    9.459736] USB Video Class driver (1.1.1)
Oct 18 07:52:20 localhost kernel: [    9.462143] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
Oct 18 07:52:20 localhost kernel: [    9.463394] Registered led device: ath9k-phy0
Oct 18 07:52:20 localhost kernel: [    9.464403] ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xffffc90006aa0000, irq=17
Oct 18 07:52:20 localhost kernel: [    9.477838] usbcore: registered new interface driver btusb
Oct 18 07:52:20 localhost kernel: [    9.490768] Bluetooth: Firmware file "ath3k-1.fw" not found
Oct 18 07:52:20 localhost kernel: [    9.491827] ath3k: probe of 1-1.1:1.0 failed with error -2
Oct 18 07:52:20 localhost kernel: [    9.492871] usbcore: registered new interface driver ath3k
Oct 18 07:52:20 localhost kernel: [   10.258843] EXT4-fs (dm-0): re-mounted. Opts: commit=300
Oct 18 07:52:20 localhost kernel: [   11.143233] md: md0 stopped.
Oct 18 07:52:20 localhost kernel: [   11.146838] md: bind<sdb1>
Oct 18 07:52:20 localhost kernel: [   11.152438] md: bind<sda1>
Oct 18 07:52:20 localhost kernel: [   11.213070] md: raid1 personality registered for level 1
Oct 18 07:52:20 localhost kernel: [   11.214774] md/raid1:md0: active with 2 out of 2 mirrors
Oct 18 07:52:20 localhost kernel: [   11.216183] md0: detected capacity change from 0 to 509804544
Oct 18 07:52:20 localhost kernel: [   11.220499]  md0: unknown partition table
Oct 18 07:52:20 localhost kernel: [   11.835554] kjournald starting.  Commit interval 300 seconds
Oct 18 07:52:20 localhost kernel: [   11.842696] EXT3-fs (md0): using internal journal
Oct 18 07:52:20 localhost kernel: [   11.844088] EXT3-fs (md0): mounted filesystem with writeback data mode
Oct 18 07:52:20 localhost kernel: [   11.972360] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: commit=300

--nextPart3600253.nEyvJli8FP--

