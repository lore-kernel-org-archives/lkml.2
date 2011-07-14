Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab1GNTRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 15:17:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50754 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab1GNTRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 15:17:18 -0400
Date: Thu, 14 Jul 2011 22:16:30 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: possible circular locking dependency detected
Message-ID: <20110714191630.GB3060@swordfish>
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
 <1310661699.2309.13.camel@laptop>
 <20110714165751.GA7400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <20110714165751.GA7400@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/14/11 09:57), Paul E. McKenney wrote:
>=20
> On Thu, Jul 14, 2011 at 06:41:39PM +0200, Peter Zijlstra wrote:
> > On Thu, 2011-07-14 at 17:49 +0300, Sergey Senozhatsky wrote:
> > > Hello,
> > >=20
> > > [ 4172.371094] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > [ 4172.371097] [ INFO: possible circular locking dependency detected ]
> > > [ 4172.371103] 3.0.0-rc7-dbg-00565-g6b31efc #644
> > > [ 4172.371105] -------------------------------------------------------
> > > [ 4172.371108] make/11702 is trying to acquire lock:
> > > [ 4172.371111]  (rcu_node_level_0){..-...}, at: [<ffffffff810a55e2>] =
__rcu_read_unlock+0xb9/0x217
> > > [ 4172.371123]=20
> > > [ 4172.371123] but task is already holding lock:
> > > [ 4172.371125]  (&p->pi_lock){-.-.-.}, at: [<ffffffff8103775e>] try_t=
o_wake_up+0x29/0x28b
> > > [ 4172.371135]=20
> > > [ 4172.371135] which lock already depends on the new lock.
> >=20
> > Happen to have a .config and means of reproduction? We're a little
> > stumped at trying to explain how this can actually happen.
>=20
> What Peter said!  Sergey, could also you please tell us what tree you
> are using?  I am not seeing commit 6b31efc in mainline or -tip.
>=20

I'm using vanilla kernel
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

$git pull
Already up-to-date.


	Sergey

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iJwEAQECAAYFAk4fQI4ACgkQfKHnntdSXjR3AgP/QZGAbEXl4bcZzRB7AsvLrWaK
UJ97hFVOzSLPVAWDIeoaXkqvF3r8mhCunm1jcdSkleNuIwZnd4KzHlX7YqTwlWg0
n0UDt1Y9oRJ0xu/0+smYD2TCrq3FD6heWX/J7vGJvhaO4EW7P0yKbsRxvKJce/Ry
V0erusC2COKH2cl5wJA=
=HPq2
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
