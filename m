Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2IISMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 14:12:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48994 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754173Ab2IISMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 14:12:15 -0400
Message-ID: <1347214327.7709.55.camel@deadeye.wl.decadent.org.uk>
Subject: Re: rcu_bh stalls on 3.2.28
From: Ben Hutchings <ben@decadent.org.uk>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 09 Sep 2012 19:12:07 +0100
In-Reply-To: <20120831230256.GA7016@khazad-dum.debian.net>
References: <1345467862.22400.139.camel@deadeye.wl.decadent.org.uk>
	 <20120831230256.GA7016@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fVB5rXCS/Lz4yzSalI/T"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fVB5rXCS/Lz4yzSalI/T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please note that I can only directly deal with regressions that are
specific to 3.2, caused by a bad backport.  For anything else, you need
to identify an upstream fix to be applied - I'm not usually going to
have the time to do that.

On Fri, 2012-08-31 at 20:02 -0300, Henrique de Moraes Holschuh wrote:
> Just got one of these:
>=20
> kernel: INFO: rcu_bh detected stall on CPU 2 (t=3D0 jiffies)
> kernel: Pid: 0, comm: swapper/2 Not tainted 3.2.28+ #2
> kernel: Call Trace:
> kernel: <IRQ>  [<ffffffff810d1609>] __rcu_pending+0x159/0x400
> kernel: [<ffffffff810d20bb>] rcu_check_callbacks+0x9b/0x120
> kernel: [<ffffffff81089673>] update_process_times+0x43/0x80
> kernel: [<ffffffff810a836f>] tick_sched_timer+0x5f/0xb0
> kernel: [<ffffffff8109c097>] __run_hrtimer.isra.30+0x57/0x100
> kernel: [<ffffffff8109c8f5>] hrtimer_interrupt+0xe5/0x220
> kernel: [<ffffffff8104ce14>] smp_apic_timer_interrupt+0x64/0xa0
> kernel: [<ffffffff8159b5cb>] apic_timer_interrupt+0x6b/0x70
> kernel: <EOI>  [<ffffffff81315645>] ? intel_idle+0xe5/0x140
> kernel: [<ffffffff81315623>] ? intel_idle+0xc3/0x140
> kernel: [<ffffffff814420ee>] cpuidle_idle_call+0x8e/0xf0
> kernel: [<ffffffff81032425>] cpu_idle+0xa5/0x110
> kernel: [<ffffffff8158a9ac>] start_secondary+0x1e5/0x1ec
>=20
> There are previous reports of these weird rcu_bh stalls with t=3D0 in the=
 3.2
> and 3.3 branches as well:
>=20
> https://lkml.org/lkml/2012/2/18/34
> http://lkml.org/lkml/2012/3/28/175
>=20
> another data point:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D806610

Says it was fixed in (Fedora's) 3.3 - so perhaps there are multiple bugs
involved.

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that everything doesn't happen at once.

--=-fVB5rXCS/Lz4yzSalI/T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUEzb9+e/yOyVhhEJAQrJpw/9Gw4MFxmexA4CQe93U8FA7ejZJe5jN8mi
eNUE7DA9Uh/eSEpfBtO9fws+hFV25uC1toymFKCatqGTGGN4ZUVxTrLNuAeyu1cK
3U+vea7GQLqVbU4Shi7FxDD2CMWrCS3/E7H0/UtrRRph/K/Vxq2cJT3du6fSilJ3
TxFVefUj8AH6LsKf6dC5akXz0msD0lJpdTmG/1SkOEPeW3alZdWwJCyF82lQRAN1
Zg9hSHPRE85RtVbDDLj7sQ28xTpUfecmH4BEkWr5q81/J/tjAOb/wZza9aiv17H8
rc9yJpMPLJliLRv/JmMh+6VqS+KC2vrCW+QGTzg4EEIZMrGoZZ+VOt8rZM6LgR6w
GJn3nLpMQPGGljGEkVRBYex2eQlraE/VFpi80Br/46yfAM1iYqsAKkpJ2tXiR4SZ
dZWr5HO9AZjrdhlBv2D9pM//7tBHPzYrHrSTPXEuQJeuDeITzRvixa0GRxQvw9sz
pVoEfzjN2DjVdX/z+qhBQk9CqKscasBcf4jtczOSMKjuNEM7A6IA5savCq1hlUmx
3bx4CBopQ8KqOAGTIZR9LrTWpqGs8KRSmV4qZqawZv9TkE1AB/mANxPf1YpjoE0k
kTon+BFxLAyRFdnIpOXbjgPIcIpFFDrExaDOvhWusawFQebP61Qyeiu+ok3ir852
/lgGbPbhwAk=
=gs1+
-----END PGP SIGNATURE-----

--=-fVB5rXCS/Lz4yzSalI/T--
