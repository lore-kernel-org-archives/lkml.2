Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab1DLI1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 04:27:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37256 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1DLI1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 04:27:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MWnkqmmTYNy6GjJ2LUZu4zVEOkdhlmJz/DDRzOIKcHK+03PG8JTmIV5JdAZUSoHyTw
         vUdVf13sNlu7Bkc9o6h5fJ/8RJwF/Y61BWfOUAbT82m+eCL6qLrfjR0J9lEf3x+tukHl
         kKGMI1DU3vIUSHUmpkE6Q2MoMF0BAk4UiAlzE=
Date: Tue, 12 Apr 2011 11:28:06 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: suspend/resume stopped working
Message-ID: <20110412082806.GA4333@swordfish.minsk.epam.com>
References: <20110411210228.GB4227@swordfish>
 <20110411214945.GA7495@dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20110411214945.GA7495@dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On (04/11/11 17:49), Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 12, 2011 at 12:02:28AM +0300, Sergey Senozhatsky wrote:
> > Hello,
> > Aborting (Ctrl-Brake) suspend to disk process (s2disk) brakes drm/radeo=
n.
>=20
> Can you try to revert 69a07f0b117a40fcc1a479358d8e1f41793617f2 just to see
> if that is the culprit.
>


No, seems this is not the case:

[  187.664959] snapshot_ioctl: ioctl '80083307' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  187.664973] Syncing filesystems ... done.
[  187.924511] Freezing user space processes ... (elapsed 0.01 seconds) don=
e.
[  187.936806] Freezing remaining freezable tasks ... (elapsed 0.01 seconds=
) done.
[  187.950171] snapshot_ioctl: ioctl '4004330c' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  187.950279] snapshot_ioctl: ioctl '40083306' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  187.950286] snapshot_ioctl: ioctl '40083303' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  187.950387] PM: Preallocating image memory... done (allocated 111404 pag=
es)
[  188.090274] PM: Allocated 445616 kbytes in 0.14 seconds (3182.97 MB/s)
[  188.090276] Suspending console(s) (use no_console_suspend to debug)
[  188.092488] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  188.093460] HDA Intel 0000:01:00.1: PCI INT B disabled
[  188.093735] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  188.431250] PM: freeze of devices complete after 340.164 msecs
[  188.432394] PM: late freeze of devices complete after 1.138 msecs
[  188.432631] ACPI: Preparing to enter system sleep state S4
[  188.459387] PM: Saving platform NVS memory
[  188.465680] Disabling non-boot CPUs ...
[  188.514554] CPU 1 is now offline
[  188.668819] CPU 2 is now offline
[  188.791921] CPU 3 is now offline
[  188.791925] lockdep: fixing up alternatives.
[  188.792860] Extended CMOS year: 2000
[  188.793031] PM: Creating hibernation image:
[  188.942484] PM: Need to copy 115235 pages
[  189.583797] PM: Hibernation image created (115235 pages copied)
[  188.793588] Extended CMOS year: 2000
[  188.794138] microcode: CPU0 updated to revision 0xc, date =3D 2010-06-10
[  188.794167] Enabling non-boot CPUs ...
[  188.801437] lockdep: fixing up alternatives.
[  188.801450] Booting Node 0 Processor 1 APIC 0x1
[  188.801455] smpboot cpu 1: start_ip =3D 98000
[  188.919038] Switched to NOHz mode on CPU #1
[  188.960028] NMI watchdog enabled, takes one hw-pmu counter.
[  188.960917] microcode: CPU1 updated to revision 0xc, date =3D 2010-06-10
[  188.960932] CPU1 is up
[  188.961183] lockdep: fixing up alternatives.
[  188.961188] Booting Node 0 Processor 2 APIC 0x4
[  188.961190] smpboot cpu 2: start_ip =3D 98000
[  189.078785] Switched to NOHz mode on CPU #2
[  189.119907] NMI watchdog enabled, takes one hw-pmu counter.
[  189.121519] microcode: CPU2 updated to revision 0xc, date =3D 2010-06-10
[  189.121538] CPU2 is up
[  189.122009] lockdep: fixing up alternatives.
[  189.122072] Booting Node 0 Processor 3 APIC 0x5
[  189.122076] smpboot cpu 3: start_ip =3D 98000
[  189.238541] Switched to NOHz mode on CPU #3
[  189.280097] NMI watchdog enabled, takes one hw-pmu counter.
[  189.281622] microcode: CPU3 updated to revision 0xc, date =3D 2010-06-10
[  189.281641] CPU3 is up
[  189.284963] ACPI: Waking up from system sleep state S4
[  189.358433] PM: early thaw of devices complete after 0.778 msecs
[  189.358884] pci 0000:00:1e.0: setting latency timer to 64
[  189.358966] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00403, writing 0x2b00407)
[  189.359008] radeon 0000:01:00.0: power state changed by ACPI to D0
[  189.359017] radeon 0000:01:00.0: power state changed by ACPI to D0
[  189.359043] ahci 0000:00:1f.2: setting latency timer to 64
[  189.359115] radeon 0000:01:00.0: setting latency timer to 64
[  189.360927] tg3 0000:02:00.0: eth0: Link is down
[  189.368514] sd 0:0:0:0: [sda] Starting disk
[  189.371631] HDA Intel 0000:00:1b.0: BAR 0: set to [mem 0xb4100000-0xb410=
3fff 64bit] (PCI address [0xb4100000-0xb4103fff])
[  189.371683] HDA Intel 0000:00:1b.0: restoring config space at offset 0xf=
 (was 0x100, writing 0x10a)
[  189.371738] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3=
 (was 0x0, writing 0x10)
