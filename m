Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136Ab1KDXIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 19:08:47 -0400
Received: from nm8-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.194]:47542 "HELO
	nm8-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750740Ab1KDXIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 19:08:46 -0400
X-Yahoo-Newman-Id: 504620.6300.bm@smtp222.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: TVSTKAcVM1mYz2Dhe5cpQzv2EVHcbFDEbPBVOHgGwqy0J8e
 V9qmGnVtuuKHFeUrycA0VtJEKqFqDzT7DDxiE1.NWBsRxU.FmfScCMgA_35H
 wJj53N7DMqpgSRoZF4mGRR86yuJ._iYd_SYFkz5y.Xv0ZYRn0yuc1dKB3Bn1
 s6keudiCO9YoJt19BtjZXvEe_YuSDsnyV3Et_Lp6wZO.1gm9CfgeT2_sorj4
 kBq7zVvPC2e6hijzrbM1Axhf1ZhB4EDB4rRQyW0p0icjPRNDOqleHCYx62JZ
 R_2B3ge7v4VCIH_Om7WrGA0BwCYnC7iO2tzdRxTO0gkccfOWH7osLjw39chJ
 N9WA8JIn2m5I5dYa4_NWivgTt2ZXT3TZfgC3Ky5n92bnbcyq1
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Fri, 4 Nov 2011 18:08:20 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111104230758.GA7332@zeus>
References: <20111102054658.GA29035@core.coreip.homeip.net>
 <20111102160208.GA6657@zeus>
 <20111102163109.GA29430@core.coreip.homeip.net>
 <20111103155956.GG4417@google.com>
 <20111103184559.GA3295@zeus>
 <20111103213959.GP4417@google.com>
 <20111104134347.GA2480@zeus>
 <20111104161431.GZ4417@google.com>
 <20111104173441.GA2157@zeus>
 <CAH3drwaXcUy1vz8bvHwE2_iga5WUsWn_Dp0oe_0r3UacV0vT_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <CAH3drwaXcUy1vz8bvHwE2_iga5WUsWn_Dp0oe_0r3UacV0vT_A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 04, 2011 at 01:35:53PM -0400, Jerome Glisse wrote:
> 
> I need full dmesg
> 
> Cheers,
> Jerome

Hi. Just noticed I attached a gzip of my dmesg last time by mistake.

Here goes as text/plain.

~ Andy


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bad-dmesg.txt"

