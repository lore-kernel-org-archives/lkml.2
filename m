Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab1LERRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:17:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47969 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab1LERRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:17:22 -0500
Date: Mon, 5 Dec 2011 20:21:14 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [regression] WARNING: at drivers/block/floppy.c:2929
 do_fd_request+0xb7/0xb9() in 3.2.0-rc2 and 3
Message-ID: <20111205202114.6457443b@sf.home>
In-Reply-To: <20111125103420.GO4581@charite.de>
References: <20111125103420.GO4581@charite.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ajnQNLBe4.R3r0E4y1OuAAk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ajnQNLBe4.R3r0E4y1OuAAk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> When booting, 3.2.0-rc2 and 3.2.0-rc3 report:
>=20
> ...
> [    0.412076] intel_idle: MWAIT substates: 0x2220
> [    0.412079] intel_idle: does not run on family 6 model 15
> [    0.412386] Floppy drive(s): fd0 is 1.44M
> [    1.354458] Refined TSC clocksource calibration: 3000.106 MHz.
> [    1.354519] Switching to clocksource tsc
> [    3.424080] floppy0: no floppy controllers found
> [    3.424191] ------------[ cut here ]------------
> [    3.424253] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xb7=
/0xb9()
> [    3.424317] Hardware name: ProLiant DL360 G5
> [    3.424370] VFS: do_fd_request called on non-open device
> [    3.424425] Modules linked in:
> [    3.424508] Pid: 1, comm: swapper Not tainted 3.2.0-rc3 #12
> [    3.424564] Call Trace:
> [    3.424617]  [<c102b98c>] ? warn_slowpath_common+0x6c/0x95
> [    3.424673]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.424728]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.424783]  [<c102ba3e>] ? warn_slowpath_fmt+0x33/0x37
> [    3.424839]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.424895]  [<c113cbab>] ? blk_drain_queue+0x46/0x54
> [    3.424950]  [<c113cc74>] ? blk_cleanup_queue+0xbb/0x153
> [    3.425007]  [<c13737a3>] ? floppy_init+0xd1a/0xd48
> [    3.425063]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.425118]  [<c1001027>] ? do_one_initcall+0x27/0x150
> [    3.425173]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.425184]  [<c1372a89>] ? set_cmos+0x79/0x79
> [    3.425184]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.425184]  [<c13546f1>] ? kernel_init+0x81/0x110
> [    3.425184]  [<c126f53e>] ? kernel_thread_helper+0x6/0xd
> [    3.425184] ---[ end trace dd61103ea87a7da7 ]---
> [    3.425517] ------------[ cut here ]------------
> [    3.425571] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xb7=
/0xb9()
> [    3.425629] Hardware name: ProLiant DL360 G5
> [    3.425682] VFS: do_fd_request called on non-open device
> [    3.425737] Modules linked in:
> [    3.425819] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc3 #12
> [    3.425876] Call Trace:
> [    3.425926]  [<c102b98c>] ? warn_slowpath_common+0x6c/0x95
> [    3.425982]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.426508]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.426508]  [<c102ba3e>] ? warn_slowpath_fmt+0x33/0x37
> [    3.426508]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.426508]  [<c113cbab>] ? blk_drain_queue+0x46/0x54
> [    3.426508]  [<c113cc74>] ? blk_cleanup_queue+0xbb/0x153
> [    3.426508]  [<c13737a3>] ? floppy_init+0xd1a/0xd48
> [    3.426508]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.426508]  [<c1001027>] ? do_one_initcall+0x27/0x150
> [    3.426508]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.426508]  [<c1372a89>] ? set_cmos+0x79/0x79
> [    3.426508]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.426508]  [<c13546f1>] ? kernel_init+0x81/0x110
> [    3.426508]  [<c126f53e>] ? kernel_thread_helper+0x6/0xd
> [    3.426508] ---[ end trace dd61103ea87a7da8 ]---
> [    3.428496] ------------[ cut here ]------------
> [    3.428550] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xb7=
/0xb9()
> [    3.428608] Hardware name: ProLiant DL360 G5
> [    3.428661] VFS: do_fd_request called on non-open device
> [    3.428716] Modules linked in:
> [    3.428798] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc3 #12
> [    3.428855] Call Trace:
> [    3.428906]  [<c102b98c>] ? warn_slowpath_common+0x6c/0x95
> [    3.428961]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.429017]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.429071]  [<c102ba3e>] ? warn_slowpath_fmt+0x33/0x37
> [    3.429127]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.429182]  [<c113cbab>] ? blk_drain_queue+0x46/0x54
> [    3.429237]  [<c113cc74>] ? blk_cleanup_queue+0xbb/0x153
> [    3.429292]  [<c13737a3>] ? floppy_init+0xd1a/0xd48
> [    3.429347]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.429402]  [<c1001027>] ? do_one_initcall+0x27/0x150
> [    3.429457]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.429490]  [<c1372a89>] ? set_cmos+0x79/0x79
> [    3.429490]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.429490]  [<c13546f1>] ? kernel_init+0x81/0x110
> [    3.429490]  [<c126f53e>] ? kernel_thread_helper+0x6/0xd
> [    3.429490] ---[ end trace dd61103ea87a7da9 ]---
> [    3.429791] ------------[ cut here ]------------
> [    3.429846] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xb7=
/0xb9()
> [    3.429904] Hardware name: ProLiant DL360 G5
> [    3.429957] VFS: do_fd_request called on non-open device
> [    3.430011] Modules linked in:
> [    3.430093] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc3 #12
> [    3.430150] Call Trace:
> [    3.430201]  [<c102b98c>] ? warn_slowpath_common+0x6c/0x95
> [    3.430257]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.430312]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.430367]  [<c102ba3e>] ? warn_slowpath_fmt+0x33/0x37
> [    3.430422]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.430477]  [<c113cbab>] ? blk_drain_queue+0x46/0x54
> [    3.430532]  [<c113cc74>] ? blk_cleanup_queue+0xbb/0x153
> [    3.430588]  [<c13737a3>] ? floppy_init+0xd1a/0xd48
> [    3.430643]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.430698]  [<c1001027>] ? do_one_initcall+0x27/0x150
> [    3.430753]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.430786]  [<c1372a89>] ? set_cmos+0x79/0x79
> [    3.430786]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.430786]  [<c13546f1>] ? kernel_init+0x81/0x110
> [    3.430786]  [<c126f53e>] ? kernel_thread_helper+0x6/0xd
> [    3.430786] ---[ end trace dd61103ea87a7daa ]---
> [    3.431086] ------------[ cut here ]------------
> [    3.431141] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xb7=
/0xb9()
> [    3.431199] Hardware name: ProLiant DL360 G5
> [    3.431252] VFS: do_fd_request called on non-open device
> [    3.431306] Modules linked in:
> [    3.431389] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc3 #12
> [    3.431446] Call Trace:
> [    3.431497]  [<c102b98c>] ? warn_slowpath_common+0x6c/0x95
> [    3.431553]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.431608]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.431662]  [<c102ba3e>] ? warn_slowpath_fmt+0x33/0x37
> [    3.431718]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.431773]  [<c113cbab>] ? blk_drain_queue+0x46/0x54
> [    3.431828]  [<c113cc74>] ? blk_cleanup_queue+0xbb/0x153
> [    3.431883]  [<c13737a3>] ? floppy_init+0xd1a/0xd48
> [    3.431938]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.431993]  [<c1001027>] ? do_one_initcall+0x27/0x150
> [    3.432048]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.432081]  [<c1372a89>] ? set_cmos+0x79/0x79
> [    3.432081]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.432081]  [<c13546f1>] ? kernel_init+0x81/0x110
> [    3.432081]  [<c126f53e>] ? kernel_thread_helper+0x6/0xd
> [    3.432081] ---[ end trace dd61103ea87a7dab ]---
> [    3.432381] ------------[ cut here ]------------
> [    3.432436] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xb7=
/0xb9()
> [    3.432494] Hardware name: ProLiant DL360 G5
> [    3.432547] VFS: do_fd_request called on non-open device
> [    3.432601] Modules linked in:
> [    3.432683] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc3 #12
> [    3.432740] Call Trace:
> [    3.432791]  [<c102b98c>] ? warn_slowpath_common+0x6c/0x95
> [    3.432846]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.432901]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.432956]  [<c102ba3e>] ? warn_slowpath_fmt+0x33/0x37
> [    3.433012]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.433066]  [<c113cbab>] ? blk_drain_queue+0x46/0x54
> [    3.433121]  [<c113cc74>] ? blk_cleanup_queue+0xbb/0x153
> [    3.433177]  [<c13737a3>] ? floppy_init+0xd1a/0xd48
> [    3.433232]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.433286]  [<c1001027>] ? do_one_initcall+0x27/0x150
> [    3.433341]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.433376]  [<c1372a89>] ? set_cmos+0x79/0x79
> [    3.433376]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.433376]  [<c13546f1>] ? kernel_init+0x81/0x110
> [    3.433376]  [<c126f53e>] ? kernel_thread_helper+0x6/0xd
> [    3.433376] ---[ end trace dd61103ea87a7dac ]---
> [    3.433675] ------------[ cut here ]------------
> [    3.433730] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xb7=
/0xb9()
> [    3.433788] Hardware name: ProLiant DL360 G5
> [    3.433840] VFS: do_fd_request called on non-open device
> [    3.433895] Modules linked in:
> [    3.433977] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc3 #12
> [    3.434034] Call Trace:
> [    3.434085]  [<c102b98c>] ? warn_slowpath_common+0x6c/0x95
> [    3.434141]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.434196]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.434250]  [<c102ba3e>] ? warn_slowpath_fmt+0x33/0x37
> [    3.434306]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.434361]  [<c113cbab>] ? blk_drain_queue+0x46/0x54
> [    3.434416]  [<c113cc74>] ? blk_cleanup_queue+0xbb/0x153
> [    3.434471]  [<c13737a3>] ? floppy_init+0xd1a/0xd48
> [    3.434526]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.434581]  [<c1001027>] ? do_one_initcall+0x27/0x150
> [    3.434636]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.434670]  [<c1372a89>] ? set_cmos+0x79/0x79
> [    3.434670]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.434670]  [<c13546f1>] ? kernel_init+0x81/0x110
> [    3.434670]  [<c126f53e>] ? kernel_thread_helper+0x6/0xd
> [    3.434670] ---[ end trace dd61103ea87a7dad ]---
> [    3.434969] ------------[ cut here ]------------
> [    3.435024] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xb7=
/0xb9()
> [    3.435082] Hardware name: ProLiant DL360 G5
> [    3.435135] VFS: do_fd_request called on non-open device
> [    3.435189] Modules linked in:
> [    3.435272] Pid: 1, comm: swapper Tainted: G        W    3.2.0-rc3 #12
> [    3.435328] Call Trace:
> [    3.435379]  [<c102b98c>] ? warn_slowpath_common+0x6c/0x95
> [    3.435435]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.435490]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.435545]  [<c102ba3e>] ? warn_slowpath_fmt+0x33/0x37
> [    3.435600]  [<c11b1667>] ? do_fd_request+0xb7/0xb9
> [    3.435655]  [<c113cbab>] ? blk_drain_queue+0x46/0x54
> [    3.435710]  [<c113cc74>] ? blk_cleanup_queue+0xbb/0x153
> [    3.435766]  [<c13737a3>] ? floppy_init+0xd1a/0xd48
> [    3.435821]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.435875]  [<c1001027>] ? do_one_initcall+0x27/0x150
> [    3.435930]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.435964]  [<c1372a89>] ? set_cmos+0x79/0x79
> [    3.435964]  [<c1354670>] ? start_kernel+0x2c2/0x2c2
> [    3.435964]  [<c13546f1>] ? kernel_init+0x81/0x110
> [    3.435964]  [<c126f53e>] ? kernel_thread_helper+0x6/0xd
> [    3.435964] ---[ end trace dd61103ea87a7dae ]---
> [    3.436263] Compaq SMART2 Driver (v 2.6.0)
> [    3.436400] HP CISS Driver (v 3.6.26)
> [    3.436545] cciss 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IR=
Q 16
> [    3.536824] cciss 0000:06:00.0: cciss0: <0x3230> at PCI 0000:06:00.0 I=
RQ 16 using DAC
> [    3.541276]  cciss/c0d0: p1 < p5 p6 >
> [    3.541718] Uniform Multi-Platform E-IDE driver
> [    3.541905] piix 0000:00:1f.1: IDE controller (0x8086:0x269e rev 0x09)
> [    3.541971] pci 0000:00:1f.1: PCI INT A -> GSI 17 (level, low) -> IRQ =
17
> [    3.542058] piix 0000:00:1f.1: not 100% native mode: will probe irqs l=
ater
> [    3.542119]     ide0: BM-DMA at 0x0500-0x0507
> [    3.542177]     ide1: BM-DMA at 0x0508-0x050f
> [    3.542233] Probing IDE interface ide0...
> [    4.214230] hda: HL-DT-STCD-RW/DVD DRIVE GCC-C10N, ATAPI CD/DVD-ROM dr=
ive
> [    4.520106] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> [    4.521096] hda: UDMA/33 mode selected
> [    4.522099] Probing IDE interface ide1...
> [    5.041112] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [    5.041230] ide1 at 0x170-0x177,0x376 on irq 15
> [    5.041666] ide_generic: please use "probe_mask=3D0x3f" module paramet=
er for probing all legacy ISA IDE ports
> [    5.041746] ide-gd driver 1.18
> [    5.041858] ide-cd driver 5.00
> [    5.044132] ide-cd: hda: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
> [    5.044366] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    5.062928] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at =
0x60,0x64 irq 1,12
> [    5.064667] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    5.064724] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    5.064892] mousedev: PS/2 mouse device common for all mice
> [    5.065002] cpuidle: using governor ladder
> [    5.066757] cpuidle: using governor menu
> [    5.066818] TCP cubic registered
> [    5.066870] NET: Registered protocol family 17
> [    5.066931] Using IPI Shortcut mode
> [    5.066988] registered taskstats version 1
> [    5.148680] kjournald starting.  Commit interval 5 seconds
> [    5.148724] EXT3-fs (cciss/c0d0p5): mounted filesystem with writeback =
data mode
> [    5.148733] VFS: Mounted root (ext3 filesystem) readonly on device 104=
:5.
> [    5.148901] Freeing unused kernel memory: 348k freed
> [    6.395528] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
> [    6.395580] thermal LNXTHERM:00: registered as thermal_zone0
> [    6.395582] ACPI: Thermal Zone [THM0] (8 C)
> [    6.395717] ACPI: Power Button [PWRF]
> [    6.410255] bnx2: Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v=
2.1.11 (July 20, 2011)
> [    6.531029] bnx2 0000:03:00.0: BAR 0: set to [mem 0xf8000000-0xf9fffff=
f 64bit] (PCI address [0xf8000000-0xf9ffffff])
> [    6.531120] bnx2 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ=
 18