[  189.371756] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100000, writing 0x100002)
[  189.371820] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> =
IRQ 22
[  189.371838] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  189.371901] HDA Intel 0000:01:00.1: BAR 0: set to [mem 0xb4020000-0xb402=
3fff 64bit] (PCI address [0xb4020000-0xb4023fff])
[  189.371968] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[  189.372066] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[  189.372083] HDA Intel 0000:01:00.1: setting latency timer to 64
[  189.372183] HDA Intel 0000:01:00.1: irq 44 for MSI/MSI-X
[  189.388906] radeon 0000:01:00.0: WB enabled
[  189.405421] [drm] ring test succeeded in 0 usecs
[  189.405492] [drm] ib test succeeded in 0 usecs
[  189.677756] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  189.684411] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  189.688617] ata1.00: configured for UDMA/133
[  189.712515] ata2.00: configured for UDMA/100
[  191.462224] PM: thaw of devices complete after 2107.311 msecs
[  191.463396] snapshot_ioctl: ioctl '80083308' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  191.463529] snapshot_ioctl: ioctl '80083307' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  191.463641] snapshot_ioctl: ioctl '80083308' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  191.463651] snapshot_ioctl: ioctl '80083308' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  191.463995] snapshot_ioctl: ioctl '80083308' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  191.464125] snapshot_ioctl: ioctl '80083308' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  192.729019] Restarting tasks ... done.
[  207.645904] radeon 0000:01:00.0: GPU lockup CP stall for more than 10000=
msec
[  207.645909] ------------[ cut here ]------------
[  207.645921] WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:246 radeon=
_fence_wait+0x3c9/0x4a7()
[  207.645925] Hardware name: Aspire 5741G   =20
[  207.645928] GPU lockup (waiting for 0x0000033A last fence id 0x00000338)
[  207.645931] Modules linked in: microcode snd_seq_dummy snd_seq_oss snd_s=
eq_midi_event snd_seq snd_seq_device snd_hwdep snd_hda_codec_hdmi snd_hda_c=
odec_realtek snd_pcm_oss snd_hda_intel snd_hda_codec snd_pcm sparse_keymap =
ac snd_timer
snd_page_alloc wmi snd_mixer_oss button battery psmouse snd broadcom tg3 li=
bphy evdev soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci
[  207.645987] Pid: 3729, comm: X Not tainted 2.6.39-rc3-dbg-00380-ge2d16b4=
-dirty #521
[  207.645990] Call Trace:
[  207.646001]  [<ffffffff8103e2ac>] warn_slowpath_common+0x7e/0x96
[  207.646007]  [<ffffffff8103e358>] warn_slowpath_fmt+0x41/0x43
[  207.646013]  [<ffffffff81306686>] radeon_fence_wait+0x3c9/0x4a7
[  207.646021]  [<ffffffff8105cb72>] ? __init_waitqueue_head+0x46/0x46
[  207.646027]  [<ffffffff81306c75>] radeon_sync_obj_wait+0xc/0xe
[  207.646035]  [<ffffffff812d98d8>] ttm_bo_wait+0xb8/0x174
[  207.646043]  [<ffffffff8131a332>] radeon_gem_wait_idle_ioctl+0x7c/0xee
[  207.646050]  [<ffffffff812c6942>] drm_ioctl+0x29f/0x381
[  207.646055]  [<ffffffff8131a2b6>] ? radeon_gem_busy_ioctl+0x114/0x114
[  207.646064]  [<ffffffff810706d4>] ? trace_hardirqs_on_caller+0x10d/0x131
[  207.646069]  [<ffffffff81070705>] ? trace_hardirqs_on+0xd/0xf
[  207.646078]  [<ffffffff810e5de0>] ? remove_vma+0x57/0x5f
[  207.646084]  [<ffffffff81113f83>] do_vfs_ioctl+0x46c/0x4ad
[  207.646091]  [<ffffffff811057ef>] ? fget_light+0x11f/0x30b
[  207.646098]  [<ffffffff81477d4a>] ? sysret_check+0x2e/0x69
[  207.646103]  [<ffffffff81114015>] sys_ioctl+0x51/0x74
[  207.646109]  [<ffffffff81477d12>] system_call_fastpath+0x16/0x1b
[  207.646113] ---[ end trace 2090fe895342aa04 ]---
[  207.647421] radeon 0000:01:00.0: GPU softreset=20
[  207.647425] radeon 0000:01:00.0:   GRBM_STATUS=3D0xB2703828
[  207.647429] radeon 0000:01:00.0:   GRBM_STATUS_SE0=3D0x1C000007
[  207.647432] radeon 0000:01:00.0:   GRBM_STATUS_SE1=3D0x00000007
[  207.647436] radeon 0000:01:00.0:   SRBM_STATUS=3D0x200000C0
[  207.647496] radeon 0000:01:00.0:   GRBM_SOFT_RESET=3D0x00007F6B
[  207.647601] radeon 0000:01:00.0:   GRBM_STATUS=3D0x00003828
[  207.647605] radeon 0000:01:00.0:   GRBM_STATUS_SE0=3D0x00000007
[  207.647608] radeon 0000:01:00.0:   GRBM_STATUS_SE1=3D0x00000007
[  207.647612] radeon 0000:01:00.0:   SRBM_STATUS=3D0x200000C0
[  207.648623] radeon 0000:01:00.0: GPU reset succeed
[  207.670209] radeon 0000:01:00.0: WB enabled
[  207.686710] [drm] ring test succeeded in 1 usecs
[  207.686758] [drm] ib test succeeded in 1 usecs
[  219.558069] radeon 0000:01:00.0: GPU lockup CP stall for more than 10020=
msec
[  219.558074] ------------[ cut here ]------------
[  219.558085] WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:246 radeon=
_fence_wait+0x3c9/0x4a7()
[  219.558090] Hardware name: Aspire 5741G   =20
[  219.558093] GPU lockup (waiting for 0x0000033C last fence id 0x0000033B)
[  219.558096] Modules linked in: microcode snd_seq_dummy snd_seq_oss snd_s=
eq_midi_event snd_seq snd_seq_device snd_hwdep snd_hda_codec_hdmi snd_hda_c=
odec_realtek snd_pcm_oss snd_hda_intel snd_hda_codec snd_pcm sparse_keymap =
ac snd_timer
snd_page_alloc wmi snd_mixer_oss button battery psmouse snd broadcom tg3 li=
bphy evdev soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci
[  219.558151] Pid: 3729, comm: X Tainted: G        W   2.6.39-rc3-dbg-0038=
0-ge2d16b4-dirty #521
[  219.558154] Call Trace:
[  219.558164]  [<ffffffff8103e2ac>] warn_slowpath_common+0x7e/0x96
[  219.558170]  [<ffffffff8103e358>] warn_slowpath_fmt+0x41/0x43
[  219.558177]  [<ffffffff81306686>] radeon_fence_wait+0x3c9/0x4a7
[  219.558185]  [<ffffffff8105cb72>] ? __init_waitqueue_head+0x46/0x46
[  219.558191]  [<ffffffff81306c75>] radeon_sync_obj_wait+0xc/0xe
[  219.558198]  [<ffffffff812d98d8>] ttm_bo_wait+0xb8/0x174
[  219.558206]  [<ffffffff8131a332>] radeon_gem_wait_idle_ioctl+0x7c/0xee
[  219.558213]  [<ffffffff812c6942>] drm_ioctl+0x29f/0x381
[  219.558219]  [<ffffffff8131a2b6>] ? radeon_gem_busy_ioctl+0x114/0x114
[  219.558227]  [<ffffffff8106f9df>] ? lock_release_non_nested+0x91/0x247
[  219.558235]  [<ffffffff81001cee>] ? sys_rt_sigreturn+0x86/0x21c
[  219.558241]  [<ffffffff81001cee>] ? sys_rt_sigreturn+0x86/0x21c
[  219.558247]  [<ffffffff81113f83>] do_vfs_ioctl+0x46c/0x4ad
[  219.558253]  [<ffffffff811057ef>] ? fget_light+0x11f/0x30b
[  219.558259]  [<ffffffff81471ebd>] ? retint_swapgs+0x13/0x1b
[  219.558264]  [<ffffffff81114015>] sys_ioctl+0x51/0x74
[  219.558270]  [<ffffffff81477d12>] system_call_fastpath+0x16/0x1b
[  219.558275] ---[ end trace 2090fe895342aa05 ]---
[  219.559580] radeon 0000:01:00.0: GPU softreset=20
[  219.559585] radeon 0000:01:00.0:   GRBM_STATUS=3D0xB2703828
[  219.559588] radeon 0000:01:00.0:   GRBM_STATUS_SE0=3D0x1C000007
[  219.559592] radeon 0000:01:00.0:   GRBM_STATUS_SE1=3D0x00000007
[  219.559596] radeon 0000:01:00.0:   SRBM_STATUS=3D0x200000C0
[  219.559656] radeon 0000:01:00.0:   GRBM_SOFT_RESET=3D0x00007F6B
[  219.559761] radeon 0000:01:00.0:   GRBM_STATUS=3D0x00003828
[  219.559765] radeon 0000:01:00.0:   GRBM_STATUS_SE0=3D0x00000007
[  219.559768] radeon 0000:01:00.0:   GRBM_STATUS_SE1=3D0x00000007
[  219.559772] radeon 0000:01:00.0:   SRBM_STATUS=3D0x200000C0
[  219.560783] radeon 0000:01:00.0: GPU reset succeed
[  219.582354] radeon 0000:01:00.0: WB enabled
[  219.598842] [drm] ring test succeeded in 1 usecs
[  219.598853] [drm] ib test succeeded in 1 usecs
[  231.773092] radeon 0000:01:00.0: GPU lockup CP stall for more than 10020=
msec
[  231.773096] ------------[ cut here ]------------
[  231.773108] WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:246 radeon=
_fence_wait+0x3c9/0x4a7()
[  231.773112] Hardware name: Aspire 5741G   =20
[  231.773115] GPU lockup (waiting for 0x00000342 last fence id 0x00000341)
[  231.773118] Modules linked in: microcode snd_seq_dummy snd_seq_oss snd_s=
eq_midi_event snd_seq snd_seq_device snd_hwdep snd_hda_codec_hdmi snd_hda_c=
odec_realtek snd_pcm_oss snd_hda_intel snd_hda_codec snd_pcm sparse_keymap =
ac snd_timer
snd_page_alloc wmi snd_mixer_oss button battery psmouse snd broadcom tg3 li=
bphy evdev soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci
[  231.773176] Pid: 3729, comm: X Tainted: G        W   2.6.39-rc3-dbg-0038=
0-ge2d16b4-dirty #521
[  231.773180] Call Trace:
[  231.773191]  [<ffffffff8103e2ac>] warn_slowpath_common+0x7e/0x96
[  231.773197]  [<ffffffff8103e358>] warn_slowpath_fmt+0x41/0x43
[  231.773203]  [<ffffffff81306686>] radeon_fence_wait+0x3c9/0x4a7
[  231.773211]  [<ffffffff8105cb72>] ? __init_waitqueue_head+0x46/0x46
[  231.773217]  [<ffffffff81306c75>] radeon_sync_obj_wait+0xc/0xe
[  231.773225]  [<ffffffff812d98d8>] ttm_bo_wait+0xb8/0x174
[  231.773233]  [<ffffffff8131a332>] radeon_gem_wait_idle_ioctl+0x7c/0xee
[  231.773240]  [<ffffffff812c6942>] drm_ioctl+0x29f/0x381
[  231.773246]  [<ffffffff8131a2b6>] ? radeon_gem_busy_ioctl+0x114/0x114
[  231.773255]  [<ffffffff8106f9df>] ? lock_release_non_nested+0x91/0x247
[  231.773262]  [<ffffffff81001cee>] ? sys_rt_sigreturn+0x86/0x21c
[  231.773268]  [<ffffffff81001cee>] ? sys_rt_sigreturn+0x86/0x21c
[  231.773275]  [<ffffffff81113f83>] do_vfs_ioctl+0x46c/0x4ad
[  231.773282]  [<ffffffff811057ef>] ? fget_light+0x11f/0x30b
[  231.773288]  [<ffffffff81471ebd>] ? retint_swapgs+0x13/0x1b
[  231.773293]  [<ffffffff81114015>] sys_ioctl+0x51/0x74
[  231.773301]  [<ffffffff81477d12>] system_call_fastpath+0x16/0x1b
[  231.773305] ---[ end trace 2090fe895342aa06 ]---
[  188.801455] smpboot cpu 1: start_ip =3D 98000
[  188.919038] Switched to NOHz mode on CPU #1
[  188.960028] NMI watchdog enabled, takes one hw-pmu counter.
[  188.960917] microcode: CPU1 updated to revision 0xc, date =3D 2010-06-10
[  188.960932] CPU1 is up
[  188.961183] lockdep: fixing up alternatives.
[  188.961188] Booting Node 0 Processor 2 APIC 0x4
[  188.961190] smpboot cpu 2: start_ip =3D 98000
[  189.078785] Switched to NOHz mode on CPU #2
[  189.119907] NMI watchdog enabled, takes one hw-pmu counter.
[  189.121519] microcode: CPU2 updated to revision 0xc, date =3D 2010-06-10
[  189.121538] CPU2 is up
[  189.122009] lockdep: fixing up alternatives.
[  189.122072] Booting Node 0 Processor 3 APIC 0x5
[  189.122076] smpboot cpu 3: start_ip =3D 98000
[  189.238541] Switched to NOHz mode on CPU #3
[  189.280097] NMI watchdog enabled, takes one hw-pmu counter.
[  189.281622] microcode: CPU3 updated to revision 0xc, date =3D 2010-06-10
[  189.281641] CPU3 is up
[  189.284963] ACPI: Waking up from system sleep state S4
[  189.358433] PM: early thaw of devices complete after 0.778 msecs
[  189.358884] pci 0000:00:1e.0: setting latency timer to 64
[  189.358966] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was=
 0x2b00403, writing 0x2b00407)
