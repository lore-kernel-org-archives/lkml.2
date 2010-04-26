Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab0DZMuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 08:50:05 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:55411 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab0DZMuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 08:50:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hln9BTEZedI+q4C3pKxh48KDNu9NLJlSMvNwjFC56XJo9A7mWxYkcvz0+iZlbLDGw8
         Jv2WQKGawKRlYFhqPEltBWVav3ewl77d5HrUv4mAqPCv+U5OfIj0k/5ctX+i6H1BjDXB
         DHrzuh90TWj1Npd9LmVTslJP5iRbKsrI5Vj/0=
Date: Mon, 26 Apr 2010 15:51:19 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
Message-ID: <20100426125119.GA3291@swordfish.minsk.epam.com>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
 <YeFfFNFyTSF.A.62H.yRSzLB@tosh>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <YeFfFNFyTSF.A.62H.yRSzLB@tosh>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On (04/20/10 05:19), Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary repo=
rt
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the trac=
king team
> know (either way).
>=20
>

=2E34-rc5-git7

kernel: [12887.906682] pktgen 2.72: Packet Generator for packet performance=
 testing.
kernel: [12938.998730] ------------[ cut here ]------------
kernel: [12938.998741] WARNING: at net/sched/sch_generic.c:256 dev_watchdog=
+0xc1/0x129()
kernel: [12938.998745] Hardware name: F3JC               =20
kernel: [12938.998748] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 time=
d out
kernel: [12938.998751] Modules linked in: pktgen usb_storage ipv6 snd_hwdep=
 snd_hda_codec_si3054 snd_hda_codec_realtek asus_laptop sparse_keymap sdhci=
_pci sdhci snd_hda_intel mmc_core led_class psmouse snd_hda_codec snd_pcm s=
nd_timer snd
soundcore snd_page_alloc serio_raw rng_core sg i2c_i801 evdev r8169 mii usb=
hid hid uhci_hcd ehci_hcd sr_mod cdrom sd_mod usbcore ata_piix
kernel: [12938.998808] Pid: 4617, comm: kpktgend_0 Not tainted 2.6.34-rc5-d=
bg-r8169-git7 #97
kernel: [12938.998811] Call Trace:
kernel: [12938.998819]  [<c102e1b2>] warn_slowpath_common+0x65/0x7c
kernel: [12938.998824]  [<c1268085>] ? dev_watchdog+0xc1/0x129
kernel: [12938.998829]  [<c102e1fd>] warn_slowpath_fmt+0x24/0x27
kernel: [12938.998834]  [<c1268085>] dev_watchdog+0xc1/0x129
kernel: [12938.998841]  [<c1040039>] ? __kfifo_from_user_generic+0x30/0x5c
kernel: [12938.998848]  [<c1036ae3>] ? run_timer_softirq+0x136/0x203
kernel: [12938.998853]  [<c1036b3c>] run_timer_softirq+0x18f/0x203
kernel: [12938.998858]  [<c1036ae3>] ? run_timer_softirq+0x136/0x203
kernel: [12938.998864]  [<c1267fc4>] ? dev_watchdog+0x0/0x129
kernel: [12938.998870]  [<c1032a72>] __do_softirq+0x88/0x10c
kernel: [12938.998875]  [<c1032b25>] do_softirq+0x2f/0x47
kernel: [12938.998883]  [<f8095488>] ? pktgen_xmit+0xd3e/0xe0b [pktgen]
kernel: [12938.998888]  [<c1032d08>] _local_bh_enable_ip+0x8b/0xb3
kernel: [12938.998894]  [<c1032d38>] local_bh_enable_ip+0x8/0xa
kernel: [12938.998900]  [<c12c3818>] _raw_spin_unlock_bh+0x2f/0x32
kernel: [12938.998906]  [<f8095488>] pktgen_xmit+0xd3e/0xe0b [pktgen]
kernel: [12938.998913]  [<c104463c>] ? sched_clock_cpu+0x121/0x131
kernel: [12938.998922]  [<fd1cf5e4>] ? rtl8169_start_xmit+0x0/0x2f9 [r8169]
kernel: [12938.998928]  [<f8095793>] ? pktgen_thread_worker+0xd9/0x5e8 [pkt=
gen]
kernel: [12938.998934]  [<c1044679>] ? cpu_clock+0x2d/0x4e
kernel: [12938.998941]  [<c104d1f7>] ? put_lock_stats+0xd/0x21
kernel: [12938.998946]  [<c104d2c0>] ? lock_release_holdtime+0xb5/0xba
kernel: [12938.998952]  [<f8095793>] ? pktgen_thread_worker+0xd9/0x5e8 [pkt=
gen]
kernel: [12938.998959]  [<f809582a>] pktgen_thread_worker+0x170/0x5e8 [pktg=
en]
kernel: [12938.998965]  [<c103fa46>] ? autoremove_wake_function+0x0/0x2f
kernel: [12938.998971]  [<c103fa46>] ? autoremove_wake_function+0x0/0x2f
kernel: [12938.998977]  [<f80956ba>] ? pktgen_thread_worker+0x0/0x5e8 [pktg=
en]
kernel: [12938.998982]  [<c103f76a>] kthread+0x6a/0x6f
kernel: [12938.998988]  [<c103f700>] ? kthread+0x0/0x6f
kernel: [12938.998994]  [<c1002dc2>] kernel_thread_helper+0x6/0x10
kernel: [12938.998998] ---[ end trace 030ae30a64f8cf05 ]---
kernel: [12939.012657] r8169 0000:02:00.0: eth0: link up
kernel: [12951.012273] r8169 0000:02:00.0: eth0: link up
kernel: [12951.475547] pktgen: interface: eth0 is already stopped



=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D15704
> Subject		: [r8169] WARNING: at net/sched/sch_generic.c
> Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date		: 2010-03-31 10:21 (20 days old)
> Message-ID	: <<20100331102142.GA3294@swordfish.minsk.epam.com>>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D127003090406108&w=3D2
>=20
>=20


	Sergey
--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvVjEcACgkQfKHnntdSXjQBhAQApWJ03Cz6vNdiLXnfn2bVi2pU
Kw5CEDyErs50iaryd4pVbnR3ULd06h/kpSNck2Aa0rnYe+iKo4rpSes6UIEGVXph
K9WrjRKomxlvCT/FeonEz7yqNk2WMByTXuf51WGFjsEyjx/rcyW6Q2tr5vN+HeyT
+HqHjTe0BwlC7fjyMV4=
=OlQI
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