> [    6.861251] bnx2 0000:03:00.0: eth0: Broadcom NetXtreme II BCM5708 100=
0Base-T (B2) PCI-X 64-bit 133MHz found at mem f8000000, IRQ 18, node addr 0=
0:1e:0b:5f:f9:36
> [    6.861382] bnx2 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ=
 19
> [    7.191209] bnx2 0000:05:00.0: eth1: Broadcom NetXtreme II BCM5708 100=
0Base-T (B2) PCI-X 64-bit 133MHz found at mem fa000000, IRQ 19, node addr 0=
0:1e:0b:5f:ca:84
> [    7.677759] Adding 1733980k swap on /dev/cciss/c0d0p6.  Priority:-1 ex=
tents:1 across:1733980k=20
> [    7.814360] EXT3-fs (cciss/c0d0p5): using internal journal
> [   12.501807] bnx2 0000:03:00.0: eth0: NIC Copper Link is Up, 1000 Mbps =
full duplex, receive & transmit flow control ON
> [   30.347585] watchdog (2020): /proc/2020/oom_adj is deprecated, please =
use /proc/2020/oom_score_adj instead.

Same here on 3.2.0-rc4-00077-g5983fe2

'swapper' cmd looks suspicious.
[ CCing someone who is familar with block layer, sorry in advance ]

