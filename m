Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2EaJJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:09:54 -0400
Received: from investici.nine.ch ([217.150.252.179]:27925 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2EaJJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:09:51 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 confino.investici.org A6910C883D
Date: Thu, 31 May 2012 09:53:22 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: warn_slowpath_common with linux-3.4
Message-ID: <20120531075317.GA31440@ritirata.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello all,

here are some warning I got after resuming from suspend.
It is not really clear to me how I could debug further. Please tell me if I=
 can
do something else.

I also attached the whole dmesg.

Best Regards,


[170934.181984] ------------[ cut here ]------------
[170934.181991] WARNING: at drivers/gpu/drm/i915/intel_display.c:963
assert_plane+0x70/0x80()
[170934.181992] Hardware name: Latitude E5420
[170934.181994] plane B assertion failure (expected off, current on)
[170934.181995] Modules linked in: mac80211_hwsim vboxnetadp(O) vboxnetflt(=
O)
vboxdrv(O) ppp_async crc_ccitt ppp_generic slhc hid_logitech_dj hid_cherry
usbhid psmouse cpufreq_stats vfat fat usb_storage bluetooth fuse iwlwifi
uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev
snd_hda_codec_hdmi mac80211 snd_hda_codec_idt snd_hda_intel snd_hda_codec
snd_hwdep ehci_hcd snd_pcm cfg80211 usbcore crc32c_intel aesni_intel
snd_page_alloc snd_timer snd aes_x86_64 cryptd usb_common soundcore [last
unloaded: psmouse]
[170934.182023] Pid: 29929, comm: kworker/u:5 Tainted: G        W  O 3.4.0o=
rdex+
#3
[170934.182025] Call Trace:
[170934.182030]  [<ffffffff81033d4a>] warn_slowpath_common+0x7a/0xb0
[170934.182034]  [<ffffffff8105c4f0>] ? async_schedule+0x20/0x20
[170934.182036]  [<ffffffff81033e21>] warn_slowpath_fmt+0x41/0x50
[170934.182040]  [<ffffffff8130b4e6>] ? ironlake_crtc_dpms+0x86/0x90
[170934.182042]  [<ffffffff81300dd0>] assert_plane+0x70/0x80
[170934.182044]  [<ffffffff8130684c>] intel_crtc_disable+0x6c/0xc0
[170934.182048]  [<ffffffff812c6c85>]
drm_helper_disable_unused_functions+0x115/0x190
[170934.182050]  [<ffffffff812c77a8>] drm_helper_resume_force_mode+0x128/0x=
160
[170934.182053]  [<ffffffff8105c4f0>] ? async_schedule+0x20/0x20
[170934.182057]  [<ffffffff812e4741>] i915_drm_thaw+0x111/0x160
[170934.182059]  [<ffffffff812e4a19>] i915_resume+0x49/0x80
[170934.182062]  [<ffffffff812e4a61>] i915_pm_resume+0x11/0x20
[170934.182066]  [<ffffffff81237979>] pci_pm_restore+0x79/0xe0
[170934.182068]  [<ffffffff81237900>] ? pci_pm_suspend_noirq+0x170/0x170
[170934.182072]  [<ffffffff81334c76>] dpm_run_callback.isra.5+0x36/0x70
[170934.182074]  [<ffffffff81334f90>] device_resume+0xa0/0x160
[170934.182076]  [<ffffffff8133506c>] async_resume+0x1c/0x50
[170934.182079]  [<ffffffff8105c569>] async_run_entry_fn+0x79/0x170
[170934.182082]  [<ffffffff8104d924>] process_one_work+0x174/0x450
[170934.182085]  [<ffffffff8104d8c6>] ? process_one_work+0x116/0x450
[170934.182088]  [<ffffffff8104f6cf>] worker_thread+0x15f/0x350
[170934.182090]  [<ffffffff8104f570>] ? manage_workers.isra.28+0x220/0x220
[170934.182093]  [<ffffffff8105472e>] kthread+0x8e/0xa0
[170934.182098]  [<ffffffff814fc914>] kernel_thread_helper+0x4/0x10
[170934.182101]  [<ffffffff8105de60>] ? finish_task_switch+0x80/0x110
[170934.182103]  [<ffffffff8105de60>] ? finish_task_switch+0x80/0x110
[170934.182106]  [<ffffffff814fafdd>] ? retint_restore_args+0xe/0xe
[170934.182109]  [<ffffffff810546a0>] ? __init_kthread_worker+0x70/0x70
[170934.182111]  [<ffffffff814fc910>] ? gs_change+0xb/0xb
[170934.182113] ---[ end trace e93713a9d40cd079 ]---
[170934.182114] ------------[ cut here ]------------
[170934.182116] WARNING: at drivers/gpu/drm/i915/intel_display.c:948
assert_pipe+0x86/0x90()
[170934.182117] Hardware name: Latitude E5420
[170934.182119] pipe B assertion failure (expected off, current on)
[170934.182120] Modules linked in: mac80211_hwsim vboxnetadp(O) vboxnetflt(=
O)
vboxdrv(O) ppp_async crc_ccitt ppp_generic slhc hid_logitech_dj hid_cherry
usbhid psmouse cpufreq_stats vfat fat usb_storage bluetooth fuse iwlwifi
uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev
snd_hda_codec_hdmi mac80211 snd_hda_codec_idt snd_hda_intel snd_hda_codec
snd_hwdep ehci_hcd snd_pcm cfg80211 usbcore crc32c_intel aesni_intel
snd_page_alloc snd_timer snd aes_x86_64 cryptd usb_common soundcore [last
unloaded: psmouse]
[170934.182139] Pid: 29929, comm: kworker/u:5 Tainted: G        W  O 3.4.0o=
rdex+
#3
[170934.182140] Call Trace:
[170934.182142]  [<ffffffff81033d4a>] warn_slowpath_common+0x7a/0xb0
[170934.182145]  [<ffffffff8105c4f0>] ? async_schedule+0x20/0x20
[170934.182147]  [<ffffffff81033e21>] warn_slowpath_fmt+0x41/0x50
[170934.182150]  [<ffffffff8130b4e6>] ? ironlake_crtc_dpms+0x86/0x90
[170934.182152]  [<ffffffff81305066>] assert_pipe+0x86/0x90
[170934.182154]  [<ffffffff81306861>] intel_crtc_disable+0x81/0xc0
[170934.182156]  [<ffffffff812c6c85>]
drm_helper_disable_unused_functions+0x115/0x190
[170934.182159]  [<ffffffff812c77a8>] drm_helper_resume_force_mode+0x128/0x=
160
[170934.182162]  [<ffffffff8105c4f0>] ? async_schedule+0x20/0x20
[170934.182164]  [<ffffffff812e4741>] i915_drm_thaw+0x111/0x160
[170934.182167]  [<ffffffff812e4a19>] i915_resume+0x49/0x80
[170934.182170]  [<ffffffff812e4a61>] i915_pm_resume+0x11/0x20
[170934.182172]  [<ffffffff81237979>] pci_pm_restore+0x79/0xe0
[170934.182174]  [<ffffffff81237900>] ? pci_pm_suspend_noirq+0x170/0x170
[170934.182177]  [<ffffffff81334c76>] dpm_run_callback.isra.5+0x36/0x70
[170934.182179]  [<ffffffff81334f90>] device_resume+0xa0/0x160
[170934.182181]  [<ffffffff8133506c>] async_resume+0x1c/0x50
[170934.182184]  [<ffffffff8105c569>] async_run_entry_fn+0x79/0x170
[170934.182186]  [<ffffffff8104d924>] process_one_work+0x174/0x450
[170934.182193]  [<ffffffff8104d8c6>] ? process_one_work+0x116/0x450
[170934.182195]  [<ffffffff8104f6cf>] worker_thread+0x15f/0x350
[170934.182198]  [<ffffffff8104f570>] ? manage_workers.isra.28+0x220/0x220
[170934.182201]  [<ffffffff8105472e>] kthread+0x8e/0xa0
[170934.182204]  [<ffffffff814fc914>] kernel_thread_helper+0x4/0x10
[170934.182206]  [<ffffffff8105de60>] ? finish_task_switch+0x80/0x110
[170934.182209]  [<ffffffff8105de60>] ? finish_task_switch+0x80/0x110
[170934.182212]  [<ffffffff814fafdd>] ? retint_restore_args+0xe/0xe
[170934.182215]  [<ffffffff810546a0>] ? __init_kthread_worker+0x70/0x70
[170934.182218]  [<ffffffff814fc910>] ? gs_change+0xb/0xb
[170934.182219] ---[ end trace e93713a9d40cd07a ]---



--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg.log"
Content-Transfer-Encoding: quoted-printable

=2E779897] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67d000=20
[170933.779898] DMAR:[fault reason 06] PTE Read access is not set
[170933.779910] DRHD: handling fault status reg 3
[170933.779912] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67f00=
0=20
[170933.779913] DMAR:[fault reason 06] PTE Read access is not set
[170933.779925] DRHD: handling fault status reg 3
[170933.779927] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68100=
0=20
[170933.779928] DMAR:[fault reason 06] PTE Read access is not set
[170933.779939] DRHD: handling fault status reg 3
[170933.779941] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68300=
0=20
[170933.779942] DMAR:[fault reason 06] PTE Read access is not set
[170933.779954] DRHD: handling fault status reg 3
[170933.779957] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68500=
0=20
[170933.779957] DMAR:[fault reason 06] PTE Read access is not set
[170933.779969] DRHD: handling fault status reg 3
[170933.779971] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68700=
0=20
[170933.779972] DMAR:[fault reason 06] PTE Read access is not set
[170933.779983] DRHD: handling fault status reg 3
[170933.779986] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68800=
0=20
[170933.779986] DMAR:[fault reason 06] PTE Read access is not set
[170933.779998] DRHD: handling fault status reg 3
[170933.780000] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68a00=
0=20
[170933.780001] DMAR:[fault reason 06] PTE Read access is not set
[170933.780013] DRHD: handling fault status reg 3
[170933.780015] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68c00=
0=20
[170933.780016] DMAR:[fault reason 06] PTE Read access is not set
[170933.780028] DRHD: handling fault status reg 3
[170933.780030] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68e00=
0=20
[170933.780031] DMAR:[fault reason 06] PTE Read access is not set
[170933.780043] DRHD: handling fault status reg 3
[170933.780045] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69000=
0=20
[170933.780046] DMAR:[fault reason 06] PTE Read access is not set
[170933.780057] DRHD: handling fault status reg 3
[170933.780059] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69300=
0=20
[170933.780060] DMAR:[fault reason 06] PTE Read access is not set
[170933.780072] DRHD: handling fault status reg 3
[170933.780074] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69400=
0=20
[170933.780075] DMAR:[fault reason 06] PTE Read access is not set
[170933.780087] DRHD: handling fault status reg 3
[170933.780089] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69600=
0=20
[170933.780090] DMAR:[fault reason 06] PTE Read access is not set
[170933.780102] DRHD: handling fault status reg 3
[170933.780104] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69700=
0=20
[170933.780105] DMAR:[fault reason 06] PTE Read access is not set
[170933.780116] DRHD: handling fault status reg 3
[170933.780118] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69900=
0=20
[170933.780119] DMAR:[fault reason 06] PTE Read access is not set
[170933.780131] DRHD: handling fault status reg 3
[170933.780134] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69b00=
0=20
[170933.780134] DMAR:[fault reason 06] PTE Read access is not set
[170933.780146] DRHD: handling fault status reg 3
[170933.780148] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69d00=
0=20
[170933.780149] DMAR:[fault reason 06] PTE Read access is not set
[170933.780161] DRHD: handling fault status reg 3
[170933.780163] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69f00=
0=20
[170933.780164] DMAR:[fault reason 06] PTE Read access is not set
[170933.780176] DRHD: handling fault status reg 3
[170933.780178] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a100=
0=20
[170933.780179] DMAR:[fault reason 06] PTE Read access is not set
[170933.780190] DRHD: handling fault status reg 3
[170933.780192] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a300=
0=20
[170933.780193] DMAR:[fault reason 06] PTE Read access is not set
[170933.780205] DRHD: handling fault status reg 3
[170933.780207] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a500=
0=20
[170933.780208] DMAR:[fault reason 06] PTE Read access is not set
[170933.780220] DRHD: handling fault status reg 3
[170933.780222] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a600=
0=20
[170933.780223] DMAR:[fault reason 06] PTE Read access is not set
[170933.780235] DRHD: handling fault status reg 3
[170933.780237] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a800=
0=20
[170933.780238] DMAR:[fault reason 06] PTE Read access is not set
[170933.780250] DRHD: handling fault status reg 3
[170933.780252] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6aa00=
0=20
[170933.780253] DMAR:[fault reason 06] PTE Read access is not set
[170933.780264] DRHD: handling fault status reg 3
[170933.780267] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ac00=
0=20
[170933.780267] DMAR:[fault reason 06] PTE Read access is not set
[170933.780279] DRHD: handling fault status reg 3
[170933.780281] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ae00=
0=20
[170933.780282] DMAR:[fault reason 06] PTE Read access is not set
[170933.780294] DRHD: handling fault status reg 3
[170933.780296] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b000=
0=20
[170933.780297] DMAR:[fault reason 06] PTE Read access is not set
[170933.780309] DRHD: handling fault status reg 3
[170933.780311] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b200=
0=20
[170933.780312] DMAR:[fault reason 06] PTE Read access is not set
[170933.780323] DRHD: handling fault status reg 3
[170933.780326] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b400=
0=20
[170933.780326] DMAR:[fault reason 06] PTE Read access is not set
[170933.780339] DRHD: handling fault status reg 3
[170933.780341] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b500=
0=20
[170933.780342] DMAR:[fault reason 06] PTE Read access is not set
[170933.780353] DRHD: handling fault status reg 3
[170933.780355] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b700=
0=20
[170933.780356] DMAR:[fault reason 06] PTE Read access is not set
[170933.780368] DRHD: handling fault status reg 3
[170933.780370] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b900=
0=20
[170933.780371] DMAR:[fault reason 06] PTE Read access is not set
[170933.780383] DRHD: handling fault status reg 3
[170933.780385] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6bb00=
0=20
[170933.780386] DMAR:[fault reason 06] PTE Read access is not set
[170933.780398] DRHD: handling fault status reg 3
[170933.780400] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6bd00=
0=20
[170933.780401] DMAR:[fault reason 06] PTE Read access is not set
[170933.780412] DRHD: handling fault status reg 3
[170933.780415] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6bf00=
0=20
[170933.780415] DMAR:[fault reason 06] PTE Read access is not set
[170933.780427] DRHD: handling fault status reg 3
[170933.780429] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c100=
0=20
[170933.780430] DMAR:[fault reason 06] PTE Read access is not set
[170933.780442] DRHD: handling fault status reg 3
[170933.780444] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c300=
0=20
[170933.780445] DMAR:[fault reason 06] PTE Read access is not set
[170933.780457] DRHD: handling fault status reg 3
[170933.780459] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c400=
0=20
[170933.780460] DMAR:[fault reason 06] PTE Read access is not set
[170933.780472] DRHD: handling fault status reg 3
[170933.780474] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c600=
0=20
[170933.780475] DMAR:[fault reason 06] PTE Read access is not set
[170933.780487] DRHD: handling fault status reg 3
[170933.780489] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c800=
0=20
[170933.780490] DMAR:[fault reason 06] PTE Read access is not set
[170933.780502] DRHD: handling fault status reg 3
[170933.780504] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ca00=
0=20
[170933.780505] DMAR:[fault reason 06] PTE Read access is not set
[170933.780516] DRHD: handling fault status reg 3
[170933.780519] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6cc00=
0=20
[170933.780519] DMAR:[fault reason 06] PTE Read access is not set
[170933.780531] DRHD: handling fault status reg 3
[170933.780533] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ce00=
0=20
[170933.780534] DMAR:[fault reason 06] PTE Read access is not set
[170933.780546] DRHD: handling fault status reg 3
[170933.780548] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d000=
0=20
[170933.780549] DMAR:[fault reason 06] PTE Read access is not set
[170933.780561] DRHD: handling fault status reg 3
[170933.780563] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d200=
0=20
[170933.780564] DMAR:[fault reason 06] PTE Read access is not set
[170933.780575] DRHD: handling fault status reg 3
[170933.780577] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d300=
0=20
[170933.780578] DMAR:[fault reason 06] PTE Read access is not set
[170933.780590] DRHD: handling fault status reg 3
[170933.780592] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d500=
0=20
[170933.780593] DMAR:[fault reason 06] PTE Read access is not set
[170933.780605] DRHD: handling fault status reg 3
[170933.780607] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d700=
0=20
[170933.780608] DMAR:[fault reason 06] PTE Read access is not set
[170933.780620] DRHD: handling fault status reg 3
[170933.780622] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d900=
0=20
[170933.780623] DMAR:[fault reason 06] PTE Read access is not set
[170933.780634] DRHD: handling fault status reg 3
[170933.780637] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6db00=
0=20
[170933.780637] DMAR:[fault reason 06] PTE Read access is not set
[170933.780649] DRHD: handling fault status reg 3
[170933.780651] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6dd00=
0=20
[170933.780652] DMAR:[fault reason 06] PTE Read access is not set
[170933.780664] DRHD: handling fault status reg 3
[170933.780666] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6df00=
0=20
[170933.780667] DMAR:[fault reason 06] PTE Read access is not set
[170933.780679] DRHD: handling fault status reg 3
[170933.780681] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e100=
0=20
[170933.780682] DMAR:[fault reason 06] PTE Read access is not set
[170933.780694] DRHD: handling fault status reg 3
[170933.780696] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e200=
0=20
[170933.780697] DMAR:[fault reason 06] PTE Read access is not set
[170933.780711] DRHD: handling fault status reg 3
[170933.780713] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e400=
0=20
[170933.780714] DMAR:[fault reason 06] PTE Read access is not set
[170933.780723] DRHD: handling fault status reg 3
[170933.780725] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e600=
0=20
[170933.780726] DMAR:[fault reason 06] PTE Read access is not set
[170933.780738] DRHD: handling fault status reg 3
[170933.780740] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e800=
0=20
[170933.780741] DMAR:[fault reason 06] PTE Read access is not set
[170933.780753] DRHD: handling fault status reg 3
[170933.780755] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ea00=
0=20
[170933.780756] DMAR:[fault reason 06] PTE Read access is not set
[170933.780768] DRHD: handling fault status reg 3
[170933.780770] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ec00=
0=20
[170933.780771] DMAR:[fault reason 06] PTE Read access is not set
[170933.780782] DRHD: handling fault status reg 3
[170933.780784] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ee00=
0=20
[170933.780785] DMAR:[fault reason 06] PTE Read access is not set
[170933.780797] DRHD: handling fault status reg 3
[170933.780799] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f000=
0=20
[170933.780800] DMAR:[fault reason 06] PTE Read access is not set
[170933.780812] DRHD: handling fault status reg 3
[170933.780814] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f100=
0=20
[170933.780815] DMAR:[fault reason 06] PTE Read access is not set
[170933.780827] DRHD: handling fault status reg 3
[170933.780829] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f300=
0=20
[170933.780829] DMAR:[fault reason 06] PTE Read access is not set
[170933.780841] DRHD: handling fault status reg 3
[170933.780843] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f500=
0=20
[170933.780844] DMAR:[fault reason 06] PTE Read access is not set
[170933.780857] DRHD: handling fault status reg 3
[170933.780859] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f700=
0=20
[170933.780860] DMAR:[fault reason 06] PTE Read access is not set
[170933.780871] DRHD: handling fault status reg 3
[170933.780874] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f900=
0=20
[170933.780874] DMAR:[fault reason 06] PTE Read access is not set
[170933.780886] DRHD: handling fault status reg 2
[170933.780888] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6fd00=
0=20
[170933.780889] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.780901] DRHD: handling fault status reg 3
[170933.780903] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6fd00=
0=20
[170933.780904] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.780916] DRHD: handling fault status reg 3
[170933.780918] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70000=
0=20
[170933.780919] DMAR:[fault reason 06] PTE Read access is not set
[170933.780930] DRHD: handling fault status reg 3
[170933.780932] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70000=
0=20
[170933.780933] DMAR:[fault reason 06] PTE Read access is not set
[170933.780945] DRHD: handling fault status reg 3
[170933.780947] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70200=
0=20
[170933.780948] DMAR:[fault reason 06] PTE Read access is not set
[170933.780960] DRHD: handling fault status reg 3
[170933.780962] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70400=
0=20
[170933.780963] DMAR:[fault reason 06] PTE Read access is not set
[170933.780975] DRHD: handling fault status reg 3
[170933.780977] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70600=
0=20
[170933.780977] DMAR:[fault reason 06] PTE Read access is not set
[170933.780989] DRHD: handling fault status reg 3
[170933.780991] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70800=
0=20
[170933.780992] DMAR:[fault reason 06] PTE Read access is not set
[170933.781004] DRHD: handling fault status reg 3
[170933.781006] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70a00=
0=20
[170933.781007] DMAR:[fault reason 06] PTE Read access is not set
[170933.781019] DRHD: handling fault status reg 3
[170933.781021] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70c00=
0=20
[170933.781022] DMAR:[fault reason 06] PTE Read access is not set
[170933.781034] DRHD: handling fault status reg 3
[170933.781036] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70e00=
0=20
[170933.781037] DMAR:[fault reason 06] PTE Read access is not set
[170933.781049] DRHD: handling fault status reg 3
[170933.781051] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70f00=
0=20
[170933.781052] DMAR:[fault reason 06] PTE Read access is not set
[170933.781063] DRHD: handling fault status reg 3
[170933.781066] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71100=
0=20
[170933.781066] DMAR:[fault reason 06] PTE Read access is not set
[170933.781078] DRHD: handling fault status reg 3
[170933.781080] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71300=
0=20
[170933.781081] DMAR:[fault reason 06] PTE Read access is not set
[170933.781093] DRHD: handling fault status reg 3
[170933.781095] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71500=
0=20
[170933.781096] DMAR:[fault reason 06] PTE Read access is not set
[170933.781108] DRHD: handling fault status reg 3
[170933.781110] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71700=
0=20
[170933.781111] DMAR:[fault reason 06] PTE Read access is not set
[170933.781122] DRHD: handling fault status reg 3
[170933.781125] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71900=
0=20
[170933.781125] DMAR:[fault reason 06] PTE Read access is not set
[170933.781137] DRHD: handling fault status reg 3
[170933.781139] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71b00=
0=20
[170933.781140] DMAR:[fault reason 06] PTE Read access is not set
[170933.781152] DRHD: handling fault status reg 3
[170933.781154] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71d00=
0=20
[170933.781155] DMAR:[fault reason 06] PTE Read access is not set
[170933.781167] DRHD: handling fault status reg 3
[170933.781169] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71e00=
0=20
[170933.781170] DMAR:[fault reason 06] PTE Read access is not set
[170933.781182] DRHD: handling fault status reg 3
[170933.781184] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72000=
0=20
[170933.781185] DMAR:[fault reason 06] PTE Read access is not set
[170933.781197] DRHD: handling fault status reg 3
[170933.781199] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72200=
0=20
[170933.781200] DMAR:[fault reason 06] PTE Read access is not set
[170933.781211] DRHD: handling fault status reg 3
[170933.781214] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72400=
0=20
[170933.781214] DMAR:[fault reason 06] PTE Read access is not set
[170933.781226] DRHD: handling fault status reg 3
[170933.781228] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72600=
0=20
[170933.781229] DMAR:[fault reason 06] PTE Read access is not set
[170933.781241] DRHD: handling fault status reg 3
[170933.781243] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72800=
0=20
[170933.781244] DMAR:[fault reason 06] PTE Read access is not set
[170933.781256] DRHD: handling fault status reg 3
[170933.781258] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72a00=
0=20
[170933.781259] DMAR:[fault reason 06] PTE Read access is not set
[170933.781271] DRHD: handling fault status reg 3
[170933.781273] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72c00=
0=20
[170933.781274] DMAR:[fault reason 06] PTE Read access is not set
[170933.781285] DRHD: handling fault status reg 3
[170933.781288] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72d00=
0=20
[170933.781288] DMAR:[fault reason 06] PTE Read access is not set
[170933.781300] DRHD: handling fault status reg 3
[170933.781302] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72f00=
0=20
[170933.781303] DMAR:[fault reason 06] PTE Read access is not set
[170933.781315] DRHD: handling fault status reg 3
[170933.781317] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73100=
0=20
[170933.781318] DMAR:[fault reason 06] PTE Read access is not set
[170933.781330] DRHD: handling fault status reg 3
[170933.781332] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73300=
0=20
[170933.781333] DMAR:[fault reason 06] PTE Read access is not set
[170933.781345] DRHD: handling fault status reg 3
[170933.781347] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73500=
0=20
[170933.781348] DMAR:[fault reason 06] PTE Read access is not set
[170933.781359] DRHD: handling fault status reg 3
[170933.781361] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73700=
0=20
[170933.781362] DMAR:[fault reason 06] PTE Read access is not set
[170933.781374] DRHD: handling fault status reg 3
[170933.781376] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73900=
0=20
[170933.781377] DMAR:[fault reason 06] PTE Read access is not set
[170933.781389] DRHD: handling fault status reg 3
[170933.781391] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73b00=
0=20
[170933.781392] DMAR:[fault reason 06] PTE Read access is not set
[170933.781404] DRHD: handling fault status reg 3
[170933.781406] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73c00=
0=20
[170933.781407] DMAR:[fault reason 06] PTE Read access is not set
[170933.781419] DRHD: handling fault status reg 3
[170933.781421] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73e00=
0=20
[170933.781422] DMAR:[fault reason 06] PTE Read access is not set
[170933.781433] DRHD: handling fault status reg 3
[170933.781435] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74000=
0=20
[170933.781436] DMAR:[fault reason 06] PTE Read access is not set
[170933.781448] DRHD: handling fault status reg 3
[170933.781450] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74200=
0=20
[170933.781451] DMAR:[fault reason 06] PTE Read access is not set
[170933.781463] DRHD: handling fault status reg 3
[170933.781465] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74400=
0=20
[170933.781466] DMAR:[fault reason 06] PTE Read access is not set
[170933.781478] DRHD: handling fault status reg 3
[170933.781480] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74600=
0=20
[170933.781481] DMAR:[fault reason 06] PTE Read access is not set
[170933.781492] DRHD: handling fault status reg 3
[170933.781495] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74800=
0=20
[170933.781495] DMAR:[fault reason 06] PTE Read access is not set
[170933.781507] DRHD: handling fault status reg 3
[170933.781509] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74a00=
0=20
[170933.781510] DMAR:[fault reason 06] PTE Read access is not set
[170933.781522] DRHD: handling fault status reg 3
[170933.781524] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74b00=
0=20
[170933.781525] DMAR:[fault reason 06] PTE Read access is not set
[170933.781537] DRHD: handling fault status reg 3
[170933.781539] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74d00=
0=20
[170933.781540] DMAR:[fault reason 06] PTE Read access is not set
[170933.781552] DRHD: handling fault status reg 3
[170933.781554] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74f00=
0=20
[170933.781555] DMAR:[fault reason 06] PTE Read access is not set
[170933.781567] DRHD: handling fault status reg 3
[170933.781569] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75100=
0=20
[170933.781570] DMAR:[fault reason 06] PTE Read access is not set
[170933.781581] DRHD: handling fault status reg 3
[170933.781583] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75300=
0=20
[170933.781584] DMAR:[fault reason 06] PTE Read access is not set
[170933.781596] DRHD: handling fault status reg 3
[170933.781598] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75500=
0=20
[170933.781599] DMAR:[fault reason 06] PTE Read access is not set
[170933.781611] DRHD: handling fault status reg 3
[170933.781613] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75700=
0=20
[170933.781614] DMAR:[fault reason 06] PTE Read access is not set
[170933.781626] DRHD: handling fault status reg 3
[170933.781628] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75900=
0=20
[170933.781629] DMAR:[fault reason 06] PTE Read access is not set
[170933.781640] DRHD: handling fault status reg 3
[170933.781642] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75a00=
0=20
[170933.781643] DMAR:[fault reason 06] PTE Read access is not set
[170933.781655] DRHD: handling fault status reg 3
[170933.781657] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75c00=
0=20
[170933.781658] DMAR:[fault reason 06] PTE Read access is not set
[170933.781670] DRHD: handling fault status reg 3
[170933.781672] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75e00=
0=20
[170933.781673] DMAR:[fault reason 06] PTE Read access is not set
[170933.781685] DRHD: handling fault status reg 3
[170933.781687] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76000=
0=20
[170933.781688] DMAR:[fault reason 06] PTE Read access is not set
[170933.781699] DRHD: handling fault status reg 3
[170933.781702] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76200=
0=20
[170933.781702] DMAR:[fault reason 06] PTE Read access is not set
[170933.781715] DRHD: handling fault status reg 3
[170933.781717] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76400=
0=20
[170933.781718] DMAR:[fault reason 06] PTE Read access is not set
[170933.781730] DRHD: handling fault status reg 3
[170933.781732] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76600=
0=20
[170933.781733] DMAR:[fault reason 06] PTE Read access is not set
[170933.781744] DRHD: handling fault status reg 3
[170933.781746] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76800=
0=20
[170933.781747] DMAR:[fault reason 06] PTE Read access is not set
[170933.781759] DRHD: handling fault status reg 3
[170933.781761] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76900=
0=20
[170933.781762] DMAR:[fault reason 06] PTE Read access is not set
[170933.781774] DRHD: handling fault status reg 3
[170933.781776] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76b00=
0=20
[170933.781777] DMAR:[fault reason 06] PTE Read access is not set
[170933.781789] DRHD: handling fault status reg 3
[170933.781791] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76d00=
0=20
[170933.781792] DMAR:[fault reason 06] PTE Read access is not set
[170933.781803] DRHD: handling fault status reg 3
[170933.781805] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76f00=
0=20
[170933.781806] DMAR:[fault reason 06] PTE Read access is not set
[170933.781818] DRHD: handling fault status reg 3
[170933.781820] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77100=
0=20
[170933.781821] DMAR:[fault reason 06] PTE Read access is not set
[170933.781833] DRHD: handling fault status reg 3
[170933.781835] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77300=
0=20
[170933.781836] DMAR:[fault reason 06] PTE Read access is not set
[170933.781848] DRHD: handling fault status reg 3
[170933.781850] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77500=
0=20
[170933.781851] DMAR:[fault reason 06] PTE Read access is not set
[170933.781862] DRHD: handling fault status reg 3
[170933.781865] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77700=
0=20
[170933.781865] DMAR:[fault reason 06] PTE Read access is not set
[170933.781877] DRHD: handling fault status reg 3
[170933.781879] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77800=
0=20
[170933.781880] DMAR:[fault reason 06] PTE Read access is not set
[170933.781892] DRHD: handling fault status reg 3
[170933.781894] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77a00=
0=20
[170933.781895] DMAR:[fault reason 06] PTE Read access is not set
[170933.781907] DRHD: handling fault status reg 3
[170933.781909] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77c00=
0=20
[170933.781910] DMAR:[fault reason 06] PTE Read access is not set
[170933.781922] DRHD: handling fault status reg 3
[170933.781924] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77e00=
0=20
[170933.781925] DMAR:[fault reason 06] PTE Read access is not set
[170933.781936] DRHD: handling fault status reg 3
[170933.781939] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78000=
0=20
[170933.781939] DMAR:[fault reason 06] PTE Read access is not set
[170933.781951] DRHD: handling fault status reg 3
[170933.781953] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78200=
0=20
[170933.781954] DMAR:[fault reason 06] PTE Read access is not set
[170933.781966] DRHD: handling fault status reg 3
[170933.781968] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78400=
0=20
[170933.781969] DMAR:[fault reason 06] PTE Read access is not set
[170933.781981] DRHD: handling fault status reg 3
[170933.781983] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78600=
0=20
[170933.781984] DMAR:[fault reason 06] PTE Read access is not set
[170933.781996] DRHD: handling fault status reg 3
[170933.781998] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78700=
0=20
[170933.781999] DMAR:[fault reason 06] PTE Read access is not set
[170933.782010] DRHD: handling fault status reg 3
[170933.782013] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78900=
0=20
[170933.782013] DMAR:[fault reason 06] PTE Read access is not set
[170933.782025] DRHD: handling fault status reg 3
[170933.782027] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78b00=
0=20
[170933.782028] DMAR:[fault reason 06] PTE Read access is not set
[170933.782040] DRHD: handling fault status reg 3
[170933.782042] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78d00=
0=20
[170933.782043] DMAR:[fault reason 06] PTE Read access is not set
[170933.782055] DRHD: handling fault status reg 3
[170933.782057] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78f00=
0=20
[170933.782058] DMAR:[fault reason 06] PTE Read access is not set
[170933.782070] DRHD: handling fault status reg 3
[170933.782072] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79100=
0=20
[170933.782073] DMAR:[fault reason 06] PTE Read access is not set
[170933.782084] DRHD: handling fault status reg 3
[170933.782086] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79300=
0=20
[170933.782087] DMAR:[fault reason 06] PTE Read access is not set
[170933.782099] DRHD: handling fault status reg 3
[170933.782101] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79500=
0=20
[170933.782102] DMAR:[fault reason 06] PTE Read access is not set
[170933.782114] DRHD: handling fault status reg 3
[170933.782116] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79600=
0=20
[170933.782117] DMAR:[fault reason 06] PTE Read access is not set
[170933.782129] DRHD: handling fault status reg 3
[170933.782131] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79800=
0=20
[170933.782132] DMAR:[fault reason 06] PTE Read access is not set
[170933.782144] DRHD: handling fault status reg 3
[170933.782146] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79a00=
0=20
[170933.782147] DMAR:[fault reason 06] PTE Read access is not set
[170933.782158] DRHD: handling fault status reg 3
[170933.782160] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79c00=
0=20
[170933.782161] DMAR:[fault reason 06] PTE Read access is not set
[170933.782173] DRHD: handling fault status reg 3
[170933.782175] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79e00=
0=20
[170933.782176] DMAR:[fault reason 06] PTE Read access is not set
[170933.782188] DRHD: handling fault status reg 3
[170933.782190] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a000=
0=20
[170933.782191] DMAR:[fault reason 06] PTE Read access is not set
[170933.782203] DRHD: handling fault status reg 3
[170933.782205] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a200=
0=20
[170933.782206] DMAR:[fault reason 06] PTE Read access is not set
[170933.782217] DRHD: handling fault status reg 3
[170933.782219] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a400=
0=20
[170933.782220] DMAR:[fault reason 06] PTE Read access is not set
[170933.782232] DRHD: handling fault status reg 3
[170933.782234] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a500=
0=20
[170933.782235] DMAR:[fault reason 06] PTE Read access is not set
[170933.782247] DRHD: handling fault status reg 3
[170933.782249] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a700=
0=20
[170933.782250] DMAR:[fault reason 06] PTE Read access is not set
[170933.782262] DRHD: handling fault status reg 3
[170933.782264] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a900=
0=20
[170933.782265] DMAR:[fault reason 06] PTE Read access is not set
[170933.782276] DRHD: handling fault status reg 3
[170933.782279] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7ab00=
0=20
[170933.782279] DMAR:[fault reason 06] PTE Read access is not set
[170933.782291] DRHD: handling fault status reg 3
[170933.782293] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7ad00=
0=20
[170933.782294] DMAR:[fault reason 06] PTE Read access is not set
[170933.782306] DRHD: handling fault status reg 3
[170933.782308] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7af00=
0=20
[170933.782309] DMAR:[fault reason 06] PTE Read access is not set
[170933.782321] DRHD: handling fault status reg 3
[170933.782323] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b100=
0=20
[170933.782324] DMAR:[fault reason 06] PTE Read access is not set
[170933.782336] DRHD: handling fault status reg 3
[170933.782338] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b300=
0=20
[170933.782339] DMAR:[fault reason 06] PTE Read access is not set
[170933.782351] DRHD: handling fault status reg 3
[170933.782353] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b400=
0=20
[170933.782354] DMAR:[fault reason 06] PTE Read access is not set
[170933.782365] DRHD: handling fault status reg 3
[170933.782367] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b600=
0=20
[170933.782368] DMAR:[fault reason 06] PTE Read access is not set
[170933.782381] DRHD: handling fault status reg 3
[170933.782383] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b800=
0=20
[170933.782384] DMAR:[fault reason 06] PTE Read access is not set
[170933.782395] DRHD: handling fault status reg 3
[170933.782398] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7ba00=
0=20
[170933.782398] DMAR:[fault reason 06] PTE Read access is not set
[170933.782410] DRHD: handling fault status reg 3
[170933.782412] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7bc00=
0=20
[170933.782413] DMAR:[fault reason 06] PTE Read access is not set
[170933.782425] DRHD: handling fault status reg 3
[170933.782427] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7be00=
0=20
[170933.782428] DMAR:[fault reason 06] PTE Read access is not set
[170933.782440] DRHD: handling fault status reg 3
[170933.782442] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c000=
0=20
[170933.782443] DMAR:[fault reason 06] PTE Read access is not set
[170933.782454] DRHD: handling fault status reg 3
[170933.782456] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c200=
0=20
[170933.782457] DMAR:[fault reason 06] PTE Read access is not set
[170933.782469] DRHD: handling fault status reg 3
[170933.782471] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c300=
0=20
[170933.782472] DMAR:[fault reason 06] PTE Read access is not set
[170933.782484] DRHD: handling fault status reg 3
[170933.782486] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c500=
0=20
[170933.782487] DMAR:[fault reason 06] PTE Read access is not set
[170933.782499] DRHD: handling fault status reg 3
[170933.782501] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c700=
0=20
[170933.782502] DMAR:[fault reason 06] PTE Read access is not set
[170933.782513] DRHD: handling fault status reg 3
[170933.782516] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c900=
0=20
[170933.782516] DMAR:[fault reason 06] PTE Read access is not set
[170933.782528] DRHD: handling fault status reg 3
[170933.782530] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7cb00=
0=20
[170933.782531] DMAR:[fault reason 06] PTE Read access is not set
[170933.782543] DRHD: handling fault status reg 3
[170933.782545] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7cd00=
0=20
[170933.782546] DMAR:[fault reason 06] PTE Read access is not set
[170933.782558] DRHD: handling fault status reg 3
[170933.782560] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7cf00=
0=20
[170933.782561] DMAR:[fault reason 06] PTE Read access is not set
[170933.782573] DRHD: handling fault status reg 3
[170933.782575] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d100=
0=20
[170933.782576] DMAR:[fault reason 06] PTE Read access is not set
[170933.782587] DRHD: handling fault status reg 3
[170933.782590] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d200=
0=20
[170933.782590] DMAR:[fault reason 06] PTE Read access is not set
[170933.782602] DRHD: handling fault status reg 3
[170933.782604] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d400=
0=20
[170933.782605] DMAR:[fault reason 06] PTE Read access is not set
[170933.782617] DRHD: handling fault status reg 3
[170933.782619] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d600=
0=20
[170933.782620] DMAR:[fault reason 06] PTE Read access is not set
[170933.782632] DRHD: handling fault status reg 3
[170933.782634] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d800=
0=20
[170933.782635] DMAR:[fault reason 06] PTE Read access is not set
[170933.782647] DRHD: handling fault status reg 3
[170933.782649] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7da00=
0=20
[170933.782650] DMAR:[fault reason 06] PTE Read access is not set
[170933.782661] DRHD: handling fault status reg 3
[170933.782663] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7dc00=
0=20
[170933.782664] DMAR:[fault reason 06] PTE Read access is not set
[170933.782676] DRHD: handling fault status reg 3
[170933.782678] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7de00=
0=20
[170933.782679] DMAR:[fault reason 06] PTE Read access is not set
[170933.782691] DRHD: handling fault status reg 3
[170933.782693] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e000=
0=20
[170933.782694] DMAR:[fault reason 06] PTE Read access is not set
[170933.782708] DRHD: handling fault status reg 3
[170933.782710] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e100=
0=20
[170933.782711] DMAR:[fault reason 06] PTE Read access is not set
[170933.782721] DRHD: handling fault status reg 3
[170933.782723] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e300=
0=20
[170933.782724] DMAR:[fault reason 06] PTE Read access is not set
[170933.782735] DRHD: handling fault status reg 3
[170933.782737] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e500=
0=20
[170933.782738] DMAR:[fault reason 06] PTE Read access is not set
[170933.782750] DRHD: handling fault status reg 3
[170933.782752] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e700=
0=20
[170933.782753] DMAR:[fault reason 06] PTE Read access is not set
[170933.784587] DRHD: handling fault status reg 2
[170933.784590] DMAR:[DMA Read] Request device [00:02.0] fault addr ff57f00=
0=20
[170933.784590] DMAR:[fault reason 06] PTE Read access is not set
[170933.784607] DRHD: handling fault status reg 3
[170933.784610] DMAR:[DMA Read] Request device [00:02.0] fault addr ff57f00=
0=20
[170933.784610] DMAR:[fault reason 06] PTE Read access is not set
[170933.784628] DRHD: handling fault status reg 3
[170933.784630] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58100=
0=20
[170933.784631] DMAR:[fault reason 06] PTE Read access is not set
[170933.784649] DRHD: handling fault status reg 3
[170933.784651] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58400=
0=20
[170933.784652] DMAR:[fault reason 06] PTE Read access is not set
[170933.784674] DRHD: handling fault status reg 3
[170933.784676] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58600=
0=20
[170933.784677] DMAR:[fault reason 06] PTE Read access is not set
[170933.784696] DRHD: handling fault status reg 3
[170933.784698] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58800=
0=20
[170933.784699] DMAR:[fault reason 06] PTE Read access is not set
[170933.784717] DRHD: handling fault status reg 3
[170933.784719] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58a00=
0=20
[170933.784720] DMAR:[fault reason 06] PTE Read access is not set
[170933.784738] DRHD: handling fault status reg 3
[170933.784741] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58d00=
0=20
[170933.784741] DMAR:[fault reason 06] PTE Read access is not set
[170933.784764] DRHD: handling fault status reg 3
[170933.784766] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58f00=
0=20
[170933.784767] DMAR:[fault reason 06] PTE Read access is not set
[170933.784785] DRHD: handling fault status reg 3
[170933.784787] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59100=
0=20
[170933.784788] DMAR:[fault reason 06] PTE Read access is not set
[170933.784806] DRHD: handling fault status reg 3
[170933.784808] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59400=
0=20
[170933.784809] DMAR:[fault reason 06] PTE Read access is not set
[170933.784826] DRHD: handling fault status reg 3
[170933.784828] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59600=
0=20
[170933.784829] DMAR:[fault reason 06] PTE Read access is not set
[170933.784847] DRHD: handling fault status reg 3
[170933.784849] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59800=
0=20
[170933.784850] DMAR:[fault reason 06] PTE Read access is not set
[170933.784873] DRHD: handling fault status reg 3
[170933.784875] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59b00=
0=20
[170933.784876] DMAR:[fault reason 06] PTE Read access is not set
[170933.784894] DRHD: handling fault status reg 3
[170933.784897] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59d00=
0=20
[170933.784897] DMAR:[fault reason 06] PTE Read access is not set
[170933.784916] DRHD: handling fault status reg 3
[170933.784918] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59f00=
0=20
[170933.784919] DMAR:[fault reason 06] PTE Read access is not set
[170933.784937] DRHD: handling fault status reg 3
[170933.784939] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a200=
0=20
[170933.784940] DMAR:[fault reason 06] PTE Read access is not set
[170933.784962] DRHD: handling fault status reg 3
[170933.784964] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a400=
0=20
[170933.784965] DMAR:[fault reason 06] PTE Read access is not set
[170933.784983] DRHD: handling fault status reg 3
[170933.784985] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a600=
0=20
[170933.784986] DMAR:[fault reason 06] PTE Read access is not set
[170933.785005] DRHD: handling fault status reg 3
[170933.785007] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a800=
0=20
[170933.785008] DMAR:[fault reason 06] PTE Read access is not set
[170933.785025] DRHD: handling fault status reg 3
[170933.785027] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5aa00=
0=20
[170933.785028] DMAR:[fault reason 06] PTE Read access is not set
[170933.785046] DRHD: handling fault status reg 3
[170933.785048] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ad00=
0=20
[170933.785049] DMAR:[fault reason 06] PTE Read access is not set
[170933.785071] DRHD: handling fault status reg 3
[170933.785074] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5af00=
0=20
[170933.785075] DMAR:[fault reason 06] PTE Read access is not set
[170933.785093] DRHD: handling fault status reg 3
[170933.785095] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b100=
0=20
[170933.785096] DMAR:[fault reason 06] PTE Read access is not set
[170933.785114] DRHD: handling fault status reg 3
[170933.785117] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b400=
0=20
[170933.785117] DMAR:[fault reason 06] PTE Read access is not set
[170933.785136] DRHD: handling fault status reg 3
[170933.785138] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b600=
0=20
[170933.785139] DMAR:[fault reason 06] PTE Read access is not set
[170933.785161] DRHD: handling fault status reg 3
[170933.785163] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b800=
0=20
[170933.785164] DMAR:[fault reason 06] PTE Read access is not set
[170933.785182] DRHD: handling fault status reg 3
[170933.785184] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5bb00=
0=20
[170933.785185] DMAR:[fault reason 06] PTE Read access is not set
[170933.785203] DRHD: handling fault status reg 3
[170933.785206] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5bd00=
0=20
[170933.785206] DMAR:[fault reason 06] PTE Read access is not set
[170933.785224] DRHD: handling fault status reg 3
[170933.785226] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5bf00=
0=20
[170933.785227] DMAR:[fault reason 06] PTE Read access is not set
[170933.785245] DRHD: handling fault status reg 3
[170933.785247] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c200=
0=20
[170933.785248] DMAR:[fault reason 06] PTE Read access is not set
[170933.785270] DRHD: handling fault status reg 3
[170933.785272] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c400=
0=20
[170933.785273] DMAR:[fault reason 06] PTE Read access is not set
[170933.785291] DRHD: handling fault status reg 3
[170933.785294] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c600=
0=20
[170933.785294] DMAR:[fault reason 06] PTE Read access is not set
[170933.785313] DRHD: handling fault status reg 3
[170933.785315] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c800=
0=20
[170933.785316] DMAR:[fault reason 06] PTE Read access is not set
[170933.785334] DRHD: handling fault status reg 3
[170933.785336] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cb00=
0=20
[170933.785337] DMAR:[fault reason 06] PTE Read access is not set
[170933.785359] DRHD: handling fault status reg 3
[170933.785361] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cd00=
0=20
[170933.785362] DMAR:[fault reason 06] PTE Read access is not set
[170933.785381] DRHD: handling fault status reg 3
[170933.785383] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cf00=
0=20
[170933.785384] DMAR:[fault reason 06] PTE Read access is not set
[170933.785402] DRHD: handling fault status reg 3
[170933.785404] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d200=
0=20
[170933.785405] DMAR:[fault reason 06] PTE Read access is not set
[170933.785422] DRHD: handling fault status reg 3
[170933.785425] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d400=
0=20
[170933.785425] DMAR:[fault reason 06] PTE Read access is not set
[170933.785443] DRHD: handling fault status reg 3
[170933.785446] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d600=
0=20
[170933.785446] DMAR:[fault reason 06] PTE Read access is not set
[170933.785469] DRHD: handling fault status reg 3
[170933.785471] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d800=
0=20
[170933.785472] DMAR:[fault reason 06] PTE Read access is not set
[170933.785490] DRHD: handling fault status reg 3
[170933.785492] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5db00=
0=20
[170933.785493] DMAR:[fault reason 06] PTE Read access is not set
[170933.785512] DRHD: handling fault status reg 3
[170933.785514] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5dd00=
0=20
[170933.785515] DMAR:[fault reason 06] PTE Read access is not set
[170933.785533] DRHD: handling fault status reg 3
[170933.785535] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5df00=
0=20
[170933.785536] DMAR:[fault reason 06] PTE Read access is not set
[170933.785558] DRHD: handling fault status reg 3
[170933.785560] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e200=
0=20
[170933.785561] DMAR:[fault reason 06] PTE Read access is not set
[170933.785579] DRHD: handling fault status reg 3
[170933.785581] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e400=
0=20
[170933.785582] DMAR:[fault reason 06] PTE Read access is not set
[170933.785601] DRHD: handling fault status reg 3
[170933.785603] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e600=
0=20
[170933.785604] DMAR:[fault reason 06] PTE Read access is not set
[170933.785621] DRHD: handling fault status reg 3
[170933.785623] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e800=
0=20
[170933.785624] DMAR:[fault reason 06] PTE Read access is not set
[170933.785642] DRHD: handling fault status reg 3
[170933.785644] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5eb00=
0=20
[170933.785645] DMAR:[fault reason 06] PTE Read access is not set
[170933.785668] DRHD: handling fault status reg 3
[170933.785670] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ed00=
0=20
[170933.785670] DMAR:[fault reason 06] PTE Read access is not set
[170933.785689] DRHD: handling fault status reg 3
[170933.785691] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ef00=
0=20
[170933.785692] DMAR:[fault reason 06] PTE Read access is not set
[170933.785711] DRHD: handling fault status reg 3
[170933.785713] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f200=
0=20
[170933.785714] DMAR:[fault reason 06] PTE Read access is not set
[170933.785732] DRHD: handling fault status reg 3
[170933.785734] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f400=
0=20
[170933.785735] DMAR:[fault reason 06] PTE Read access is not set
[170933.785757] DRHD: handling fault status reg 3
[170933.785759] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f600=
0=20
[170933.785760] DMAR:[fault reason 06] PTE Read access is not set
[170933.785778] DRHD: handling fault status reg 3
[170933.785780] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f900=
0=20
[170933.785781] DMAR:[fault reason 06] PTE Read access is not set
[170933.785799] DRHD: handling fault status reg 3
[170933.785801] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5fb00=
0=20
[170933.785802] DMAR:[fault reason 06] PTE Read access is not set
[170933.785821] DRHD: handling fault status reg 3
[170933.785823] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5fd00=
0=20
[170933.785824] DMAR:[fault reason 06] PTE Read access is not set
[170933.785842] DRHD: handling fault status reg 3
[170933.785844] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60000=
0=20
[170933.785845] DMAR:[fault reason 06] PTE Read access is not set
[170933.785868] DRHD: handling fault status reg 3
[170933.785870] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60200=
0=20
[170933.785871] DMAR:[fault reason 06] PTE Read access is not set
[170933.785889] DRHD: handling fault status reg 3
[170933.785891] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60400=
0=20
[170933.785892] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.785910] DRHD: handling fault status reg 3
[170933.785912] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60600=
0=20
[170933.785913] DMAR:[fault reason 06] PTE Read access is not set
[170933.785932] DRHD: handling fault status reg 3
[170933.785934] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60900=
0=20
[170933.785935] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.785957] DRHD: handling fault status reg 3
[170933.785959] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60b00=
0=20
[170933.785960] DMAR:[fault reason 06] PTE Read access is not set
[170933.785978] DRHD: handling fault status reg 3
[170933.785980] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60d00=
0=20
[170933.785981] DMAR:[fault reason 06] PTE Read access is not set
[170933.786000] DRHD: handling fault status reg 3
[170933.786002] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61000=
0=20
[170933.786003] DMAR:[fault reason 06] PTE Read access is not set
[170933.786020] DRHD: handling fault status reg 3
[170933.786023] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61200=
0=20
[170933.786023] DMAR:[fault reason 06] PTE Read access is not set
[170933.786046] DRHD: handling fault status reg 3
[170933.786048] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61400=
0=20
[170933.786049] DMAR:[fault reason 06] PTE Read access is not set
[170933.786067] DRHD: handling fault status reg 3
[170933.786069] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61700=
0=20
[170933.786070] DMAR:[fault reason 06] PTE Read access is not set
[170933.786089] DRHD: handling fault status reg 3
[170933.786091] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61900=
0=20
[170933.786092] DMAR:[fault reason 06] PTE Read access is not set
[170933.786110] DRHD: handling fault status reg 3
[170933.786112] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61b00=
0=20
[170933.786113] DMAR:[fault reason 06] PTE Read access is not set
[170933.786131] DRHD: handling fault status reg 3
[170933.786133] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61e00=
0=20
[170933.786134] DMAR:[fault reason 06] PTE Read access is not set
[170933.786157] DRHD: handling fault status reg 3
[170933.786159] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62000=
0=20
[170933.786160] DMAR:[fault reason 06] PTE Read access is not set
[170933.786178] DRHD: handling fault status reg 3
[170933.786180] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62200=
0=20
[170933.786181] DMAR:[fault reason 06] PTE Read access is not set
[170933.786199] DRHD: handling fault status reg 3
[170933.786201] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62400=
0=20
[170933.786202] DMAR:[fault reason 06] PTE Read access is not set
[170933.786220] DRHD: handling fault status reg 3
[170933.786222] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62700=
0=20
[170933.786223] DMAR:[fault reason 06] PTE Read access is not set
[170933.786245] DRHD: handling fault status reg 3
[170933.786247] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62900=
0=20
[170933.786248] DMAR:[fault reason 06] PTE Read access is not set
[170933.786267] DRHD: handling fault status reg 3
[170933.786269] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62b00=
0=20
[170933.786270] DMAR:[fault reason 06] PTE Read access is not set
[170933.786289] DRHD: handling fault status reg 3
[170933.786291] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62e00=
0=20
[170933.786292] DMAR:[fault reason 06] PTE Read access is not set
[170933.786310] DRHD: handling fault status reg 3
[170933.786312] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63000=
0=20
[170933.786313] DMAR:[fault reason 06] PTE Read access is not set
[170933.786334] DRHD: handling fault status reg 3
[170933.786337] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63200=
0=20
[170933.786337] DMAR:[fault reason 06] PTE Read access is not set
[170933.786356] DRHD: handling fault status reg 3
[170933.786358] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63500=
0=20
[170933.786359] DMAR:[fault reason 06] PTE Read access is not set
[170933.786378] DRHD: handling fault status reg 3
[170933.786380] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63700=
0=20
[170933.786381] DMAR:[fault reason 06] PTE Read access is not set
[170933.786399] DRHD: handling fault status reg 3
[170933.786401] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63900=
0=20
[170933.786402] DMAR:[fault reason 06] PTE Read access is not set
[170933.786420] DRHD: handling fault status reg 3
[170933.786422] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63c00=
0=20
[170933.786423] DMAR:[fault reason 06] PTE Read access is not set
[170933.786445] DRHD: handling fault status reg 3
[170933.786447] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63e00=
0=20
[170933.786448] DMAR:[fault reason 06] PTE Read access is not set
[170933.786467] DRHD: handling fault status reg 3
[170933.786469] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64000=
0=20
[170933.786470] DMAR:[fault reason 06] PTE Read access is not set
[170933.786488] DRHD: handling fault status reg 3
[170933.786490] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64200=
0=20
[170933.786491] DMAR:[fault reason 06] PTE Read access is not set
[170933.786509] DRHD: handling fault status reg 3
[170933.786511] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64500=
0=20
[170933.786512] DMAR:[fault reason 06] PTE Read access is not set
[170933.786534] DRHD: handling fault status reg 3
[170933.786537] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64700=
0=20
[170933.786537] DMAR:[fault reason 06] PTE Read access is not set
[170933.786556] DRHD: handling fault status reg 3
[170933.786558] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64900=
0=20
[170933.786559] DMAR:[fault reason 06] PTE Read access is not set
[170933.786577] DRHD: handling fault status reg 3
[170933.786579] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64c00=
0=20
[170933.786580] DMAR:[fault reason 06] PTE Read access is not set
[170933.786599] DRHD: handling fault status reg 3
[170933.786601] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64e00=
0=20
[170933.786602] DMAR:[fault reason 06] PTE Read access is not set
[170933.786624] DRHD: handling fault status reg 3
[170933.786626] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65000=
0=20
[170933.786627] DMAR:[fault reason 06] PTE Read access is not set
[170933.786645] DRHD: handling fault status reg 3
[170933.786647] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65300=
0=20
[170933.786648] DMAR:[fault reason 06] PTE Read access is not set
[170933.786666] DRHD: handling fault status reg 3
[170933.786669] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65500=
0=20
[170933.786669] DMAR:[fault reason 06] PTE Read access is not set
[170933.786687] DRHD: handling fault status reg 3
[170933.786689] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65700=
0=20
[170933.786690] DMAR:[fault reason 06] PTE Read access is not set
[170933.786708] DRHD: handling fault status reg 3
[170933.786710] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65900=
0=20
[170933.786711] DMAR:[fault reason 06] PTE Read access is not set
[170933.786733] DRHD: handling fault status reg 3
[170933.786735] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65c00=
0=20
[170933.786736] DMAR:[fault reason 06] PTE Read access is not set
[170933.786754] DRHD: handling fault status reg 3
[170933.786757] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65e00=
0=20
[170933.786757] DMAR:[fault reason 06] PTE Read access is not set
[170933.786776] DRHD: handling fault status reg 3
[170933.786778] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66000=
0=20
[170933.786779] DMAR:[fault reason 06] PTE Read access is not set
[170933.786797] DRHD: handling fault status reg 3
[170933.786799] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66300=
0=20
[170933.786800] DMAR:[fault reason 06] PTE Read access is not set
[170933.786823] DRHD: handling fault status reg 3
[170933.786825] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66500=
0=20
[170933.786826] DMAR:[fault reason 06] PTE Read access is not set
[170933.786843] DRHD: handling fault status reg 3
[170933.786846] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66700=
0=20
[170933.786846] DMAR:[fault reason 06] PTE Read access is not set
[170933.786865] DRHD: handling fault status reg 3
[170933.786867] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66900=
0=20
[170933.786868] DMAR:[fault reason 06] PTE Read access is not set
[170933.786885] DRHD: handling fault status reg 3
[170933.786887] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66c00=
0=20
[170933.786888] DMAR:[fault reason 06] PTE Read access is not set
[170933.786906] DRHD: handling fault status reg 3
[170933.786908] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66e00=
0=20
[170933.786909] DMAR:[fault reason 06] PTE Read access is not set
[170933.786932] DRHD: handling fault status reg 3
[170933.786934] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67000=
0=20
[170933.786935] DMAR:[fault reason 06] PTE Read access is not set
[170933.786953] DRHD: handling fault status reg 3
[170933.786955] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67300=
0=20
[170933.786956] DMAR:[fault reason 06] PTE Read access is not set
[170933.786975] DRHD: handling fault status reg 3
[170933.786977] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67500=
0=20
[170933.786978] DMAR:[fault reason 06] PTE Read access is not set
[170933.786996] DRHD: handling fault status reg 3
[170933.786998] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67700=
0=20
[170933.786999] DMAR:[fault reason 06] PTE Read access is not set
[170933.787021] DRHD: handling fault status reg 3
[170933.787023] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67a00=
0=20
[170933.787024] DMAR:[fault reason 06] PTE Read access is not set
[170933.787042] DRHD: handling fault status reg 3
[170933.787045] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67c00=
0=20
[170933.787045] DMAR:[fault reason 06] PTE Read access is not set
[170933.787064] DRHD: handling fault status reg 3
[170933.787066] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67e00=
0=20
[170933.787067] DMAR:[fault reason 06] PTE Read access is not set
[170933.787084] DRHD: handling fault status reg 3
[170933.787086] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68000=
0=20
[170933.787087] DMAR:[fault reason 06] PTE Read access is not set
[170933.787105] DRHD: handling fault status reg 3
[170933.787107] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68300=
0=20
[170933.787108] DMAR:[fault reason 06] PTE Read access is not set
[170933.787130] DRHD: handling fault status reg 3
[170933.787133] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68500=
0=20
[170933.787133] DMAR:[fault reason 06] PTE Read access is not set
[170933.787152] DRHD: handling fault status reg 3
[170933.787154] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68700=
0=20
[170933.787155] DMAR:[fault reason 06] PTE Read access is not set
[170933.787173] DRHD: handling fault status reg 3
[170933.787175] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68900=
0=20
[170933.787176] DMAR:[fault reason 06] PTE Read access is not set
[170933.787195] DRHD: handling fault status reg 3
[170933.787197] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68c00=
0=20
[170933.787198] DMAR:[fault reason 06] PTE Read access is not set
[170933.787220] DRHD: handling fault status reg 3
[170933.787222] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68e00=
0=20
[170933.787223] DMAR:[fault reason 06] PTE Read access is not set
[170933.787241] DRHD: handling fault status reg 3
[170933.787243] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69000=
0=20
[170933.787244] DMAR:[fault reason 06] PTE Read access is not set
[170933.787262] DRHD: handling fault status reg 3
[170933.787264] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69300=
0=20
[170933.787265] DMAR:[fault reason 06] PTE Read access is not set
[170933.787283] DRHD: handling fault status reg 3
[170933.787285] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69500=
0=20
[170933.787286] DMAR:[fault reason 06] PTE Read access is not set
[170933.794530] DRHD: handling fault status reg 3
[170933.794533] DMAR:[DMA Read] Request device [00:02.0] fault addr ff57f00=
0=20
[170933.794534] DMAR:[fault reason 06] PTE Read access is not set
[170933.794543] DRHD: handling fault status reg 3
[170933.794545] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58000=
0=20
[170933.794546] DMAR:[fault reason 06] PTE Read access is not set
[170933.794557] DRHD: handling fault status reg 3
[170933.794559] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58200=
0=20
[170933.794560] DMAR:[fault reason 06] PTE Read access is not set
[170933.794572] DRHD: handling fault status reg 3
[170933.794574] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58400=
0=20
[170933.794575] DMAR:[fault reason 06] PTE Read access is not set
[170933.794587] DRHD: handling fault status reg 3
[170933.794589] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58600=
0=20
[170933.794590] DMAR:[fault reason 06] PTE Read access is not set
[170933.794601] DRHD: handling fault status reg 3
[170933.794604] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58800=
0=20
[170933.794604] DMAR:[fault reason 06] PTE Read access is not set
[170933.794616] DRHD: handling fault status reg 3
[170933.794618] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58900=
0=20
[170933.794619] DMAR:[fault reason 06] PTE Read access is not set
[170933.794631] DRHD: handling fault status reg 3
[170933.794633] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58b00=
0=20
[170933.794634] DMAR:[fault reason 06] PTE Read access is not set
[170933.794646] DRHD: handling fault status reg 3
[170933.794648] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58d00=
0=20
[170933.794649] DMAR:[fault reason 06] PTE Read access is not set
[170933.794660] DRHD: handling fault status reg 3
[170933.794663] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58f00=
0=20
[170933.794663] DMAR:[fault reason 06] PTE Read access is not set
[170933.794675] DRHD: handling fault status reg 3
[170933.794677] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59100=
0=20
[170933.794678] DMAR:[fault reason 06] PTE Read access is not set
[170933.794694] DRHD: handling fault status reg 3
[170933.794696] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59300=
0=20
[170933.794697] DMAR:[fault reason 06] PTE Read access is not set
[170933.794705] DRHD: handling fault status reg 3
[170933.794707] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59500=
0=20
[170933.794708] DMAR:[fault reason 06] PTE Read access is not set
[170933.794720] DRHD: handling fault status reg 3
[170933.794723] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59700=
0=20
[170933.794723] DMAR:[fault reason 06] PTE Read access is not set
[170933.794735] DRHD: handling fault status reg 3
[170933.794737] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59800=
0=20
[170933.794738] DMAR:[fault reason 06] PTE Read access is not set
[170933.794749] DRHD: handling fault status reg 3
[170933.794752] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59a00=
0=20
[170933.794753] DMAR:[fault reason 06] PTE Read access is not set
[170933.794764] DRHD: handling fault status reg 3
[170933.794766] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59c00=
0=20
[170933.794767] DMAR:[fault reason 06] PTE Read access is not set
[170933.794779] DRHD: handling fault status reg 3
[170933.794781] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59e00=
0=20
[170933.794782] DMAR:[fault reason 06] PTE Read access is not set
[170933.794794] DRHD: handling fault status reg 3
[170933.794796] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a000=
0=20
[170933.794797] DMAR:[fault reason 06] PTE Read access is not set
[170933.794809] DRHD: handling fault status reg 3
[170933.794811] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a200=
0=20
[170933.794812] DMAR:[fault reason 06] PTE Read access is not set
[170933.794823] DRHD: handling fault status reg 3
[170933.794825] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a400=
0=20
[170933.794826] DMAR:[fault reason 06] PTE Read access is not set
[170933.794838] DRHD: handling fault status reg 3
[170933.794840] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a600=
0=20
[170933.794841] DMAR:[fault reason 06] PTE Read access is not set
[170933.794853] DRHD: handling fault status reg 3
[170933.794855] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a700=
0=20
[170933.794856] DMAR:[fault reason 06] PTE Read access is not set
[170933.794868] DRHD: handling fault status reg 3
[170933.794870] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a900=
0=20
[170933.794871] DMAR:[fault reason 06] PTE Read access is not set
[170933.794882] DRHD: handling fault status reg 3
[170933.794884] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ab00=
0=20
[170933.794885] DMAR:[fault reason 06] PTE Read access is not set
[170933.794898] DRHD: handling fault status reg 3
[170933.794900] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ad00=
0=20
[170933.794901] DMAR:[fault reason 06] PTE Read access is not set
[170933.794912] DRHD: handling fault status reg 3
[170933.794914] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5af00=
0=20
[170933.794915] DMAR:[fault reason 06] PTE Read access is not set
[170933.794927] DRHD: handling fault status reg 3
[170933.794929] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b100=
0=20
[170933.794930] DMAR:[fault reason 06] PTE Read access is not set
[170933.794942] DRHD: handling fault status reg 3
[170933.794944] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b300=
0=20
[170933.794945] DMAR:[fault reason 06] PTE Read access is not set
[170933.794957] DRHD: handling fault status reg 3
[170933.794959] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b500=
0=20
[170933.794960] DMAR:[fault reason 06] PTE Read access is not set
[170933.794972] DRHD: handling fault status reg 3
[170933.794974] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b600=
0=20
[170933.794975] DMAR:[fault reason 06] PTE Read access is not set
[170933.794986] DRHD: handling fault status reg 3
[170933.794989] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b800=
0=20
[170933.794989] DMAR:[fault reason 06] PTE Read access is not set
[170933.795001] DRHD: handling fault status reg 3
[170933.795003] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ba00=
0=20
[170933.795004] DMAR:[fault reason 06] PTE Read access is not set
[170933.795016] DRHD: handling fault status reg 3
[170933.795018] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5bc00=
0=20
[170933.795019] DMAR:[fault reason 06] PTE Read access is not set
[170933.795030] DRHD: handling fault status reg 3
[170933.795033] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5be00=
0=20
[170933.795033] DMAR:[fault reason 06] PTE Read access is not set
[170933.795045] DRHD: handling fault status reg 3
[170933.795047] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c000=
0=20
[170933.795048] DMAR:[fault reason 06] PTE Read access is not set
[170933.795060] DRHD: handling fault status reg 3
[170933.795062] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c200=
0=20
[170933.795063] DMAR:[fault reason 06] PTE Read access is not set
[170933.795075] DRHD: handling fault status reg 3
[170933.795077] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c400=
0=20
[170933.795078] DMAR:[fault reason 06] PTE Read access is not set
[170933.795090] DRHD: handling fault status reg 3
[170933.795092] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c500=
0=20
[170933.795093] DMAR:[fault reason 06] PTE Read access is not set
[170933.795104] DRHD: handling fault status reg 3
[170933.795107] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c700=
0=20
[170933.795107] DMAR:[fault reason 06] PTE Read access is not set
[170933.795119] DRHD: handling fault status reg 3
[170933.795121] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c900=
0=20
[170933.795122] DMAR:[fault reason 06] PTE Read access is not set
[170933.795134] DRHD: handling fault status reg 3
[170933.795136] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cb00=
0=20
[170933.795137] DMAR:[fault reason 06] PTE Read access is not set
[170933.795149] DRHD: handling fault status reg 3
[170933.795151] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cd00=
0=20
[170933.795152] DMAR:[fault reason 06] PTE Read access is not set
[170933.795163] DRHD: handling fault status reg 3
[170933.795166] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cf00=
0=20
[170933.795166] DMAR:[fault reason 06] PTE Read access is not set
[170933.795178] DRHD: handling fault status reg 3
[170933.795180] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d100=
0=20
[170933.795181] DMAR:[fault reason 06] PTE Read access is not set
[170933.795193] DRHD: handling fault status reg 3
[170933.795195] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d300=
0=20
[170933.795196] DMAR:[fault reason 06] PTE Read access is not set
[170933.795208] DRHD: handling fault status reg 3
[170933.795210] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d400=
0=20
[170933.795211] DMAR:[fault reason 06] PTE Read access is not set
[170933.795223] DRHD: handling fault status reg 3
[170933.795225] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d600=
0=20
[170933.795226] DMAR:[fault reason 06] PTE Read access is not set
[170933.795238] DRHD: handling fault status reg 3
[170933.795240] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d800=
0=20
[170933.795241] DMAR:[fault reason 06] PTE Read access is not set
[170933.795252] DRHD: handling fault status reg 3
[170933.795254] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5da00=
0=20
[170933.795255] DMAR:[fault reason 06] PTE Read access is not set
[170933.795268] DRHD: handling fault status reg 3
[170933.795270] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5dc00=
0=20
[170933.795271] DMAR:[fault reason 06] PTE Read access is not set
[170933.795282] DRHD: handling fault status reg 3
[170933.795284] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5de00=
0=20
[170933.795285] DMAR:[fault reason 06] PTE Read access is not set
[170933.795297] DRHD: handling fault status reg 3
[170933.795299] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e000=
0=20
[170933.795300] DMAR:[fault reason 06] PTE Read access is not set
[170933.795312] DRHD: handling fault status reg 3
[170933.795314] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e200=
0=20
[170933.795315] DMAR:[fault reason 06] PTE Read access is not set
[170933.795327] DRHD: handling fault status reg 3
[170933.795329] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e300=
0=20
[170933.795330] DMAR:[fault reason 06] PTE Read access is not set
[170933.795341] DRHD: handling fault status reg 3
[170933.795343] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e500=
0=20
[170933.795344] DMAR:[fault reason 06] PTE Read access is not set
[170933.795356] DRHD: handling fault status reg 3
[170933.795358] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e700=
0=20
[170933.795359] DMAR:[fault reason 06] PTE Read access is not set
[170933.795371] DRHD: handling fault status reg 3
[170933.795373] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e900=
0=20
[170933.795374] DMAR:[fault reason 06] PTE Read access is not set
[170933.795386] DRHD: handling fault status reg 3
[170933.795388] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5eb00=
0=20
[170933.795389] DMAR:[fault reason 06] PTE Read access is not set
[170933.795400] DRHD: handling fault status reg 3
[170933.795402] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ed00=
0=20
[170933.795403] DMAR:[fault reason 06] PTE Read access is not set
[170933.795415] DRHD: handling fault status reg 3
[170933.795417] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ef00=
0=20
[170933.795418] DMAR:[fault reason 06] PTE Read access is not set
[170933.795430] DRHD: handling fault status reg 3
[170933.795432] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f100=
0=20
[170933.795433] DMAR:[fault reason 06] PTE Read access is not set
[170933.795445] DRHD: handling fault status reg 3
[170933.795447] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f200=
0=20
[170933.795448] DMAR:[fault reason 06] PTE Read access is not set
[170933.795460] DRHD: handling fault status reg 3
[170933.795462] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f400=
0=20
[170933.795463] DMAR:[fault reason 06] PTE Read access is not set
[170933.795474] DRHD: handling fault status reg 3
[170933.795476] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f600=
0=20
[170933.795477] DMAR:[fault reason 06] PTE Read access is not set
[170933.795489] DRHD: handling fault status reg 3
[170933.795491] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f800=
0=20
[170933.795492] DMAR:[fault reason 06] PTE Read access is not set
[170933.795504] DRHD: handling fault status reg 3
[170933.795506] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5fa00=
0=20
[170933.795507] DMAR:[fault reason 06] PTE Read access is not set
[170933.795519] DRHD: handling fault status reg 3
[170933.795521] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5fc00=
0=20
[170933.795522] DMAR:[fault reason 06] PTE Read access is not set
[170933.795534] DRHD: handling fault status reg 3
[170933.795536] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5fe00=
0=20
[170933.795537] DMAR:[fault reason 06] PTE Read access is not set
[170933.795548] DRHD: handling fault status reg 3
[170933.795550] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60000=
0=20
[170933.795551] DMAR:[fault reason 06] PTE Read access is not set
[170933.795564] DRHD: handling fault status reg 3
[170933.795566] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60100=
0=20
[170933.795566] DMAR:[fault reason 06] PTE Read access is not set
[170933.795578] DRHD: handling fault status reg 3
[170933.795580] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60300=
0=20
[170933.795581] DMAR:[fault reason 06] PTE Read access is not set
[170933.795593] DRHD: handling fault status reg 3
[170933.795595] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60500=
0=20
[170933.795596] DMAR:[fault reason 06] PTE Read access is not set
[170933.795607] DRHD: handling fault status reg 3
[170933.795610] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60700=
0=20
[170933.795610] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.795622] DRHD: handling fault status reg 3
[170933.795624] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60900=
0=20
[170933.795625] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.795637] DRHD: handling fault status reg 3
[170933.795639] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60b00=
0=20
[170933.795640] DMAR:[fault reason 06] PTE Read access is not set
[170933.795652] DRHD: handling fault status reg 3
[170933.795654] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60d00=
0=20
[170933.795655] DMAR:[fault reason 06] PTE Read access is not set
[170933.795666] DRHD: handling fault status reg 3
[170933.795669] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60f00=
0=20
[170933.795669] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.795681] DRHD: handling fault status reg 3
[170933.795683] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61000=
0=20
[170933.795684] DMAR:[fault reason 06] PTE Read access is not set
[170933.795697] DRHD: handling fault status reg 3
[170933.795699] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61200=
0=20
[170933.795700] DMAR:[fault reason 06] PTE Read access is not set
[170933.795711] DRHD: handling fault status reg 3
[170933.795714] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61400=
0=20
[170933.795714] DMAR:[fault reason 06] PTE Read access is not set
[170933.795726] DRHD: handling fault status reg 3
[170933.795728] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61600=
0=20
[170933.795729] DMAR:[fault reason 06] PTE Read access is not set
[170933.795741] DRHD: handling fault status reg 3
[170933.795743] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61800=
0=20
[170933.795744] DMAR:[fault reason 06] PTE Read access is not set
[170933.795755] DRHD: handling fault status reg 3
[170933.795757] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61a00=
0=20
[170933.795758] DMAR:[fault reason 06] PTE Read access is not set
[170933.795770] DRHD: handling fault status reg 3
[170933.795773] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61c00=
0=20
[170933.795773] DMAR:[fault reason 06] PTE Read access is not set
[170933.795785] DRHD: handling fault status reg 3
[170933.795787] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61e00=
0=20
[170933.795788] DMAR:[fault reason 06] PTE Read access is not set
[170933.795800] DRHD: handling fault status reg 3
[170933.795802] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61f00=
0=20
[170933.795803] DMAR:[fault reason 06] PTE Read access is not set
[170933.795815] DRHD: handling fault status reg 3
[170933.795817] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62100=
0=20
[170933.795818] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.795830] DRHD: handling fault status reg 3
[170933.795832] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62300=
0=20
[170933.795833] DMAR:[fault reason 06] PTE Read access is not set
[170933.795845] DRHD: handling fault status reg 3
[170933.795847] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62500=
0=20
[170933.795847] DMAR:[fault reason 06] PTE Read access is not set
[170933.795859] DRHD: handling fault status reg 3
[170933.795861] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62700=
0=20
[170933.795862] DMAR:[fault reason 06] PTE Read access is not set
[170933.795874] DRHD: handling fault status reg 3
[170933.795876] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62900=
0=20
[170933.795877] DMAR:[fault reason 06] PTE Read access is not set
[170933.795889] DRHD: handling fault status reg 3
[170933.795891] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62b00=
0=20
[170933.795892] DMAR:[fault reason 06] PTE Read access is not set
[170933.795903] DRHD: handling fault status reg 3
[170933.795906] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62d00=
0=20
[170933.795906] DMAR:[fault reason 06] PTE Read access is not set
[170933.795918] DRHD: handling fault status reg 3
[170933.795920] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62e00=
0=20
[170933.795921] DMAR:[fault reason 06] PTE Read access is not set
[170933.795933] DRHD: handling fault status reg 3
[170933.795935] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63000=
0=20
[170933.795936] DMAR:[fault reason 06] PTE Read access is not set
[170933.795948] DRHD: handling fault status reg 3
[170933.795950] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63200=
0=20
[170933.795951] DMAR:[fault reason 06] PTE Read access is not set
[170933.795962] DRHD: handling fault status reg 3
[170933.795964] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63400=
0=20
[170933.795965] DMAR:[fault reason 06] PTE Read access is not set
[170933.795978] DRHD: handling fault status reg 3
[170933.795980] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63600=
0=20
[170933.795981] DMAR:[fault reason 06] PTE Read access is not set
[170933.795992] DRHD: handling fault status reg 3
[170933.795994] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63800=
0=20
[170933.795995] DMAR:[fault reason 06] PTE Read access is not set
[170933.796007] DRHD: handling fault status reg 3
[170933.796010] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63a00=
0=20
[170933.796010] DMAR:[fault reason 06] PTE Read access is not set
[170933.796022] DRHD: handling fault status reg 3
[170933.796024] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63c00=
0=20
[170933.796025] DMAR:[fault reason 06] PTE Read access is not set
[170933.796037] DRHD: handling fault status reg 3
[170933.796039] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63d00=
0=20
[170933.796040] DMAR:[fault reason 06] PTE Read access is not set
[170933.796052] DRHD: handling fault status reg 3
[170933.796054] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63f00=
0=20
[170933.796055] DMAR:[fault reason 06] PTE Read access is not set
[170933.796066] DRHD: handling fault status reg 3
[170933.796069] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64100=
0=20
[170933.796070] DMAR:[fault reason 06] PTE Read access is not set
[170933.796081] DRHD: handling fault status reg 3
[170933.796084] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64300=
0=20
[170933.796085] DMAR:[fault reason 06] PTE Read access is not set
[170933.796096] DRHD: handling fault status reg 3
[170933.796098] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64500=
0=20
[170933.796099] DMAR:[fault reason 06] PTE Read access is not set
[170933.796110] DRHD: handling fault status reg 3
[170933.796112] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64700=
0=20
[170933.796113] DMAR:[fault reason 06] PTE Read access is not set
[170933.796125] DRHD: handling fault status reg 3
[170933.796127] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64900=
0=20
[170933.796128] DMAR:[fault reason 06] PTE Read access is not set
[170933.796140] DRHD: handling fault status reg 3
[170933.796142] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64b00=
0=20
[170933.796143] DMAR:[fault reason 06] PTE Read access is not set
[170933.796156] DRHD: handling fault status reg 3
[170933.796158] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64c00=
0=20
[170933.796159] DMAR:[fault reason 06] PTE Read access is not set
[170933.796170] DRHD: handling fault status reg 3
[170933.796172] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64e00=
0=20
[170933.796173] DMAR:[fault reason 06] PTE Read access is not set
[170933.796185] DRHD: handling fault status reg 3
[170933.796187] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65000=
0=20
[170933.796188] DMAR:[fault reason 06] PTE Read access is not set
[170933.796199] DRHD: handling fault status reg 3
[170933.796201] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65200=
0=20
[170933.796202] DMAR:[fault reason 06] PTE Read access is not set
[170933.796214] DRHD: handling fault status reg 3
[170933.796216] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65400=
0=20
[170933.796217] DMAR:[fault reason 06] PTE Read access is not set
[170933.796229] DRHD: handling fault status reg 3
[170933.796231] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65600=
0=20
[170933.796232] DMAR:[fault reason 06] PTE Read access is not set
[170933.796244] DRHD: handling fault status reg 3
[170933.796246] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65800=
0=20
[170933.796247] DMAR:[fault reason 06] PTE Read access is not set
[170933.796259] DRHD: handling fault status reg 3
[170933.796261] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65a00=
0=20
[170933.796262] DMAR:[fault reason 06] PTE Read access is not set
[170933.796273] DRHD: handling fault status reg 3
[170933.796275] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65b00=
0=20
[170933.796276] DMAR:[fault reason 06] PTE Read access is not set
[170933.796288] DRHD: handling fault status reg 3
[170933.796290] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65d00=
0=20
[170933.796291] DMAR:[fault reason 06] PTE Read access is not set
[170933.796303] DRHD: handling fault status reg 3
[170933.796305] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65f00=
0=20
[170933.796306] DMAR:[fault reason 06] PTE Read access is not set
[170933.796318] DRHD: handling fault status reg 3
[170933.796320] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66100=
0=20
[170933.796321] DMAR:[fault reason 06] PTE Read access is not set
[170933.796332] DRHD: handling fault status reg 3
[170933.796335] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66300=
0=20
[170933.796335] DMAR:[fault reason 06] PTE Read access is not set
[170933.796347] DRHD: handling fault status reg 3
[170933.796349] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66500=
0=20
[170933.796350] DMAR:[fault reason 06] PTE Read access is not set
[170933.796362] DRHD: handling fault status reg 3
[170933.796365] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66700=
0=20
[170933.796365] DMAR:[fault reason 06] PTE Read access is not set
[170933.796377] DRHD: handling fault status reg 3
[170933.796379] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66900=
0=20
[170933.796380] DMAR:[fault reason 06] PTE Read access is not set
[170933.796391] DRHD: handling fault status reg 3
[170933.796394] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66a00=
0=20
[170933.796394] DMAR:[fault reason 06] PTE Read access is not set
[170933.796406] DRHD: handling fault status reg 3
[170933.796408] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66c00=
0=20
[170933.796409] DMAR:[fault reason 06] PTE Read access is not set
[170933.796421] DRHD: handling fault status reg 3
[170933.796423] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66e00=
0=20
[170933.796424] DMAR:[fault reason 06] PTE Read access is not set
[170933.796436] DRHD: handling fault status reg 3
[170933.796438] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67000=
0=20
[170933.796439] DMAR:[fault reason 06] PTE Read access is not set
[170933.796451] DRHD: handling fault status reg 3
[170933.796453] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67200=
0=20
[170933.796454] DMAR:[fault reason 06] PTE Read access is not set
[170933.796466] DRHD: handling fault status reg 3
[170933.796468] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67400=
0=20
[170933.796469] DMAR:[fault reason 06] PTE Read access is not set
[170933.796480] DRHD: handling fault status reg 3
[170933.796482] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67600=
0=20
[170933.796483] DMAR:[fault reason 06] PTE Read access is not set
[170933.796495] DRHD: handling fault status reg 3
[170933.796497] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67800=
0=20
[170933.796498] DMAR:[fault reason 06] PTE Read access is not set
[170933.796510] DRHD: handling fault status reg 3
[170933.796512] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67900=
0=20
[170933.796513] DMAR:[fault reason 06] PTE Read access is not set
[170933.796525] DRHD: handling fault status reg 3
[170933.796527] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67b00=
0=20
[170933.796528] DMAR:[fault reason 06] PTE Read access is not set
[170933.796540] DRHD: handling fault status reg 3
[170933.796542] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67d00=
0=20
[170933.796543] DMAR:[fault reason 06] PTE Read access is not set
[170933.796554] DRHD: handling fault status reg 3
[170933.796556] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67f00=
0=20
[170933.796557] DMAR:[fault reason 06] PTE Read access is not set
[170933.796569] DRHD: handling fault status reg 3
[170933.796571] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68100=
0=20
[170933.796572] DMAR:[fault reason 06] PTE Read access is not set
[170933.796584] DRHD: handling fault status reg 3
[170933.796586] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68300=
0=20
[170933.796587] DMAR:[fault reason 06] PTE Read access is not set
[170933.796599] DRHD: handling fault status reg 3
[170933.796601] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68500=
0=20
[170933.796602] DMAR:[fault reason 06] PTE Read access is not set
[170933.796613] DRHD: handling fault status reg 3
[170933.796616] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68700=
0=20
[170933.796616] DMAR:[fault reason 06] PTE Read access is not set
[170933.796628] DRHD: handling fault status reg 3
[170933.796631] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68800=
0=20
[170933.796631] DMAR:[fault reason 06] PTE Read access is not set
[170933.796643] DRHD: handling fault status reg 3
[170933.796645] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68a00=
0=20
[170933.796646] DMAR:[fault reason 06] PTE Read access is not set
[170933.796658] DRHD: handling fault status reg 3
[170933.796660] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68c00=
0=20
[170933.796661] DMAR:[fault reason 06] PTE Read access is not set
[170933.796673] DRHD: handling fault status reg 3
[170933.796675] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68e00=
0=20
[170933.796676] DMAR:[fault reason 06] PTE Read access is not set
[170933.796690] DRHD: handling fault status reg 3
[170933.796692] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69000=
0=20
[170933.796693] DMAR:[fault reason 06] PTE Read access is not set
[170933.796702] DRHD: handling fault status reg 3
[170933.796704] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69300=
0=20
[170933.796705] DMAR:[fault reason 06] PTE Read access is not set
[170933.796717] DRHD: handling fault status reg 3
[170933.796719] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69400=
0=20
[170933.796720] DMAR:[fault reason 06] PTE Read access is not set
[170933.796732] DRHD: handling fault status reg 3
[170933.796734] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69600=
0=20
[170933.796735] DMAR:[fault reason 06] PTE Read access is not set
[170933.796747] DRHD: handling fault status reg 3
[170933.796749] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69700=
0=20
[170933.796750] DMAR:[fault reason 06] PTE Read access is not set
[170933.796762] DRHD: handling fault status reg 3
[170933.796764] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69900=
0=20
[170933.796765] DMAR:[fault reason 06] PTE Read access is not set
[170933.796776] DRHD: handling fault status reg 3
[170933.796779] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69b00=
0=20
[170933.796779] DMAR:[fault reason 06] PTE Read access is not set
[170933.796791] DRHD: handling fault status reg 3
[170933.796793] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69d00=
0=20
[170933.796794] DMAR:[fault reason 06] PTE Read access is not set
[170933.796806] DRHD: handling fault status reg 3
[170933.796808] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69f00=
0=20
[170933.796809] DMAR:[fault reason 06] PTE Read access is not set
[170933.796821] DRHD: handling fault status reg 3
[170933.796823] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a100=
0=20
[170933.796824] DMAR:[fault reason 06] PTE Read access is not set
[170933.796835] DRHD: handling fault status reg 3
[170933.796837] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a300=
0=20
[170933.796838] DMAR:[fault reason 06] PTE Read access is not set
[170933.796850] DRHD: handling fault status reg 3
[170933.796852] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a500=
0=20
[170933.796853] DMAR:[fault reason 06] PTE Read access is not set
[170933.796865] DRHD: handling fault status reg 3
[170933.796867] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a600=
0=20
[170933.796868] DMAR:[fault reason 06] PTE Read access is not set
[170933.796880] DRHD: handling fault status reg 3
[170933.796882] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a800=
0=20
[170933.796883] DMAR:[fault reason 06] PTE Read access is not set
[170933.796895] DRHD: handling fault status reg 3
[170933.796897] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6aa00=
0=20
[170933.796897] DMAR:[fault reason 06] PTE Read access is not set
[170933.796909] DRHD: handling fault status reg 3
[170933.796911] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ac00=
0=20
[170933.796912] DMAR:[fault reason 06] PTE Read access is not set
[170933.796924] DRHD: handling fault status reg 3
[170933.796927] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ae00=
0=20
[170933.796927] DMAR:[fault reason 06] PTE Read access is not set
[170933.796940] DRHD: handling fault status reg 3
[170933.796942] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b000=
0=20
[170933.796943] DMAR:[fault reason 06] PTE Read access is not set
[170933.796954] DRHD: handling fault status reg 3
[170933.796956] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b200=
0=20
[170933.796957] DMAR:[fault reason 06] PTE Read access is not set
[170933.796969] DRHD: handling fault status reg 3
[170933.796971] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b400=
0=20
[170933.796972] DMAR:[fault reason 06] PTE Read access is not set
[170933.796983] DRHD: handling fault status reg 3
[170933.796985] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b500=
0=20
[170933.796986] DMAR:[fault reason 06] PTE Read access is not set
[170933.796998] DRHD: handling fault status reg 3
[170933.797000] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b700=
0=20
[170933.797001] DMAR:[fault reason 06] PTE Read access is not set
[170933.797013] DRHD: handling fault status reg 3
[170933.797015] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b900=
0=20
[170933.797016] DMAR:[fault reason 06] PTE Read access is not set
[170933.797028] DRHD: handling fault status reg 3
[170933.797030] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6bb00=
0=20
[170933.797031] DMAR:[fault reason 06] PTE Read access is not set
[170933.797042] DRHD: handling fault status reg 3
[170933.797045] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6bd00=
0=20
[170933.797045] DMAR:[fault reason 06] PTE Read access is not set
[170933.797057] DRHD: handling fault status reg 3
[170933.797059] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6bf00=
0=20
[170933.797060] DMAR:[fault reason 06] PTE Read access is not set
[170933.797072] DRHD: handling fault status reg 3
[170933.797074] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c100=
0=20
[170933.797075] DMAR:[fault reason 06] PTE Read access is not set
[170933.797087] DRHD: handling fault status reg 3
[170933.797089] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c300=
0=20
[170933.797090] DMAR:[fault reason 06] PTE Read access is not set
[170933.797102] DRHD: handling fault status reg 3
[170933.797104] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c400=
0=20
[170933.797105] DMAR:[fault reason 06] PTE Read access is not set
[170933.797117] DRHD: handling fault status reg 3
[170933.797119] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c600=
0=20
[170933.797120] DMAR:[fault reason 06] PTE Read access is not set
[170933.797131] DRHD: handling fault status reg 3
[170933.797133] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c800=
0=20
[170933.797134] DMAR:[fault reason 06] PTE Read access is not set
[170933.797146] DRHD: handling fault status reg 3
[170933.797148] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ca00=
0=20
[170933.797149] DMAR:[fault reason 06] PTE Read access is not set
[170933.797161] DRHD: handling fault status reg 3
[170933.797163] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6cc00=
0=20
[170933.797164] DMAR:[fault reason 06] PTE Read access is not set
[170933.797176] DRHD: handling fault status reg 3
[170933.797178] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ce00=
0=20
[170933.797179] DMAR:[fault reason 06] PTE Read access is not set
[170933.797191] DRHD: handling fault status reg 3
[170933.797193] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d000=
0=20
[170933.797194] DMAR:[fault reason 06] PTE Read access is not set
[170933.797205] DRHD: handling fault status reg 3
[170933.797208] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d200=
0=20
[170933.797208] DMAR:[fault reason 06] PTE Read access is not set
[170933.797220] DRHD: handling fault status reg 3
[170933.797222] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d300=
0=20
[170933.797223] DMAR:[fault reason 06] PTE Read access is not set
[170933.797235] DRHD: handling fault status reg 3
[170933.797237] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d500=
0=20
[170933.797238] DMAR:[fault reason 06] PTE Read access is not set
[170933.797250] DRHD: handling fault status reg 3
[170933.797252] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d700=
0=20
[170933.797253] DMAR:[fault reason 06] PTE Read access is not set
[170933.797264] DRHD: handling fault status reg 3
[170933.797267] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d900=
0=20
[170933.797267] DMAR:[fault reason 06] PTE Read access is not set
[170933.797279] DRHD: handling fault status reg 3
[170933.797282] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6db00=
0=20
[170933.797282] DMAR:[fault reason 06] PTE Read access is not set
[170933.797294] DRHD: handling fault status reg 3
[170933.797296] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6dd00=
0=20
[170933.797297] DMAR:[fault reason 06] PTE Read access is not set
[170933.797309] DRHD: handling fault status reg 3
[170933.797311] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6df00=
0=20
[170933.797312] DMAR:[fault reason 06] PTE Read access is not set
[170933.797324] DRHD: handling fault status reg 3
[170933.797326] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e100=
0=20
[170933.797327] DMAR:[fault reason 06] PTE Read access is not set
[170933.797339] DRHD: handling fault status reg 3
[170933.797341] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e200=
0=20
[170933.797342] DMAR:[fault reason 06] PTE Read access is not set
[170933.797353] DRHD: handling fault status reg 3
[170933.797355] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e400=
0=20
[170933.797356] DMAR:[fault reason 06] PTE Read access is not set
[170933.797368] DRHD: handling fault status reg 3
[170933.797370] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e600=
0=20
[170933.797371] DMAR:[fault reason 06] PTE Read access is not set
[170933.797383] DRHD: handling fault status reg 3
[170933.797385] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e800=
0=20
[170933.797386] DMAR:[fault reason 06] PTE Read access is not set
[170933.797398] DRHD: handling fault status reg 3
[170933.797400] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ea00=
0=20
[170933.797401] DMAR:[fault reason 06] PTE Read access is not set
[170933.797413] DRHD: handling fault status reg 3
[170933.797415] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ec00=
0=20
[170933.797416] DMAR:[fault reason 06] PTE Read access is not set
[170933.797428] DRHD: handling fault status reg 3
[170933.797430] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ee00=
0=20
[170933.797431] DMAR:[fault reason 06] PTE Read access is not set
[170933.797442] DRHD: handling fault status reg 3
[170933.797444] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f000=
0=20
[170933.797445] DMAR:[fault reason 06] PTE Read access is not set
[170933.797457] DRHD: handling fault status reg 3
[170933.797459] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f100=
0=20
[170933.797460] DMAR:[fault reason 06] PTE Read access is not set
[170933.797472] DRHD: handling fault status reg 3
[170933.797474] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f300=
0=20
[170933.797475] DMAR:[fault reason 06] PTE Read access is not set
[170933.797487] DRHD: handling fault status reg 3
[170933.797489] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f500=
0=20
[170933.797490] DMAR:[fault reason 06] PTE Read access is not set
[170933.797502] DRHD: handling fault status reg 3
[170933.797504] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f700=
0=20
[170933.797505] DMAR:[fault reason 06] PTE Read access is not set
[170933.797518] DRHD: handling fault status reg 2
[170933.797520] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f900=
0=20
[170933.797521] DMAR:[fault reason 06] PTE Read access is not set
[170933.797531] DRHD: handling fault status reg 2
[170933.797534] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6fd00=
0=20
[170933.797534] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.797546] DRHD: handling fault status reg 3
[170933.797548] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6fd00=
0=20
[170933.797549] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.797561] DRHD: handling fault status reg 3
[170933.797563] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70000=
0=20
[170933.797564] DMAR:[fault reason 06] PTE Read access is not set
[170933.797575] DRHD: handling fault status reg 3
[170933.797577] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70000=
0=20
[170933.797578] DMAR:[fault reason 06] PTE Read access is not set
[170933.797590] DRHD: handling fault status reg 3
[170933.797592] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70200=
0=20
[170933.797593] DMAR:[fault reason 06] PTE Read access is not set
[170933.797605] DRHD: handling fault status reg 3
[170933.797607] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70400=
0=20
[170933.797608] DMAR:[fault reason 06] PTE Read access is not set
[170933.797620] DRHD: handling fault status reg 3
[170933.797622] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70600=
0=20
[170933.797623] DMAR:[fault reason 06] PTE Read access is not set
[170933.797635] DRHD: handling fault status reg 3
[170933.797637] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70800=
0=20
[170933.797638] DMAR:[fault reason 06] PTE Read access is not set
[170933.797649] DRHD: handling fault status reg 3
[170933.797651] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70a00=
0=20
[170933.797652] DMAR:[fault reason 06] PTE Read access is not set
[170933.797664] DRHD: handling fault status reg 3
[170933.797666] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70c00=
0=20
[170933.797667] DMAR:[fault reason 06] PTE Read access is not set
[170933.797679] DRHD: handling fault status reg 3
[170933.797681] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70e00=
0=20
[170933.797682] DMAR:[fault reason 06] PTE Read access is not set
[170933.797694] DRHD: handling fault status reg 3
[170933.797696] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70f00=
0=20
[170933.797697] DMAR:[fault reason 06] PTE Read access is not set
[170933.797709] DRHD: handling fault status reg 3
[170933.797711] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71100=
0=20
[170933.797711] DMAR:[fault reason 06] PTE Read access is not set
[170933.797723] DRHD: handling fault status reg 3
[170933.797725] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71300=
0=20
[170933.797726] DMAR:[fault reason 06] PTE Read access is not set
[170933.797739] DRHD: handling fault status reg 3
[170933.797741] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71500=
0=20
[170933.797742] DMAR:[fault reason 06] PTE Read access is not set
[170933.797753] DRHD: handling fault status reg 3
[170933.797755] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71700=
0=20
[170933.797756] DMAR:[fault reason 06] PTE Read access is not set
[170933.797768] DRHD: handling fault status reg 3
[170933.797770] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71900=
0=20
[170933.797771] DMAR:[fault reason 06] PTE Read access is not set
[170933.797782] DRHD: handling fault status reg 3
[170933.797784] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71b00=
0=20
[170933.797785] DMAR:[fault reason 06] PTE Read access is not set
[170933.797797] DRHD: handling fault status reg 3
[170933.797799] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71d00=
0=20
[170933.797800] DMAR:[fault reason 06] PTE Read access is not set
[170933.797813] DRHD: handling fault status reg 3
[170933.797815] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71e00=
0=20
[170933.797816] DMAR:[fault reason 06] PTE Read access is not set
[170933.797827] DRHD: handling fault status reg 3
[170933.797829] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72000=
0=20
[170933.797830] DMAR:[fault reason 06] PTE Read access is not set
[170933.797842] DRHD: handling fault status reg 3
[170933.797844] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72200=
0=20
[170933.797845] DMAR:[fault reason 06] PTE Read access is not set
[170933.797857] DRHD: handling fault status reg 3
[170933.797859] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72400=
0=20
[170933.797860] DMAR:[fault reason 06] PTE Read access is not set
[170933.797872] DRHD: handling fault status reg 3
[170933.797874] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72600=
0=20
[170933.797875] DMAR:[fault reason 06] PTE Read access is not set
[170933.797886] DRHD: handling fault status reg 3
[170933.797888] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72800=
0=20
[170933.797889] DMAR:[fault reason 06] PTE Read access is not set
[170933.797901] DRHD: handling fault status reg 3
[170933.797903] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72a00=
0=20
[170933.797904] DMAR:[fault reason 06] PTE Read access is not set
[170933.797916] DRHD: handling fault status reg 3
[170933.797918] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72c00=
0=20
[170933.797919] DMAR:[fault reason 06] PTE Read access is not set
[170933.797930] DRHD: handling fault status reg 3
[170933.797932] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72d00=
0=20
[170933.797933] DMAR:[fault reason 06] PTE Read access is not set
[170933.797945] DRHD: handling fault status reg 3
[170933.797947] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72f00=
0=20
[170933.797948] DMAR:[fault reason 06] PTE Read access is not set
[170933.797960] DRHD: handling fault status reg 3
[170933.797962] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73100=
0=20
[170933.797963] DMAR:[fault reason 06] PTE Read access is not set
[170933.797975] DRHD: handling fault status reg 3
[170933.797977] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73300=
0=20
[170933.797978] DMAR:[fault reason 06] PTE Read access is not set
[170933.797990] DRHD: handling fault status reg 3
[170933.797992] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73500=
0=20
[170933.797993] DMAR:[fault reason 06] PTE Read access is not set
[170933.798004] DRHD: handling fault status reg 3
[170933.798007] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73700=
0=20
[170933.798007] DMAR:[fault reason 06] PTE Read access is not set
[170933.798019] DRHD: handling fault status reg 3
[170933.798021] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73900=
0=20
[170933.798022] DMAR:[fault reason 06] PTE Read access is not set
[170933.798034] DRHD: handling fault status reg 3
[170933.798036] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73b00=
0=20
[170933.798037] DMAR:[fault reason 06] PTE Read access is not set
[170933.798049] DRHD: handling fault status reg 3
[170933.798051] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73c00=
0=20
[170933.798052] DMAR:[fault reason 06] PTE Read access is not set
[170933.798063] DRHD: handling fault status reg 3
[170933.798065] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73e00=
0=20
[170933.798066] DMAR:[fault reason 06] PTE Read access is not set
[170933.798078] DRHD: handling fault status reg 3
[170933.798081] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74000=
0=20
[170933.798081] DMAR:[fault reason 06] PTE Read access is not set
[170933.798093] DRHD: handling fault status reg 3
[170933.798095] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74200=
0=20
[170933.798096] DMAR:[fault reason 06] PTE Read access is not set
[170933.798108] DRHD: handling fault status reg 3
[170933.798110] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74400=
0=20
[170933.798111] DMAR:[fault reason 06] PTE Read access is not set
[170933.798123] DRHD: handling fault status reg 3
[170933.798125] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74600=
0=20
[170933.798126] DMAR:[fault reason 06] PTE Read access is not set
[170933.798138] DRHD: handling fault status reg 3
[170933.798140] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74800=
0=20
[170933.798141] DMAR:[fault reason 06] PTE Read access is not set
[170933.798152] DRHD: handling fault status reg 3
[170933.798154] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74a00=
0=20
[170933.798155] DMAR:[fault reason 06] PTE Read access is not set
[170933.798167] DRHD: handling fault status reg 3
[170933.798169] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74b00=
0=20
[170933.798170] DMAR:[fault reason 06] PTE Read access is not set
[170933.798182] DRHD: handling fault status reg 3
[170933.798184] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74d00=
0=20
[170933.798185] DMAR:[fault reason 06] PTE Read access is not set
[170933.798197] DRHD: handling fault status reg 3
[170933.798199] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74f00=
0=20
[170933.798200] DMAR:[fault reason 06] PTE Read access is not set
[170933.798212] DRHD: handling fault status reg 3
[170933.798214] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75100=
0=20
[170933.798214] DMAR:[fault reason 06] PTE Read access is not set
[170933.798226] DRHD: handling fault status reg 3
[170933.798228] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75300=
0=20
[170933.798229] DMAR:[fault reason 06] PTE Read access is not set
[170933.798241] DRHD: handling fault status reg 3
[170933.798243] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75500=
0=20
[170933.798244] DMAR:[fault reason 06] PTE Read access is not set
[170933.798256] DRHD: handling fault status reg 3
[170933.798258] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75700=
0=20
[170933.798259] DMAR:[fault reason 06] PTE Read access is not set
[170933.798271] DRHD: handling fault status reg 3
[170933.798273] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75900=
0=20
[170933.798274] DMAR:[fault reason 06] PTE Read access is not set
[170933.798285] DRHD: handling fault status reg 3
[170933.798287] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75a00=
0=20
[170933.798288] DMAR:[fault reason 06] PTE Read access is not set
[170933.798301] DRHD: handling fault status reg 3
[170933.798303] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75c00=
0=20
[170933.798304] DMAR:[fault reason 06] PTE Read access is not set
[170933.798315] DRHD: handling fault status reg 3
[170933.798317] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75e00=
0=20
[170933.798318] DMAR:[fault reason 06] PTE Read access is not set
[170933.798330] DRHD: handling fault status reg 3
[170933.798332] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76000=
0=20
[170933.798333] DMAR:[fault reason 06] PTE Read access is not set
[170933.798345] DRHD: handling fault status reg 3
[170933.798347] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76200=
0=20
[170933.798348] DMAR:[fault reason 06] PTE Read access is not set
[170933.798360] DRHD: handling fault status reg 3
[170933.798362] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76400=
0=20
[170933.798363] DMAR:[fault reason 06] PTE Read access is not set
[170933.798375] DRHD: handling fault status reg 3
[170933.798377] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76600=
0=20
[170933.798378] DMAR:[fault reason 06] PTE Read access is not set
[170933.798390] DRHD: handling fault status reg 3
[170933.798392] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76800=
0=20
[170933.798392] DMAR:[fault reason 06] PTE Read access is not set
[170933.798404] DRHD: handling fault status reg 3
[170933.798406] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76900=
0=20
[170933.798407] DMAR:[fault reason 06] PTE Read access is not set
[170933.798419] DRHD: handling fault status reg 3
[170933.798421] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76b00=
0=20
[170933.798422] DMAR:[fault reason 06] PTE Read access is not set
[170933.798433] DRHD: handling fault status reg 3
[170933.798435] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76d00=
0=20
[170933.798436] DMAR:[fault reason 06] PTE Read access is not set
[170933.798448] DRHD: handling fault status reg 3
[170933.798450] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76f00=
0=20
[170933.798451] DMAR:[fault reason 06] PTE Read access is not set
[170933.798463] DRHD: handling fault status reg 3
[170933.798465] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77100=
0=20
[170933.798466] DMAR:[fault reason 06] PTE Read access is not set
[170933.798478] DRHD: handling fault status reg 3
[170933.798480] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77300=
0=20
[170933.798481] DMAR:[fault reason 06] PTE Read access is not set
[170933.798493] DRHD: handling fault status reg 3
[170933.798495] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77500=
0=20
[170933.798496] DMAR:[fault reason 06] PTE Read access is not set
[170933.798507] DRHD: handling fault status reg 3
[170933.798510] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77700=
0=20
[170933.798510] DMAR:[fault reason 06] PTE Read access is not set
[170933.798522] DRHD: handling fault status reg 3
[170933.798524] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77800=
0=20
[170933.798525] DMAR:[fault reason 06] PTE Read access is not set
[170933.798537] DRHD: handling fault status reg 3
[170933.798539] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77a00=
0=20
[170933.798540] DMAR:[fault reason 06] PTE Read access is not set
[170933.798552] DRHD: handling fault status reg 3
[170933.798554] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77c00=
0=20
[170933.798555] DMAR:[fault reason 06] PTE Read access is not set
[170933.798566] DRHD: handling fault status reg 3
[170933.798569] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77e00=
0=20
[170933.798569] DMAR:[fault reason 06] PTE Read access is not set
[170933.798581] DRHD: handling fault status reg 3
[170933.798583] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78000=
0=20
[170933.798584] DMAR:[fault reason 06] PTE Read access is not set
[170933.798596] DRHD: handling fault status reg 3
[170933.798598] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78200=
0=20
[170933.798599] DMAR:[fault reason 06] PTE Read access is not set
[170933.798611] DRHD: handling fault status reg 3
[170933.798613] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78400=
0=20
[170933.798614] DMAR:[fault reason 06] PTE Read access is not set
[170933.798626] DRHD: handling fault status reg 3
[170933.798628] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78600=
0=20
[170933.798629] DMAR:[fault reason 06] PTE Read access is not set
[170933.798640] DRHD: handling fault status reg 3
[170933.798643] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78700=
0=20
[170933.798643] DMAR:[fault reason 06] PTE Read access is not set
[170933.798655] DRHD: handling fault status reg 3
[170933.798657] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78900=
0=20
[170933.798658] DMAR:[fault reason 06] PTE Read access is not set
[170933.798670] DRHD: handling fault status reg 3
[170933.798673] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78b00=
0=20
[170933.798673] DMAR:[fault reason 06] PTE Read access is not set
[170933.798688] DRHD: handling fault status reg 3
[170933.798690] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78d00=
0=20
[170933.798691] DMAR:[fault reason 06] PTE Read access is not set
[170933.798700] DRHD: handling fault status reg 3
[170933.798702] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78f00=
0=20
[170933.798703] DMAR:[fault reason 06] PTE Read access is not set
[170933.798714] DRHD: handling fault status reg 3
[170933.798716] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79100=
0=20
[170933.798717] DMAR:[fault reason 06] PTE Read access is not set
[170933.798729] DRHD: handling fault status reg 3
[170933.798731] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79300=
0=20
[170933.798732] DMAR:[fault reason 06] PTE Read access is not set
[170933.798744] DRHD: handling fault status reg 3
[170933.798746] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79500=
0=20
[170933.798747] DMAR:[fault reason 06] PTE Read access is not set
[170933.798759] DRHD: handling fault status reg 3
[170933.798761] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79600=
0=20
[170933.798762] DMAR:[fault reason 06] PTE Read access is not set
[170933.798774] DRHD: handling fault status reg 3
[170933.798776] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79800=
0=20
[170933.798777] DMAR:[fault reason 06] PTE Read access is not set
[170933.798789] DRHD: handling fault status reg 3
[170933.798791] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79a00=
0=20
[170933.798792] DMAR:[fault reason 06] PTE Read access is not set
[170933.798803] DRHD: handling fault status reg 3
[170933.798805] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79c00=
0=20
[170933.798806] DMAR:[fault reason 06] PTE Read access is not set
[170933.798818] DRHD: handling fault status reg 3
[170933.798820] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79e00=
0=20
[170933.798821] DMAR:[fault reason 06] PTE Read access is not set
[170933.798833] DRHD: handling fault status reg 3
[170933.798835] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a000=
0=20
[170933.798836] DMAR:[fault reason 06] PTE Read access is not set
[170933.798848] DRHD: handling fault status reg 3
[170933.798850] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a200=
0=20
[170933.798851] DMAR:[fault reason 06] PTE Read access is not set
[170933.798863] DRHD: handling fault status reg 3
[170933.798865] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a400=
0=20
[170933.798866] DMAR:[fault reason 06] PTE Read access is not set
[170933.798877] DRHD: handling fault status reg 3
[170933.798879] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a500=
0=20
[170933.798880] DMAR:[fault reason 06] PTE Read access is not set
[170933.798892] DRHD: handling fault status reg 3
[170933.798894] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a700=
0=20
[170933.798895] DMAR:[fault reason 06] PTE Read access is not set
[170933.798907] DRHD: handling fault status reg 3
[170933.798909] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a900=
0=20
[170933.798910] DMAR:[fault reason 06] PTE Read access is not set
[170933.798922] DRHD: handling fault status reg 3
[170933.798924] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7ab00=
0=20
[170933.798925] DMAR:[fault reason 06] PTE Read access is not set
[170933.798937] DRHD: handling fault status reg 3
[170933.798939] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7ad00=
0=20
[170933.798940] DMAR:[fault reason 06] PTE Read access is not set
[170933.798951] DRHD: handling fault status reg 3
[170933.798953] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7af00=
0=20
[170933.798954] DMAR:[fault reason 06] PTE Read access is not set
[170933.798966] DRHD: handling fault status reg 3
[170933.798968] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b100=
0=20
[170933.798969] DMAR:[fault reason 06] PTE Read access is not set
[170933.798981] DRHD: handling fault status reg 3
[170933.798983] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b300=
0=20
[170933.798984] DMAR:[fault reason 06] PTE Read access is not set
[170933.798996] DRHD: handling fault status reg 3
[170933.798998] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b400=
0=20
[170933.798999] DMAR:[fault reason 06] PTE Read access is not set
[170933.799011] DRHD: handling fault status reg 3
[170933.799013] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b600=
0=20
[170933.799014] DMAR:[fault reason 06] PTE Read access is not set
[170933.799026] DRHD: handling fault status reg 3
[170933.799028] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b800=
0=20
[170933.799029] DMAR:[fault reason 06] PTE Read access is not set
[170933.799040] DRHD: handling fault status reg 3
[170933.799042] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7ba00=
0=20
[170933.799043] DMAR:[fault reason 06] PTE Read access is not set
[170933.799055] DRHD: handling fault status reg 3
[170933.799057] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7bc00=
0=20
[170933.799058] DMAR:[fault reason 06] PTE Read access is not set
[170933.799070] DRHD: handling fault status reg 3
[170933.799072] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7be00=
0=20
[170933.799073] DMAR:[fault reason 06] PTE Read access is not set
[170933.799085] DRHD: handling fault status reg 3
[170933.799087] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c000=
0=20
[170933.799087] DMAR:[fault reason 06] PTE Read access is not set
[170933.799099] DRHD: handling fault status reg 3
[170933.799101] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c200=
0=20
[170933.799102] DMAR:[fault reason 06] PTE Read access is not set
[170933.799114] DRHD: handling fault status reg 3
[170933.799116] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c300=
0=20
[170933.799117] DMAR:[fault reason 06] PTE Read access is not set
[170933.799129] DRHD: handling fault status reg 3
[170933.799131] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c500=
0=20
[170933.799132] DMAR:[fault reason 06] PTE Read access is not set
[170933.799144] DRHD: handling fault status reg 3
[170933.799146] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c700=
0=20
[170933.799147] DMAR:[fault reason 06] PTE Read access is not set
[170933.799159] DRHD: handling fault status reg 3
[170933.799161] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c900=
0=20
[170933.799162] DMAR:[fault reason 06] PTE Read access is not set
[170933.799174] DRHD: handling fault status reg 3
[170933.799176] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7cb00=
0=20
[170933.799177] DMAR:[fault reason 06] PTE Read access is not set
[170933.799188] DRHD: handling fault status reg 3
[170933.799190] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7cd00=
0=20
[170933.799191] DMAR:[fault reason 06] PTE Read access is not set
[170933.799203] DRHD: handling fault status reg 3
[170933.799205] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7cf00=
0=20
[170933.799206] DMAR:[fault reason 06] PTE Read access is not set
[170933.799218] DRHD: handling fault status reg 3
[170933.799220] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d100=
0=20
[170933.799220] DMAR:[fault reason 06] PTE Read access is not set
[170933.799232] DRHD: handling fault status reg 3
[170933.799234] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d200=
0=20
[170933.799235] DMAR:[fault reason 06] PTE Read access is not set
[170933.799247] DRHD: handling fault status reg 3
[170933.799249] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d400=
0=20
[170933.799250] DMAR:[fault reason 06] PTE Read access is not set
[170933.799262] DRHD: handling fault status reg 3
[170933.799264] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d600=
0=20
[170933.799265] DMAR:[fault reason 06] PTE Read access is not set
[170933.799277] DRHD: handling fault status reg 3
[170933.799279] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d800=
0=20
[170933.799280] DMAR:[fault reason 06] PTE Read access is not set
[170933.799292] DRHD: handling fault status reg 3
[170933.799294] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7da00=
0=20
[170933.799295] DMAR:[fault reason 06] PTE Read access is not set
[170933.799306] DRHD: handling fault status reg 3
[170933.799308] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7dc00=
0=20
[170933.799309] DMAR:[fault reason 06] PTE Read access is not set
[170933.799321] DRHD: handling fault status reg 3
[170933.799323] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7de00=
0=20
[170933.799324] DMAR:[fault reason 06] PTE Read access is not set
[170933.799336] DRHD: handling fault status reg 3
[170933.799338] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e000=
0=20
[170933.799339] DMAR:[fault reason 06] PTE Read access is not set
[170933.799351] DRHD: handling fault status reg 3
[170933.799353] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e100=
0=20
[170933.799354] DMAR:[fault reason 06] PTE Read access is not set
[170933.799365] DRHD: handling fault status reg 3
[170933.799367] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e300=
0=20
[170933.799368] DMAR:[fault reason 06] PTE Read access is not set
[170933.799380] DRHD: handling fault status reg 3
[170933.799383] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e500=
0=20
[170933.799383] DMAR:[fault reason 06] PTE Read access is not set
[170933.799395] DRHD: handling fault status reg 3
[170933.799397] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e700=
0=20
[170933.799398] DMAR:[fault reason 06] PTE Read access is not set
[170933.801280] DRHD: handling fault status reg 3
[170933.801283] DMAR:[DMA Read] Request device [00:02.0] fault addr ff57f00=
0=20
[170933.801284] DMAR:[fault reason 06] PTE Read access is not set
[170933.801301] DRHD: handling fault status reg 3
[170933.801303] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58000=
0=20
[170933.801304] DMAR:[fault reason 06] PTE Read access is not set
[170933.801326] DRHD: handling fault status reg 3
[170933.801328] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58200=
0=20
[170933.801329] DMAR:[fault reason 06] PTE Read access is not set
[170933.801347] DRHD: handling fault status reg 3
[170933.801349] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58400=
0=20
[170933.801350] DMAR:[fault reason 06] PTE Read access is not set
[170933.801368] DRHD: handling fault status reg 3
[170933.801370] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58700=
0=20
[170933.801371] DMAR:[fault reason 06] PTE Read access is not set
[170933.801389] DRHD: handling fault status reg 3
[170933.801391] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58900=
0=20
[170933.801392] DMAR:[fault reason 06] PTE Read access is not set
[170933.801410] DRHD: handling fault status reg 3
[170933.801412] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58b00=
0=20
[170933.801413] DMAR:[fault reason 06] PTE Read access is not set
[170933.801435] DRHD: handling fault status reg 3
[170933.801437] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58d00=
0=20
[170933.801438] DMAR:[fault reason 06] PTE Read access is not set
[170933.801456] DRHD: handling fault status reg 3
[170933.801458] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59000=
0=20
[170933.801459] DMAR:[fault reason 06] PTE Read access is not set
[170933.801478] DRHD: handling fault status reg 3
[170933.801480] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59200=
0=20
[170933.801481] DMAR:[fault reason 06] PTE Read access is not set
[170933.801499] DRHD: handling fault status reg 3
[170933.801501] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59400=
0=20
[170933.801502] DMAR:[fault reason 06] PTE Read access is not set
[170933.801524] DRHD: handling fault status reg 3
[170933.801526] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59700=
0=20
[170933.801527] DMAR:[fault reason 06] PTE Read access is not set
[170933.801546] DRHD: handling fault status reg 3
[170933.801548] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59900=
0=20
[170933.801549] DMAR:[fault reason 06] PTE Read access is not set
[170933.801567] DRHD: handling fault status reg 3
[170933.801569] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59b00=
0=20
[170933.801570] DMAR:[fault reason 06] PTE Read access is not set
[170933.801588] DRHD: handling fault status reg 3
[170933.801590] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59e00=
0=20
[170933.801591] DMAR:[fault reason 06] PTE Read access is not set
[170933.801609] DRHD: handling fault status reg 3
[170933.801611] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a000=
0=20
[170933.801612] DMAR:[fault reason 06] PTE Read access is not set
[170933.801634] DRHD: handling fault status reg 3
[170933.801636] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a200=
0=20
[170933.801637] DMAR:[fault reason 06] PTE Read access is not set
[170933.801655] DRHD: handling fault status reg 3
[170933.801657] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a400=
0=20
[170933.801658] DMAR:[fault reason 06] PTE Read access is not set
[170933.801677] DRHD: handling fault status reg 3
[170933.801679] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a700=
0=20
[170933.801680] DMAR:[fault reason 06] PTE Read access is not set
[170933.801698] DRHD: handling fault status reg 3
[170933.801700] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a900=
0=20
[170933.801701] DMAR:[fault reason 06] PTE Read access is not set
[170933.801723] DRHD: handling fault status reg 3
[170933.801725] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ab00=
0=20
[170933.801726] DMAR:[fault reason 06] PTE Read access is not set
[170933.801744] DRHD: handling fault status reg 3
[170933.801746] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ae00=
0=20
[170933.801747] DMAR:[fault reason 06] PTE Read access is not set
[170933.801765] DRHD: handling fault status reg 3
[170933.801768] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b000=
0=20
[170933.801768] DMAR:[fault reason 06] PTE Read access is not set
[170933.801786] DRHD: handling fault status reg 3
[170933.801788] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b200=
0=20
[170933.801789] DMAR:[fault reason 06] PTE Read access is not set
[170933.801808] DRHD: handling fault status reg 3
[170933.801810] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b400=
0=20
[170933.801811] DMAR:[fault reason 06] PTE Read access is not set
[170933.801832] DRHD: handling fault status reg 3
[170933.801835] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b700=
0=20
[170933.801835] DMAR:[fault reason 06] PTE Read access is not set
[170933.801854] DRHD: handling fault status reg 3
[170933.801856] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b900=
0=20
[170933.801857] DMAR:[fault reason 06] PTE Read access is not set
[170933.801875] DRHD: handling fault status reg 3
[170933.801877] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5bb00=
0=20
[170933.801878] DMAR:[fault reason 06] PTE Read access is not set
[170933.801896] DRHD: handling fault status reg 3
[170933.801898] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5be00=
0=20
[170933.801899] DMAR:[fault reason 06] PTE Read access is not set
[170933.801921] DRHD: handling fault status reg 3
[170933.801923] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c000=
0=20
[170933.801924] DMAR:[fault reason 06] PTE Read access is not set
[170933.801943] DRHD: handling fault status reg 3
[170933.801945] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c200=
0=20
[170933.801946] DMAR:[fault reason 06] PTE Read access is not set
[170933.801964] DRHD: handling fault status reg 3
[170933.801966] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c400=
0=20
[170933.801967] DMAR:[fault reason 06] PTE Read access is not set
[170933.801984] DRHD: handling fault status reg 3
[170933.801987] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c700=
0=20
[170933.801987] DMAR:[fault reason 06] PTE Read access is not set
[170933.802006] DRHD: handling fault status reg 3
[170933.802008] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c900=
0=20
[170933.802009] DMAR:[fault reason 06] PTE Read access is not set
[170933.802031] DRHD: handling fault status reg 3
[170933.802033] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cb00=
0=20
[170933.802034] DMAR:[fault reason 06] PTE Read access is not set
[170933.802053] DRHD: handling fault status reg 3
[170933.802055] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ce00=
0=20
[170933.802056] DMAR:[fault reason 06] PTE Read access is not set
[170933.802074] DRHD: handling fault status reg 3
[170933.802076] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d000=
0=20
[170933.802077] DMAR:[fault reason 06] PTE Read access is not set
[170933.802095] DRHD: handling fault status reg 3
[170933.802097] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d200=
0=20
[170933.802098] DMAR:[fault reason 06] PTE Read access is not set
[170933.802120] DRHD: handling fault status reg 3
[170933.802122] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d500=
0=20
[170933.802123] DMAR:[fault reason 06] PTE Read access is not set
[170933.802142] DRHD: handling fault status reg 3
[170933.802144] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d700=
0=20
[170933.802145] DMAR:[fault reason 06] PTE Read access is not set
[170933.802163] DRHD: handling fault status reg 3
[170933.802165] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d900=
0=20
[170933.802166] DMAR:[fault reason 06] PTE Read access is not set
[170933.802183] DRHD: handling fault status reg 3
[170933.802186] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5db00=
0=20
[170933.802186] DMAR:[fault reason 06] PTE Read access is not set
[170933.802204] DRHD: handling fault status reg 3
[170933.802206] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5de00=
0=20
[170933.802207] DMAR:[fault reason 06] PTE Read access is not set
[170933.802230] DRHD: handling fault status reg 3
[170933.802232] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e000=
0=20
[170933.802233] DMAR:[fault reason 06] PTE Read access is not set
[170933.802251] DRHD: handling fault status reg 3
[170933.802253] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e200=
0=20
[170933.802254] DMAR:[fault reason 06] PTE Read access is not set
[170933.802273] DRHD: handling fault status reg 3
[170933.802275] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e400=
0=20
[170933.802276] DMAR:[fault reason 06] PTE Read access is not set
[170933.802294] DRHD: handling fault status reg 3
[170933.802296] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e700=
0=20
[170933.802297] DMAR:[fault reason 06] PTE Read access is not set
[170933.802319] DRHD: handling fault status reg 3
[170933.802321] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e900=
0=20
[170933.802322] DMAR:[fault reason 06] PTE Read access is not set
[170933.802340] DRHD: handling fault status reg 3
[170933.802342] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5eb00=
0=20
[170933.802343] DMAR:[fault reason 06] PTE Read access is not set
[170933.802362] DRHD: handling fault status reg 3
[170933.802364] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ee00=
0=20
[170933.802365] DMAR:[fault reason 06] PTE Read access is not set
[170933.802382] DRHD: handling fault status reg 3
[170933.802384] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f000=
0=20
[170933.802385] DMAR:[fault reason 06] PTE Read access is not set
[170933.802403] DRHD: handling fault status reg 3
[170933.802405] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f200=
0=20
[170933.802406] DMAR:[fault reason 06] PTE Read access is not set
[170933.802429] DRHD: handling fault status reg 3
[170933.802431] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f500=
0=20
[170933.802432] DMAR:[fault reason 06] PTE Read access is not set
[170933.802450] DRHD: handling fault status reg 3
[170933.802452] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f700=
0=20
[170933.802453] DMAR:[fault reason 06] PTE Read access is not set
[170933.802471] DRHD: handling fault status reg 3
[170933.802473] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f900=
0=20
[170933.802474] DMAR:[fault reason 06] PTE Read access is not set
[170933.802493] DRHD: handling fault status reg 3
[170933.802495] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5fc00=
0=20
[170933.802496] DMAR:[fault reason 06] PTE Read access is not set
[170933.802518] DRHD: handling fault status reg 3
[170933.802520] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5fe00=
0=20
[170933.802521] DMAR:[fault reason 06] PTE Read access is not set
[170933.802539] DRHD: handling fault status reg 3
[170933.802542] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60000=
0=20
[170933.802542] DMAR:[fault reason 06] PTE Read access is not set
[170933.802561] DRHD: handling fault status reg 3
[170933.802563] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60200=
0=20
[170933.802564] DMAR:[fault reason 06] PTE Read access is not set
[170933.802582] DRHD: handling fault status reg 3
[170933.802584] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60500=
0=20
[170933.802585] DMAR:[fault reason 06] PTE Read access is not set
[170933.802603] DRHD: handling fault status reg 3
[170933.802605] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60700=
0=20
[170933.802606] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.802629] DRHD: handling fault status reg 3
[170933.802631] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60900=
0=20
[170933.802632] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.802650] DRHD: handling fault status reg 3
[170933.802652] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60c00=
0=20
[170933.802653] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.802671] DRHD: handling fault status reg 3
[170933.802673] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60e00=
0=20
[170933.802674] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.802693] DRHD: handling fault status reg 3
[170933.802695] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61000=
0=20
[170933.802696] DMAR:[fault reason 06] PTE Read access is not set
[170933.802718] DRHD: handling fault status reg 3
[170933.802720] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61300=
0=20
[170933.802721] DMAR:[fault reason 06] PTE Read access is not set
[170933.802740] DRHD: handling fault status reg 3
[170933.802742] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61500=
0=20
[170933.802743] DMAR:[fault reason 06] PTE Read access is not set
[170933.802760] DRHD: handling fault status reg 3
[170933.802762] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61700=
0=20
[170933.802763] DMAR:[fault reason 06] PTE Read access is not set
[170933.802782] DRHD: handling fault status reg 3
[170933.802784] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61a00=
0=20
[170933.802785] DMAR:[fault reason 06] PTE Read access is not set
[170933.802807] DRHD: handling fault status reg 3
[170933.802809] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61c00=
0=20
[170933.802810] DMAR:[fault reason 06] PTE Read access is not set
[170933.802829] DRHD: handling fault status reg 3
[170933.802831] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61e00=
0=20
[170933.802832] DMAR:[fault reason 06] PTE Read access is not set
[170933.802849] DRHD: handling fault status reg 3
[170933.802852] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62000=
0=20
[170933.802852] DMAR:[fault reason 06] PTE Read access is not set
[170933.802871] DRHD: handling fault status reg 3
[170933.802873] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62300=
0=20
[170933.802874] DMAR:[fault reason 06] PTE Read access is not set
[170933.802892] DRHD: handling fault status reg 3
[170933.802894] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62500=
0=20
[170933.802895] DMAR:[fault reason 06] PTE Read access is not set
[170933.802918] DRHD: handling fault status reg 3
[170933.802920] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62700=
0=20
[170933.802921] DMAR:[fault reason 06] PTE Read access is not set
[170933.802938] DRHD: handling fault status reg 3
[170933.802941] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62a00=
0=20
[170933.802941] DMAR:[fault reason 06] PTE Read access is not set
[170933.802960] DRHD: handling fault status reg 3
[170933.802962] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62c00=
0=20
[170933.802963] DMAR:[fault reason 06] PTE Read access is not set
[170933.802981] DRHD: handling fault status reg 3
[170933.802983] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62e00=
0=20
[170933.802984] DMAR:[fault reason 06] PTE Read access is not set
[170933.803006] DRHD: handling fault status reg 3
[170933.803008] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63100=
0=20
[170933.803009] DMAR:[fault reason 06] PTE Read access is not set
[170933.803028] DRHD: handling fault status reg 3
[170933.803030] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63300=
0=20
[170933.803031] DMAR:[fault reason 06] PTE Read access is not set
[170933.803049] DRHD: handling fault status reg 3
[170933.803051] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63500=
0=20
[170933.803052] DMAR:[fault reason 06] PTE Read access is not set
[170933.803071] DRHD: handling fault status reg 3
[170933.803073] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63800=
0=20
[170933.803074] DMAR:[fault reason 06] PTE Read access is not set
[170933.803096] DRHD: handling fault status reg 3
[170933.803098] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63a00=
0=20
[170933.803099] DMAR:[fault reason 06] PTE Read access is not set
[170933.803117] DRHD: handling fault status reg 3
[170933.803119] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63c00=
0=20
[170933.803120] DMAR:[fault reason 06] PTE Read access is not set
[170933.803139] DRHD: handling fault status reg 3
[170933.803141] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63e00=
0=20
[170933.803142] DMAR:[fault reason 06] PTE Read access is not set
[170933.803160] DRHD: handling fault status reg 3
[170933.803162] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64100=
0=20
[170933.803163] DMAR:[fault reason 06] PTE Read access is not set
[170933.803181] DRHD: handling fault status reg 3
[170933.803183] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64300=
0=20
[170933.803184] DMAR:[fault reason 06] PTE Read access is not set
[170933.803206] DRHD: handling fault status reg 3
[170933.803208] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64500=
0=20
[170933.803209] DMAR:[fault reason 06] PTE Read access is not set
[170933.803226] DRHD: handling fault status reg 3
[170933.803228] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64700=
0=20
[170933.803229] DMAR:[fault reason 06] PTE Read access is not set
[170933.803248] DRHD: handling fault status reg 3
[170933.803250] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64a00=
0=20
[170933.803251] DMAR:[fault reason 06] PTE Read access is not set
[170933.803269] DRHD: handling fault status reg 3
[170933.803271] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64c00=
0=20
[170933.803272] DMAR:[fault reason 06] PTE Read access is not set
[170933.803294] DRHD: handling fault status reg 3
[170933.803296] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64e00=
0=20
[170933.803297] DMAR:[fault reason 06] PTE Read access is not set
[170933.803316] DRHD: handling fault status reg 3
[170933.803318] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65100=
0=20
[170933.803319] DMAR:[fault reason 06] PTE Read access is not set
[170933.803337] DRHD: handling fault status reg 3
[170933.803339] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65300=
0=20
[170933.803340] DMAR:[fault reason 06] PTE Read access is not set
[170933.803357] DRHD: handling fault status reg 3
[170933.803359] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65500=
0=20
[170933.803360] DMAR:[fault reason 06] PTE Read access is not set
[170933.803378] DRHD: handling fault status reg 3
[170933.803380] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65800=
0=20
[170933.803381] DMAR:[fault reason 06] PTE Read access is not set
[170933.803404] DRHD: handling fault status reg 3
[170933.803406] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65a00=
0=20
[170933.803407] DMAR:[fault reason 06] PTE Read access is not set
[170933.803425] DRHD: handling fault status reg 3
[170933.803427] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65c00=
0=20
[170933.803428] DMAR:[fault reason 06] PTE Read access is not set
[170933.803447] DRHD: handling fault status reg 3
[170933.803449] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65e00=
0=20
[170933.803450] DMAR:[fault reason 06] PTE Read access is not set
[170933.803468] DRHD: handling fault status reg 3
[170933.803470] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66100=
0=20
[170933.803471] DMAR:[fault reason 06] PTE Read access is not set
[170933.803493] DRHD: handling fault status reg 3
[170933.803495] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66300=
0=20
[170933.803496] DMAR:[fault reason 06] PTE Read access is not set
[170933.803515] DRHD: handling fault status reg 3
[170933.803517] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66500=
0=20
[170933.803518] DMAR:[fault reason 06] PTE Read access is not set
[170933.803535] DRHD: handling fault status reg 3
[170933.803538] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66800=
0=20
[170933.803538] DMAR:[fault reason 06] PTE Read access is not set
[170933.803556] DRHD: handling fault status reg 3
[170933.803558] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66a00=
0=20
[170933.803559] DMAR:[fault reason 06] PTE Read access is not set
[170933.803577] DRHD: handling fault status reg 3
[170933.803579] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66c00=
0=20
[170933.803580] DMAR:[fault reason 06] PTE Read access is not set
[170933.803602] DRHD: handling fault status reg 3
[170933.803604] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66e00=
0=20
[170933.803605] DMAR:[fault reason 06] PTE Read access is not set
[170933.803624] DRHD: handling fault status reg 3
[170933.803626] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67100=
0=20
[170933.803627] DMAR:[fault reason 06] PTE Read access is not set
[170933.803645] DRHD: handling fault status reg 3
[170933.803647] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67300=
0=20
[170933.803648] DMAR:[fault reason 06] PTE Read access is not set
[170933.803667] DRHD: handling fault status reg 3
[170933.803669] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67500=
0=20
[170933.803670] DMAR:[fault reason 06] PTE Read access is not set
[170933.803692] DRHD: handling fault status reg 3
[170933.803694] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67800=
0=20
[170933.803695] DMAR:[fault reason 06] PTE Read access is not set
[170933.803713] DRHD: handling fault status reg 3
[170933.803715] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67a00=
0=20
[170933.803716] DMAR:[fault reason 06] PTE Read access is not set
[170933.803734] DRHD: handling fault status reg 3
[170933.803736] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67c00=
0=20
[170933.803737] DMAR:[fault reason 06] PTE Read access is not set
[170933.803755] DRHD: handling fault status reg 3
[170933.803757] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67e00=
0=20
[170933.803757] DMAR:[fault reason 06] PTE Read access is not set
[170933.803776] DRHD: handling fault status reg 3
[170933.803778] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68100=
0=20
[170933.803779] DMAR:[fault reason 06] PTE Read access is not set
[170933.803801] DRHD: handling fault status reg 3
[170933.803803] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68300=
0=20
[170933.803804] DMAR:[fault reason 06] PTE Read access is not set
[170933.803822] DRHD: handling fault status reg 3
[170933.803825] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68500=
0=20
[170933.803825] DMAR:[fault reason 06] PTE Read access is not set
[170933.803844] DRHD: handling fault status reg 3
[170933.803846] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68800=
0=20
[170933.803847] DMAR:[fault reason 06] PTE Read access is not set
[170933.803865] DRHD: handling fault status reg 3
[170933.803867] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68a00=
0=20
[170933.803868] DMAR:[fault reason 06] PTE Read access is not set
[170933.803890] DRHD: handling fault status reg 3
[170933.803893] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68c00=
0=20
[170933.803893] DMAR:[fault reason 06] PTE Read access is not set
[170933.803912] DRHD: handling fault status reg 3
[170933.803914] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68f00=
0=20
[170933.803915] DMAR:[fault reason 06] PTE Read access is not set
[170933.803933] DRHD: handling fault status reg 2
[170933.803935] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69300=
0=20
[170933.803936] DMAR:[fault reason 06] PTE Read access is not set
[170933.803953] DRHD: handling fault status reg 3
[170933.803956] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69300=
0=20
[170933.803956] DMAR:[fault reason 06] PTE Read access is not set
[170933.803974] DRHD: handling fault status reg 3
[170933.803976] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69500=
0=20
[170933.803977] DMAR:[fault reason 06] PTE Read access is not set
[170933.811176] DRHD: handling fault status reg 3
[170933.811179] DMAR:[DMA Read] Request device [00:02.0] fault addr ff57f00=
0=20
[170933.811180] DMAR:[fault reason 06] PTE Read access is not set
[170933.811187] DRHD: handling fault status reg 3
[170933.811190] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58000=
0=20
[170933.811191] DMAR:[fault reason 06] PTE Read access is not set
[170933.811202] DRHD: handling fault status reg 3
[170933.811204] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58200=
0=20
[170933.811205] DMAR:[fault reason 06] PTE Read access is not set
[170933.811217] DRHD: handling fault status reg 3
[170933.811219] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58400=
0=20
[170933.811220] DMAR:[fault reason 06] PTE Read access is not set
[170933.811232] DRHD: handling fault status reg 3
[170933.811234] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58600=
0=20
[170933.811235] DMAR:[fault reason 06] PTE Read access is not set
[170933.811246] DRHD: handling fault status reg 3
[170933.811249] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58800=
0=20
[170933.811249] DMAR:[fault reason 06] PTE Read access is not set
[170933.811262] DRHD: handling fault status reg 3
[170933.811264] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58900=
0=20
[170933.811265] DMAR:[fault reason 06] PTE Read access is not set
[170933.811276] DRHD: handling fault status reg 3
[170933.811278] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58b00=
0=20
[170933.811279] DMAR:[fault reason 06] PTE Read access is not set
[170933.811291] DRHD: handling fault status reg 3
[170933.811293] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58d00=
0=20
[170933.811294] DMAR:[fault reason 06] PTE Read access is not set
[170933.811306] DRHD: handling fault status reg 3
[170933.811308] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58f00=
0=20
[170933.811309] DMAR:[fault reason 06] PTE Read access is not set
[170933.811321] DRHD: handling fault status reg 3
[170933.811323] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59100=
0=20
[170933.811324] DMAR:[fault reason 06] PTE Read access is not set
[170933.811335] DRHD: handling fault status reg 3
[170933.811337] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59300=
0=20
[170933.811338] DMAR:[fault reason 06] PTE Read access is not set
[170933.811350] DRHD: handling fault status reg 3
[170933.811352] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59500=
0=20
[170933.811353] DMAR:[fault reason 06] PTE Read access is not set
[170933.811365] DRHD: handling fault status reg 3
[170933.811367] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59700=
0=20
[170933.811368] DMAR:[fault reason 06] PTE Read access is not set
[170933.811380] DRHD: handling fault status reg 3
[170933.811382] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59800=
0=20
[170933.811383] DMAR:[fault reason 06] PTE Read access is not set
[170933.811394] DRHD: handling fault status reg 3
[170933.811397] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59a00=
0=20
[170933.811398] DMAR:[fault reason 06] PTE Read access is not set
[170933.811409] DRHD: handling fault status reg 3
[170933.811411] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59c00=
0=20
[170933.811412] DMAR:[fault reason 06] PTE Read access is not set
[170933.811424] DRHD: handling fault status reg 3
[170933.811426] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59e00=
0=20
[170933.811427] DMAR:[fault reason 06] PTE Read access is not set
[170933.811439] DRHD: handling fault status reg 3
[170933.811441] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a000=
0=20
[170933.811442] DMAR:[fault reason 06] PTE Read access is not set
[170933.811454] DRHD: handling fault status reg 3
[170933.811456] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a200=
0=20
[170933.811457] DMAR:[fault reason 06] PTE Read access is not set
[170933.811468] DRHD: handling fault status reg 3
[170933.811470] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a400=
0=20
[170933.811471] DMAR:[fault reason 06] PTE Read access is not set
[170933.811483] DRHD: handling fault status reg 3
[170933.811485] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a600=
0=20
[170933.811486] DMAR:[fault reason 06] PTE Read access is not set
[170933.811498] DRHD: handling fault status reg 3
[170933.811500] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a700=
0=20
[170933.811501] DMAR:[fault reason 06] PTE Read access is not set
[170933.811513] DRHD: handling fault status reg 3
[170933.811515] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a900=
0=20
[170933.811516] DMAR:[fault reason 06] PTE Read access is not set
[170933.811527] DRHD: handling fault status reg 3
[170933.811529] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ab00=
0=20
[170933.811530] DMAR:[fault reason 06] PTE Read access is not set
[170933.811543] DRHD: handling fault status reg 3
[170933.811545] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ad00=
0=20
[170933.811546] DMAR:[fault reason 06] PTE Read access is not set
[170933.811557] DRHD: handling fault status reg 3
[170933.811559] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5af00=
0=20
[170933.811560] DMAR:[fault reason 06] PTE Read access is not set
[170933.811572] DRHD: handling fault status reg 3
[170933.811574] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b100=
0=20
[170933.811575] DMAR:[fault reason 06] PTE Read access is not set
[170933.811587] DRHD: handling fault status reg 3
[170933.811589] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b300=
0=20
[170933.811590] DMAR:[fault reason 06] PTE Read access is not set
[170933.811601] DRHD: handling fault status reg 3
[170933.811603] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b500=
0=20
[170933.811604] DMAR:[fault reason 06] PTE Read access is not set
[170933.811616] DRHD: handling fault status reg 3
[170933.811618] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b600=
0=20
[170933.811619] DMAR:[fault reason 06] PTE Read access is not set
[170933.811632] DRHD: handling fault status reg 3
[170933.811634] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b800=
0=20
[170933.811635] DMAR:[fault reason 06] PTE Read access is not set
[170933.811646] DRHD: handling fault status reg 3
[170933.811648] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ba00=
0=20
[170933.811649] DMAR:[fault reason 06] PTE Read access is not set
[170933.811661] DRHD: handling fault status reg 3
[170933.811663] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5bc00=
0=20
[170933.811664] DMAR:[fault reason 06] PTE Read access is not set
[170933.811676] DRHD: handling fault status reg 3
[170933.811678] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5be00=
0=20
[170933.811679] DMAR:[fault reason 06] PTE Read access is not set
[170933.811690] DRHD: handling fault status reg 3
[170933.811692] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c000=
0=20
[170933.811693] DMAR:[fault reason 06] PTE Read access is not set
[170933.811706] DRHD: handling fault status reg 3
[170933.811708] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c200=
0=20
[170933.811709] DMAR:[fault reason 06] PTE Read access is not set
[170933.811720] DRHD: handling fault status reg 3
[170933.811722] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c400=
0=20
[170933.811723] DMAR:[fault reason 06] PTE Read access is not set
[170933.811734] DRHD: handling fault status reg 3
[170933.811737] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c500=
0=20
[170933.811737] DMAR:[fault reason 06] PTE Read access is not set
[170933.811749] DRHD: handling fault status reg 3
[170933.811752] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c700=
0=20
[170933.811752] DMAR:[fault reason 06] PTE Read access is not set
[170933.811764] DRHD: handling fault status reg 3
[170933.811766] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c900=
0=20
[170933.811767] DMAR:[fault reason 06] PTE Read access is not set
[170933.811779] DRHD: handling fault status reg 3
[170933.811781] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cb00=
0=20
[170933.811782] DMAR:[fault reason 06] PTE Read access is not set
[170933.811794] DRHD: handling fault status reg 3
[170933.811796] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cd00=
0=20
[170933.811797] DMAR:[fault reason 06] PTE Read access is not set
[170933.811809] DRHD: handling fault status reg 3
[170933.811811] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cf00=
0=20
[170933.811812] DMAR:[fault reason 06] PTE Read access is not set
[170933.811823] DRHD: handling fault status reg 3
[170933.811826] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d100=
0=20
[170933.811826] DMAR:[fault reason 06] PTE Read access is not set
[170933.811838] DRHD: handling fault status reg 3
[170933.811840] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d300=
0=20
[170933.811841] DMAR:[fault reason 06] PTE Read access is not set
[170933.811853] DRHD: handling fault status reg 3
[170933.811855] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d400=
0=20
[170933.811856] DMAR:[fault reason 06] PTE Read access is not set
[170933.811868] DRHD: handling fault status reg 3
[170933.811870] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d600=
0=20
[170933.811871] DMAR:[fault reason 06] PTE Read access is not set
[170933.811883] DRHD: handling fault status reg 3
[170933.811885] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d800=
0=20
[170933.811886] DMAR:[fault reason 06] PTE Read access is not set
[170933.811898] DRHD: handling fault status reg 3
[170933.811900] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5da00=
0=20
[170933.811901] DMAR:[fault reason 06] PTE Read access is not set
[170933.811912] DRHD: handling fault status reg 3
[170933.811914] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5dc00=
0=20
[170933.811915] DMAR:[fault reason 06] PTE Read access is not set
[170933.811927] DRHD: handling fault status reg 3
[170933.811929] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5de00=
0=20
[170933.811930] DMAR:[fault reason 06] PTE Read access is not set
[170933.811942] DRHD: handling fault status reg 3
[170933.811944] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e000=
0=20
[170933.811945] DMAR:[fault reason 06] PTE Read access is not set
[170933.811958] DRHD: handling fault status reg 3
[170933.811960] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e200=
0=20
[170933.811960] DMAR:[fault reason 06] PTE Read access is not set
[170933.811971] DRHD: handling fault status reg 3
[170933.811974] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e300=
0=20
[170933.811974] DMAR:[fault reason 06] PTE Read access is not set
[170933.811986] DRHD: handling fault status reg 3
[170933.811988] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e500=
0=20
[170933.811989] DMAR:[fault reason 06] PTE Read access is not set
[170933.812001] DRHD: handling fault status reg 3
[170933.812003] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e700=
0=20
[170933.812004] DMAR:[fault reason 06] PTE Read access is not set
[170933.812016] DRHD: handling fault status reg 3
[170933.812018] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e900=
0=20
[170933.812019] DMAR:[fault reason 06] PTE Read access is not set
[170933.812031] DRHD: handling fault status reg 3
[170933.812033] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5eb00=
0=20
[170933.812034] DMAR:[fault reason 06] PTE Read access is not set
[170933.812045] DRHD: handling fault status reg 3
[170933.812048] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ed00=
0=20
[170933.812048] DMAR:[fault reason 06] PTE Read access is not set
[170933.812060] DRHD: handling fault status reg 3
[170933.812062] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ef00=
0=20
[170933.812063] DMAR:[fault reason 06] PTE Read access is not set
[170933.812075] DRHD: handling fault status reg 3
[170933.812077] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f100=
0=20
[170933.812078] DMAR:[fault reason 06] PTE Read access is not set
[170933.812090] DRHD: handling fault status reg 3
[170933.812092] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f200=
0=20
[170933.812093] DMAR:[fault reason 06] PTE Read access is not set
[170933.812105] DRHD: handling fault status reg 3
[170933.812107] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f400=
0=20
[170933.812108] DMAR:[fault reason 06] PTE Read access is not set
[170933.812119] DRHD: handling fault status reg 3
[170933.812121] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f600=
0=20
[170933.812122] DMAR:[fault reason 06] PTE Read access is not set
[170933.812134] DRHD: handling fault status reg 3
[170933.812136] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f800=
0=20
[170933.812137] DMAR:[fault reason 06] PTE Read access is not set
[170933.812149] DRHD: handling fault status reg 3
[170933.812151] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5fa00=
0=20
[170933.812152] DMAR:[fault reason 06] PTE Read access is not set
[170933.812164] DRHD: handling fault status reg 3
[170933.812166] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5fc00=
0=20
[170933.812167] DMAR:[fault reason 06] PTE Read access is not set
[170933.812179] DRHD: handling fault status reg 3
[170933.812181] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5fe00=
0=20
[170933.812182] DMAR:[fault reason 06] PTE Read access is not set
[170933.812193] DRHD: handling fault status reg 3
[170933.812195] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60000=
0=20
[170933.812196] DMAR:[fault reason 06] PTE Read access is not set
[170933.812208] DRHD: handling fault status reg 3
[170933.812211] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60100=
0=20
[170933.812211] DMAR:[fault reason 06] PTE Read access is not set
[170933.812224] DRHD: handling fault status reg 3
[170933.812226] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60300=
0=20
[170933.812227] DMAR:[fault reason 06] PTE Read access is not set
[170933.812238] DRHD: handling fault status reg 3
[170933.812240] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60500=
0=20
[170933.812241] DMAR:[fault reason 06] PTE Read access is not set
[170933.812252] DRHD: handling fault status reg 3
[170933.812255] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60700=
0=20
[170933.812256] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.812268] DRHD: handling fault status reg 3
[170933.812270] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60900=
0=20
[170933.812271] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.812282] DRHD: handling fault status reg 3
[170933.812284] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60b00=
0=20
[170933.812285] DMAR:[fault reason 06] PTE Read access is not set
[170933.812297] DRHD: handling fault status reg 3
[170933.812299] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60d00=
0=20
[170933.812300] DMAR:[fault reason 06] PTE Read access is not set
[170933.812312] DRHD: handling fault status reg 3
[170933.812314] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60f00=
0=20
[170933.812315] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.812327] DRHD: handling fault status reg 3
[170933.812329] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61000=
0=20
[170933.812330] DMAR:[fault reason 06] PTE Read access is not set
[170933.812342] DRHD: handling fault status reg 3
[170933.812344] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61200=
0=20
[170933.812345] DMAR:[fault reason 06] PTE Read access is not set
[170933.812356] DRHD: handling fault status reg 3
[170933.812359] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61400=
0=20
[170933.812360] DMAR:[fault reason 06] PTE Read access is not set
[170933.812371] DRHD: handling fault status reg 3
[170933.812373] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61600=
0=20
[170933.812374] DMAR:[fault reason 06] PTE Read access is not set
[170933.812385] DRHD: handling fault status reg 3
[170933.812388] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61800=
0=20
[170933.812388] DMAR:[fault reason 06] PTE Read access is not set
[170933.812401] DRHD: handling fault status reg 3
[170933.812403] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61a00=
0=20
[170933.812404] DMAR:[fault reason 06] PTE Read access is not set
[170933.812415] DRHD: handling fault status reg 3
[170933.812417] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61c00=
0=20
[170933.812418] DMAR:[fault reason 06] PTE Read access is not set
[170933.812430] DRHD: handling fault status reg 3
[170933.812432] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61e00=
0=20
[170933.812433] DMAR:[fault reason 06] PTE Read access is not set
[170933.812445] DRHD: handling fault status reg 3
[170933.812447] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61f00=
0=20
[170933.812448] DMAR:[fault reason 06] PTE Read access is not set
[170933.812459] DRHD: handling fault status reg 3
[170933.812462] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62100=
0=20
[170933.812462] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.812475] DRHD: handling fault status reg 3
[170933.812477] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62300=
0=20
[170933.812478] DMAR:[fault reason 06] PTE Read access is not set
[170933.812490] DRHD: handling fault status reg 3
[170933.812492] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62500=
0=20
[170933.812493] DMAR:[fault reason 06] PTE Read access is not set
[170933.812504] DRHD: handling fault status reg 3
[170933.812506] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62700=
0=20
[170933.812507] DMAR:[fault reason 06] PTE Read access is not set
[170933.812519] DRHD: handling fault status reg 3
[170933.812521] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62900=
0=20
[170933.812522] DMAR:[fault reason 06] PTE Read access is not set
[170933.812534] DRHD: handling fault status reg 3
[170933.812536] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62b00=
0=20
[170933.812537] DMAR:[fault reason 06] PTE Read access is not set
[170933.812549] DRHD: handling fault status reg 3
[170933.812551] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62d00=
0=20
[170933.812552] DMAR:[fault reason 06] PTE Read access is not set
[170933.812563] DRHD: handling fault status reg 3
[170933.812566] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62e00=
0=20
[170933.812566] DMAR:[fault reason 06] PTE Read access is not set
[170933.812578] DRHD: handling fault status reg 3
[170933.812580] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63000=
0=20
[170933.812581] DMAR:[fault reason 06] PTE Read access is not set
[170933.812593] DRHD: handling fault status reg 3
[170933.812595] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63200=
0=20
[170933.812596] DMAR:[fault reason 06] PTE Read access is not set
[170933.812608] DRHD: handling fault status reg 3
[170933.812610] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63400=
0=20
[170933.812611] DMAR:[fault reason 06] PTE Read access is not set
[170933.812623] DRHD: handling fault status reg 3
[170933.812625] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63600=
0=20
[170933.812626] DMAR:[fault reason 06] PTE Read access is not set
[170933.812637] DRHD: handling fault status reg 3
[170933.812639] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63800=
0=20
[170933.812640] DMAR:[fault reason 06] PTE Read access is not set
[170933.812652] DRHD: handling fault status reg 3
[170933.812655] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63a00=
0=20
[170933.812655] DMAR:[fault reason 06] PTE Read access is not set
[170933.812669] DRHD: handling fault status reg 3
[170933.812671] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63c00=
0=20
[170933.812672] DMAR:[fault reason 06] PTE Read access is not set
[170933.812682] DRHD: handling fault status reg 3
[170933.812684] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63d00=
0=20
[170933.812685] DMAR:[fault reason 06] PTE Read access is not set
[170933.812696] DRHD: handling fault status reg 3
[170933.812698] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63f00=
0=20
[170933.812699] DMAR:[fault reason 06] PTE Read access is not set
[170933.812711] DRHD: handling fault status reg 3
[170933.812713] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64100=
0=20
[170933.812714] DMAR:[fault reason 06] PTE Read access is not set
[170933.812726] DRHD: handling fault status reg 3
[170933.812728] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64300=
0=20
[170933.812729] DMAR:[fault reason 06] PTE Read access is not set
[170933.812741] DRHD: handling fault status reg 3
[170933.812743] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64500=
0=20
[170933.812744] DMAR:[fault reason 06] PTE Read access is not set
[170933.812755] DRHD: handling fault status reg 3
[170933.812757] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64700=
0=20
[170933.812758] DMAR:[fault reason 06] PTE Read access is not set
[170933.812770] DRHD: handling fault status reg 3
[170933.812772] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64900=
0=20
[170933.812773] DMAR:[fault reason 06] PTE Read access is not set
[170933.812785] DRHD: handling fault status reg 3
[170933.812787] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64b00=
0=20
[170933.812788] DMAR:[fault reason 06] PTE Read access is not set
[170933.812800] DRHD: handling fault status reg 3
[170933.812802] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64c00=
0=20
[170933.812803] DMAR:[fault reason 06] PTE Read access is not set
[170933.812815] DRHD: handling fault status reg 3
[170933.812817] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64e00=
0=20
[170933.812818] DMAR:[fault reason 06] PTE Read access is not set
[170933.812830] DRHD: handling fault status reg 3
[170933.812832] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65000=
0=20
[170933.812833] DMAR:[fault reason 06] PTE Read access is not set
[170933.812844] DRHD: handling fault status reg 3
[170933.812846] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65200=
0=20
[170933.812847] DMAR:[fault reason 06] PTE Read access is not set
[170933.812860] DRHD: handling fault status reg 3
[170933.812862] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65400=
0=20
[170933.812863] DMAR:[fault reason 06] PTE Read access is not set
[170933.812874] DRHD: handling fault status reg 3
[170933.812876] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65600=
0=20
[170933.812877] DMAR:[fault reason 06] PTE Read access is not set
[170933.812889] DRHD: handling fault status reg 3
[170933.812891] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65800=
0=20
[170933.812892] DMAR:[fault reason 06] PTE Read access is not set
[170933.812904] DRHD: handling fault status reg 3
[170933.812906] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65a00=
0=20
[170933.812907] DMAR:[fault reason 06] PTE Read access is not set
[170933.812918] DRHD: handling fault status reg 3
[170933.812921] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65b00=
0=20
[170933.812921] DMAR:[fault reason 06] PTE Read access is not set
[170933.812933] DRHD: handling fault status reg 3
[170933.812935] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65d00=
0=20
[170933.812936] DMAR:[fault reason 06] PTE Read access is not set
[170933.812948] DRHD: handling fault status reg 3
[170933.812950] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65f00=
0=20
[170933.812951] DMAR:[fault reason 06] PTE Read access is not set
[170933.812963] DRHD: handling fault status reg 3
[170933.812965] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66100=
0=20
[170933.812966] DMAR:[fault reason 06] PTE Read access is not set
[170933.812978] DRHD: handling fault status reg 3
[170933.812980] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66300=
0=20
[170933.812981] DMAR:[fault reason 06] PTE Read access is not set
[170933.812992] DRHD: handling fault status reg 3
[170933.812994] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66500=
0=20
[170933.812995] DMAR:[fault reason 06] PTE Read access is not set
[170933.813007] DRHD: handling fault status reg 3
[170933.813009] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66700=
0=20
[170933.813010] DMAR:[fault reason 06] PTE Read access is not set
[170933.813022] DRHD: handling fault status reg 3
[170933.813025] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66900=
0=20
[170933.813025] DMAR:[fault reason 06] PTE Read access is not set
[170933.813036] DRHD: handling fault status reg 3
[170933.813039] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66a00=
0=20
[170933.813039] DMAR:[fault reason 06] PTE Read access is not set
[170933.813051] DRHD: handling fault status reg 3
[170933.813054] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66c00=
0=20
[170933.813055] DMAR:[fault reason 06] PTE Read access is not set
[170933.813066] DRHD: handling fault status reg 3
[170933.813068] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66e00=
0=20
[170933.813069] DMAR:[fault reason 06] PTE Read access is not set
[170933.813081] DRHD: handling fault status reg 3
[170933.813083] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67000=
0=20
[170933.813084] DMAR:[fault reason 06] PTE Read access is not set
[170933.813096] DRHD: handling fault status reg 3
[170933.813098] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67200=
0=20
[170933.813099] DMAR:[fault reason 06] PTE Read access is not set
[170933.813111] DRHD: handling fault status reg 3
[170933.813113] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67400=
0=20
[170933.813114] DMAR:[fault reason 06] PTE Read access is not set
[170933.813125] DRHD: handling fault status reg 3
[170933.813128] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67600=
0=20
[170933.813128] DMAR:[fault reason 06] PTE Read access is not set
[170933.813140] DRHD: handling fault status reg 3
[170933.813142] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67800=
0=20
[170933.813143] DMAR:[fault reason 06] PTE Read access is not set
[170933.813155] DRHD: handling fault status reg 3
[170933.813157] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67900=
0=20
[170933.813158] DMAR:[fault reason 06] PTE Read access is not set
[170933.813170] DRHD: handling fault status reg 3
[170933.813172] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67b00=
0=20
[170933.813173] DMAR:[fault reason 06] PTE Read access is not set
[170933.813185] DRHD: handling fault status reg 3
[170933.813187] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67d00=
0=20
[170933.813188] DMAR:[fault reason 06] PTE Read access is not set
[170933.813199] DRHD: handling fault status reg 3
[170933.813201] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67f00=
0=20
[170933.813202] DMAR:[fault reason 06] PTE Read access is not set
[170933.813214] DRHD: handling fault status reg 3
[170933.813217] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68100=
0=20
[170933.813217] DMAR:[fault reason 06] PTE Read access is not set
[170933.813229] DRHD: handling fault status reg 3
[170933.813232] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68300=
0=20
[170933.813232] DMAR:[fault reason 06] PTE Read access is not set
[170933.813244] DRHD: handling fault status reg 3
[170933.813246] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68500=
0=20
[170933.813247] DMAR:[fault reason 06] PTE Read access is not set
[170933.813259] DRHD: handling fault status reg 3
[170933.813261] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68700=
0=20
[170933.813262] DMAR:[fault reason 06] PTE Read access is not set
[170933.813273] DRHD: handling fault status reg 3
[170933.813276] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68800=
0=20
[170933.813276] DMAR:[fault reason 06] PTE Read access is not set
[170933.813288] DRHD: handling fault status reg 3
[170933.813290] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68a00=
0=20
[170933.813291] DMAR:[fault reason 06] PTE Read access is not set
[170933.813303] DRHD: handling fault status reg 3
[170933.813305] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68c00=
0=20
[170933.813306] DMAR:[fault reason 06] PTE Read access is not set
[170933.813318] DRHD: handling fault status reg 3
[170933.813320] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68e00=
0=20
[170933.813321] DMAR:[fault reason 06] PTE Read access is not set
[170933.813333] DRHD: handling fault status reg 3
[170933.813335] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69000=
0=20
[170933.813336] DMAR:[fault reason 06] PTE Read access is not set
[170933.813348] DRHD: handling fault status reg 3
[170933.813350] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69300=
0=20
[170933.813351] DMAR:[fault reason 06] PTE Read access is not set
[170933.813362] DRHD: handling fault status reg 3
[170933.813364] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69400=
0=20
[170933.813365] DMAR:[fault reason 06] PTE Read access is not set
[170933.813377] DRHD: handling fault status reg 3
[170933.813379] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69600=
0=20
[170933.813380] DMAR:[fault reason 06] PTE Read access is not set
[170933.813392] DRHD: handling fault status reg 3
[170933.813394] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69700=
0=20
[170933.813395] DMAR:[fault reason 06] PTE Read access is not set
[170933.813407] DRHD: handling fault status reg 3
[170933.813409] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69900=
0=20
[170933.813409] DMAR:[fault reason 06] PTE Read access is not set
[170933.813422] DRHD: handling fault status reg 3
[170933.813424] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69b00=
0=20
[170933.813424] DMAR:[fault reason 06] PTE Read access is not set
[170933.813436] DRHD: handling fault status reg 3
[170933.813438] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69d00=
0=20
[170933.813439] DMAR:[fault reason 06] PTE Read access is not set
[170933.813451] DRHD: handling fault status reg 3
[170933.813453] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69f00=
0=20
[170933.813454] DMAR:[fault reason 06] PTE Read access is not set
[170933.813466] DRHD: handling fault status reg 3
[170933.813468] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a100=
0=20
[170933.813469] DMAR:[fault reason 06] PTE Read access is not set
[170933.813481] DRHD: handling fault status reg 3
[170933.813483] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a300=
0=20
[170933.813483] DMAR:[fault reason 06] PTE Read access is not set
[170933.813495] DRHD: handling fault status reg 3
[170933.813497] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a500=
0=20
[170933.813498] DMAR:[fault reason 06] PTE Read access is not set
[170933.813510] DRHD: handling fault status reg 3
[170933.813512] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a600=
0=20
[170933.813513] DMAR:[fault reason 06] PTE Read access is not set
[170933.813526] DRHD: handling fault status reg 3
[170933.813528] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6a800=
0=20
[170933.813528] DMAR:[fault reason 06] PTE Read access is not set
[170933.813540] DRHD: handling fault status reg 3
[170933.813542] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6aa00=
0=20
[170933.813543] DMAR:[fault reason 06] PTE Read access is not set
[170933.813555] DRHD: handling fault status reg 3
[170933.813557] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ac00=
0=20
[170933.813557] DMAR:[fault reason 06] PTE Read access is not set
[170933.813569] DRHD: handling fault status reg 3
[170933.813571] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ae00=
0=20
[170933.813572] DMAR:[fault reason 06] PTE Read access is not set
[170933.813584] DRHD: handling fault status reg 3
[170933.813586] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b000=
0=20
[170933.813587] DMAR:[fault reason 06] PTE Read access is not set
[170933.813599] DRHD: handling fault status reg 3
[170933.813601] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b200=
0=20
[170933.813602] DMAR:[fault reason 06] PTE Read access is not set
[170933.813614] DRHD: handling fault status reg 3
[170933.813616] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b400=
0=20
[170933.813616] DMAR:[fault reason 06] PTE Read access is not set
[170933.813629] DRHD: handling fault status reg 3
[170933.813631] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b500=
0=20
[170933.813632] DMAR:[fault reason 06] PTE Read access is not set
[170933.813643] DRHD: handling fault status reg 3
[170933.813645] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b700=
0=20
[170933.813646] DMAR:[fault reason 06] PTE Read access is not set
[170933.813658] DRHD: handling fault status reg 3
[170933.813660] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6b900=
0=20
[170933.813661] DMAR:[fault reason 06] PTE Read access is not set
[170933.813673] DRHD: handling fault status reg 3
[170933.813675] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6bb00=
0=20
[170933.813676] DMAR:[fault reason 06] PTE Read access is not set
[170933.813688] DRHD: handling fault status reg 3
[170933.813690] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6bd00=
0=20
[170933.813691] DMAR:[fault reason 06] PTE Read access is not set
[170933.813702] DRHD: handling fault status reg 3
[170933.813704] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6bf00=
0=20
[170933.813705] DMAR:[fault reason 06] PTE Read access is not set
[170933.813717] DRHD: handling fault status reg 3
[170933.813719] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c100=
0=20
[170933.813720] DMAR:[fault reason 06] PTE Read access is not set
[170933.813732] DRHD: handling fault status reg 3
[170933.813734] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c300=
0=20
[170933.813735] DMAR:[fault reason 06] PTE Read access is not set
[170933.813747] DRHD: handling fault status reg 3
[170933.813749] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c400=
0=20
[170933.813750] DMAR:[fault reason 06] PTE Read access is not set
[170933.813762] DRHD: handling fault status reg 3
[170933.813764] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c600=
0=20
[170933.813765] DMAR:[fault reason 06] PTE Read access is not set
[170933.813776] DRHD: handling fault status reg 3
[170933.813778] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6c800=
0=20
[170933.813779] DMAR:[fault reason 06] PTE Read access is not set
[170933.813792] DRHD: handling fault status reg 3
[170933.813794] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ca00=
0=20
[170933.813794] DMAR:[fault reason 06] PTE Read access is not set
[170933.813806] DRHD: handling fault status reg 3
[170933.813808] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6cc00=
0=20
[170933.813809] DMAR:[fault reason 06] PTE Read access is not set
[170933.813821] DRHD: handling fault status reg 3
[170933.813823] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ce00=
0=20
[170933.813824] DMAR:[fault reason 06] PTE Read access is not set
[170933.813836] DRHD: handling fault status reg 3
[170933.813838] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d000=
0=20
[170933.813838] DMAR:[fault reason 06] PTE Read access is not set
[170933.813850] DRHD: handling fault status reg 3
[170933.813852] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d200=
0=20
[170933.813853] DMAR:[fault reason 06] PTE Read access is not set
[170933.813865] DRHD: handling fault status reg 3
[170933.813867] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d300=
0=20
[170933.813868] DMAR:[fault reason 06] PTE Read access is not set
[170933.813880] DRHD: handling fault status reg 3
[170933.813882] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d500=
0=20
[170933.813883] DMAR:[fault reason 06] PTE Read access is not set
[170933.813895] DRHD: handling fault status reg 3
[170933.813898] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d700=
0=20
[170933.813898] DMAR:[fault reason 06] PTE Read access is not set
[170933.813910] DRHD: handling fault status reg 3
[170933.813912] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6d900=
0=20
[170933.813912] DMAR:[fault reason 06] PTE Read access is not set
[170933.813924] DRHD: handling fault status reg 3
[170933.813926] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6db00=
0=20
[170933.813927] DMAR:[fault reason 06] PTE Read access is not set
[170933.813939] DRHD: handling fault status reg 3
[170933.813941] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6dd00=
0=20
[170933.813942] DMAR:[fault reason 06] PTE Read access is not set
[170933.813954] DRHD: handling fault status reg 3
[170933.813956] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6df00=
0=20
[170933.813957] DMAR:[fault reason 06] PTE Read access is not set
[170933.813969] DRHD: handling fault status reg 3
[170933.813971] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e100=
0=20
[170933.813972] DMAR:[fault reason 06] PTE Read access is not set
[170933.813984] DRHD: handling fault status reg 3
[170933.813986] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e200=
0=20
[170933.813986] DMAR:[fault reason 06] PTE Read access is not set
[170933.813998] DRHD: handling fault status reg 3
[170933.814000] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e400=
0=20
[170933.814001] DMAR:[fault reason 06] PTE Read access is not set
[170933.814013] DRHD: handling fault status reg 3
[170933.814015] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e600=
0=20
[170933.814016] DMAR:[fault reason 06] PTE Read access is not set
[170933.814028] DRHD: handling fault status reg 3
[170933.814030] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6e800=
0=20
[170933.814031] DMAR:[fault reason 06] PTE Read access is not set
[170933.814043] DRHD: handling fault status reg 3
[170933.814045] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ea00=
0=20
[170933.814046] DMAR:[fault reason 06] PTE Read access is not set
[170933.814057] DRHD: handling fault status reg 3
[170933.814059] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ec00=
0=20
[170933.814060] DMAR:[fault reason 06] PTE Read access is not set
[170933.814072] DRHD: handling fault status reg 3
[170933.814074] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6ee00=
0=20
[170933.814075] DMAR:[fault reason 06] PTE Read access is not set
[170933.814087] DRHD: handling fault status reg 3
[170933.814089] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f000=
0=20
[170933.814090] DMAR:[fault reason 06] PTE Read access is not set
[170933.814102] DRHD: handling fault status reg 3
[170933.814104] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f100=
0=20
[170933.814105] DMAR:[fault reason 06] PTE Read access is not set
[170933.814117] DRHD: handling fault status reg 3
[170933.814119] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f300=
0=20
[170933.814119] DMAR:[fault reason 06] PTE Read access is not set
[170933.814132] DRHD: handling fault status reg 3
[170933.814134] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f500=
0=20
[170933.814134] DMAR:[fault reason 06] PTE Read access is not set
[170933.814147] DRHD: handling fault status reg 3
[170933.814149] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f700=
0=20
[170933.814149] DMAR:[fault reason 06] PTE Read access is not set
[170933.814161] DRHD: handling fault status reg 2
[170933.814164] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6f900=
0=20
[170933.814164] DMAR:[fault reason 06] PTE Read access is not set
[170933.814176] DRHD: handling fault status reg 2
[170933.814178] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6fd00=
0=20
[170933.814179] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.814191] DRHD: handling fault status reg 3
[170933.814193] DMAR:[DMA Read] Request device [00:02.0] fault addr ff6fd00=
0=20
[170933.814194] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.814206] DRHD: handling fault status reg 3
[170933.814208] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70000=
0=20
[170933.814209] DMAR:[fault reason 06] PTE Read access is not set
[170933.814220] DRHD: handling fault status reg 3
[170933.814222] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70000=
0=20
[170933.814223] DMAR:[fault reason 06] PTE Read access is not set
[170933.814235] DRHD: handling fault status reg 3
[170933.814237] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70200=
0=20
[170933.814238] DMAR:[fault reason 06] PTE Read access is not set
[170933.814250] DRHD: handling fault status reg 3
[170933.814252] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70400=
0=20
[170933.814253] DMAR:[fault reason 06] PTE Read access is not set
[170933.814265] DRHD: handling fault status reg 3
[170933.814267] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70600=
0=20
[170933.814267] DMAR:[fault reason 06] PTE Read access is not set
[170933.814280] DRHD: handling fault status reg 3
[170933.814282] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70800=
0=20
[170933.814282] DMAR:[fault reason 06] PTE Read access is not set
[170933.814294] DRHD: handling fault status reg 3
[170933.814296] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70a00=
0=20
[170933.814297] DMAR:[fault reason 06] PTE Read access is not set
[170933.814309] DRHD: handling fault status reg 3
[170933.814312] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70c00=
0=20
[170933.814312] DMAR:[fault reason 06] PTE Read access is not set
[170933.814324] DRHD: handling fault status reg 3
[170933.814326] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70e00=
0=20
[170933.814327] DMAR:[fault reason 06] PTE Read access is not set
[170933.814339] DRHD: handling fault status reg 3
[170933.814341] DMAR:[DMA Read] Request device [00:02.0] fault addr ff70f00=
0=20
[170933.814342] DMAR:[fault reason 06] PTE Read access is not set
[170933.814354] DRHD: handling fault status reg 3
[170933.814356] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71100=
0=20
[170933.814356] DMAR:[fault reason 06] PTE Read access is not set
[170933.814368] DRHD: handling fault status reg 3
[170933.814370] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71300=
0=20
[170933.814371] DMAR:[fault reason 06] PTE Read access is not set
[170933.814383] DRHD: handling fault status reg 3
[170933.814385] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71500=
0=20
[170933.814386] DMAR:[fault reason 06] PTE Read access is not set
[170933.814398] DRHD: handling fault status reg 3
[170933.814400] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71700=
0=20
[170933.814401] DMAR:[fault reason 06] PTE Read access is not set
[170933.814413] DRHD: handling fault status reg 3
[170933.814415] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71900=
0=20
[170933.814415] DMAR:[fault reason 06] PTE Read access is not set
[170933.814428] DRHD: handling fault status reg 3
[170933.814430] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71b00=
0=20
[170933.814430] DMAR:[fault reason 06] PTE Read access is not set
[170933.814442] DRHD: handling fault status reg 3
[170933.814444] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71d00=
0=20
[170933.814445] DMAR:[fault reason 06] PTE Read access is not set
[170933.814458] DRHD: handling fault status reg 3
[170933.814460] DMAR:[DMA Read] Request device [00:02.0] fault addr ff71e00=
0=20
[170933.814461] DMAR:[fault reason 06] PTE Read access is not set
[170933.814472] DRHD: handling fault status reg 3
[170933.814474] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72000=
0=20
[170933.814474] DMAR:[fault reason 06] PTE Read access is not set
[170933.814487] DRHD: handling fault status reg 3
[170933.814489] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72200=
0=20
[170933.814489] DMAR:[fault reason 06] PTE Read access is not set
[170933.814502] DRHD: handling fault status reg 3
[170933.814504] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72400=
0=20
[170933.814504] DMAR:[fault reason 06] PTE Read access is not set
[170933.814516] DRHD: handling fault status reg 3
[170933.814518] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72600=
0=20
[170933.814519] DMAR:[fault reason 06] PTE Read access is not set
[170933.814531] DRHD: handling fault status reg 3
[170933.814533] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72800=
0=20
[170933.814534] DMAR:[fault reason 06] PTE Read access is not set
[170933.814546] DRHD: handling fault status reg 3
[170933.814548] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72a00=
0=20
[170933.814549] DMAR:[fault reason 06] PTE Read access is not set
[170933.814561] DRHD: handling fault status reg 3
[170933.814563] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72c00=
0=20
[170933.814563] DMAR:[fault reason 06] PTE Read access is not set
[170933.814575] DRHD: handling fault status reg 3
[170933.814577] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72d00=
0=20
[170933.814578] DMAR:[fault reason 06] PTE Read access is not set
[170933.814590] DRHD: handling fault status reg 3
[170933.814592] DMAR:[DMA Read] Request device [00:02.0] fault addr ff72f00=
0=20
[170933.814593] DMAR:[fault reason 06] PTE Read access is not set
[170933.814605] DRHD: handling fault status reg 3
[170933.814607] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73100=
0=20
[170933.814608] DMAR:[fault reason 06] PTE Read access is not set
[170933.814620] DRHD: handling fault status reg 3
[170933.814622] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73300=
0=20
[170933.814623] DMAR:[fault reason 06] PTE Read access is not set
[170933.814634] DRHD: handling fault status reg 3
[170933.814636] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73500=
0=20
[170933.814637] DMAR:[fault reason 06] PTE Read access is not set
[170933.814650] DRHD: handling fault status reg 3
[170933.814652] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73700=
0=20
[170933.814653] DMAR:[fault reason 06] PTE Read access is not set
[170933.814666] DRHD: handling fault status reg 3
[170933.814669] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73900=
0=20
[170933.814669] DMAR:[fault reason 06] PTE Read access is not set
[170933.814679] DRHD: handling fault status reg 3
[170933.814681] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73b00=
0=20
[170933.814682] DMAR:[fault reason 06] PTE Read access is not set
[170933.814694] DRHD: handling fault status reg 3
[170933.814696] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73c00=
0=20
[170933.814697] DMAR:[fault reason 06] PTE Read access is not set
[170933.814709] DRHD: handling fault status reg 3
[170933.814711] DMAR:[DMA Read] Request device [00:02.0] fault addr ff73e00=
0=20
[170933.814711] DMAR:[fault reason 06] PTE Read access is not set
[170933.814723] DRHD: handling fault status reg 3
[170933.814725] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74000=
0=20
[170933.814726] DMAR:[fault reason 06] PTE Read access is not set
[170933.814739] DRHD: handling fault status reg 3
[170933.814741] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74200=
0=20
[170933.814741] DMAR:[fault reason 06] PTE Read access is not set
[170933.814753] DRHD: handling fault status reg 3
[170933.814755] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74400=
0=20
[170933.814756] DMAR:[fault reason 06] PTE Read access is not set
[170933.814768] DRHD: handling fault status reg 3
[170933.814770] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74600=
0=20
[170933.814771] DMAR:[fault reason 06] PTE Read access is not set
[170933.814783] DRHD: handling fault status reg 3
[170933.814785] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74800=
0=20
[170933.814785] DMAR:[fault reason 06] PTE Read access is not set
[170933.814797] DRHD: handling fault status reg 3
[170933.814799] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74a00=
0=20
[170933.814800] DMAR:[fault reason 06] PTE Read access is not set
[170933.814812] DRHD: handling fault status reg 3
[170933.814814] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74b00=
0=20
[170933.814815] DMAR:[fault reason 06] PTE Read access is not set
[170933.814827] DRHD: handling fault status reg 3
[170933.814829] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74d00=
0=20
[170933.814830] DMAR:[fault reason 06] PTE Read access is not set
[170933.814842] DRHD: handling fault status reg 3
[170933.814844] DMAR:[DMA Read] Request device [00:02.0] fault addr ff74f00=
0=20
[170933.814845] DMAR:[fault reason 06] PTE Read access is not set
[170933.814857] DRHD: handling fault status reg 3
[170933.814859] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75100=
0=20
[170933.814859] DMAR:[fault reason 06] PTE Read access is not set
[170933.814871] DRHD: handling fault status reg 3
[170933.814873] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75300=
0=20
[170933.814874] DMAR:[fault reason 06] PTE Read access is not set
[170933.814886] DRHD: handling fault status reg 3
[170933.814888] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75500=
0=20
[170933.814889] DMAR:[fault reason 06] PTE Read access is not set
[170933.814901] DRHD: handling fault status reg 3
[170933.814903] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75700=
0=20
[170933.814904] DMAR:[fault reason 06] PTE Read access is not set
[170933.814916] DRHD: handling fault status reg 3
[170933.814918] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75900=
0=20
[170933.814919] DMAR:[fault reason 06] PTE Read access is not set
[170933.814930] DRHD: handling fault status reg 3
[170933.814932] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75a00=
0=20
[170933.814933] DMAR:[fault reason 06] PTE Read access is not set
[170933.814946] DRHD: handling fault status reg 3
[170933.814948] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75c00=
0=20
[170933.814949] DMAR:[fault reason 06] PTE Read access is not set
[170933.814960] DRHD: handling fault status reg 3
[170933.814962] DMAR:[DMA Read] Request device [00:02.0] fault addr ff75e00=
0=20
[170933.814963] DMAR:[fault reason 06] PTE Read access is not set
[170933.814975] DRHD: handling fault status reg 3
[170933.814977] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76000=
0=20
[170933.814978] DMAR:[fault reason 06] PTE Read access is not set
[170933.814990] DRHD: handling fault status reg 3
[170933.814992] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76200=
0=20
[170933.814993] DMAR:[fault reason 06] PTE Read access is not set
[170933.815005] DRHD: handling fault status reg 3
[170933.815007] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76400=
0=20
[170933.815008] DMAR:[fault reason 06] PTE Read access is not set
[170933.815019] DRHD: handling fault status reg 3
[170933.815021] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76600=
0=20
[170933.815022] DMAR:[fault reason 06] PTE Read access is not set
[170933.815034] DRHD: handling fault status reg 3
[170933.815036] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76800=
0=20
[170933.815037] DMAR:[fault reason 06] PTE Read access is not set
[170933.815049] DRHD: handling fault status reg 3
[170933.815051] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76900=
0=20
[170933.815052] DMAR:[fault reason 06] PTE Read access is not set
[170933.815064] DRHD: handling fault status reg 3
[170933.815066] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76b00=
0=20
[170933.815067] DMAR:[fault reason 06] PTE Read access is not set
[170933.815078] DRHD: handling fault status reg 3
[170933.815080] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76d00=
0=20
[170933.815081] DMAR:[fault reason 06] PTE Read access is not set
[170933.815093] DRHD: handling fault status reg 3
[170933.815095] DMAR:[DMA Read] Request device [00:02.0] fault addr ff76f00=
0=20
[170933.815096] DMAR:[fault reason 06] PTE Read access is not set
[170933.815108] DRHD: handling fault status reg 3
[170933.815110] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77100=
0=20
[170933.815111] DMAR:[fault reason 06] PTE Read access is not set
[170933.815123] DRHD: handling fault status reg 3
[170933.815125] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77300=
0=20
[170933.815126] DMAR:[fault reason 06] PTE Read access is not set
[170933.815138] DRHD: handling fault status reg 3
[170933.815140] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77500=
0=20
[170933.815141] DMAR:[fault reason 06] PTE Read access is not set
[170933.815152] DRHD: handling fault status reg 3
[170933.815155] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77700=
0=20
[170933.815155] DMAR:[fault reason 06] PTE Read access is not set
[170933.815167] DRHD: handling fault status reg 3
[170933.815169] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77800=
0=20
[170933.815170] DMAR:[fault reason 06] PTE Read access is not set
[170933.815182] DRHD: handling fault status reg 3
[170933.815184] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77a00=
0=20
[170933.815185] DMAR:[fault reason 06] PTE Read access is not set
[170933.815197] DRHD: handling fault status reg 3
[170933.815199] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77c00=
0=20
[170933.815200] DMAR:[fault reason 06] PTE Read access is not set
[170933.815212] DRHD: handling fault status reg 3
[170933.815214] DMAR:[DMA Read] Request device [00:02.0] fault addr ff77e00=
0=20
[170933.815215] DMAR:[fault reason 06] PTE Read access is not set
[170933.815226] DRHD: handling fault status reg 3
[170933.815228] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78000=
0=20
[170933.815229] DMAR:[fault reason 06] PTE Read access is not set
[170933.815241] DRHD: handling fault status reg 3
[170933.815243] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78200=
0=20
[170933.815244] DMAR:[fault reason 06] PTE Read access is not set
[170933.815256] DRHD: handling fault status reg 3
[170933.815258] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78400=
0=20
[170933.815259] DMAR:[fault reason 06] PTE Read access is not set
[170933.815271] DRHD: handling fault status reg 3
[170933.815273] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78600=
0=20
[170933.815274] DMAR:[fault reason 06] PTE Read access is not set
[170933.815286] DRHD: handling fault status reg 3
[170933.815288] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78700=
0=20
[170933.815288] DMAR:[fault reason 06] PTE Read access is not set
[170933.815301] DRHD: handling fault status reg 3
[170933.815303] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78900=
0=20
[170933.815303] DMAR:[fault reason 06] PTE Read access is not set
[170933.815315] DRHD: handling fault status reg 3
[170933.815317] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78b00=
0=20
[170933.815318] DMAR:[fault reason 06] PTE Read access is not set
[170933.815330] DRHD: handling fault status reg 3
[170933.815332] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78d00=
0=20
[170933.815333] DMAR:[fault reason 06] PTE Read access is not set
[170933.815345] DRHD: handling fault status reg 3
[170933.815347] DMAR:[DMA Read] Request device [00:02.0] fault addr ff78f00=
0=20
[170933.815348] DMAR:[fault reason 06] PTE Read access is not set
[170933.815360] DRHD: handling fault status reg 3
[170933.815362] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79100=
0=20
[170933.815362] DMAR:[fault reason 06] PTE Read access is not set
[170933.815374] DRHD: handling fault status reg 3
[170933.815376] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79300=
0=20
[170933.815377] DMAR:[fault reason 06] PTE Read access is not set
[170933.815390] DRHD: handling fault status reg 3
[170933.815392] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79500=
0=20
[170933.815393] DMAR:[fault reason 06] PTE Read access is not set
[170933.815404] DRHD: handling fault status reg 3
[170933.815406] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79600=
0=20
[170933.815407] DMAR:[fault reason 06] PTE Read access is not set
[170933.815419] DRHD: handling fault status reg 3
[170933.815421] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79800=
0=20
[170933.815421] DMAR:[fault reason 06] PTE Read access is not set
[170933.815434] DRHD: handling fault status reg 3
[170933.815436] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79a00=
0=20
[170933.815437] DMAR:[fault reason 06] PTE Read access is not set
[170933.815448] DRHD: handling fault status reg 3
[170933.815450] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79c00=
0=20
[170933.815451] DMAR:[fault reason 06] PTE Read access is not set
[170933.815463] DRHD: handling fault status reg 3
[170933.815466] DMAR:[DMA Read] Request device [00:02.0] fault addr ff79e00=
0=20
[170933.815466] DMAR:[fault reason 06] PTE Read access is not set
[170933.815478] DRHD: handling fault status reg 3
[170933.815480] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a000=
0=20
[170933.815481] DMAR:[fault reason 06] PTE Read access is not set
[170933.815493] DRHD: handling fault status reg 3
[170933.815495] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a200=
0=20
[170933.815495] DMAR:[fault reason 06] PTE Read access is not set
[170933.815507] DRHD: handling fault status reg 3
[170933.815509] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a400=
0=20
[170933.815510] DMAR:[fault reason 06] PTE Read access is not set
[170933.815522] DRHD: handling fault status reg 3
[170933.815524] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a500=
0=20
[170933.815525] DMAR:[fault reason 06] PTE Read access is not set
[170933.815537] DRHD: handling fault status reg 3
[170933.815539] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a700=
0=20
[170933.815540] DMAR:[fault reason 06] PTE Read access is not set
[170933.815552] DRHD: handling fault status reg 3
[170933.815554] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7a900=
0=20
[170933.815555] DMAR:[fault reason 06] PTE Read access is not set
[170933.815567] DRHD: handling fault status reg 3
[170933.815569] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7ab00=
0=20
[170933.815570] DMAR:[fault reason 06] PTE Read access is not set
[170933.815582] DRHD: handling fault status reg 3
[170933.815584] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7ad00=
0=20
[170933.815584] DMAR:[fault reason 06] PTE Read access is not set
[170933.815596] DRHD: handling fault status reg 3
[170933.815598] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7af00=
0=20
[170933.815599] DMAR:[fault reason 06] PTE Read access is not set
[170933.815611] DRHD: handling fault status reg 3
[170933.815613] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b100=
0=20
[170933.815614] DMAR:[fault reason 06] PTE Read access is not set
[170933.815626] DRHD: handling fault status reg 3
[170933.815628] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b300=
0=20
[170933.815629] DMAR:[fault reason 06] PTE Read access is not set
[170933.815641] DRHD: handling fault status reg 3
[170933.815643] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b400=
0=20
[170933.815643] DMAR:[fault reason 06] PTE Read access is not set
[170933.815656] DRHD: handling fault status reg 3
[170933.815658] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b600=
0=20
[170933.815658] DMAR:[fault reason 06] PTE Read access is not set
[170933.815670] DRHD: handling fault status reg 3
[170933.815673] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7b800=
0=20
[170933.815673] DMAR:[fault reason 06] PTE Read access is not set
[170933.815685] DRHD: handling fault status reg 3
[170933.815687] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7ba00=
0=20
[170933.815688] DMAR:[fault reason 06] PTE Read access is not set
[170933.815700] DRHD: handling fault status reg 3
[170933.815702] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7bc00=
0=20
[170933.815702] DMAR:[fault reason 06] PTE Read access is not set
[170933.815715] DRHD: handling fault status reg 3
[170933.815717] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7be00=
0=20
[170933.815718] DMAR:[fault reason 06] PTE Read access is not set
[170933.815729] DRHD: handling fault status reg 3
[170933.815731] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c000=
0=20
[170933.815732] DMAR:[fault reason 06] PTE Read access is not set
[170933.815744] DRHD: handling fault status reg 3
[170933.815746] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c200=
0=20
[170933.815747] DMAR:[fault reason 06] PTE Read access is not set
[170933.815759] DRHD: handling fault status reg 3
[170933.815761] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c300=
0=20
[170933.815762] DMAR:[fault reason 06] PTE Read access is not set
[170933.815774] DRHD: handling fault status reg 3
[170933.815776] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c500=
0=20
[170933.815777] DMAR:[fault reason 06] PTE Read access is not set
[170933.815789] DRHD: handling fault status reg 3
[170933.815791] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c700=
0=20
[170933.815791] DMAR:[fault reason 06] PTE Read access is not set
[170933.815803] DRHD: handling fault status reg 3
[170933.815805] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7c900=
0=20
[170933.815806] DMAR:[fault reason 06] PTE Read access is not set
[170933.815819] DRHD: handling fault status reg 3
[170933.815821] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7cb00=
0=20
[170933.815821] DMAR:[fault reason 06] PTE Read access is not set
[170933.815833] DRHD: handling fault status reg 3
[170933.815835] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7cd00=
0=20
[170933.815836] DMAR:[fault reason 06] PTE Read access is not set
[170933.815848] DRHD: handling fault status reg 3
[170933.815850] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7cf00=
0=20
[170933.815851] DMAR:[fault reason 06] PTE Read access is not set
[170933.815863] DRHD: handling fault status reg 3
[170933.815865] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d100=
0=20
[170933.815865] DMAR:[fault reason 06] PTE Read access is not set
[170933.815877] DRHD: handling fault status reg 3
[170933.815879] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d200=
0=20
[170933.815880] DMAR:[fault reason 06] PTE Read access is not set
[170933.815893] DRHD: handling fault status reg 3
[170933.815895] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d400=
0=20
[170933.815895] DMAR:[fault reason 06] PTE Read access is not set
[170933.815907] DRHD: handling fault status reg 3
[170933.815909] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d600=
0=20
[170933.815910] DMAR:[fault reason 06] PTE Read access is not set
[170933.815922] DRHD: handling fault status reg 3
[170933.815924] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7d800=
0=20
[170933.815925] DMAR:[fault reason 06] PTE Read access is not set
[170933.815937] DRHD: handling fault status reg 3
[170933.815940] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7da00=
0=20
[170933.815940] DMAR:[fault reason 06] PTE Read access is not set
[170933.815952] DRHD: handling fault status reg 3
[170933.815954] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7dc00=
0=20
[170933.815954] DMAR:[fault reason 06] PTE Read access is not set
[170933.815966] DRHD: handling fault status reg 3
[170933.815968] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7de00=
0=20
[170933.815969] DMAR:[fault reason 06] PTE Read access is not set
[170933.815981] DRHD: handling fault status reg 3
[170933.815983] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e000=
0=20
[170933.815984] DMAR:[fault reason 06] PTE Read access is not set
[170933.815996] DRHD: handling fault status reg 3
[170933.815998] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e100=
0=20
[170933.815999] DMAR:[fault reason 06] PTE Read access is not set
[170933.816011] DRHD: handling fault status reg 3
[170933.816013] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e300=
0=20
[170933.816013] DMAR:[fault reason 06] PTE Read access is not set
[170933.816025] DRHD: handling fault status reg 3
[170933.816027] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e500=
0=20
[170933.816028] DMAR:[fault reason 06] PTE Read access is not set
[170933.816040] DRHD: handling fault status reg 3
[170933.816042] DMAR:[DMA Read] Request device [00:02.0] fault addr ff7e700=
0=20
[170933.816043] DMAR:[fault reason 06] PTE Read access is not set
[170933.817965] DRHD: handling fault status reg 3
[170933.817968] DMAR:[DMA Read] Request device [00:02.0] fault addr ff57f00=
0=20
[170933.817969] DMAR:[fault reason 06] PTE Read access is not set
[170933.817985] DRHD: handling fault status reg 3
[170933.817987] DMAR:[DMA Read] Request device [00:02.0] fault addr ff57f00=
0=20
[170933.817988] DMAR:[fault reason 06] PTE Read access is not set
[170933.818005] DRHD: handling fault status reg 3
[170933.818007] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58100=
0=20
[170933.818008] DMAR:[fault reason 06] PTE Read access is not set
[170933.818026] DRHD: handling fault status reg 3
[170933.818028] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58400=
0=20
[170933.818029] DMAR:[fault reason 06] PTE Read access is not set
[170933.818052] DRHD: handling fault status reg 3
[170933.818054] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58600=
0=20
[170933.818055] DMAR:[fault reason 06] PTE Read access is not set
[170933.818073] DRHD: handling fault status reg 3
[170933.818075] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58800=
0=20
[170933.818076] DMAR:[fault reason 06] PTE Read access is not set
[170933.818094] DRHD: handling fault status reg 3
[170933.818096] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58a00=
0=20
[170933.818097] DMAR:[fault reason 06] PTE Read access is not set
[170933.818116] DRHD: handling fault status reg 3
[170933.818118] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58d00=
0=20
[170933.818118] DMAR:[fault reason 06] PTE Read access is not set
[170933.818141] DRHD: handling fault status reg 3
[170933.818143] DMAR:[DMA Read] Request device [00:02.0] fault addr ff58f00=
0=20
[170933.818143] DMAR:[fault reason 06] PTE Read access is not set
[170933.818162] DRHD: handling fault status reg 3
[170933.818164] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59100=
0=20
[170933.818165] DMAR:[fault reason 06] PTE Read access is not set
[170933.818183] DRHD: handling fault status reg 3
[170933.818186] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59400=
0=20
[170933.818186] DMAR:[fault reason 06] PTE Read access is not set
[170933.818204] DRHD: handling fault status reg 3
[170933.818206] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59600=
0=20
[170933.818207] DMAR:[fault reason 06] PTE Read access is not set
[170933.818225] DRHD: handling fault status reg 3
[170933.818227] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59800=
0=20
[170933.818228] DMAR:[fault reason 06] PTE Read access is not set
[170933.818250] DRHD: handling fault status reg 3
[170933.818252] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59b00=
0=20
[170933.818253] DMAR:[fault reason 06] PTE Read access is not set
[170933.818271] DRHD: handling fault status reg 3
[170933.818274] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59d00=
0=20
[170933.818274] DMAR:[fault reason 06] PTE Read access is not set
[170933.818293] DRHD: handling fault status reg 3
[170933.818295] DMAR:[DMA Read] Request device [00:02.0] fault addr ff59f00=
0=20
[170933.818296] DMAR:[fault reason 06] PTE Read access is not set
[170933.818315] DRHD: handling fault status reg 3
[170933.818317] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a200=
0=20
[170933.818318] DMAR:[fault reason 06] PTE Read access is not set
[170933.818340] DRHD: handling fault status reg 3
[170933.818342] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a400=
0=20
[170933.818342] DMAR:[fault reason 06] PTE Read access is not set
[170933.818361] DRHD: handling fault status reg 3
[170933.818363] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a600=
0=20
[170933.818363] DMAR:[fault reason 06] PTE Read access is not set
[170933.818382] DRHD: handling fault status reg 3
[170933.818384] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5a800=
0=20
[170933.818385] DMAR:[fault reason 06] PTE Read access is not set
[170933.818403] DRHD: handling fault status reg 3
[170933.818405] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5aa00=
0=20
[170933.818405] DMAR:[fault reason 06] PTE Read access is not set
[170933.818423] DRHD: handling fault status reg 3
[170933.818425] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ad00=
0=20
[170933.818426] DMAR:[fault reason 06] PTE Read access is not set
[170933.818450] DRHD: handling fault status reg 3
[170933.818452] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5af00=
0=20
[170933.818452] DMAR:[fault reason 06] PTE Read access is not set
[170933.818470] DRHD: handling fault status reg 3
[170933.818472] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b100=
0=20
[170933.818473] DMAR:[fault reason 06] PTE Read access is not set
[170933.818492] DRHD: handling fault status reg 3
[170933.818494] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b400=
0=20
[170933.818494] DMAR:[fault reason 06] PTE Read access is not set
[170933.818513] DRHD: handling fault status reg 3
[170933.818516] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b600=
0=20
[170933.818516] DMAR:[fault reason 06] PTE Read access is not set
[170933.818538] DRHD: handling fault status reg 3
[170933.818540] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5b800=
0=20
[170933.818541] DMAR:[fault reason 06] PTE Read access is not set
[170933.818559] DRHD: handling fault status reg 3
[170933.818561] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5bb00=
0=20
[170933.818562] DMAR:[fault reason 06] PTE Read access is not set
[170933.818581] DRHD: handling fault status reg 3
[170933.818583] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5bd00=
0=20
[170933.818583] DMAR:[fault reason 06] PTE Read access is not set
[170933.818601] DRHD: handling fault status reg 3
[170933.818603] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5bf00=
0=20
[170933.818604] DMAR:[fault reason 06] PTE Read access is not set
[170933.818622] DRHD: handling fault status reg 3
[170933.818624] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c200=
0=20
[170933.818625] DMAR:[fault reason 06] PTE Read access is not set
[170933.818647] DRHD: handling fault status reg 3
[170933.818649] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c400=
0=20
[170933.818650] DMAR:[fault reason 06] PTE Read access is not set
[170933.818669] DRHD: handling fault status reg 3
[170933.818671] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c600=
0=20
[170933.818672] DMAR:[fault reason 06] PTE Read access is not set
[170933.818690] DRHD: handling fault status reg 3
[170933.818692] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5c800=
0=20
[170933.818693] DMAR:[fault reason 06] PTE Read access is not set
[170933.818712] DRHD: handling fault status reg 3
[170933.818714] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cb00=
0=20
[170933.818715] DMAR:[fault reason 06] PTE Read access is not set
[170933.818737] DRHD: handling fault status reg 3
[170933.818739] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cd00=
0=20
[170933.818739] DMAR:[fault reason 06] PTE Read access is not set
[170933.818758] DRHD: handling fault status reg 3
[170933.818760] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5cf00=
0=20
[170933.818761] DMAR:[fault reason 06] PTE Read access is not set
[170933.818780] DRHD: handling fault status reg 3
[170933.818782] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d200=
0=20
[170933.818782] DMAR:[fault reason 06] PTE Read access is not set
[170933.818800] DRHD: handling fault status reg 3
[170933.818802] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d400=
0=20
[170933.818803] DMAR:[fault reason 06] PTE Read access is not set
[170933.818820] DRHD: handling fault status reg 3
[170933.818822] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d600=
0=20
[170933.818823] DMAR:[fault reason 06] PTE Read access is not set
[170933.818847] DRHD: handling fault status reg 3
[170933.818849] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5d800=
0=20
[170933.818849] DMAR:[fault reason 06] PTE Read access is not set
[170933.818868] DRHD: handling fault status reg 3
[170933.818870] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5db00=
0=20
[170933.818870] DMAR:[fault reason 06] PTE Read access is not set
[170933.818889] DRHD: handling fault status reg 3
[170933.818891] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5dd00=
0=20
[170933.818892] DMAR:[fault reason 06] PTE Read access is not set
[170933.818910] DRHD: handling fault status reg 3
[170933.818912] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5df00=
0=20
[170933.818913] DMAR:[fault reason 06] PTE Read access is not set
[170933.818935] DRHD: handling fault status reg 3
[170933.818937] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e200=
0=20
[170933.818938] DMAR:[fault reason 06] PTE Read access is not set
[170933.818957] DRHD: handling fault status reg 3
[170933.818959] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e400=
0=20
[170933.818959] DMAR:[fault reason 06] PTE Read access is not set
[170933.818978] DRHD: handling fault status reg 3
[170933.818980] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e600=
0=20
[170933.818981] DMAR:[fault reason 06] PTE Read access is not set
[170933.818998] DRHD: handling fault status reg 3
[170933.819000] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5e800=
0=20
[170933.819001] DMAR:[fault reason 06] PTE Read access is not set
[170933.819019] DRHD: handling fault status reg 3
[170933.819021] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5eb00=
0=20
[170933.819022] DMAR:[fault reason 06] PTE Read access is not set
[170933.819045] DRHD: handling fault status reg 3
[170933.819047] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ed00=
0=20
[170933.819048] DMAR:[fault reason 06] PTE Read access is not set
[170933.819066] DRHD: handling fault status reg 3
[170933.819068] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5ef00=
0=20
[170933.819069] DMAR:[fault reason 06] PTE Read access is not set
[170933.819088] DRHD: handling fault status reg 3
[170933.819090] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f200=
0=20
[170933.819091] DMAR:[fault reason 06] PTE Read access is not set
[170933.819109] DRHD: handling fault status reg 3
[170933.819111] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f400=
0=20
[170933.819112] DMAR:[fault reason 06] PTE Read access is not set
[170933.819134] DRHD: handling fault status reg 3
[170933.819136] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f600=
0=20
[170933.819137] DMAR:[fault reason 06] PTE Read access is not set
[170933.819155] DRHD: handling fault status reg 3
[170933.819157] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5f900=
0=20
[170933.819158] DMAR:[fault reason 06] PTE Read access is not set
[170933.819177] DRHD: handling fault status reg 3
[170933.819179] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5fb00=
0=20
[170933.819179] DMAR:[fault reason 06] PTE Read access is not set
[170933.819199] DRHD: handling fault status reg 3
[170933.819201] DMAR:[DMA Read] Request device [00:02.0] fault addr ff5fd00=
0=20
[170933.819202] DMAR:[fault reason 06] PTE Read access is not set
[170933.819219] DRHD: handling fault status reg 3
[170933.819221] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60000=
0=20
[170933.819222] DMAR:[fault reason 06] PTE Read access is not set
[170933.819245] DRHD: handling fault status reg 3
[170933.819247] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60200=
0=20
[170933.819248] DMAR:[fault reason 06] PTE Read access is not set
[170933.819266] DRHD: handling fault status reg 3
[170933.819269] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60400=
0=20
[170933.819269] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.819288] DRHD: handling fault status reg 3
[170933.819290] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60600=
0=20
[170933.819291] DMAR:[fault reason 06] PTE Read access is not set
[170933.819309] DRHD: handling fault status reg 3
[170933.819311] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60900=
0=20
[170933.819312] DMAR:[fault reason 12] non-zero reserved fields in PTE
[170933.819334] DRHD: handling fault status reg 3
[170933.819336] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60b00=
0=20
[170933.819336] DMAR:[fault reason 06] PTE Read access is not set
[170933.819356] DRHD: handling fault status reg 3
[170933.819358] DMAR:[DMA Read] Request device [00:02.0] fault addr ff60d00=
0=20
[170933.819358] DMAR:[fault reason 06] PTE Read access is not set
[170933.819377] DRHD: handling fault status reg 3
[170933.819379] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61000=
0=20
[170933.819380] DMAR:[fault reason 06] PTE Read access is not set
[170933.819398] DRHD: handling fault status reg 3
[170933.819401] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61200=
0=20
[170933.819401] DMAR:[fault reason 06] PTE Read access is not set
[170933.819423] DRHD: handling fault status reg 3
[170933.819425] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61400=
0=20
[170933.819426] DMAR:[fault reason 06] PTE Read access is not set
[170933.819445] DRHD: handling fault status reg 3
[170933.819447] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61700=
0=20
[170933.819448] DMAR:[fault reason 06] PTE Read access is not set
[170933.819465] DRHD: handling fault status reg 3
[170933.819468] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61900=
0=20
[170933.819468] DMAR:[fault reason 06] PTE Read access is not set
[170933.819487] DRHD: handling fault status reg 3
[170933.819489] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61b00=
0=20
[170933.819490] DMAR:[fault reason 06] PTE Read access is not set
[170933.819514] DRHD: handling fault status reg 3
[170933.819516] DMAR:[DMA Read] Request device [00:02.0] fault addr ff61e00=
0=20
[170933.819516] DMAR:[fault reason 06] PTE Read access is not set
[170933.819535] DRHD: handling fault status reg 3
[170933.819537] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62000=
0=20
[170933.819538] DMAR:[fault reason 06] PTE Read access is not set
[170933.819556] DRHD: handling fault status reg 3
[170933.819558] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62200=
0=20
[170933.819559] DMAR:[fault reason 06] PTE Read access is not set
[170933.819578] DRHD: handling fault status reg 3
[170933.819580] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62500=
0=20
[170933.819581] DMAR:[fault reason 06] PTE Read access is not set
[170933.819599] DRHD: handling fault status reg 3
[170933.819601] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62700=
0=20
[170933.819602] DMAR:[fault reason 06] PTE Read access is not set
[170933.819624] DRHD: handling fault status reg 3
[170933.819626] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62900=
0=20
[170933.819627] DMAR:[fault reason 06] PTE Read access is not set
[170933.819646] DRHD: handling fault status reg 3
[170933.819648] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62b00=
0=20
[170933.819649] DMAR:[fault reason 06] PTE Read access is not set
[170933.819667] DRHD: handling fault status reg 3
[170933.819669] DMAR:[DMA Read] Request device [00:02.0] fault addr ff62e00=
0=20
[170933.819670] DMAR:[fault reason 06] PTE Read access is not set
[170933.819688] DRHD: handling fault status reg 3
[170933.819690] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63000=
0=20
[170933.819690] DMAR:[fault reason 06] PTE Read access is not set
[170933.819713] DRHD: handling fault status reg 3
[170933.819715] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63200=
0=20
[170933.819716] DMAR:[fault reason 06] PTE Read access is not set
[170933.819735] DRHD: handling fault status reg 3
[170933.819737] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63500=
0=20
[170933.819738] DMAR:[fault reason 06] PTE Read access is not set
[170933.819757] DRHD: handling fault status reg 3
[170933.819759] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63700=
0=20
[170933.819760] DMAR:[fault reason 06] PTE Read access is not set
[170933.819778] DRHD: handling fault status reg 3
[170933.819780] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63900=
0=20
[170933.819780] DMAR:[fault reason 06] PTE Read access is not set
[170933.819802] DRHD: handling fault status reg 3
[170933.819804] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63c00=
0=20
[170933.819805] DMAR:[fault reason 06] PTE Read access is not set
[170933.819823] DRHD: handling fault status reg 3
[170933.819825] DMAR:[DMA Read] Request device [00:02.0] fault addr ff63e00=
0=20
[170933.819826] DMAR:[fault reason 06] PTE Read access is not set
[170933.819845] DRHD: handling fault status reg 3
[170933.819847] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64000=
0=20
[170933.819848] DMAR:[fault reason 06] PTE Read access is not set
[170933.819865] DRHD: handling fault status reg 3
[170933.819867] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64200=
0=20
[170933.819868] DMAR:[fault reason 06] PTE Read access is not set
[170933.819887] DRHD: handling fault status reg 3
[170933.819889] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64500=
0=20
[170933.819890] DMAR:[fault reason 06] PTE Read access is not set
[170933.819912] DRHD: handling fault status reg 3
[170933.819914] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64700=
0=20
[170933.819915] DMAR:[fault reason 06] PTE Read access is not set
[170933.819933] DRHD: handling fault status reg 3
[170933.819935] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64900=
0=20
[170933.819936] DMAR:[fault reason 06] PTE Read access is not set
[170933.819955] DRHD: handling fault status reg 3
[170933.819957] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64c00=
0=20
[170933.819957] DMAR:[fault reason 06] PTE Read access is not set
[170933.819976] DRHD: handling fault status reg 3
[170933.819978] DMAR:[DMA Read] Request device [00:02.0] fault addr ff64e00=
0=20
[170933.819979] DMAR:[fault reason 06] PTE Read access is not set
[170933.820001] DRHD: handling fault status reg 3
[170933.820003] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65000=
0=20
[170933.820004] DMAR:[fault reason 06] PTE Read access is not set
[170933.820022] DRHD: handling fault status reg 3
[170933.820024] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65300=
0=20
[170933.820025] DMAR:[fault reason 06] PTE Read access is not set
[170933.820044] DRHD: handling fault status reg 3
[170933.820046] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65500=
0=20
[170933.820046] DMAR:[fault reason 06] PTE Read access is not set
[170933.820064] DRHD: handling fault status reg 3
[170933.820066] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65700=
0=20
[170933.820067] DMAR:[fault reason 06] PTE Read access is not set
[170933.820085] DRHD: handling fault status reg 3
[170933.820087] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65900=
0=20
[170933.820088] DMAR:[fault reason 06] PTE Read access is not set
[170933.820110] DRHD: handling fault status reg 3
[170933.820112] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65c00=
0=20
[170933.820113] DMAR:[fault reason 06] PTE Read access is not set
[170933.820133] DRHD: handling fault status reg 3
[170933.820135] DMAR:[DMA Read] Request device [00:02.0] fault addr ff65e00=
0=20
[170933.820135] DMAR:[fault reason 06] PTE Read access is not set
[170933.820154] DRHD: handling fault status reg 3
[170933.820156] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66000=
0=20
[170933.820156] DMAR:[fault reason 06] PTE Read access is not set
[170933.820174] DRHD: handling fault status reg 3
[170933.820176] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66300=
0=20
[170933.820177] DMAR:[fault reason 06] PTE Read access is not set
[170933.820200] DRHD: handling fault status reg 3
[170933.820202] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66500=
0=20
[170933.820202] DMAR:[fault reason 06] PTE Read access is not set
[170933.820222] DRHD: handling fault status reg 3
[170933.820224] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66700=
0=20
[170933.820225] DMAR:[fault reason 06] PTE Read access is not set
[170933.820242] DRHD: handling fault status reg 3
[170933.820244] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66900=
0=20
[170933.820245] DMAR:[fault reason 06] PTE Read access is not set
[170933.820264] DRHD: handling fault status reg 3
[170933.820266] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66c00=
0=20
[170933.820267] DMAR:[fault reason 06] PTE Read access is not set
[170933.820285] DRHD: handling fault status reg 3
[170933.820287] DMAR:[DMA Read] Request device [00:02.0] fault addr ff66e00=
0=20
[170933.820287] DMAR:[fault reason 06] PTE Read access is not set
[170933.820309] DRHD: handling fault status reg 3
[170933.820311] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67000=
0=20
[170933.820312] DMAR:[fault reason 06] PTE Read access is not set
[170933.820332] DRHD: handling fault status reg 3
[170933.820334] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67300=
0=20
[170933.820334] DMAR:[fault reason 06] PTE Read access is not set
[170933.820352] DRHD: handling fault status reg 3
[170933.820354] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67500=
0=20
[170933.820355] DMAR:[fault reason 06] PTE Read access is not set
[170933.820373] DRHD: handling fault status reg 3
[170933.820375] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67700=
0=20
[170933.820376] DMAR:[fault reason 06] PTE Read access is not set
[170933.820398] DRHD: handling fault status reg 3
[170933.820400] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67a00=
0=20
[170933.820401] DMAR:[fault reason 06] PTE Read access is not set
[170933.820420] DRHD: handling fault status reg 3
[170933.820422] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67c00=
0=20
[170933.820423] DMAR:[fault reason 06] PTE Read access is not set
[170933.820441] DRHD: handling fault status reg 3
[170933.820443] DMAR:[DMA Read] Request device [00:02.0] fault addr ff67e00=
0=20
[170933.820444] DMAR:[fault reason 06] PTE Read access is not set
[170933.820462] DRHD: handling fault status reg 3
[170933.820464] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68000=
0=20
[170933.820464] DMAR:[fault reason 06] PTE Read access is not set
[170933.820483] DRHD: handling fault status reg 3
[170933.820485] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68300=
0=20
[170933.820485] DMAR:[fault reason 06] PTE Read access is not set
[170933.820508] DRHD: handling fault status reg 3
[170933.820510] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68500=
0=20
[170933.820511] DMAR:[fault reason 06] PTE Read access is not set
[170933.820530] DRHD: handling fault status reg 3
[170933.820532] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68700=
0=20
[170933.820532] DMAR:[fault reason 06] PTE Read access is not set
[170933.820551] DRHD: handling fault status reg 3
[170933.820553] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68900=
0=20
[170933.820553] DMAR:[fault reason 06] PTE Read access is not set
[170933.820572] DRHD: handling fault status reg 3
[170933.820574] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68c00=
0=20
[170933.820575] DMAR:[fault reason 06] PTE Read access is not set
[170933.820597] DRHD: handling fault status reg 3
[170933.820599] DMAR:[DMA Read] Request device [00:02.0] fault addr ff68e00=
0=20
[170933.820600] DMAR:[fault reason 06] PTE Read access is not set
[170933.820618] DRHD: handling fault status reg 3
[170933.820620] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69000=
0=20
[170933.820621] DMAR:[fault reason 06] PTE Read access is not set
[170933.820640] DRHD: handling fault status reg 3
[170933.820642] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69300=
0=20
[170933.820642] DMAR:[fault reason 06] PTE Read access is not set
[170933.820660] DRHD: handling fault status reg 3
[170933.820662] DMAR:[DMA Read] Request device [00:02.0] fault addr ff69500=
0=20
[170933.820663] DMAR:[fault reason 06] PTE Read access is not set
[170933.823651] i915 0000:00:02.0: setting latency timer to 64
[170933.823672] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[170933.823708] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[170933.823838] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[170933.823943] usb usb2: root hub lost power or was reset
[170933.823960] usb usb1: root hub lost power or was reset
[170933.827818] ehci_hcd 0000:00:1d.0: cache line size of 64 is not support=
ed
[170933.827843] ahci 0000:00:1f.2: setting latency timer to 64
[170933.827853] ehci_hcd 0000:00:1a.0: cache line size of 64 is not support=
ed
[170933.827926] pci 0000:03:00.0: setting latency timer to 64
[170933.859453] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[170934.132346] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[170934.143970] ata5: SATA link down (SStatus 0 SControl 300)
[170934.144024] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[170934.144059] ata6: SATA link down (SStatus 0 SControl 300)
[170934.144080] ata4: SATA link down (SStatus 0 SControl 300)
[170934.144487] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (unknown) rejected b=
y device (Stat=3D0x51 Err=3D0x04)
[170934.153331] usb 2-1: reset high-speed USB device number 2 using ehci_hcd
[170934.157918] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (unknown) rejected b=
y device (Stat=3D0x51 Err=3D0x04)
[170934.158292] ata1.00: configured for UDMA/133
[170934.169356] sd 0:0:0:0: [sda] Starting disk
[170934.172308] ata2.00: configured for UDMA/100
[170934.181984] ------------[ cut here ]------------
[170934.181991] WARNING: at drivers/gpu/drm/i915/intel_display.c:963 assert=
_plane+0x70/0x80()
[170934.181992] Hardware name: Latitude E5420
[170934.181994] plane B assertion failure (expected off, current on)
[170934.181995] Modules linked in: mac80211_hwsim vboxnetadp(O) vboxnetflt(=
O) vboxdrv(O) ppp_async crc_ccitt ppp_generic slhc hid_logitech_dj hid_cher=
ry usbhid psmouse cpufreq_stats vfat fat usb_storage bluetooth fuse iwlwifi=
 uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev snd_hd=
