Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab0HDLg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:36:28 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:54965 "EHLO
	archlinux.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757716Ab0HDLg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:36:26 -0400
Message-ID: <4C5950B7.4000802@archlinux.org>
Date: Wed, 04 Aug 2010 13:36:23 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.7) Gecko/20100720 Lanikai/3.1.1
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: WARNING at net/wireless/reg.c when wireless network is disconnected
X-Enigmail-Version: 1.1
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enigAA8E523DD3BE04A4F9B450F6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAA8E523DD3BE04A4F9B450F6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hello,

this warning has been around ever since I switched to 2.6.34, has
accompanied me through the 2.6.35-rc* phase and is still there with
2.6.35. I didn't bother to report it so far, as there seems to be no harm=
=2E

Whenever I disconnect/get disconnected from the wireless, I receive the
below warning:

------------[ cut here ]------------
WARNING: at net/wireless/reg.c:272
regulatory_hint_disconnect+0x1b3/0x230 [cfg80211]()
Hardware name: TECRA A11
Unexpected user alpha2: de
Modules linked in: hidp rfcomm sco bnep l2cap bridge stp llc microcode
cpufreq_ondemand tun btusb bluetooth uvcvideo videodev tpm_infineon
v4l2_compat_ioctl32 arc4 snd_seq_dummy snd_seq_oss ecb
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
snd_hda_codec_intelhdmi snd_mixer_oss snd_hda_codec_realtek
snd_hda_intel snd_hda_codec ath9k snd_hwdep kvm_intel ath9k_common kvm
snd_pcm ath9k_hw snd_timer snd tpm_tis ehci_hcd ath sdhci_pci
acpi_cpufreq sdhci soundcore mac80211 freq_table mmc_core tpm cfg80211
usbcore snd_page_alloc tpm_bios e1000e mperf led_class psmouse sr_mod
iTCO_wdt sg evdev toshiba_acpi toshiba_bluetooth cdrom battery ac
thermal processor rfkill nls_base rtc_cmos rtc_core rtc_lib fpu
aesni_intel cryptd aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod
sd_mod ahci libahci libata scsi_mod ext4 mbcache jbd2 crc16 i915
drm_kms_helper drm i2c_algo_bit cfbcopyarea video backlight output
cfbimgblt cfbfillrect intel_agp agpgart
Pid: 15, comm: events/0 Not tainted 2.6.35 #28
Call Trace:
 [<ffffffff8103e98b>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffffa0337760>] ? disconnect_work+0x0/0x30 [cfg80211]
 [<ffffffff8103ea85>] ? warn_slowpath_fmt+0x45/0x50
 [<ffffffffa0337760>] ? disconnect_work+0x0/0x30 [cfg80211]
 [<ffffffffa0325163>] ? regulatory_hint_disconnect+0x1b3/0x230 [cfg80211]=

 [<ffffffffa0337760>] ? disconnect_work+0x0/0x30 [cfg80211]
 [<ffffffff81052df8>] ? worker_thread+0x158/0x230
 [<ffffffff810574d0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff81052ca0>] ? worker_thread+0x0/0x230
 [<ffffffff8105703e>] ? kthread+0x8e/0xa0
 [<ffffffff810032d4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81056fb0>] ? kthread+0x0/0xa0
 [<ffffffff810032d0>] ? kernel_thread_helper+0x0/0x10
---[ end trace cbb09501d5faaa20 ]---


--------------enigAA8E523DD3BE04A4F9B450F6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEAREIAAYFAkxZULcACgkQEda5KzHP/VCy3gCcDVXQvZLrnOPkD29ZDKtf7zbK
OUQAoISV+5QMZoly9MmaXR7HvqHqR4vQ
=78nf
-----END PGP SIGNATURE-----

--------------enigAA8E523DD3BE04A4F9B450F6--