[  189.359008] radeon 0000:01:00.0: power state changed by ACPI to D0
[  189.359017] radeon 0000:01:00.0: power state changed by ACPI to D0
[  189.359043] ahci 0000:00:1f.2: setting latency timer to 64
[  189.359115] radeon 0000:01:00.0: setting latency timer to 64
[  189.360927] tg3 0000:02:00.0: eth0: Link is down
[  189.368514] sd 0:0:0:0: [sda] Starting disk
[  189.371631] HDA Intel 0000:00:1b.0: BAR 0: set to [mem 0xb4100000-0xb410=
3fff 64bit] (PCI address [0xb4100000-0xb4103fff])
[  189.371683] HDA Intel 0000:00:1b.0: restoring config space at offset 0xf=
 (was 0x100, writing 0x10a)
[  189.371738] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3=
 (was 0x0, writing 0x10)
[  189.371756] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1=
 (was 0x100000, writing 0x100002)
[  189.371820] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> =
IRQ 22
[  189.371838] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  189.371901] HDA Intel 0000:01:00.1: BAR 0: set to [mem 0xb4020000-0xb402=
3fff 64bit] (PCI address [0xb4020000-0xb4023fff])
[  189.371968] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
[  189.372066] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> =
IRQ 17
[  189.372083] HDA Intel 0000:01:00.1: setting latency timer to 64
[  189.372183] HDA Intel 0000:01:00.1: irq 44 for MSI/MSI-X
[  189.388906] radeon 0000:01:00.0: WB enabled
[  189.405421] [drm] ring test succeeded in 0 usecs
[  189.405492] [drm] ib test succeeded in 0 usecs
[  189.677756] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  189.684411] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  189.688617] ata1.00: configured for UDMA/133
[  189.712515] ata2.00: configured for UDMA/100
[  191.462224] PM: thaw of devices complete after 2107.311 msecs
[  191.463396] snapshot_ioctl: ioctl '80083308' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  191.463529] snapshot_ioctl: ioctl '80083307' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  191.463641] snapshot_ioctl: ioctl '80083308' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  191.463651] snapshot_ioctl: ioctl '80083308' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  191.463995] snapshot_ioctl: ioctl '80083308' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  191.464125] snapshot_ioctl: ioctl '80083308' is deprecated and will be r=
emoved soon, update your suspend-to-disk utilities
[  192.729019] Restarting tasks ... done.
[  207.645904] radeon 0000:01:00.0: GPU lockup CP stall for more than 10000=
msec
[  207.645909] ------------[ cut here ]------------
[  207.645921] WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:246 radeon=
_fence_wait+0x3c9/0x4a7()
[  207.645925] Hardware name: Aspire 5741G   =20
[  207.645928] GPU lockup (waiting for 0x0000033A last fence id 0x00000338)
[  207.645931] Modules linked in: microcode snd_seq_dummy snd_seq_oss snd_s=
eq_midi_event snd_seq snd_seq_device snd_hwdep snd_hda_codec_hdmi snd_hda_c=
odec_realtek snd_pcm_oss snd_hda_intel snd_hda_codec snd_pcm sparse_keymap =
ac snd_timer
snd_page_alloc wmi snd_mixer_oss button battery psmouse snd broadcom tg3 li=
bphy evdev soundcore ehci_hcd sr_mod usbcore cdrom sd_mod ahci
[  207.645987] Pid: 3729, comm: X Not tainted 2.6.39-rc3-dbg-00380-ge2d16b4=
-dirty #521
[  207.645990] Call Trace:
[  207.646001]  [<ffffffff8103e2ac>] warn_slowpath_common+0x7e/0x96
[  207.646007]  [<ffffffff8103e358>] warn_slowpath_fmt+0x41/0x43
[  207.646013]  [<ffffffff81306686>] radeon_fence_wait+0x3c9/0x4a7
[  207.646021]  [<ffffffff8105cb72>] ? __init_waitqueue_head+0x46/0x46
[  207.646027]  [<ffffffff81306c75>] radeon_sync_obj_wait+0xc/0xe
[  207.646035]  [<ffffffff812d98d8>] ttm_bo_wait+0xb8/0x174
[  207.646043]  [<ffffffff8131a332>] radeon_gem_wait_idle_ioctl+0x7c/0xee
[  207.646050]  [<ffffffff812c6942>] drm_ioctl+0x29f/0x381
[  207.646055]  [<ffffffff8131a2b6>] ? radeon_gem_busy_ioctl+0x114/0x114
[  207.646064]  [<ffffffff810706d4>] ? trace_hardirqs_on_caller+0x10d/0x131
[  207.646069]  [<ffffffff81070705>] ? trace_hardirqs_on+0xd/0xf
[  207.646078]  [<ffffffff810e5de0>] ? remove_vma+0x57/0x5f
[  207.646084]  [<ffffffff81113f83>] do_vfs_ioctl+0x46c/0x4ad
[  207.646091]  [<ffffffff811057ef>] ? fget_light+0x11f/0x30b
[  207.646098]  [<ffffffff81477d4a>] ? sysret_check+0x2e/0x69
[  207.646103]  [<ffffffff81114015>] sys_ioctl+0x51/0x74
[  207.646109]  [<ffffffff81477d12>] system_call_fastpath+0x16/0x1b
[  207.646113] ---[ end trace 2090fe895342aa04 ]---
[  207.647421] radeon 0000:01:00.0: GPU softreset=20
[  207.647425] radeon 0000:01:00.0:   GRBM_STATUS=3D0xB2703828
[  207.647429] radeon 0000:01:00.0:   GRBM_STATUS_SE0=3D0x1C000007
[  207.647432] radeon 0000:01:00.0:   GRBM_STATUS_SE1=3D0x00000007
[  207.647436] radeon 0000:01:00.0:   SRBM_STATUS=3D0x200000C0
[  207.647496] radeon 0000:01:00.0:   GRBM_SOFT_RESET=3D0x00007F6B
[  207.647601] radeon 0000:01:00.0:   GRBM_STATUS=3D0x00003828
[  207.647605] radeon 0000:01:00.0:   GRBM_STATUS_SE0=3D0x00000007
[  207.647608] radeon 0000:01:00.0:   GRBM_STATUS_SE1=3D0x00000007
[  207.647612] radeon 0000:01:00.0:   SRBM_STATUS=3D0x200000C0
[  207.648623] radeon 0000:01:00.0: GPU reset succeed
[  207.670209] radeon 0000:01:00.0: WB enabled
[  207.686710] [drm] ring test succeeded in 1 usecs
[  207.686758] [drm] ib test succeeded in 1 usecs
[  219.558069] radeon 0000:01:00.0: GPU lockup CP stall for more than 10020=
msec



	Sergey