a_codec_hdmi mac80211 snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwd=
ep ehci_hcd snd_pcm cfg80211 usbcore crc32c_intel aesni_intel snd_page_allo=
c snd_timer snd aes_x86_64 cryptd usb_common soundcore [last unloaded: psmo=
use]
[170934.182023] Pid: 29929, comm: kworker/u:5 Tainted: G        W  O 3.4.0o=
rdex+ #3
[170934.182025] Call Trace:
[170934.182030]  [<ffffffff81033d4a>] warn_slowpath_common+0x7a/0xb0
[170934.182034]  [<ffffffff8105c4f0>] ? async_schedule+0x20/0x20
[170934.182036]  [<ffffffff81033e21>] warn_slowpath_fmt+0x41/0x50
[170934.182040]  [<ffffffff8130b4e6>] ? ironlake_crtc_dpms+0x86/0x90
[170934.182042]  [<ffffffff81300dd0>] assert_plane+0x70/0x80
[170934.182044]  [<ffffffff8130684c>] intel_crtc_disable+0x6c/0xc0
[170934.182048]  [<ffffffff812c6c85>] drm_helper_disable_unused_functions+0=
x115/0x190
[170934.182050]  [<ffffffff812c77a8>] drm_helper_resume_force_mode+0x128/0x=
160
[170934.182053]  [<ffffffff8105c4f0>] ? async_schedule+0x20/0x20
[170934.182057]  [<ffffffff812e4741>] i915_drm_thaw+0x111/0x160
[170934.182059]  [<ffffffff812e4a19>] i915_resume+0x49/0x80
[170934.182062]  [<ffffffff812e4a61>] i915_pm_resume+0x11/0x20
[170934.182066]  [<ffffffff81237979>] pci_pm_restore+0x79/0xe0
[170934.182068]  [<ffffffff81237900>] ? pci_pm_suspend_noirq+0x170/0x170
[170934.182072]  [<ffffffff81334c76>] dpm_run_callback.isra.5+0x36/0x70
[170934.182074]  [<ffffffff81334f90>] device_resume+0xa0/0x160
[170934.182076]  [<ffffffff8133506c>] async_resume+0x1c/0x50
[170934.182079]  [<ffffffff8105c569>] async_run_entry_fn+0x79/0x170
[170934.182082]  [<ffffffff8104d924>] process_one_work+0x174/0x450
[170934.182085]  [<ffffffff8104d8c6>] ? process_one_work+0x116/0x450
[170934.182088]  [<ffffffff8104f6cf>] worker_thread+0x15f/0x350
[170934.182090]  [<ffffffff8104f570>] ? manage_workers.isra.28+0x220/0x220
[170934.182093]  [<ffffffff8105472e>] kthread+0x8e/0xa0
[170934.182098]  [<ffffffff814fc914>] kernel_thread_helper+0x4/0x10
[170934.182101]  [<ffffffff8105de60>] ? finish_task_switch+0x80/0x110
[170934.182103]  [<ffffffff8105de60>] ? finish_task_switch+0x80/0x110
[170934.182106]  [<ffffffff814fafdd>] ? retint_restore_args+0xe/0xe
[170934.182109]  [<ffffffff810546a0>] ? __init_kthread_worker+0x70/0x70
[170934.182111]  [<ffffffff814fc910>] ? gs_change+0xb/0xb
[170934.182113] ---[ end trace e93713a9d40cd079 ]---
[170934.182114] ------------[ cut here ]------------
[170934.182116] WARNING: at drivers/gpu/drm/i915/intel_display.c:948 assert=
_pipe+0x86/0x90()
[170934.182117] Hardware name: Latitude E5420
[170934.182119] pipe B assertion failure (expected off, current on)
[170934.182120] Modules linked in: mac80211_hwsim vboxnetadp(O) vboxnetflt(=
O) vboxdrv(O) ppp_async crc_ccitt ppp_generic slhc hid_logitech_dj hid_cher=
ry usbhid psmouse cpufreq_stats vfat fat usb_storage bluetooth fuse iwlwifi=
 uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev snd_hd=
