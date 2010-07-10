Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0GJJsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 05:48:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62527 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab0GJJsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 05:48:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XzTKFldZZsjyz28VMPnTxRlI9iNMSKRszHWSTn8TRr+1Wne+r7pVCy6n0O+44mGvNc
         HibSFEwzmJBPRqDwCPmAPCzSc/NaXvXBHKAjbKjIHnUvPU3zDf140q8N/IXiSx/xlIlc
         cApXWbn1Gq+D9f8q31zvy5QHN9YnOOPv9JtlE=
Date: Sat, 10 Jul 2010 12:52:44 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
Message-ID: <20100710095244.GA4121@swordfish>
References: <xkNyyYrLiTN.A.s_G.7p7NMB@chimera>
 <Hc02ROPrUsG.A.F4.bt7NMB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <Hc02ROPrUsG.A.F4.bt7NMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/10/10 02:33), Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D15704
> Subject		: [r8169] WARNING: at net/sched/sch_generic.c
> Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date		: 2010-03-31 10:21 (101 days old)
> Message-ID	: <20100331102142.GA3294@swordfish.minsk.epam.com>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D127003090406108&w=3D2
>=20
>=20

Hello,

[ 3564.850086] pktgen 2.73: Packet Generator for packet performance testing.
[ 3580.993027] ------------[ cut here ]------------
[ 3580.993039] WARNING: at net/sched/sch_generic.c:258 dev_watchdog+0xc1/0x=
129()
[ 3580.993043] Hardware name: F3JC               =20
[ 3580.993046] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
[ 3580.993049] Modules linked in: pktgen ppp_async crc_ccitt ipv6 ppp_gener=
ic slhc usb_storage snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq sn=
d_seq_device snd_hwdep snd_hda_codec_si3054 snd_pcm_oss snd_mixer_oss
snd_hda_codec_realtek sdhci_pci sdhci mmc_core asus_laptop sparse_keymap le=
d_class snd_hda_intel snd_hda_codec snd_pcm psmouse rng_core i2c_i801 snd_t=
imer snd_page_alloc sg snd soundcore serio_raw evdev r8169 mii usbhid hid u=
hci_hcd
ehci_hcd sr_mod usbcore cdrom sd_mod ata_piix
[ 3580.993120] Pid: 0, comm: swapper Not tainted 2.6.35-rc4-dbg-git4-00247-=
g5bbf43d-dirty #72
[ 3580.993124] Call Trace:
[ 3580.993132]  [<c102e3a6>] warn_slowpath_common+0x65/0x7a
[ 3580.993137]  [<c12694af>] ? dev_watchdog+0xc1/0x129
[ 3580.993143]  [<c102e41f>] warn_slowpath_fmt+0x26/0x2a
[ 3580.993148]  [<c12694af>] dev_watchdog+0xc1/0x129
[ 3580.993155]  [<c10370ab>] ? run_timer_softirq+0x136/0x22b
[ 3580.993160]  [<c1037104>] run_timer_softirq+0x18f/0x22b
[ 3580.993165]  [<c10370ab>] ? run_timer_softirq+0x136/0x22b
[ 3580.993171]  [<c12693ee>] ? dev_watchdog+0x0/0x129
[ 3580.993177]  [<c1032c2d>] __do_softirq+0x88/0x10c
[ 3580.993183]  [<c1032ce0>] do_softirq+0x2f/0x47
[ 3580.993188]  [<c1032f9d>] irq_exit+0x38/0x75
[ 3580.993193]  [<c10159b8>] smp_apic_timer_interrupt+0x5f/0x6d
[ 3580.993200]  [<c12c732a>] apic_timer_interrupt+0x36/0x3c
[ 3580.993207]  [<c104007b>] ? __kfifo_peek_n+0x1b/0x2b
[ 3580.993213]  [<c11dd5f6>] ? acpi_idle_enter_simple+0x117/0x14b
[ 3580.993220]  [<c12468e9>] cpuidle_idle_call+0x6a/0xa0
[ 3580.993225]  [<c100170d>] cpu_idle+0x89/0xbe
[ 3580.993232]  [<c12c1e6d>] start_secondary+0x1f4/0x1fb
[ 3580.993237] ---[ end trace 0e0b0610391f3050 ]---
[ 3581.009527] r8169 0000:02:00.0: eth0: link up


	Sergey

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkw4QuwACgkQfKHnntdSXjTPIAP9HTpYXvSYkQAepGCPljaEmZpp
lRCuFJUK2IrS2+V3UqdxH21EKuT/r2S+qbC439veYj9saYfK5k8sXQcbZDcIBdS5
g4GCRU2MghKZtLWzUeZuwn/CNmq0GkfoscKATTw9A4h+rW5MiqTLpHAVa01ccm+Y
qu6nSYtBklSSJzkDz9Y=
=b7UE
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
