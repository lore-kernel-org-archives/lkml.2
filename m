Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0ELNpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:45:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33139 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0ELNpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZTGF9WKfoGptyF4kMjdSPW+XAzqLzlw1LExBPXBAJ4SAaF39ViuxH5QknPuw59TY74
         7DIzaB8kaV8DJv1oEs99utTyixMRMbWm628SXlupX4Pvl/L5AFlNAtjt5fQlBX3KDGw8
         Lww/b4UiN+dig8OPodo0ymFISaabVtR3oO7s8=
Date: Wed, 12 May 2010 16:47:04 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
Message-ID: <20100512134704.GG3302@swordfish>
References: <10aqDnTJcLO.A.mLE.48y5LB@chimera>
 <HqroMXsT-CJ.A.D0F.m-y5LB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bFsKbPszpzYNtEU6"
Content-Disposition: inline
In-Reply-To: <HqroMXsT-CJ.A.D0F.m-y5LB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bFsKbPszpzYNtEU6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (05/09/10 23:17), Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D15704
> Subject		: [r8169] WARNING: at net/sched/sch_generic.c
> Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date		: 2010-03-31 10:21 (40 days old)
> Message-ID	: <<<20100331102142.GA3294@swordfish.minsk.epam.com>>>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D127003090406108&w=3D2
>=20
>=20

 kernel: [13898.863507] pktgen 2.72: Packet Generator for packet performanc=
e testing.
 kernel: [13928.998629] ------------[ cut here ]------------
 kernel: [13928.998641] WARNING: at net/sched/sch_generic.c:256 dev_watchdo=
g+0xc1/0x129()
 kernel: [13928.998645] Hardware name: F3JC               =20
 kernel: [13928.998648] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 tim=
ed out
 kernel: [13928.998651] Modules linked in: pktgen ppp_async crc_ccitt ipv6 =
ppp_generic slhc snd_hda_codec_si3054 snd_hda_codec_realtek snd_hwdep snd_h=
da_intel asus_laptop sparse_keymap snd_hda_codec sdhci_pci sdhci snd_pcm sn=
d_timer
 mmc_core led_class snd_page_alloc psmouse i2c_i801 snd soundcore sg rng_co=
re r8169 evdev serio_raw mii usbhid hid uhci_hcd ehci_hcd sr_mod cdrom usbc=
ore sd_mod ata_piix
 kernel: [13928.998709] Pid: 6159, comm: kpktgend_0 Not tainted 2.6.34-rc7-=
dbg-git2 #116
 kernel: [13928.998712] Call Trace:
 kernel: [13928.998720]  [<c102dd26>] warn_slowpath_common+0x65/0x7c
 kernel: [13928.998726]  [<c12612bd>] ? dev_watchdog+0xc1/0x129
 kernel: [13928.998731]  [<c102dd71>] warn_slowpath_fmt+0x24/0x27
 kernel: [13928.998736]  [<c12612bd>] dev_watchdog+0xc1/0x129
 kernel: [13928.998743]  [<c1040039>] ? cleanup_timers+0x31/0xcd
 kernel: [13928.998749]  [<c1036657>] ? run_timer_softirq+0x136/0x203
 kernel: [13928.998754]  [<c10366b0>] run_timer_softirq+0x18f/0x203
 kernel: [13928.998759]  [<c1036657>] ? run_timer_softirq+0x136/0x203
 kernel: [13928.998765]  [<c12611fc>] ? dev_watchdog+0x0/0x129
 kernel: [13928.998771]  [<c10325e6>] __do_softirq+0x88/0x10c
 kernel: [13928.998778]  [<f80a3793>] ? pktgen_thread_worker+0xd9/0x5e8 [pk=
tgen]
 kernel: [13928.998784]  [<c1032699>] do_softirq+0x2f/0x47
 kernel: [13928.998789]  [<c1032956>] irq_exit+0x38/0x75
 kernel: [13928.998795]  [<c1014691>] smp_apic_timer_interrupt+0x5f/0x6d
 kernel: [13928.998801]  [<c12bd52a>] apic_timer_interrupt+0x36/0x3c
 kernel: [13928.998807]  [<f80a3793>] ? pktgen_thread_worker+0xd9/0x5e8 [pk=
tgen]
 kernel: [13928.998813]  [<c104007b>] ? cleanup_timers+0x73/0xcd
 kernel: [13928.998818]  [<c10400d8>] ? process_cpu_nsleep_restart+0x3/0xa
 kernel: [13928.998825]  [<c10504f2>] ? lock_release+0x19d/0x1a4
 kernel: [13928.998832]  [<c12bcaa1>] _raw_spin_unlock+0x16/0x3f
 kernel: [13928.998838]  [<f80a3793>] pktgen_thread_worker+0xd9/0x5e8 [pktg=
en]
 kernel: [13928.998844]  [<c103f5be>] ? autoremove_wake_function+0x0/0x2f
 kernel: [13928.998849]  [<c103f5be>] ? autoremove_wake_function+0x0/0x2f
 kernel: [13928.998855]  [<f80a36ba>] ? pktgen_thread_worker+0x0/0x5e8 [pkt=
gen]
 kernel: [13928.998860]  [<c103f2e2>] kthread+0x6a/0x6f
 kernel: [13928.998866]  [<c103f278>] ? kthread+0x0/0x6f
 kernel: [13928.998872]  [<c1002dc2>] kernel_thread_helper+0x6/0x10
 kernel: [13928.998876] ---[ end trace 7e230fb0e7444e5e ]---
 kernel: [13929.012534] r8169 0000:02:00.0: eth0: link up


	Sergey
--bFsKbPszpzYNtEU6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvqsVgACgkQfKHnntdSXjSm9AQAn2ILro7f0KVVOkUeNtwvwDXD
pW+gnioJrMahsC1/c1ZtqFrKf1E76mgPIMIm99Auz+lL9DWUF2U/+s7dPK23ektM
MBcKXUpJVcBbGDZDR96Nk0pfQoUg4wmalkcp69tS977wzBg7wv+VnLzlPtZEisRL
H7uEzVzdaIcTsSS5DLY=
=/Jyn
-----END PGP SIGNATURE-----

--bFsKbPszpzYNtEU6--