[  237.030115] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[  237.030121] PM: Basic memory bitmaps created
[  237.030123] PM: Syncing filesystems ... done.
[  237.046109] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  237.057089] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  237.068083] PM: Preallocating image memory... done (allocated 83937 pages)
[  237.154418] PM: Allocated 335748 kbytes in 0.08 seconds (4196.85 MB/s)
[  237.154422] Suspending console(s) (use no_console_suspend to debug)
[  237.154847] hub 4-0:1.0: hub_suspend
[  237.154858] usb usb4: bus suspend
[  237.154863] ohci_hcd 0000:02:07.0: suspend root hub
[  237.154891] hub 3-0:1.0: hub_suspend
[  237.154896] usb usb3: bus suspend
[  237.154900] ohci_hcd 0000:00:13.1: suspend root hub
[  237.154927] hub 2-0:1.0: hub_suspend
[  237.154932] usb usb2: bus suspend
[  237.154936] ohci_hcd 0000:00:13.0: suspend root hub
[  237.154969] hub 1-0:1.0: hub_suspend
[  237.154974] usb usb1: bus suspend
[  237.154978] ehci_hcd 0000:02:07.2: suspend root hub
[  237.156423] hub 5-0:1.0: hub_suspend
[  237.156429] usb usb5: bus suspend
[  237.156433] ohci_hcd 0000:02:07.1: suspend root hub
[  237.209815] i8042 aux 00:06: wake-up capability disabled by ACPI
[  237.213576] i8042 kbd 00:05: wake-up capability enabled by ACPI
[  237.213699] b43-pci-bridge 0000:02:02.0: PCI INT A disabled
[  237.213748] ACPI handle has no context!
[  237.234057] ATI IXP AC97 controller 0000:00:14.5: PCI INT B disabled
[  237.234108] ATIIXP_IDE 0000:00:14.1: PCI INT A disabled
[  237.244424] PM: freeze of devices complete after 89.751 msecs
[  237.244831] PM: late freeze of devices complete after 0.401 msecs
[  237.244951] ACPI: Preparing to enter system sleep state S4
[  237.270225] PM: Saving platform NVS memory
[  237.270273] hibernation debug: Waiting for 5 seconds.
[  242.272850] ACPI: Waking up from system sleep state S4
[  242.275175] ATIIXP_IDE 0000:00:14.1: restoring config space at offset 0x1 (was 0xa000001, writing 0xa000005)
[  242.286031] firewire_ohci 0000:02:00.0: BAR 0: set to [mem 0xd0208000-0xd02087ff] (PCI address [0xd0208000-0xd02087ff])
[  242.286038] firewire_ohci 0000:02:00.0: BAR 1: set to [mem 0xd0200000-0xd0203fff] (PCI address [0xd0200000-0xd0203fff])
[  242.286049] firewire_ohci 0000:02:00.0: restoring config space at offset 0xf (was 0x4020100, writing 0x402010a)
[  242.286068] firewire_ohci 0000:02:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
[  242.286075] firewire_ohci 0000:02:00.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100016)
[  242.286105] b43-pci-bridge 0000:02:02.0: restoring config space at offset 0x1 (was 0x2, writing 0x6)
[  242.286617] PM: early restore of devices complete after 11.560 msecs
[  242.319891] ohci_hcd 0000:00:13.0: lost power
[  242.319919] ohci_hcd 0000:00:13.1: lost power
[  242.319946] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  242.319964] ATI IXP AC97 controller 0000:00:14.5: PCI INT B -> GSI 5 (level, low) -> IRQ 5
[  242.323512] [drm] AGP mode requested: 8
[  242.323517] agpgart-ati 0000:00:00.0: AGP 3.0 bridge
[  242.323535] agpgart-ati 0000:00:00.0: putting AGP V3 device into 8x mode
[  242.323553] radeon 0000:01:05.0: putting AGP V3 device into 8x mode
[  242.323603] radeon 0000:01:05.0: GTT: 32M 0xD2000000 - 0xD3FFFFFF
[  242.333997] b43-pci-bridge 0000:02:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  242.334041] ohci_hcd 0000:02:07.0: lost power
[  242.334060] ohci_hcd 0000:02:07.1: lost power
[  242.334411] radeon 0000:01:05.0: WB disabled
[  242.334450] [drm] radeon: ring at 0x00000000D2001000
[  242.334469] [drm] ring test succeeded in 0 usecs
[  242.334497] [drm] ib test succeeded in 0 usecs
[  242.446359] ohci_hcd 0000:00:13.0: OHCI controller state
[  242.446364] ohci_hcd 0000:00:13.0: OHCI 1.0, NO legacy support registers
[  242.446369] ohci_hcd 0000:00:13.0: control 0x083 HCFS=operational CBSR=3
[  242.446373] ohci_hcd 0000:00:13.0: cmdstatus 0x00000 SOC=0
[  242.446377] ohci_hcd 0000:00:13.0: intrstatus 0x00000004 SF
[  242.446382] ohci_hcd 0000:00:13.0: intrenable 0x8000005a MIE RHSC UE RD WDH
[  242.446390] ohci_hcd 0000:00:13.0: hcca frame #0005
[  242.446395] ohci_hcd 0000:00:13.0: roothub.a 02000203 POTPGT=2 NPS NDP=3(3)
[  242.446399] ohci_hcd 0000:00:13.0: roothub.b 00000000 PPCM=0000 DR=0000
[  242.446403] ohci_hcd 0000:00:13.0: roothub.status 00008000 DRWE
[  242.446408] ohci_hcd 0000:00:13.0: roothub.portstatus [0] 0x00000100 PPS
[  242.446412] ohci_hcd 0000:00:13.0: roothub.portstatus [1] 0x00000100 PPS
[  242.446416] ohci_hcd 0000:00:13.0: roothub.portstatus [2] 0x00000100 PPS
[  242.446419] ohci_hcd 0000:00:13.0: restart complete
[  242.446423] usb usb2: root hub lost power or was reset
[  242.446426] ohci_hcd 0000:00:13.0: suspend root hub
[  242.450451] ohci_hcd 0000:00:13.1: OHCI controller state
[  242.450455] ohci_hcd 0000:00:13.1: OHCI 1.0, NO legacy support registers
[  242.450459] ohci_hcd 0000:00:13.1: control 0x083 HCFS=operational CBSR=3
[  242.450463] ohci_hcd 0000:00:13.1: cmdstatus 0x00000 SOC=0
[  242.450467] ohci_hcd 0000:00:13.1: intrstatus 0x00000004 SF
[  242.450471] ohci_hcd 0000:00:13.1: intrenable 0x8000005a MIE RHSC UE RD WDH
[  242.450479] ohci_hcd 0000:00:13.1: hcca frame #0005
[  242.450484] ohci_hcd 0000:00:13.1: roothub.a 02000203 POTPGT=2 NPS NDP=3(3)
[  242.450488] ohci_hcd 0000:00:13.1: roothub.b 00000000 PPCM=0000 DR=0000
[  242.450492] ohci_hcd 0000:00:13.1: roothub.status 00008000 DRWE
[  242.450496] ohci_hcd 0000:00:13.1: roothub.portstatus [0] 0x00000100 PPS
[  242.450500] ohci_hcd 0000:00:13.1: roothub.portstatus [1] 0x00000100 PPS
[  242.450504] ohci_hcd 0000:00:13.1: roothub.portstatus [2] 0x00000100 PPS
[  242.450507] ohci_hcd 0000:00:13.1: restart complete
[  242.450509] usb usb3: root hub lost power or was reset
[  242.450513] ohci_hcd 0000:00:13.1: suspend root hub
[  242.480589] ohci_hcd 0000:02:07.0: OHCI controller state
[  242.480593] ohci_hcd 0000:02:07.0: OHCI 1.0, NO legacy support registers
[  242.480597] ohci_hcd 0000:02:07.0: control 0x283 RWC HCFS=operational CBSR=3
[  242.480601] ohci_hcd 0000:02:07.0: cmdstatus 0x00000 SOC=0
[  242.480605] ohci_hcd 0000:02:07.0: intrstatus 0x00000004 SF
[  242.480609] ohci_hcd 0000:02:07.0: intrenable 0x8000005a MIE RHSC UE RD WDH
[  242.480616] ohci_hcd 0000:02:07.0: hcca frame #001f
[  242.480620] ohci_hcd 0000:02:07.0: roothub.a 0f000203 POTPGT=15 NPS NDP=3(3)
[  242.480624] ohci_hcd 0000:02:07.0: roothub.b 00000000 PPCM=0000 DR=0000
[  242.480627] ohci_hcd 0000:02:07.0: roothub.status 00008000 DRWE
[  242.480632] ohci_hcd 0000:02:07.0: roothub.portstatus [0] 0x00000100 PPS
[  242.480636] ohci_hcd 0000:02:07.0: roothub.portstatus [1] 0x00000100 PPS
[  242.480640] ohci_hcd 0000:02:07.0: roothub.portstatus [2] 0x00000100 PPS
[  242.480642] ohci_hcd 0000:02:07.0: restart complete
[  242.480645] usb usb4: root hub lost power or was reset
[  242.480648] ohci_hcd 0000:02:07.0: suspend root hub
[  242.510670] ohci_hcd 0000:02:07.1: OHCI controller state
[  242.510674] ohci_hcd 0000:02:07.1: OHCI 1.0, NO legacy support registers
[  242.510678] ohci_hcd 0000:02:07.1: control 0x283 RWC HCFS=operational CBSR=3
[  242.510682] ohci_hcd 0000:02:07.1: cmdstatus 0x00000 SOC=0
[  242.510686] ohci_hcd 0000:02:07.1: intrstatus 0x00000004 SF
[  242.510689] ohci_hcd 0000:02:07.1: intrenable 0x8000005a MIE RHSC UE RD WDH
[  242.510696] ohci_hcd 0000:02:07.1: hcca frame #001f
[  242.510700] ohci_hcd 0000:02:07.1: roothub.a 0f000202 POTPGT=15 NPS NDP=2(2)
[  242.510704] ohci_hcd 0000:02:07.1: roothub.b 00000000 PPCM=0000 DR=0000
[  242.510708] ohci_hcd 0000:02:07.1: roothub.status 00008000 DRWE
[  242.510712] ohci_hcd 0000:02:07.1: roothub.portstatus [0] 0x00000100 PPS
[  242.510716] ohci_hcd 0000:02:07.1: roothub.portstatus [1] 0x00000100 PPS
[  242.510718] ohci_hcd 0000:02:07.1: restart complete
[  242.510721] usb usb5: root hub lost power or was reset
[  242.510724] ohci_hcd 0000:02:07.1: suspend root hub
[  242.510778] firewire_core: skipped bus generations, destroying all nodes
[  242.510792] usb usb2: usb resume
[  242.510797] ohci_hcd 0000:00:13.0: resume root hub
[  242.510803] usb usb3: usb resume
[  242.510807] ohci_hcd 0000:00:13.1: resume root hub
[  242.510818] usb usb1: root hub lost power or was reset
[  242.510826] ehci_hcd 0000:02:07.2: reset command 0010006 (park)=0 ithresh=1 period=512 Reset HALT
[  242.510834] ehci_hcd 0000:02:07.2: MWI active
[  242.510840] ehci_hcd 0000:02:07.2: ...powerup ports...
[  242.510856] usb usb4: usb resume
[  242.510860] ohci_hcd 0000:02:07.0: wakeup root hub
[  242.510865] usb usb5: usb resume
[  242.541947] ohci_hcd 0000:02:07.1: resume root hub
[  242.541956] usb usb1: usb resume
[  242.541960] ehci_hcd 0000:02:07.2: resume root hub after power loss
[  242.570028] hub 3-0:1.0: hub_reset_resume
[  242.570032] hub 3-0:1.0: trying to enable port power on non-switchable hub
[  242.570045] hub 2-0:1.0: hub_reset_resume
[  242.570047] hub 2-0:1.0: trying to enable port power on non-switchable hub
[  242.570054] hub 4-0:1.0: hub_reset_resume
[  242.570057] hub 4-0:1.0: trying to enable port power on non-switchable hub
[  242.571026] ehci_hcd 0000:02:07.2: port 2 low speed --> companion
[  242.601023] hub 5-0:1.0: hub_reset_resume
[  242.601026] hub 5-0:1.0: trying to enable port power on non-switchable hub
[  242.662162] ehci_hcd 0000:02:07.2: port 3 full speed --> companion
[  242.662170] ehci_hcd 0000:02:07.2: GetStatus port:3 status 003801 0  ACK POWER OWNER sig=j CONNECT
[  242.662192] ehci_hcd 0000:02:07.2: GetStatus port:2 status 003402 0  ACK POWER OWNER sig=k CSC
[  242.671059] ohci_hcd 0000:02:07.0: GetStatus roothub.portstatus [1] = 0x00010101 CSC PPS CCS
[  242.671064] hub 4-0:1.0: port 2: status 0101 change 0001
[  242.673022] hub 1-0:1.0: hub_reset_resume
[  242.673025] hub 1-0:1.0: enabling power on all ports
[  242.702027] ohci_hcd 0000:02:07.1: GetStatus roothub.portstatus [0] = 0x00010301 CSC LSDA PPS CCS
[  242.702032] hub 5-0:1.0: port 1: status 0301 change 0001
[  242.743895] i8042 kbd 00:05: wake-up capability disabled by ACPI
[  242.746578] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[  242.751037] hda: UDMA/100 mode selected
[  242.774059] usb 4-2: reset-resume
[  242.803444] usb 5-1: reset-resume
[  242.836028] ohci_hcd 0000:02:07.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
[  242.887035] usb 4-2: reset full speed USB device number 3 using ohci_hcd
[  242.951026] ohci_hcd 0000:02:07.0: GetStatus roothub.portstatus [1] = 0x00100103 PRSC PPS PES CCS
[  243.011046] firewire_core: rediscovered device fw0
[  243.024045] pl2303 4-2:1.0: no reset_resume for driver pl2303?
[  243.024047] pl2303 4-2:1.0: forced unbind
[  243.024165] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[  243.024180] pl2303 4-2:1.0: device disconnected
[  243.230025] ohci_hcd 0000:02:07.1: GetStatus roothub.portstatus [0] = 0x00100303 PRSC LSDA PPS PES CCS
[  243.281032] usb 5-1: reset low speed USB device number 2 using ohci_hcd
[  243.494027] ohci_hcd 0000:02:07.1: GetStatus roothub.portstatus [0] = 0x00100303 PRSC LSDA PPS PES CCS
[  243.574073] PM: restore of devices complete after 1254.411 msecs
[  243.574095] pl2303 4-2:1.0: usb_probe_interface
[  243.574098] pl2303 4-2:1.0: usb_probe_interface - got id
[  243.574104] pl2303 4-2:1.0: pl2303 converter detected
[  243.606085] usb 4-2: pl2303 converter now attached to ttyUSB0
[  243.606236] PM: Image restored successfully.
[  243.606239] Restarting tasks ... done.
[  243.606443] PM: Basic memory bitmaps freed
[  243.606452] video LNXVIDEO:00: Restoring backlight state
[  243.606484] hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0000
[  243.606489] hub 2-0:1.0: state 7 ports 3 chg 0000 evt 0000
[  243.606493] hub 4-0:1.0: state 7 ports 3 chg 0004 evt 0004
[  243.606502] hub 4-0:1.0: port 2, status 0103, change 0000, 12 Mb/s
[  243.606507] hub 1-0:1.0: state 7 ports 5 chg 0000 evt 0000
[  243.606510] hub 5-0:1.0: state 7 ports 2 chg 0002 evt 0002
[  243.606515] hub 5-0:1.0: port 1, status 0303, change 0000, 1.5 Mb/s
[  243.626231] radeon 0000:01:05.0: GPU lockup CP stall for more than 82318msec
[  243.626236] ------------[ cut here ]------------
[  243.626252] WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:246 radeon_fence_wait+0x2c3/0x311()
[  243.626256] Hardware name: Pavilion zv5000
[  243.626259] GPU lockup (waiting for 0x00000F8C last fence id 0x00000F8A)
[  243.626262] Modules linked in: fan snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss fuse pl2303 snd_atiixp snd_ac97_codec ac97_bus snd_pcm pcmcia snd_timer snd ohci_hcd shpchp processor yenta_socket pcmcia_rsrc ssb video thermal wmi battery button ac ehci_hcd thermal_sys pcmcia_core firewire_ohci snd_page_alloc
[  243.626311] Pid: 1646, comm: X Tainted: G   M        2.6.39.4 #19
[  243.626314] Call Trace:
[  243.626325]  [<c1033164>] warn_slowpath_common+0x67/0x8e
[  243.626331]  [<c12c082a>] ? radeon_fence_wait+0x2c3/0x311
[  243.626335]  [<c12c082a>] ? radeon_fence_wait+0x2c3/0x311
[  243.626339]  [<c1033207>] warn_slowpath_fmt+0x2e/0x30
[  243.626344]  [<c12c082a>] radeon_fence_wait+0x2c3/0x311
[  243.626352]  [<c104b12a>] ? wake_up_bit+0x62/0x62
[  243.626358]  [<c12c0e37>] radeon_sync_obj_wait+0xc/0xe
[  243.626363]  [<c12908be>] ttm_bo_wait+0xa1/0x108
[  243.626371]  [<c12d6e7b>] radeon_gem_wait_idle_ioctl+0x76/0xc4
[  243.626378]  [<c127e62e>] drm_ioctl+0x1c2/0x42c
[  243.626383]  [<c12d6e05>] ? radeon_gem_set_tiling_ioctl+0x8e/0x8e
[  243.626389]  [<c109ad9a>] ? perf_pmu_enable+0x1a/0x21
[  243.626395]  [<c1026eed>] ? update_curr+0x164/0x24d
[  243.626403]  [<c11f5171>] ? rb_erase+0x16e/0x27a
[  243.626411]  [<c1007ba8>] ? __switch_to_xtra+0xf7/0x11d
[  243.626417]  [<c103015e>] ? set_next_entity+0xad/0xc1
[  243.626422]  [<c127e46c>] ? drm_version+0x8a/0x8a
[  243.626428]  [<c10e288e>] do_vfs_ioctl+0x79/0x54b
[  243.626436]  [<c158c95a>] ? schedule+0x29a/0x614
[  243.626441]  [<c10e2dcb>] sys_ioctl+0x6b/0x70
[  243.626446]  [<c1593813>] sysenter_do_call+0x12/0x22
[  243.626449] ---[ end trace 17a119d9361222c9 ]---
[  243.633615] radeon 0000:01:05.0: GPU reset succeed
[  243.671128] radeon 0000:01:05.0: WB disabled
[  243.671170] [drm] radeon: ring at 0x00000000D2001000
[  243.671189] [drm] ring test succeeded in 0 usecs
[  243.671200] [drm] ib test succeeded in 1 usecs
[  243.704033] ohci_hcd 0000:00:13.1: auto-stop root hub
[  243.704048] ohci_hcd 0000:00:13.0: auto-stop root hub

--eJnRUKwClWJh1Khz--