=20

> > Please see the logs below:
> >=20
> > [..]
> > [  130.722206] snapshot_ioctl: ioctl '80083307' is deprecated and will =
be removed soon, update your suspend-to-disk utilities
> > [  130.722220] Syncing filesystems ... done.
> > [  131.022029] Freezing user space processes ... (elapsed 0.01 seconds)=
 done.
> > [  131.034312] Freezing remaining freezable tasks ... (elapsed 0.01 sec=
onds) done.
> > [  131.047640] snapshot_ioctl: ioctl '4004330c' is deprecated and will =
be removed soon, update your suspend-to-disk utilities
> > [  131.047752] snapshot_ioctl: ioctl '40083306' is deprecated and will =
be removed soon, update your suspend-to-disk utilities
> > [  131.047759] snapshot_ioctl: ioctl '40083303' is deprecated and will =
be removed soon, update your suspend-to-disk utilities
> > [  131.047871] PM: Preallocating image memory... done (allocated 82641 =
pages)
> > [  131.179814] PM: Allocated 330564 kbytes in 0.13 seconds (2542.80 MB/=
s)
> > [  131.179817] Suspending console(s) (use no_console_suspend to debug)
> > [  131.182797] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> > [  131.183264] HDA Intel 0000:01:00.1: PCI INT B disabled
> > [  131.183802] HDA Intel 0000:00:1b.0: PCI INT A disabled
> > [  131.504654] PM: freeze of devices complete after 323.233 msecs
> > [  131.506566] PM: late freeze of devices complete after 1.904 msecs
> > [  131.506773] ACPI: Preparing to enter system sleep state S4
> > [  131.531112] PM: Saving platform NVS memory
> > [  131.534328] Disabling non-boot CPUs ...
> > [  131.580177] CPU 1 is now offline
> > [  131.622812] CPU 2 is now offline
> > [  131.754363] CPU 3 is now offline
> > [  131.754367] lockdep: fixing up alternatives.
> > [  131.755297] Extended CMOS year: 2000
> > [  131.755468] PM: Creating hibernation image:
> > [  131.908665] PM: Need to copy 86670 pages
> > [  132.509928] PM: Hibernation image created (86670 pages copied)
> > [  131.756026] Extended CMOS year: 2000
> > [  131.756578] microcode: CPU0 updated to revision 0xc, date =3D 2010-0=
6-10
> > [  131.756606] Enabling non-boot CPUs ...
> > [  131.763890] lockdep: fixing up alternatives.
> > [  131.763904] Booting Node 0 Processor 1 APIC 0x1
> > [  131.763908] smpboot cpu 1: start_ip =3D 98000
> > [  131.881690] Switched to NOHz mode on CPU #1
> > [  131.923128] NMI watchdog enabled, takes one hw-pmu counter.
> > [  131.924625] microcode: CPU1 updated to revision 0xc, date =3D 2010-0=
6-10
> > [  131.924656] CPU1 is up
> > [  131.924949] lockdep: fixing up alternatives.
> > [  131.924959] Booting Node 0 Processor 2 APIC 0x4
> > [  131.924962] smpboot cpu 2: start_ip =3D 98000
> > [  132.041707] Switched to NOHz mode on CPU #2
> > [  132.083285] NMI watchdog enabled, takes one hw-pmu counter.
> > [  132.084938] microcode: CPU2 updated to revision 0xc, date =3D 2010-0=
6-10
> > [  132.084950] CPU2 is up
> > [  132.085415] lockdep: fixing up alternatives.
> > [  132.085460] Booting Node 0 Processor 3 APIC 0x5
> > [  132.085463] smpboot cpu 3: start_ip =3D 98000
> > [  132.201793] Switched to NOHz mode on CPU #3
> > [  132.244130] NMI watchdog enabled, takes one hw-pmu counter.
> > [  132.245820] microcode: CPU3 updated to revision 0xc, date =3D 2010-0=
6-10
> > [  132.245834] CPU3 is up
> > [  132.248617] ACPI: Waking up from system sleep state S4
> > [  132.324868] PM: early thaw of devices complete after 0.540 msecs
> > [  132.325292] pci 0000:00:1e.0: setting latency timer to 64
> > [  132.325386] radeon 0000:01:00.0: power state changed by ACPI to D0
> > [  132.325470] ahci 0000:00:1f.2: restoring config space at offset 0x1 =
(was 0x2b00403, writing 0x2b00407)
> > [  132.325510] radeon 0000:01:00.0: power state changed by ACPI to D0
> > [  132.325547] ahci 0000:00:1f.2: setting latency timer to 64
> > [  132.325630] radeon 0000:01:00.0: setting latency timer to 64
> > [  132.325681] sd 0:0:0:0: [sda] Starting disk
> > [  132.338376] HDA Intel 0000:00:1b.0: BAR 0: set to [mem 0xb4100000-0x=
b4103fff 64bit] (PCI address [0xb4100000-0xb4103fff])
> > [  132.338381] HDA Intel 0000:01:00.1: BAR 0: set to [mem 0xb4020000-0x=
b4023fff 64bit] (PCI address [0xb4020000-0xb4023fff])
> > [  132.338413] HDA Intel 0000:00:1b.0: restoring config space at offset=
 0xf (was 0x100, writing 0x10a)
