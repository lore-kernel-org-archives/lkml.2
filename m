Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0GZNLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 09:11:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57280 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab0GZNLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 09:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XolJbLskACSQVPFAXR1cnVu8iwYMDLydk4+qdP4ah7+ZNKisXo2wg9G5penMXrhWTn
         Xo1TkwJMo3QUV32z8Si7GmNGijbyVWm8mT4eGZu37SF70HXItDEIr0jVpWI2PTYqhE15
         cMdSPtc31A5MUY9sUmrIUreiSHRUIQZPEr8nE=
Date: Mon, 26 Jul 2010 16:16:29 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
Message-ID: <20100726131629.GA4398@swordfish.minsk.epam.com>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
 <PRbv8sgxY6G.A.UEH.mYYSMB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <PRbv8sgxY6G.A.UEH.mYYSMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/23/10 14:15), Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D15704
> Subject		: [r8169] WARNING: at net/sched/sch_generic.c
> Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date		: 2010-03-31 10:21 (115 days old)
> Message-ID	: <20100331102142.GA3294@swordfish.minsk.epam.com>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D127003090406108&w=3D2
>=20
>=20

Hello,
Sorry for the dealy - I've been away.
So, the bad news are that this is probably the last time I can test this bu=
g. This laptop will
no longer be available. Sorry.


[ 2599.495508] pktgen 2.73: Packet Generator for packet performance testing.
[ 2630.016019] ------------[ cut here ]------------
[ 2630.016031] WARNING: at net/sched/sch_generic.c:258 dev_watchdog+0xc1/0x=
129()
[ 2630.016035] Hardware name: F3JC               =20
[ 2630.016038] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
[ 2630.016041] Modules linked in: pktgen ipv6 arc4 ecb iwl3945 snd_hwdep iw=
lcore snd_seq_dummy snd_hda_codec_si3054 snd_hda_codec_realtek snd_seq_oss =
snd_seq_midi_event snd_seq snd_seq_device mac80211 snd_pcm_oss snd_mixer_os=
s asus_laptop
snd_hda_intel sparse_keymap sdhci_pci sdhci mmc_core led_class cfg80211 snd=
_hda_codec snd_pcm snd_timer snd_page_alloc snd rng_core soundcore usb_stor=
age sg psmouse evdev i2c_i801 serio_raw r8169 mii uhci_hcd ehci_hcd sd_mod =
sr_mod usbcore
cdrom ata_piix
[ 2630.016114] Pid: 4282, comm: kpktgend_0 Not tainted 2.6.35-rc6-dbg-git1-=
00136-g459ab2a-dirty #75
[ 2630.016118] Call Trace:
[ 2630.016125]  [<c102e3ae>] warn_slowpath_common+0x65/0x7a
[ 2630.016131]  [<c12695f3>] ? dev_watchdog+0xc1/0x129
[ 2630.016136]  [<c102e427>] warn_slowpath_fmt+0x26/0x2a
[ 2630.016142]  [<c12695f3>] dev_watchdog+0xc1/0x129
[ 2630.016149]  [<c10370b3>] ? run_timer_softirq+0x136/0x22b
[ 2630.016154]  [<c103710c>] run_timer_softirq+0x18f/0x22b
[ 2630.016160]  [<c10370b3>] ? run_timer_softirq+0x136/0x22b
[ 2630.016165]  [<c1269532>] ? dev_watchdog+0x0/0x129
[ 2630.016171]  [<c1032c35>] __do_softirq+0x88/0x10c
[ 2630.016177]  [<c1032ce8>] do_softirq+0x2f/0x47
[ 2630.016182]  [<c1032fa5>] irq_exit+0x38/0x75
[ 2630.016187]  [<c10159b8>] smp_apic_timer_interrupt+0x5f/0x6d
[ 2630.016195]  [<f80555e4>] ? pktgen_xmit+0xda2/0xe6f [pktgen]
[ 2630.016202]  [<c12c75a2>] apic_timer_interrupt+0x36/0x3c
[ 2630.016208]  [<f80555e4>] ? pktgen_xmit+0xda2/0xe6f [pktgen]
[ 2630.016214]  [<f80555e4>] ? pktgen_xmit+0xda2/0xe6f [pktgen]
[ 2630.016220]  [<c104007b>] ? __kfifo_peek_n+0x13/0x2b
[ 2630.016226]  [<c1032edd>] ? _local_bh_enable_ip+0x9d/0xb3
[ 2630.016231]  [<c1032efb>] local_bh_enable_ip+0x8/0xa
[ 2630.016236]  [<c12c6aaa>] _raw_spin_unlock_bh+0x2f/0x32
[ 2630.016242]  [<f80555e4>] pktgen_xmit+0xda2/0xe6f [pktgen]
[ 2630.016253]  [<f91707b8>] ? rtl8169_start_xmit+0x0/0x307 [r8169]
[ 2630.016261]  [<c11800d8>] ? plist_add+0x85/0x87
[ 2630.016267]  [<f80558ac>] ? pktgen_thread_worker+0x96/0x5c3 [pktgen]
[ 2630.016273]  [<c1029096>] ? get_parent_ip+0xb/0x31
[ 2630.016279]  [<c1029138>] ? sub_preempt_count+0x7c/0x89
[ 2630.016285]  [<f8055986>] pktgen_thread_worker+0x170/0x5c3 [pktgen]
[ 2630.016290]  [<c12c52bb>] ? schedule+0x535/0x545
[ 2630.016296]  [<c103fd96>] ? autoremove_wake_function+0x0/0x2f
[ 2630.016301]  [<c103fd96>] ? autoremove_wake_function+0x0/0x2f
[ 2630.016307]  [<f8055816>] ? pktgen_thread_worker+0x0/0x5c3 [pktgen]
[ 2630.016313]  [<c103faa6>] kthread+0x6a/0x6f
[ 2630.016318]  [<c103fa3c>] ? kthread+0x0/0x6f
[ 2630.016324]  [<c1002d82>] kernel_thread_helper+0x6/0x10
[ 2630.016328] ---[ end trace 0bdadff7f249bd0d ]---
[ 2630.032549] r8169 0000:02:00.0: eth0: link up


	Sergey
--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkxNiq0ACgkQfKHnntdSXjTFEQP/RA7k1E0vVfOmkm+srKB1NldB
m/GZaybTZI+hwBS8HyP/xXgwKfFDGAvWBC9b/wAp4yxY6f2H0jHpuHEJeS2e4q0T
A/BhS/jl43yhBD9zP1bX9G9qrBhf8EBnEEQROgmQGVZ8nVblMjHj4tQRC15YZQHL
LXweu/oYfzK7YXAHxIM=
=LeAb
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
