Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab0FNHii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 03:38:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33135 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0FNHib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 03:38:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dZauJZmTgJRrWaS22uoq8FhR+LJnfc+40/X7jvCecnPmCNWC6OLhwNe8arqzos67Q4
         O1tKsw8K9vWB24/+P7fgYcXhArfL4dqdhk0xevGqBKYCIzPzcJ8wkfS5ktLsHZA4Xlp8
         zlfdR7S7GiXtVdRV3eXfQZD8nodzwxbTbvfPY=
Date: Mon, 14 Jun 2010 10:41:55 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [Bug #15704] [r8169] WARNING: at net/sched/sch_generic.c
Message-ID: <20100614074155.GA3352@swordfish.minsk.epam.com>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
 <YPGdyfWGvNK.A.lOB.b8OFMB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <YPGdyfWGvNK.A.lOB.b8OFMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (06/13/10 16:48), Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D15704
> Subject		: [r8169] WARNING: at net/sched/sch_generic.c
> Submitter	: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date		: 2010-03-31 10:21 (75 days old)
> Message-ID	: <<<20100331102142.GA3294@swordfish.minsk.epam.com>>>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D127003090406108&w=3D2
>=20
>=20


Hello,

=2E35-rc3

kernel: [  109.024175] pktgen 2.73: Packet Generator for packet performance=
 testing.
kernel: [  144.360001] ------------[ cut here ]------------
kernel: [  144.360012] WARNING: at net/sched/sch_generic.c:258 dev_watchdog=
+0xc1/0x129()
kernel: [  144.360016] Hardware name: F3JC               =20
kernel: [  144.360019] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 time=
d out
kernel: [  144.360022] Modules linked in: pktgen snd_hwdep snd_hda_codec_si=
3054 snd_hda_codec_realtek snd_hda_intel asus_laptop sparse_keymap sdhci_pc=
i sdhci mmc_core led_class snd_hda_codec i2c_i801 rng_core snd_pcm snd_timer
snd_page_alloc snd soundcore psmouse sg serio_raw evdev r8169 mii usbhid hi=
d uhci_hcd ehci_hcd sr_mod usbcore cdrom sd_mod ata_piix
kernel: [  144.360073] Pid: 3424, comm: kpktgend_0 Not tainted 2.6.35-rc3-d=
bg-00106-ga75e02b #2
kernel: [  144.360076] Call Trace:
kernel: [  144.360085]  [<c102dc0a>] warn_slowpath_common+0x65/0x7a
kernel: [  144.360090]  [<c1266683>] ? dev_watchdog+0xc1/0x129
kernel: [  144.360095]  [<c102dc83>] warn_slowpath_fmt+0x26/0x2a
kernel: [  144.360100]  [<c1266683>] dev_watchdog+0xc1/0x129
kernel: [  144.360107]  [<c10365af>] ? run_timer_softirq+0x136/0x22b
kernel: [  144.360113]  [<c1036608>] run_timer_softirq+0x18f/0x22b
kernel: [  144.360118]  [<c10365af>] ? run_timer_softirq+0x136/0x22b
kernel: [  144.360123]  [<c12665c2>] ? dev_watchdog+0x0/0x129
kernel: [  144.360129]  [<c10322d2>] __do_softirq+0x79/0xec
kernel: [  144.360135]  [<c103236f>] do_softirq+0x2a/0x2f
kernel: [  144.360140]  [<c1032519>] _local_bh_enable_ip+0x65/0x86
kernel: [  144.360145]  [<c1032542>] local_bh_enable_ip+0x8/0xa
kernel: [  144.360151]  [<c12c354b>] _raw_spin_unlock_bh+0x2f/0x32
kernel: [  144.360158]  [<f808e5c7>] pktgen_xmit+0xda2/0xe6f [pktgen]
kernel: [  144.360168]  [<fd1d57b8>] ? rtl8169_start_xmit+0x0/0x307 [r8169]
kernel: [  144.360174]  [<c1002d70>] ? common_interrupt+0x30/0x38
kernel: [  144.360180]  [<c104c65d>] ? __lock_acquire+0x1d6/0x3ca
kernel: [  144.360187]  [<f808e88f>] ? pktgen_thread_worker+0x96/0x5c3 [pkt=
gen]
kernel: [  144.360193]  [<c1028a2f>] ? get_parent_ip+0xb/0x31
kernel: [  144.360198]  [<c1028ad1>] ? sub_preempt_count+0x7c/0x89
kernel: [  144.360205]  [<f808e969>] pktgen_thread_worker+0x170/0x5c3 [pktg=
en]
kernel: [  144.360209]  [<c12c1e13>] ? schedule+0x535/0x545
kernel: [  144.360216]  [<c103f1d2>] ? autoremove_wake_function+0x0/0x2f
kernel: [  144.360221]  [<c103f1d2>] ? autoremove_wake_function+0x0/0x2f
kernel: [  144.360227]  [<f808e7f9>] ? pktgen_thread_worker+0x0/0x5c3 [pktg=
en]
kernel: [  144.360232]  [<c103eee2>] kthread+0x6a/0x6f
kernel: [  144.360238]  [<c103ee78>] ? kthread+0x0/0x6f
kernel: [  144.360243]  [<c1002d7e>] kernel_thread_helper+0x6/0x10
kernel: [  144.360247] ---[ end trace a692664bf7dac635 ]---


	Sergey

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwV3UMACgkQfKHnntdSXjR/dgP5AWltzitvdG1GS4hzIeM6kwMu
8oYNJEj0DtJcj+AauVSyyA2LLxxSdCTENdD8EOJGedNysoxEOaT3VLOlf6RmSnTc
sMpJj7fdDwRBjM7Nb8VS42beJ12UtLvlRv8aXXgE//04ZCc43afRTnzTZzELB46K
jEXg/MDSdIhzU5v74es=
=GTjh
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