> > [  132.338457] HDA Intel 0000:00:1b.0: restoring config space at offset=
 0x3 (was 0x0, writing 0x10)
> > [  132.338470] HDA Intel 0000:00:1b.0: restoring config space at offset=
 0x1 (was 0x100000, writing 0x100002)
> > [  132.338501] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low)=
 -> IRQ 17
> > [  132.338511] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low)=
 -> IRQ 22
> > [  132.338514] HDA Intel 0000:01:00.1: setting latency timer to 64
> > [  132.338522] HDA Intel 0000:00:1b.0: setting latency timer to 64
> > [  132.338612] HDA Intel 0000:00:1b.0: irq 43 for MSI/MSI-X
> > [  132.338615] HDA Intel 0000:01:00.1: irq 44 for MSI/MSI-X
> > [  132.350073] radeon 0000:01:00.0: WB enabled
> > [  132.366610] [drm] ring test succeeded in 0 usecs
> > [  132.366676] [drm] ib test succeeded in 0 usecs
> > [  132.645181] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [  132.649348] ata1.00: configured for UDMA/133
> > [  132.658490] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > [  132.693686] ata2.00: configured for UDMA/100
> > [  134.443057] PM: thaw of devices complete after 2117.746 msecs
> > [  134.444533] snapshot_ioctl: ioctl '80083308' is deprecated and will =
be removed soon, update your suspend-to-disk utilities
> > [  134.444668] snapshot_ioctl: ioctl '80083307' is deprecated and will =
be removed soon, update your suspend-to-disk utilities
> > [  134.444779] snapshot_ioctl: ioctl '80083308' is deprecated and will =
be removed soon, update your suspend-to-disk utilities
> > [  134.444790] snapshot_ioctl: ioctl '80083308' is deprecated and will =
be removed soon, update your suspend-to-disk utilities
> > [  134.445134] snapshot_ioctl: ioctl '80083308' is deprecated and will =
be removed soon, update your suspend-to-disk utilities
> > [  134.445321] snapshot_ioctl: ioctl '80083308' is deprecated and will =
be removed soon, update your suspend-to-disk utilities
> > [  135.446441] tg3 0000:02:00.0: eth0: Link is down
> > [  136.068592] snapshot_deprecated_ioctl: 6826 callbacks suppressed
> > [  136.068600] snapshot_ioctl: ioctl '4004330c' is deprecated and will =
be removed soon, update your suspend-to-disk utilities
> > [  136.068604] Restarting tasks ... done.
> > [  151.020423] radeon 0000:01:00.0: GPU lockup CP stall for more than 1=
0000msec
> > [  151.020428] ------------[ cut here ]------------
> > [  151.020439] WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:246 ra=
deon_fence_wait+0x3c9/0x4a7()
> > [  151.020443] Hardware name: Aspire 5741G   =20
> > [  151.020447] GPU lockup (waiting for 0x00000B87 last fence id 0x00000=
B85)
> > [  151.020450] Modules linked in: ipv6 microcode snd_hda_codec_hdmi snd=
_seq_dummy snd_hwdep snd_hda_codec_realtek snd_seq_oss snd_seq_midi_event s=
nd_seq snd_seq_device rndis_host snd_hda_intel snd_pcm_oss cdc_ether usbnet=
 snd_hda_codec
