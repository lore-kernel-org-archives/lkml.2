Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1D0QNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:13:37 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61531 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab1D0QNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=vkwGPJOIV1okfVpDBbo4X/hps1jlWhIv/oFqHC2PpEDbGd2jfSIYLd/uc9mQkvf4Qp
         yib65n/6evyDuC1bc1VgzJOnZ2OV6yc8bVD8CkYJ3CzB1tGRtuWJi1QyyUf9YUiu+9fk
         Ous6nXu3hU5GOjCA+zPcek7PdvYSxAa7tWmHk=
MIME-Version: 1.0
Date: Thu, 28 Apr 2011 00:13:33 +0800
Message-ID: <BANLkTimQLXjspfHEgGdRXwdzWRu2GM3CvA@mail.gmail.com>
Subject: Some problem (show-stopper) arising from latest
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem 1:   this is caused by what?   it don't seemed to be causing
the system any harm.

[   23.834651] pci 0000:00:02.0: irq 2295 for MSI/MSI-X
[   23.834724] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   23.835226] [drm:i915_setparam] *ERROR* unknown parameter 4
[   23.835245] [drm:i915_getparam] *ERROR* Unknown parameter 9
[   23.835248] [drm:i915_getparam] *ERROR* Unknown parameter 10
[   23.835251] [drm:i915_getparam] *ERROR* Unknown parameter 11
[   23.835253] [drm:i915_getparam] *ERROR* Unknown parameter 12
[   24.809702] [drm:i915_getparam] *ERROR* Unknown parameter 9
[   24.809706] [drm:i915_getparam] *ERROR* Unknown parameter 10
[   24.809708] [drm:i915_getparam] *ERROR* Unknown parameter 11
[   24.809710] [drm:i915_getparam] *ERROR* Unknown parameter 12
[   25.414255] ppdev: user-space parallel port driver
[   29.588228] e1000e 0000:00:19.0: irq 2297 for MSI/MSI-X
[   29.640112] e1000e 0000:00:19.0: irq 2297 for MSI/MSI-X
[   29.640416] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   29.641052] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-1.ucode
[   30.084105] hda-intel: IRQ timing workaround is activated for card
#0. Suggest a bigger bdl_pos_adj.
[   30.111647] Registered led device: iwl-phy0:radio
[   30.111665] Registered led device: iwl-phy0:assoc
[   30.111678] Registered led device: iwl-phy0:RX
[   30.111691] Registered led device: iwl-phy0:TX
[   30.133136] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   38.154678] CPU0 attaching NULL sched-domain.
[   38.154682] CPU1 attaching NULL sched-domain.
[   38.154750] CPU0 attaching sched-domain:
[   38.154753]  domain 0: span 0-1 level MC
[   38.154755]   groups: 0 1
[   38.154758]   domain 1: span 0-1 level CPU
[   38.154760]    groups: 0-1
[   38.154763] CPU1 attaching sched-domain:
[   38.154765]  domain 0: span 0-1 level MC
[   38.154766]   groups: 1 0
[   38.154769]   domain 1: span 0-1 level CPU
[   38.154770]    groups: 0-1
[  122.802054] thinkpad_acpi: unhandled HKEY event 0x6030
[  122.864356] CPU0 attaching NULL sched-domain.
[  122.864360] CPU1 attaching NULL sched-domain.
[  122.876093] CPU0 attaching sched-domain:
[  122.876096]  domain 0: span 0-1 level MC
[  122.876098]   groups: 0 1
[  122.876103] CPU1 attaching sched-domain:
[  122.876104]  domain 0: span 0-1 level MC
[  122.876106]   groups: 1 0
[  130.992254] wlan0: authenticate with AP 00:1a:70:db:c8:04
[  130.994227] wlan0: authenticated
[  130.994236] wlan0: associate with AP 00:1a:70:db:c8:04
[  130.997065] wlan0: RX AssocResp from 00:1a:70:db:c8:04 (capab=0x431
status=0 aid=4)
[  130.997071] wlan0: associated
[  131.002416] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  131.100836] padlock: VIA PadLock not detected.
[  141.320059] wlan0: no IPv6 routers present
[ 2899.294918] [drm:i915_getparam] *ERROR* Unknown parameter 9
[ 2899.294927] [drm:i915_getparam] *ERROR* Unknown parameter 10
[ 2899.294933] [drm:i915_getparam] *ERROR* Unknown parameter 11
[ 2899.294938] [drm:i915_getparam] *ERROR* Unknown parameter 12
[ 4503.324045] [drm:i915_getparam] *ERROR* Unknown parameter 9
[ 4503.324055] [drm:i915_getparam] *ERROR* Unknown parameter 10
[ 4503.324061] [drm:i915_getparam] *ERROR* Unknown parameter 11
[ 4503.324066] [drm:i915_getparam] *ERROR* Unknown parameter 12
[ 4839.488668] [drm:i915_getparam] *ERROR* Unknown parameter 9
[ 4839.488679] [drm:i915_getparam] *ERROR* Unknown parameter 10
[ 4839.488685] [drm:i915_getparam] *ERROR* Unknown parameter 11
[ 4839.488690] [drm:i915_getparam] *ERROR* Unknown parameter 12
Problem 2:
Once this is encountered, the will go into a hard-hang mode very soon.
Not sure what causes it?
[   76.538909] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   76.538961] cfg80211: Calling CRDA for country: DE
[   76.541721] cfg80211: Regulatory domain changed to country: DE
[   76.541724] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   76.541727] cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz),
(N/A, 2000 mBm)
[   76.541729] cfg80211:     (5150000 KHz - 5255000 KHz @ 40000 KHz),
(N/A, 2301 mBm)
[   76.541732] cfg80211:     (5470000 KHz - 5650000 KHz @ 40000 KHz),
(N/A, 3000 mBm)
[   77.604567] padlock_aes: VIA PadLock not detected.
[   87.168053] wlan0: no IPv6 routers present
[  170.604218] BUG: unable to handle kernel NULL pointer dereference at 0000000d
[  170.604225] IP: [<c0534ef4>] tcp_recvmsg+0x1c4/0xb70
[  170.604233] *pde = 00000000
[  170.604236] Oops: 0000 [#1] SMP
[  170.604239] last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill0/state
[  170.604243] Modules linked in: aes_i586 aes_generic binfmt_misc
ppdev usbhid i915 fbcon tileblit font bitblit softcursor
drm_kms_helper drm i2c_algo_bit bridge stp bnep kvm_intel kvm xfs lp
parport snd_hda_codec_conexant snd_hda_intel snd_hda_codec arc4
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi iwlagn snd_seq_midi_event psmouse snd_seq
thinkpad_acpi pcmcia iTCO_wdt mac80211 tpm_tis intel_agp intel_gtt
agpgart tpm serio_raw video snd_timer snd_seq_device
iTCO_vendor_support nvram tpm_bios snd yenta_socket pcmcia_rsrc
pcmcia_core soundcore pcspkr snd_page_alloc cfg80211 reiserfs e1000e
[  170.604290]
[  170.604293] Pid: 5137, comm: chrome Not tainted 2.6.39-rc4+ #2
LENOVO 7440A82/7440A82
[  170.604298] EIP: 0060:[<c0534ef4>] EFLAGS: 00210206 CPU: 0
[  170.604301] EIP is at tcp_recvmsg+0x1c4/0xb70
[  170.604303] EAX: 00000000 EBX: 49a6aab7 ECX: f19ec240 EDX: f1b14100
[  170.604306] ESI: 00000000 EDI: f3ee1900 EBP: f2b47e28 ESP: f2b47dac
[  170.604308]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  170.604311] Process chrome (pid: 5137, ti=f2b46000 task=f29df110
task.ti=f2b46000)
[  170.604313] Stack:
[  170.604314]  00000000 00000001 00000003 f5d06740 00000000 00000000
00000000 f29df3e8
[  170.604320]  f29df110 f2b47ea0 f1b14100 00000000 00005460 f1b14434
00000001 00000000
[  170.604326]  00000000 00000000 49a6aab7 f1b14144 f1b14450 f1b14154
f1b14524 f1b14194
[  170.604332] Call Trace:
[  170.604337]  [<c0554941>] inet_recvmsg+0x61/0xa0
[  170.604341]  [<c04ea33d>] sock_aio_read+0x16d/0x190
[  170.604346]  [<c020dd49>] do_sync_read+0xb9/0x100
[  170.604351]  [<c020dded>] ? rw_verify_area+0x5d/0x120
[  170.604355]  [<c020e55e>] vfs_read+0x15e/0x170
[  170.604358]  [<c020e642>] sys_read+0x42/0x70
[  170.604362]  [<c05fcb5c>] sysenter_do_call+0x12/0x28
[  170.604366]  [<c05f0000>] ? check_tsc_sync_source+0xc6/0x126
[  170.604368] Code: 09 0f 18 01 90 3b 7d d0 0f 84 e1 02 00 00 8b 55
b8 8b 77 2c 8b 1a 39 f3 0f 88 99 02 00 00 89 d8 29 f0 89 45 cc 8b 87
98 00 00 00 <0f> b6 50 0d 89 d0 83 e0 02 3c 01 83 55 cc ff 8b 47 50 39
45 cc
[  170.604401] EIP: [<c0534ef4>] tcp_recvmsg+0x1c4/0xb70 SS:ESP 0068:f2b47dac
[  170.604406] CR2: 000000000000000d
[  170.604410] ---[ end trace c802808c243f63bb ]---

to trigger the 2nd problem:

a.   Now my kernel is sync against the latest linus git tree (today):

git describe
v2.6.39-rc4-245-g4175242

b.   open up several tabs in the Chrome browser - problem will not
come if tab are open successively over time.   but problem comes very
likely when many tabs are open at the save time....(eg, like the
"restore" mode in Chrome).

--
Regards,
Peter Teoh
