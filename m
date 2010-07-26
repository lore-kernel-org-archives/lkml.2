Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0GZPpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 11:45:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36406 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0GZPpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 11:45:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NS4s8b8Py5miPn0PpgG0HPn5jsqJfdmRoyhj9+/ZE9gi0BKcjfGKFjuTp1HCFVdABj
         LmrOY0IvliiQvDC5Ue7mH/4rUsZpypjTwHcA8mW+prtpkKb5dpslSE2BfCEzvJpinRIC
         jCvFfBqVTqxwSqXdl2nzTHkKZbd9SGbw2an50=
Date: Mon, 26 Jul 2010 18:50:31 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
Message-ID: <20100726155031.GB3997@swordfish.minsk.epam.com>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
 <PRbv8sgxY6G.A.UEH.mYYSMB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <PRbv8sgxY6G.A.UEH.mYYSMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



DELAY 3000

[  302.735684] pktgen 2.73: Packet Generator for packet performance testing.
[  345.008016] ------------[ cut here ]------------                        =
=20
[  345.008028] WARNING: at net/sched/sch_generic.c:258
dev_watchdog+0xc1/0x129()
[  345.008032] Hardware name: F3JC               =20
[  345.008035] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
[  345.008038] Modules linked in: pktgen ipv6 arc4 ecb iwl3945 snd_seq_dummy
iwlcore mac80211 snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
sdhci_pci sdhci mmc_core asus_laptop sparse_keymap led_class cfg
snd_mixer_oss snd_hda_codec_si3054 snd_hda_codec_realtek sg rng_core psmouse
snd_hda_intel evdev snd_hda_codec snd_pcm snd_timer i2c_i801 snd_page_alloc
serio_raw snd soundcore r8169 mii uhci_hcd ehci_hcd sr_mod
ata_piix
[  345.008109] Pid: 4013, comm: kpktgend_0 Not tainted
2.6.35-rc6-dbg-git1-00136-g459ab2a-dirty #75
[  345.008113] Call Trace:
[  345.008121]  [<c102e3ae>] warn_slowpath_common+0x65/0x7a
[  345.008127]  [<c12695f3>] ? dev_watchdog+0xc1/0x129    =20
[  345.008132]  [<c102e427>] warn_slowpath_fmt+0x26/0x2a
[  345.008137]  [<c12695f3>] dev_watchdog+0xc1/0x129
[  345.008145]  [<c10370b3>] ? run_timer_softirq+0x136/0x22b
[  345.008150]  [<c103710c>] run_timer_softirq+0x18f/0x22b =20
[  345.008155]  [<c10370b3>] ? run_timer_softirq+0x136/0x22b
[  345.008161]  [<c1269532>] ? dev_watchdog+0x0/0x129      =20
[  345.008167]  [<c1032c35>] __do_softirq+0x88/0x10c=20
[  345.008173]  [<c1032ce8>] do_softirq+0x2f/0x47   =20
[  345.008180]  [<f80555e4>] ? pktgen_xmit+0xda2/0xe6f [pktgen]
[  345.008185]  [<c1032ecb>] _local_bh_enable_ip+0x8b/0xb3    =20
[  345.008191]  [<c1032efb>] local_bh_enable_ip+0x8/0xa     =20
[  345.008197]  [<c12c6aaa>] _raw_spin_unlock_bh+0x2f/0x32  =20
[  345.008203]  [<f80555e4>] pktgen_xmit+0xda2/0xe6f [pktgen]
[  345.008213]  [<f91707b8>] ? rtl8169_start_xmit+0x0/0x307 [r8169]
[  345.008220]  [<c12c007b>] ? early_init_amd+0x49/0xad
[  345.008227]  [<f80558ac>] ? pktgen_thread_worker+0x96/0x5c3 [pktgen]
[  345.008233]  [<c1029096>] ? get_parent_ip+0xb/0x31
[  345.008239]  [<c1029138>] ? sub_preempt_count+0x7c/0x89
[  345.008245]  [<f8055986>] pktgen_thread_worker+0x170/0x5c3 [pktgen]
[  345.008250]  [<c12c52bb>] ? schedule+0x535/0x545
[  345.008256]  [<c103fd96>] ? autoremove_wake_function+0x0/0x2f
[  345.008262]  [<c103fd96>] ? autoremove_wake_function+0x0/0x2f
[  345.008268]  [<f8055816>] ? pktgen_thread_worker+0x0/0x5c3 [pktgen]
[  345.008273]  [<c103faa6>] kthread+0x6a/0x6f                       =20
[  345.008279]  [<c103fa3c>] ? kthread+0x0/0x6f
[  345.008284]  [<c1002d82>] kernel_thread_helper+0x6/0x10
[  345.008289] ---[ end trace 12f779451dc46abe ]---
[  345.024502] r8169 0000:02:00.0: eth0: link up