> > snd_pcm snd_timer snd_page_alloc snd_mixer_oss sparse_keymap mii ac bat=
tery snd wmi button broadcom psmouse tg3 libphy evdev soundcore ehci_hcd sr=
_mod cdrom usbcore sd_mod ahci
> > [  151.020515] Pid: 3772, comm: X Not tainted 2.6.39-rc2-dbg-git4-00555=
-g2fc20f7-dirty #520
> > [  151.020519] Call Trace:
> > [  151.020530]  [<ffffffff8103e2ac>] warn_slowpath_common+0x7e/0x96
> > [  151.020536]  [<ffffffff8103e358>] warn_slowpath_fmt+0x41/0x43
> > [  151.020542]  [<ffffffff8130673e>] radeon_fence_wait+0x3c9/0x4a7
> > [  151.020550]  [<ffffffff8105cb72>] ? __init_waitqueue_head+0x46/0x46
> > [  151.020557]  [<ffffffff81306d2d>] radeon_sync_obj_wait+0xc/0xe
> > [  151.020564]  [<ffffffff812d97e8>] ttm_bo_wait+0xb8/0x174
> > [  151.020573]  [<ffffffff8131a3ea>] radeon_gem_wait_idle_ioctl+0x7c/0x=
ee
> > [  151.020580]  [<ffffffff812c6852>] drm_ioctl+0x29f/0x381
> > [  151.020585]  [<ffffffff8131a36e>] ? radeon_gem_busy_ioctl+0x114/0x114
> > [  151.020594]  [<ffffffff810706d4>] ? trace_hardirqs_on_caller+0x10d/0=
x131
> > [  151.020600]  [<ffffffff81070705>] ? trace_hardirqs_on+0xd/0xf
> > [  151.020609]  [<ffffffff810e5de0>] ? remove_vma+0x57/0x5f
> > [  151.020615]  [<ffffffff81113f83>] do_vfs_ioctl+0x46c/0x4ad
> > [  151.020622]  [<ffffffff811057ef>] ? fget_light+0x11f/0x30b
> > [  151.020630]  [<ffffffff81477e0a>] ? sysret_check+0x2e/0x69
> > [  151.020636]  [<ffffffff81114015>] sys_ioctl+0x51/0x74
> > [  151.020641]  [<ffffffff81477dd2>] system_call_fastpath+0x16/0x1b
> > [  151.020646] ---[ end trace ef966166f47d63ae ]---
> > [  151.021954] radeon 0000:01:00.0: GPU softreset=20
> > [  151.021959] radeon 0000:01:00.0:   GRBM_STATUS=3D0xB2703828
> > [  151.021962] radeon 0000:01:00.0:   GRBM_STATUS_SE0=3D0x1C000007
> > [  151.021966] radeon 0000:01:00.0:   GRBM_STATUS_SE1=3D0x00000007
> > [  151.021970] radeon 0000:01:00.0:   SRBM_STATUS=3D0x200002C0
> > [  151.022029] radeon 0000:01:00.0:   GRBM_SOFT_RESET=3D0x00007F6B
> > [  151.022134] radeon 0000:01:00.0:   GRBM_STATUS=3D0x00003828
> > [  151.022138] radeon 0000:01:00.0:   GRBM_STATUS_SE0=3D0x00000007
> > [  151.022141] radeon 0000:01:00.0:   GRBM_STATUS_SE1=3D0x00000007
> > [  151.022145] radeon 0000:01:00.0:   SRBM_STATUS=3D0x200000C0
> > [  151.023156] radeon 0000:01:00.0: GPU reset succeed
> > [  151.044717] radeon 0000:01:00.0: WB enabled
> > [  151.061210] [drm] ring test succeeded in 0 usecs
> > [  151.061258] [drm] ib test succeeded in 1 usecs
> > [  162.914959] radeon 0000:01:00.0: GPU lockup CP stall for more than 1=
0020msec
> > [  162.914964] ------------[ cut here ]------------
> > [  162.914976] WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:246 ra=
deon_fence_wait+0x3c9/0x4a7()
> > [  162.914980] Hardware name: Aspire 5741G   =20
> > [  162.914983] GPU lockup (waiting for 0x00000B89 last fence id 0x00000=
B88)
> > [  162.914986] Modules linked in: ipv6 microcode snd_hda_codec_hdmi snd=
_seq_dummy snd_hwdep snd_hda_codec_realtek snd_seq_oss snd_seq_midi_event s=
nd_seq snd_seq_device rndis_host snd_hda_intel snd_pcm_oss cdc_ether usbnet=
 snd_hda_codec