[    3.792015] floppy0: no floppy controllers found
[    3.792274] ------------[ cut here ]------------
[    3.792434] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xbf/0=
xd0()
[    3.792587] Hardware name: To Be Filled By O.E.M.
[    3.792738] VFS: do_fd_request called on non-open device
[    3.792889] Modules linked in:
[    3.793008] Pid: 1, comm: swapper Not tainted 3.2.0-rc4-00077-g5983fe2 #2
[    3.793008] Call Trace:
[    3.793008]  [<ffffffff81039a6a>] warn_slowpath_common+0x7a/0xb0
[    3.793008]  [<ffffffff81039b41>] warn_slowpath_fmt+0x41/0x50
[    3.793008]  [<ffffffff813d657f>] do_fd_request+0xbf/0xd0
[    3.793008]  [<ffffffff81322b95>] blk_drain_queue+0x65/0x80
[    3.793008]  [<ffffffff81322c93>] blk_cleanup_queue+0xe3/0x1a0
[    3.793008]  [<ffffffff818a809d>] floppy_init+0xdeb/0xe28
[    3.793008]  [<ffffffff818a72b2>] ? daring+0x6b/0x6b
[    3.793008]  [<ffffffff810002af>] do_one_initcall+0x3f/0x170
[    3.793008]  [<ffffffff81884b34>] kernel_init+0x9d/0x11e
[    3.793008]  [<ffffffff810317c2>] ? schedule_tail+0x22/0xa0
[    3.793008]  [<ffffffff815dbb14>] kernel_thread_helper+0x4/0x10
[    3.793008]  [<ffffffff81884a97>] ? start_kernel+0x2be/0x2be
[    3.793008]  [<ffffffff815dbb10>] ? gs_change+0xb/0xb
[    3.793008] ---[ end trace c5807061655fec8c ]---

--=20

  Sergei

--Sig_/ajnQNLBe4.R3r0E4y1OuAAk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk7c/YsACgkQcaHudmEf86qbNgCeN6/p9ltKhaFfKn4YqMceKpp1
StkAnAsI+tRezkdCxxfOzJCvdinJW4Q9
=JiMc
-----END PGP SIGNATURE-----

--Sig_/ajnQNLBe4.R3r0E4y1OuAAk--
