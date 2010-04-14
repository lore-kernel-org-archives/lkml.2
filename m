Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab0DNKLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:11:40 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:32929 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab0DNKLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bMWbd9NDF6/4N01ftBTSD5m0QZ3Mv5YJ6YyjNcIr1EFaqipdsHdFrRW29Yc0oWkRrn
         TbK7SYraWGHPKtt2RqEHWIhjkWc16Ae6iGUon8zJldNjT2nvJrUKwjxdbb3jeYbqr9sj
         GnnnISKtoOva4ithwCmANcfd+bZ5QXYGPSD7M=
Date: Wed, 14 Apr 2010 13:12:20 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
Message-ID: <20100414101220.GA3681@swordfish.minsk.epam.com>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
 <JVS2s9dmTsP.A.YhG.FtPvLB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <JVS2s9dmTsP.A.YhG.FtPvLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
Sorry for the delay, I've been away.

On (04/07/10 23:13), Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary repo=
rt
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the trac=
king team
> know (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D15704
> Subject		: [r8169] WARNING: at net/sched/sch_generic.c
> Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date		: 2010-03-31 10:21 (8 days old)
> Message-ID	: <20100331102142.GA3294@swordfish.minsk.epam.com>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D127003090406108&w=3D2
>=20
>=20


Yes, bug is still here (though I'm not sure whether it's correct to test wi=
th frame size 2048).

Here it is:

kernel: [ 2292.172886] pktgen 2.72: Packet Generator for packet performance=
 testing.
kernel: [ 2339.999788] ------------[ cut here ]------------
kernel: [ 2339.999800] WARNING: at net/sched/sch_generic.c:256 dev_watchdog=
+0xc1/0x125()
kernel: [ 2339.999803] Hardware name: F3JC               =20
kernel: [ 2339.999806] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 time=
d out
kernel: [ 2339.999809] Modules linked in: pktgen ipv6 snd_hwdep snd_hda_cod=
ec_si3054 snd_hda_codec_realtek sdhci_pci sdhci asus_laptop sparse_keymap s=
nd_hda_intel mmc_core
led_class snd_hda_codec psmouse snd_pcm snd_timer snd soundcore snd_page_al=
loc i2c_i801 serio_raw sg evdev rng_core r8169 mii usbhid hid uhci_hcd ehci=
_hcd sr_mod cdrom sd_mod
usbcore ata_piix
kernel: [ 2339.999857] Pid: 3720, comm: kpktgend_0 Not tainted 2.6.34-rc3-d=
bg-r8169-git6 #81
kernel: [ 2339.999861] Call Trace:
kernel: [ 2339.999868]  [<c102e7f7>] warn_slowpath_common+0x65/0x7c
kernel: [ 2339.999874]  [<c126e4f8>] ? dev_watchdog+0xc1/0x125
kernel: [ 2339.999879]  [<c102e842>] warn_slowpath_fmt+0x24/0x27
kernel: [ 2339.999884]  [<c126e4f8>] dev_watchdog+0xc1/0x125
kernel: [ 2339.999891]  [<c1040039>] ? abort_exclusive_wait+0x26/0x63
kernel: [ 2339.999897]  [<c103712b>] ? run_timer_softirq+0x120/0x1eb
kernel: [ 2339.999902]  [<c1037181>] run_timer_softirq+0x176/0x1eb
kernel: [ 2339.999907]  [<c103712b>] ? run_timer_softirq+0x120/0x1eb
kernel: [ 2339.999913]  [<c126e437>] ? dev_watchdog+0x0/0x125
kernel: [ 2339.999919]  [<c10332a1>] __do_softirq+0x8d/0x117
kernel: [ 2339.999925]  [<c1033356>] do_softirq+0x2b/0x43
kernel: [ 2339.999929]  [<c103347b>] irq_exit+0x38/0x75
kernel: [ 2339.999936]  [<c1015200>] smp_apic_timer_interrupt+0x6d/0x7b
kernel: [ 2339.999943]  [<c12cbcda>] apic_timer_interrupt+0x36/0x3c
kernel: [ 2339.999948]  [<c104007b>] ? finish_wait+0x5/0x49
kernel: [ 2339.999953]  [<c10400d8>] ? prepare_to_wait_exclusive+0x19/0x5b
kernel: [ 2339.999959]  [<c105106d>] ? lock_release+0x19a/0x1a1
kernel: [ 2339.999965]  [<c12cb259>] _raw_spin_unlock+0x16/0x3f
kernel: [ 2339.999972]  [<f80ea460>] pktgen_thread_worker+0xe0/0x631 [pktge=
n]
kernel: [ 2339.999978]  [<c103ffad>] ? autoremove_wake_function+0x0/0x2f
kernel: [ 2339.999983]  [<c103ffad>] ? autoremove_wake_function+0x0/0x2f
kernel: [ 2339.999989]  [<f80ea380>] ? pktgen_thread_worker+0x0/0x631 [pktg=
en]
kernel: [ 2339.999994]  [<c103fc8a>] kthread+0x6a/0x6f
kernel: [ 2339.999999]  [<c103fc20>] ? kthread+0x0/0x6f
kernel: [ 2340.000005]  [<c1002e82>] kernel_thread_helper+0x6/0x1a
kernel: [ 2340.000008] ---[ end trace 25113681b662d02f ]---


	Sergey

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvFlQQACgkQfKHnntdSXjSVbAP+IDlOvrysGQUU6OORiCTSfnB6
+1PciaA3KTlvhTX2KccqEoq/JrMUxHReiy+rlImbL2eK0vVUUk0q1rYdMwWZZBdp
mFD/koFUsNmC72FiURrm7LC6cbVQYz2lyiZ9vGkWdWHyb77+KiydGAoI/IzRokYb
2AsssWh6fhxLuneaPQY=
=9Yfq
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