> > snd_pcm snd_timer snd_page_alloc snd_mixer_oss sparse_keymap mii ac bat=
tery snd wmi button broadcom psmouse tg3 libphy evdev soundcore ehci_hcd sr=
_mod cdrom usbcore sd_mod ahci
> > [  162.915049] Pid: 3772, comm: X Tainted: G        W   2.6.39-rc2-dbg-=
git4-00555-g2fc20f7-dirty #520
> > [  162.915052] Call Trace:
> > [  162.915062]  [<ffffffff8103e2ac>] warn_slowpath_common+0x7e/0x96
> > [  162.915068]  [<ffffffff8103e358>] warn_slowpath_fmt+0x41/0x43
> > [  162.915075]  [<ffffffff8130673e>] radeon_fence_wait+0x3c9/0x4a7
> > [  162.915083]  [<ffffffff8105cb72>] ? __init_waitqueue_head+0x46/0x46
> > [  162.915089]  [<ffffffff81306d2d>] radeon_sync_obj_wait+0xc/0xe
> > [  162.915097]  [<ffffffff812d97e8>] ttm_bo_wait+0xb8/0x174
> > [  162.915105]  [<ffffffff8131a3ea>] radeon_gem_wait_idle_ioctl+0x7c/0x=
ee
> > [  162.915112]  [<ffffffff812c6852>] drm_ioctl+0x29f/0x381
> > [  162.915118]  [<ffffffff8131a36e>] ? radeon_gem_busy_ioctl+0x114/0x114
> > [  162.915126]  [<ffffffff8106f9df>] ? lock_release_non_nested+0x91/0x2=
47
> > [  162.915134]  [<ffffffff81001cee>] ? sys_rt_sigreturn+0x86/0x21c
> > [  162.915140]  [<ffffffff81001cee>] ? sys_rt_sigreturn+0x86/0x21c
> > [  162.915147]  [<ffffffff81113f83>] do_vfs_ioctl+0x46c/0x4ad
> > [  162.915154]  [<ffffffff811057ef>] ? fget_light+0x11f/0x30b
> > [  162.915160]  [<ffffffff81471f7d>] ? retint_swapgs+0x13/0x1b
> > [  162.915165]  [<ffffffff81114015>] sys_ioctl+0x51/0x74
> > [  162.915171]  [<ffffffff81477dd2>] system_call_fastpath+0x16/0x1b
> > [  162.915176] ---[ end trace ef966166f47d63af ]---
> > [  162.916478] radeon 0000:01:00.0: GPU softreset=20
> > [  162.916482] radeon 0000:01:00.0:   GRBM_STATUS=3D0xB2703828
> > [  162.916486] radeon 0000:01:00.0:   GRBM_STATUS_SE0=3D0x1C000007
> > [  162.916490] radeon 0000:01:00.0:   GRBM_STATUS_SE1=3D0x00000007
> > [  162.916494] radeon 0000:01:00.0:   SRBM_STATUS=3D0x200000C0
> > [  162.916551] radeon 0000:01:00.0:   GRBM_SOFT_RESET=3D0x00007F6B
> > [  162.916657] radeon 0000:01:00.0:   GRBM_STATUS=3D0x00003828
> > [  162.916660] radeon 0000:01:00.0:   GRBM_STATUS_SE0=3D0x00000007
> > [  162.916664] radeon 0000:01:00.0:   GRBM_STATUS_SE1=3D0x00000007
> > [  162.916668] radeon 0000:01:00.0:   SRBM_STATUS=3D0x200000C0
> > [  162.917678] radeon 0000:01:00.0: GPU reset succeed
> > [  162.939238] radeon 0000:01:00.0: WB enabled
> > [  162.955734] [drm] ring test succeeded in 1 usecs
> > [  162.955745] [drm] ib test succeeded in 1 usecs
> > [  175.072852] radeon 0000:01:00.0: GPU lockup CP stall for more than 1=
0043msec
> > [  175.072857] ------------[ cut here ]------------
> > [  175.072869] WARNING: at drivers/gpu/drm/radeon/radeon_fence.c:246 ra=
deon_fence_wait+0x3c9/0x4a7()
> > [  175.072873] Hardware name: Aspire 5741G   =20
> > [  175.072876] GPU lockup (waiting for 0x00000B8D last fence id 0x00000=
B8C)
> > [  175.072879] Modules linked in: ipv6 microcode snd_hda_codec_hdmi snd=
_seq_dummy snd_hwdep snd_hda_codec_realtek snd_seq_oss snd_seq_midi_event s=
nd_seq snd_seq_device rndis_host snd_hda_intel snd_pcm_oss cdc_ether usbnet=
 snd_hda_codec