DELAY 5000

[   72.186395] pktgen 2.73: Packet Generator for packet performance testing.
[  102.817029] ------------[ cut here ]------------                        =
=20
[  102.817040] WARNING: at net/sched/sch_generic.c:258
dev_watchdog+0xc1/0x129()
[  102.817044] Hardware name: F3JC               =20
[  102.817047] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out  =
=20
[  102.817050] Modules linked in: pktgen ipv6 snd_seq_dummy snd_seq_oss   =
=20
snd_seq_midi_event snd_seq snd_seq_device arc4 ecb snd_hwdep iwl3945      =
=20
snd_hda_codec_si3054 snd_pcm_oss snd_mixer_oss iwlcore asus_laptop        =
=20
sparse_keymap sdhci_pci sdhci snd_hda_codec_realtek mac80211 mmc_core     =
=20
led_class cfg80211 snd_hda_intel psmouse snd_hda_codec rng_core i2c_i801  =
=20
snd_pcm snd_timer snd_page_alloc evdev sg serio_raw snd soundcore r8169 mii
uhci_hcd ehci_hcd sr_mod usbcore cdrom sd_mod ata_piix
[  102.817121] Pid: 0, comm: swapper Not tainted
2.6.35-rc6-dbg-git1-00136-g459ab2a-dirty #75
[  102.817125] Call Trace:
[  102.817133]  [<c102e3ae>] warn_slowpath_common+0x65/0x7a
[  102.817138]  [<c12695f3>] ? dev_watchdog+0xc1/0x129    =20
[  102.817144]  [<c102e427>] warn_slowpath_fmt+0x26/0x2a
[  102.817149]  [<c12695f3>] dev_watchdog+0xc1/0x129
[  102.817156]  [<c10370b3>] ? run_timer_softirq+0x136/0x22b
[  102.817162]  [<c103710c>] run_timer_softirq+0x18f/0x22b =20
[  102.817167]  [<c10370b3>] ? run_timer_softirq+0x136/0x22b
[  102.817173]  [<c1269532>] ? dev_watchdog+0x0/0x129      =20
[  102.817179]  [<c1032c35>] __do_softirq+0x88/0x10c=20
[  102.817185]  [<c1032ce8>] do_softirq+0x2f/0x47  =20
[  102.817190]  [<c1032fa5>] irq_exit+0x38/0x75
[  102.817195]  [<c10159b8>] smp_apic_timer_interrupt+0x5f/0x6d
[  102.817202]  [<c12c75a2>] apic_timer_interrupt+0x36/0x3c   =20
[  102.817209]  [<c104007b>] ? __kfifo_peek_n+0x13/0x2b
[  102.817215]  [<c11dd72e>] ? acpi_idle_enter_simple+0x117/0x14b
[  102.817222]  [<c1246a21>] cpuidle_idle_call+0x6a/0xa0        =20
[  102.817227]  [<c100170d>] cpu_idle+0x89/0xbe
[  102.817234]  [<c12c2085>] start_secondary+0x1f4/0x1fb
[  102.817239] ---[ end trace 6b1be7ded90fe937 ]---
[  102.833500] r8169 0000:02:00.0: eth0: link up


As for ethtool -a/-A, I have an "Cannot get device pause settings: Operatio=
n not supported" error.


	Sergey
--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxNrscACgkQfKHnntdSXjRbggQA2VVS0npoQIPWP2yb2bKfmgyP
hZjjbp6yz0O3+Zrr+pVuVyj0CKDFnaIvNGOTzn6VGMX9ejmzUM3NXqT3GYQ5J+mG
6FhbFEdkZ4QYmEmRKNBFKqG0hqDr3ebHqyw0CUJ9NVdA8rO7bts79ZLPgeuKww7K
GMlUeBwIc84q43rRJMs=
=OsJd
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