a_codec_hdmi mac80211 snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwd=
ep ehci_hcd snd_pcm cfg80211 usbcore crc32c_intel aesni_intel snd_page_allo=
c snd_timer snd aes_x86_64 cryptd usb_common soundcore [last unloaded: psmo=
use]
[170934.182139] Pid: 29929, comm: kworker/u:5 Tainted: G        W  O 3.4.0o=
rdex+ #3
[170934.182140] Call Trace:
[170934.182142]  [<ffffffff81033d4a>] warn_slowpath_common+0x7a/0xb0
[170934.182145]  [<ffffffff8105c4f0>] ? async_schedule+0x20/0x20
[170934.182147]  [<ffffffff81033e21>] warn_slowpath_fmt+0x41/0x50
[170934.182150]  [<ffffffff8130b4e6>] ? ironlake_crtc_dpms+0x86/0x90
[170934.182152]  [<ffffffff81305066>] assert_pipe+0x86/0x90
[170934.182154]  [<ffffffff81306861>] intel_crtc_disable+0x81/0xc0
[170934.182156]  [<ffffffff812c6c85>] drm_helper_disable_unused_functions+0=
x115/0x190
[170934.182159]  [<ffffffff812c77a8>] drm_helper_resume_force_mode+0x128/0x=
160
[170934.182162]  [<ffffffff8105c4f0>] ? async_schedule+0x20/0x20
[170934.182164]  [<ffffffff812e4741>] i915_drm_thaw+0x111/0x160
[170934.182167]  [<ffffffff812e4a19>] i915_resume+0x49/0x80
[170934.182170]  [<ffffffff812e4a61>] i915_pm_resume+0x11/0x20
[170934.182172]  [<ffffffff81237979>] pci_pm_restore+0x79/0xe0
[170934.182174]  [<ffffffff81237900>] ? pci_pm_suspend_noirq+0x170/0x170
[170934.182177]  [<ffffffff81334c76>] dpm_run_callback.isra.5+0x36/0x70
[170934.182179]  [<ffffffff81334f90>] device_resume+0xa0/0x160
[170934.182181]  [<ffffffff8133506c>] async_resume+0x1c/0x50
[170934.182184]  [<ffffffff8105c569>] async_run_entry_fn+0x79/0x170
[170934.182186]  [<ffffffff8104d924>] process_one_work+0x174/0x450
[170934.182193]  [<ffffffff8104d8c6>] ? process_one_work+0x116/0x450
[170934.182195]  [<ffffffff8104f6cf>] worker_thread+0x15f/0x350
[170934.182198]  [<ffffffff8104f570>] ? manage_workers.isra.28+0x220/0x220
[170934.182201]  [<ffffffff8105472e>] kthread+0x8e/0xa0
[170934.182204]  [<ffffffff814fc914>] kernel_thread_helper+0x4/0x10
[170934.182206]  [<ffffffff8105de60>] ? finish_task_switch+0x80/0x110
[170934.182209]  [<ffffffff8105de60>] ? finish_task_switch+0x80/0x110
[170934.182212]  [<ffffffff814fafdd>] ? retint_restore_args+0xe/0xe
[170934.182215]  [<ffffffff810546a0>] ? __init_kthread_worker+0x70/0x70
[170934.182218]  [<ffffffff814fc910>] ? gs_change+0xb/0xb
[170934.182219] ---[ end trace e93713a9d40cd07a ]---
[170934.764593] usb 1-1: reset high-speed USB device number 2 using ehci_hcd
[170934.951544] usb 2-1.6: reset full-speed USB device number 3 using ehci_=
hcd
[170935.156403] usb 1-1.4: reset high-speed USB device number 3 using ehci_=
hcd
[170935.619242] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[170935.626039] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[170935.751438] PM: restore of devices complete after 1930.372 msecs
[170940.453257] PM: Image restored successfully.
[170940.454443] Restarting tasks ...=20
[170940.456206] usb 2-1.4: USB disconnect, device number 23
[170940.456973] done.
[170940.457007] PM: Basic memory bitmaps freed
[170940.457011] video LNXVIDEO:00: Restoring backlight state
[170940.462071] usb 2-1.4.2: USB disconnect, device number 24
[170940.464142] cfg80211: Calling CRDA to update world regulatory domain
[170940.818870] [drm:gen6_fdi_link_train] *ERROR* FDI train 1 fail!
[170940.821035] [drm:gen6_fdi_link_train] *ERROR* FDI train 2 fail!
[170941.104768] usb 2-1.4.4: USB disconnect, device number 25
[170941.104773] usb 2-1.4.4.1: USB disconnect, device number 26
[170941.109628] usb 2-1.4.4.4: USB disconnect, device number 27
[170944.828113] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[170944.835063] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[170944.867059] cfg80211: World regulatory domain updated:
[170944.867063] cfg80211:   (start_freq - end_freq @ bandwidth), (max_anten=
na_gain, max_eirp)
[170944.867066] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 m=
Bi, 2000 mBm)
[170944.867068] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 m=
Bi, 2000 mBm)
[170944.867071] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 m=
Bi, 2000 mBm)
[170944.867073] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 m=
Bi, 2000 mBm)
[170944.867075] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 m=
Bi, 2000 mBm)
[170944.971982] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[170945.961224] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[170945.968105] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[170946.105929] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[170950.123118] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[170950.130047] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[170950.264441] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[170950.319664] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[170950.326517] iwlwifi 0000:02:00.0: Radio type=3D0x1-0x2-0x0
[170950.464025] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[170952.775288] wlan0: authenticate with 54:75:d0:3f:56:1e
[170952.777191] wlan0: send auth to 54:75:d0:3f:56:1e (try 1/3)
[170952.977945] wlan0: send auth to 54:75:d0:3f:56:1e (try 2/3)
[170953.178648] wlan0: send auth to 54:75:d0:3f:56:1e (try 3/3)
[170953.379389] wlan0: authentication with 54:75:d0:3f:56:1e timed out
[170953.382673] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station =
id 0 addr 54:75:d0:3f:56:1e
[170961.350702] wlan0: authenticate with 54:75:d0:3f:56:1e
[170961.371870] wlan0: send auth to 54:75:d0:3f:56:1e (try 1/3)
[170961.571755] wlan0: send auth to 54:75:d0:3f:56:1e (try 2/3)
[170961.572603] wlan0: authenticated
[170961.572849] wlan0: waiting for beacon from 54:75:d0:3f:56:1e
[170961.656652] wlan0: associate with 54:75:d0:3f:56:1e (try 1/3)
[170961.659282] wlan0: RX AssocResp from 54:75:d0:3f:56:1e (capab=3D0x11 st=
atus=3D0 aid=3D7)
[170961.659287] wlan0: associated
[170961.665461] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[170961.665660] cfg80211: Calling CRDA for country: IT
[170961.675331] cfg80211: Regulatory domain changed to country: IT
[170961.675335] cfg80211:   (start_freq - end_freq @ bandwidth), (max_anten=
na_gain, max_eirp)
[170961.675338] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, =
2000 mBm)
[170961.675340] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, =
2000 mBm)
[170961.675342] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, =
2000 mBm)
[170961.675344] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, =
2700 mBm)
[170972.429760] wlan0: no IPv6 routers present
[171074.909455] usb 2-1.2: new full-speed USB device number 28 using ehci_h=
cd
[171074.998615] usb 2-1.2: New USB device found, idVendor=3D046d, idProduct=
=3Dc52b
[171074.998620] usb 2-1.2: New USB device strings: Mfr=3D1, Product=3D2, Se=
rialNumber=3D0
[171074.998623] usb 2-1.2: Product: USB Receiver
[171074.998624] usb 2-1.2: Manufacturer: Logitech
[171075.008831] logitech-djreceiver 0003:046D:C52B.0016: hidraw0: USB HID v=
1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1.2/input2
[171075.011795] input: Logitech Unifying Device. Wireless PID:1024 as /devi=
ces/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.2/0003:046D:C52B.0016/in=
put/input32
[171075.013756] logitech-djdevice 0003:046D:C52B.0017: input,hidraw1: USB H=
ID v1.11 Mouse [Logitech Unifying Device. Wireless PID:1024] on usb-0000:00=
:1d.0-1.2:1
[171075.015904] input: Logitech Unifying Device. Wireless PID:2011 as /devi=
ces/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.2/0003:046D:C52B.0016/in=
put/input33
[171075.017401] logitech-djdevice 0003:046D:C52B.0018: input,hidraw2: USB H=
ID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2011] on usb-0000=
:00:1d.0-1.2:2
[171590.435003] kmemleak: 15 new suspected memory leaks (see /sys/kernel/de=
bug/kmemleak)
[172050.077924] dell_wmi: Received unknown WMI event (0x11)
[172070.393111] NMI watchdog: enabled, takes one hw-pmu counter.
[172070.393232] NMI watchdog: enabled, takes one hw-pmu counter.
[172070.393315] NMI watchdog: enabled, takes one hw-pmu counter.
[172070.393398] NMI watchdog: enabled, takes one hw-pmu counter.
[172070.593841] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[172222.771641] kmemleak: 2 new suspected memory leaks (see /sys/kernel/deb=
ug/kmemleak)
[172439.262983] dell_wmi: Received unknown WMI event (0x11)
[172550.610429] dell_wmi: Received unknown WMI event (0x0)
[172863.895969] kmemleak: 1 new suspected memory leaks (see /sys/kernel/deb=
ug/kmemleak)

--82I3+IH0IqGh5yIs--

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPxyNtAAoJEFMQTLzJFOZFyTAH/2Nfws9daQtlNdtbLy9/9RU4
XERoQpgRMQvbQ9jvpFZtgPmpLsJ1vGta4YEi0n1rw48xjpLe7bwMKWogSjBOadTk
cSUiQMtOxP1qGC0toQIrxpOXzxUbXKS5RRmh5PXcLKPsn/k7WXqeU7a86n5DEOoG
Pz8b9nXBXHQQ2rXGW5Ya35gKzd27pkEg+jf9HLaKQyD5tNRyfQhLBihFhQcFleRW
EDXf08SjBlreuSzt4Zv25utyA/Y8bFXdRBtn4OhWwg/4J9tbQNwMsqRFgB+vTP58
fflyL3EQUUiuyq6xE2AQ53RajXdnajSi9aipNF3Edg6N/nf1PLi8jSJ3WWO92J8=
=EO9P
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