> > snd_pcm snd_timer snd_page_alloc snd_mixer_oss sparse_keymap mii ac bat=
tery snd wmi button broadcom psmouse tg3 libphy evdev soundcore ehci_hcd sr=
_mod cdrom usbcore sd_mod ahci
> > [  175.072943] Pid: 3772, comm: X Tainted: G        W   2.6.39-rc2-dbg-=
git4-00555-g2fc20f7-dirty #520
> > [  175.072947] Call Trace:
> > [  175.072957]  [<ffffffff8103e2ac>] warn_slowpath_common+0x7e/0x96
> > [  175.072963]  [<ffffffff8103e358>] warn_slowpath_fmt+0x41/0x43
> > [  175.072969]  [<ffffffff8130673e>] radeon_fence_wait+0x3c9/0x4a7
> > [  175.072977]  [<ffffffff8105cb72>] ? __init_waitqueue_head+0x46/0x46
> > [  175.072984]  [<ffffffff81306d2d>] radeon_sync_obj_wait+0xc/0xe
> > [  175.072991]  [<ffffffff812d97e8>] ttm_bo_wait+0xb8/0x174
> > [  175.072999]  [<ffffffff8131a3ea>] radeon_gem_wait_idle_ioctl+0x7c/0x=
ee
> > [  175.073007]  [<ffffffff812c6852>] drm_ioctl+0x29f/0x381
> > [  175.073012]  [<ffffffff8131a36e>] ? radeon_gem_busy_ioctl+0x114/0x114
> > [  175.073021]  [<ffffffff8106f9df>] ? lock_release_non_nested+0x91/0x2=
47
> > [  175.073029]  [<ffffffff81001cee>] ? sys_rt_sigreturn+0x86/0x21c
> > [  175.073035]  [<ffffffff81001cee>] ? sys_rt_sigreturn+0x86/0x21c
> > [  175.073042]  [<ffffffff81113f83>] do_vfs_ioctl+0x46c/0x4ad
> > [  175.073048]  [<ffffffff811057ef>] ? fget_light+0x11f/0x30b
> > [  175.073054]  [<ffffffff81471f7d>] ? retint_swapgs+0x13/0x1b
> > [  175.073059]  [<ffffffff81114015>] sys_ioctl+0x51/0x74
> > [  175.073065]  [<ffffffff81477dd2>] system_call_fastpath+0x16/0x1b
> > [  175.073070] ---[ end trace ef966166f47d63b0 ]---
> > [  175.074371] radeon 0000:01:00.0: GPU softreset=20
> > [  175.074375] radeon 0000:01:00.0:   GRBM_STATUS=3D0xB2703828
> > [  175.074379] radeon 0000:01:00.0:   GRBM_STATUS_SE0=3D0x1C000007
> > [  175.074383] radeon 0000:01:00.0:   GRBM_STATUS_SE1=3D0x00000007
> > [  175.074387] radeon 0000:01:00.0:   SRBM_STATUS=3D0x200000C0
> > [  175.074444] radeon 0000:01:00.0:   GRBM_SOFT_RESET=3D0x00007F6B
> > [  175.074550] radeon 0000:01:00.0:   GRBM_STATUS=3D0x00003828
> > [  175.074553] radeon 0000:01:00.0:   GRBM_STATUS_SE0=3D0x00000007
> > [  175.074557] radeon 0000:01:00.0:   GRBM_STATUS_SE1=3D0x00000007
> > [  175.074561] radeon 0000:01:00.0:   SRBM_STATUS=3D0x200000C0
> > [  175.075571] radeon 0000:01:00.0: GPU reset succeed
> > [  175.097128] radeon 0000:01:00.0: WB enabled
> > [  175.113623] [drm] ring test succeeded in 1 usecs
> > [...] and so on.
> >=20
> >=20
> > kernel: .39-rc2-*
> >=20
> >=20
> > 	Sergey
>=20
>=20

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk2kDRYACgkQfKHnntdSXjSrNAQAvG+XG3ta5lAMyna+N4r3PSmX
b4SUiDiwAUExq43KVhYJ3IbhWMhQdD/6JDhIztrgty5GNFIYKbnr/BJhZhVx0W0k
f0+yrHuilOEtNu3+CZ/D2OpuK55Vcw4ciQglkpMzYHxLzbomw4uN6HJs6X/M6FF0
rpEj4pNInNsr/IKaxb4=
=vzvi
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
