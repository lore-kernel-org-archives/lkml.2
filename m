Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0IYUhu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 16:37:50 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47279 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0IYUht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 16:37:49 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-pm@lists.linux-foundation.org
Subject: with init=/bin/systemd USB/eSATA external mass storage no longer works (was: Re: [linux-pm] [PATCH] Hibernate: Implement readahead when resuming)
Date: Sat, 25 Sep 2010 22:37:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35.5-tp42-vmembase-0-pm-avoid-oom-dirty; KDE/4.5.1; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>,
        Lennart Poettering <mzjro@0pointer.net>
References: <1285416056-9735-1-git-send-email-nigel@tuxonice.net> <201009252102.52401.Martin@lichtvoll.de> <201009252158.28439.Martin@lichtvoll.de> (sfid-20100925_222247_951327_A61C93D7)
In-Reply-To: <201009252158.28439.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6733798.yafZvACNvg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009252237.46391.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6733798.yafZvACNvg
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Cc'd Lennart regarding my finding that with init=3D/bin/systemd USB and eSA=
TA=20
mass storage does no longer work.

Am Samstag 25 September 2010 schrieb Martin Steigerwald:
> I will test 2.6.35.5 for a bit longer to make sure that there is no
> hang  on resume prior to loading. I need to reboot this one now too,
> cause after one of the resume attempts USB stopped working with:
>=20
> Sep 25 21:36:47 shambhala kernel: usb 1-3: New USB device found,=20
> idVendor=3D1307, idProduct=3D0330
> Sep 25 21:36:47 shambhala kernel: usb 1-3: New USB device strings:
> Mfr=3D1,  Product=3D2, SerialNumber=3D3
> Sep 25 21:36:47 shambhala kernel: usb 1-3: Product: Mass Storage Device
> Sep 25 21:36:47 shambhala kernel: usb 1-3: Manufacturer: Generic
> Sep 25 21:36:47 shambhala kernel: usb 1-3: SerialNumber: 00000000000006
> Sep 25 21:36:47 shambhala kernel: scsi3 : usb-storage 1-3:1.0
> Sep 25 21:36:48 shambhala kernel: BUG: unable to handle kernel NULL=20
> pointer dereference at 0000002c
> Sep 25 21:36:48 shambhala kernel: IP: [<c125b5de>]=20
> cfq_get_queue+0x33e/0x550
> Sep 25 21:36:48 shambhala kernel: *pde =3D 00000000=20
> Sep 25 21:36:48 shambhala kernel: Oops: 0000 [#1] PREEMPT=20
> Sep 25 21:36:48 shambhala kernel: last sysfs file:=20
> /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-3/usb_device/usbdev1
> .4/uevent
> Sep 25 21:36:48 shambhala kernel: Modules linked in: microcode cn=20
> acpi_cpufreq mperf ppdev lp vboxnetadp cpufreq_us
> erspace cpufreq_stats cpufreq_conservative cpufreq_powersave
> vboxnetflt  vboxdrv fuse tun usblp ohci_hcd usb_storage
>  usb_libusual nls_iso8859_15 nls_iso8859_1 nls_cp850 ntfs vfat msdos
> fat  reiserfs isofs udf crc_itu_t smbfs pktcdvd
>  uinput radeon ttm drm_kms_helper drm i2c_algo_bit hdaps tp_smapi=20
> thinkpad_ec binfmt_misc dm_crypt snd_intel8x0m sn
> d_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm=20
> ipw2200 snd_seq_dummy snd_seq_oss thinkpad_acp
> i hwmon snd_seq_midi libipw led_class snd_rawmidi rtc_cmos pcmcia=20
> intel_agp snd_seq_midi_event rtc_core nvram video
>  processor i2c_i801 parport_pc rtc_lib parport ac snd_seq battery
> button  yenta_socket pcmcia_rsrc pcmcia_core joyde
> v output evdev agpgart snd_timer snd_seq_device snd snd_page_alloc=20
> cfg80211 rfkill lib80211 ipv6 autofs4 dm_mod rai
> d10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov
> raid6_pq  async_tx raid1 raid0 linear md_mod
> Sep 25 21:36:48 shambhala kernel: btrfs zlib_deflate crc32c libcrc32c=20
> usbhid uhci_hcd ehci_hcd sg usbcore sr_mod th
> ermal cdrom [last unloaded: scsi_wait_scan]
> Sep 25 21:36:48 shambhala kernel:
> Sep 25 21:36:48 shambhala kernel: Pid: 10474, comm: scsi_scan_3 Not=20
> tainted 2.6.35.5-tp42-vmembase-0-pm-avoid-oom-d
> irty #4 2373CXG/2373CXG
> Sep 25 21:36:48 shambhala kernel: EIP: 0060:[<c125b5de>] EFLAGS:
> 00010086  CPU: 0
> Sep 25 21:36:48 shambhala kernel: EIP is at cfq_get_queue+0x33e/0x550
> Sep 25 21:36:48 shambhala kernel: EAX: f4d18a80 EBX: f5c9e000 ECX:=20
> 00000001 EDX: 00000000
> Sep 25 21:36:48 shambhala kernel: ESI: f5c9e108 EDI: f4976000 EBP:=20
> dc889cdc ESP: dc889c64
> Sep 25 21:36:48 shambhala kernel: DS: 007b ES: 007b FS: 0000 GS: 00e0
> SS:  0068
> Sep 25 21:36:48 shambhala kernel: Process scsi_scan_3 (pid: 10474,=20
> ti=3Ddc888000 task=3Ded8c8000 task.ti=3Ddc888000)
> Sep 25 21:36:48 shambhala kernel: Stack:
> Sep 25 21:36:48 shambhala kernel: 00000000 dc889c7c c102a154 c1a4bfa0=20
> 00008010 00000010 ed8c8000 f5c9e044
> Sep 25 21:36:48 shambhala kernel: <0> 00000001 f4976020 f5c9e028
> f5c9e0d0  f4976444 01cea7c8 f4d18a80 00000030
> Sep 25 21:36:48 shambhala kernel: <0> f49763ac f4759600 f41fbcc0
> 01000202  000000fc 00000000 00000000 00000003
> Sep 25 21:36:48 shambhala kernel: Call Trace:
> Sep 25 21:36:48 shambhala kernel: [<c102a154>] ?
> cpuacct_charge+0x44/0x50 Sep 25 21:36:48 shambhala kernel:
> [<c125b993>] ?
> cfq_set_request+0x1a3/0x410
> Sep 25 21:36:48 shambhala kernel: [<c10a9c43>] ?=20
> mempool_alloc_slab+0x13/0x20
> Sep 25 21:36:48 shambhala kernel: [<c125b7f0>] ?
> cfq_set_request+0x0/0x410 Sep 25 21:36:48 shambhala kernel:
> [<c12463f7>] ? elv_set_request+0x17/0x30 Sep 25 21:36:48 shambhala
> kernel: [<c124c95c>] ? get_request+0x31c/0x340 Sep 25 21:36:48
> shambhala kernel: [<c124c9a2>] ?
> get_request_wait+0x22/0x1a0
> Sep 25 21:36:48 shambhala kernel: [<c12f110a>] ?=20
> attribute_container_add_device+0x11a/0x1e0
> Sep 25 21:36:48 shambhala kernel: [<c1268d81>] ? kvasprintf+0x41/0x50
> Sep 25 21:36:48 shambhala kernel: [<c124cfbb>] ?
> blk_get_request+0x5b/0x90 Sep 25 21:36:48 shambhala kernel:
> [<c1308998>] ? scsi_execute+0x28/0x240 Sep 25 21:36:48 shambhala
> kernel: [<c130a627>] ?
> scsi_execute_req+0x87/0x160
> Sep 25 21:36:48 shambhala kernel: [<c130bb6c>] ?=20
> scsi_probe_and_add_lun+0x1ec/0x9f0
> Sep 25 21:36:48 shambhala kernel: [<c1268d81>] ? kvasprintf+0x41/0x50
> Sep 25 21:36:48 shambhala kernel: [<c12e9b24>] ?
> trace_kmalloc+0x54/0x90 Sep 25 21:36:48 shambhala kernel: [<c130c7e0>]
> ?
> __scsi_scan_target+0xe0/0x580
> Sep 25 21:36:48 shambhala kernel: [<c102a154>] ?
> cpuacct_charge+0x44/0x50 Sep 25 21:36:48 shambhala kernel:
> [<c102a154>] ? cpuacct_charge+0x44/0x50 Sep 25 21:36:48 shambhala
> kernel: [<c102e2f5>] ? update_curr+0x1b5/0x290 Sep 25 21:36:48
> shambhala kernel: [<c130cd06>] ?
> scsi_scan_channel+0x86/0xa0
> Sep 25 21:36:48 shambhala kernel: [<c130cde9>] ?=20
> scsi_scan_host_selected+0xc9/0x120
> Sep 25 21:36:48 shambhala kernel: [<c130cec0>] ?
> do_scan_async+0x0/0x180 Sep 25 21:36:48 shambhala kernel: [<c130cebd>]
> ?
> do_scsi_scan_host+0x7d/0x80
> Sep 25 21:36:48 shambhala kernel: [<c130ced8>] ?
> do_scan_async+0x18/0x180 Sep 25 21:36:48 shambhala kernel:
> [<c13fa837>] ?
> preempt_schedule+0x37/0x50
> Sep 25 21:36:48 shambhala kernel: [<c130cec0>] ?
> do_scan_async+0x0/0x180 Sep 25 21:36:48 shambhala kernel: [<c10531f4>]
> ? kthread+0x74/0x80 Sep 25 21:36:48 shambhala kernel: [<c1053180>] ?
> kthread+0x0/0x80 Sep 25 21:36:48 shambhala kernel: [<c100347e>] ?
> kernel_thread_helper+0x6/0x10
> Sep 25 21:36:48 shambhala kernel: Code: e4 83 45 d8 54 83 7d e4 03 0f
> 85  ee fe ff ff 8b 03 c7 83 64 02 00 00 01 00 00 00 83 e0 03 09 d8 89
> 03 8b 45 c0 8b 90 58 01 00 00 <8b> 42 2c 85 c0 74 78 8d 55 ec 89 54 24
> 0c 8d 55 f0 89 54 24 08
> Sep 25 21:36:48 shambhala kernel: EIP: [<c125b5de>]=20
> cfq_get_queue+0x33e/0x550 SS:ESP 0068:dc889c64
> Sep 25 21:36:48 shambhala kernel: CR2: 000000000000002c
> Sep 25 21:36:48 shambhala kernel: ---[ end trace eecaeed94ae31965 ]---
> Sep 25 21:36:48 shambhala kernel: note: scsi_scan_3[10474] exited with=20
> preempt_count 1

This one and another one with my Silicon Image based Delock PCMCIA eSATA=20
card are systemd related.

It is completely beyond me how a userspace tool could trigger these kind=20
of kernel problems, but they go away when I remove init=3D/bin/systemd from=
=20
kernel command line. Possibly udev initialization happens differently or=20
systemd parallizes something to much.

Using

martin@shambhala:~> apt-show-versions | grep systemd
libpam-systemd/experimental uptodate 8-2
systemd/experimental uptodate 8-2
systemd-gui/experimental uptodate 8-2

I keep it at sysvinit for now, to just test one thing at a time. I will go=
=20
on testing mainline in kernel suspend for a while, before testing Nigel's=20
(possibly in the mean time updated) patches again.

I don't think the reported hang after resume before switching to Radeon=20
KMS framebuffer is related, but after this one never seems to know. I might=
=20
test this again as well.

Anyway, enough testing for now,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart6733798.yafZvACNvg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyeXY4ACgkQmRvqrKWZhMdTcQCgoiJ2nRdf6kZs+GJcpG1w1quT
MckAnA7TXGS8ltzALgLx/e82dKqh/zJ1
=lBj6
-----END PGP SIGNATURE-----

--nextPart6733798.yafZvACNvg--
