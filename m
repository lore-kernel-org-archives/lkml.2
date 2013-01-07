Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3AGXYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:24:22 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56126 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3AGXYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:24:20 -0500
Date: Tue, 8 Jan 2013 10:24:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, Randy Dunlap <rdunlap@infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 7 (rcutorture)
Message-Id: <20130108102418.04c8cfc9b75cb48c5004f74a@canb.auug.org.au>
In-Reply-To: <1357600327.5190.13.camel@gandalf.local.home>
References: <20130107142649.c843e0b711532dc3a631e4cf@canb.auug.org.au>
	<50EB252C.4010005@infradead.org>
	<20130107221627.GZ2525@linux.vnet.ibm.com>
	<20130108095959.98d83d91dbd0e9e1ac023373@canb.auug.org.au>
	<1357600327.5190.13.camel@gandalf.local.home>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Jan_2013_10_24_18_+1100_k3U+dOuryatBn+rV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jan_2013_10_24_18_+1100_k3U+dOuryatBn+rV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Mon, 07 Jan 2013 18:12:07 -0500 Steven Rostedt <rostedt@goodmis.org> wro=
te:
>
> On Tue, 2013-01-08 at 09:59 +1100, Stephen Rothwell wrote:
> >=20
> > On Mon, 7 Jan 2013 14:16:27 -0800 "Paul E. McKenney" <paulmck@linux.vne=
t.ibm.com> wrote:
> > >
> > > On Mon, Jan 07, 2013 at 11:42:36AM -0800, Randy Dunlap wrote:
> > > >=20
> > > > on i386 or x86_64:
> > > >=20
> > > > ERROR: "trace_clock_local" [kernel/rcutorture.ko] undefined!
> > >=20
> > > Hello, Randy,
> > >=20
> > > Did your build include the following, also pushed to -next in that sa=
me
> > > batch from -rcu?  Including Steven Rostedt on CC for his take.
> >=20
> > That commit was certainly in next-20130107.
> >=20
>=20
> Could be bad config dependencies.
>=20
> Stephen, can you send me the config that gave you that error.

It was Randy and the config was in the mail the Paul cc'd you on.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Jan_2013_10_24_18_+1100_k3U+dOuryatBn+rV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ61kiAAoJEECxmPOUX5FE+dUP/2s/Kh5oihIrAbMGTIi409JP
+bqkD6YJEZyahNXeP4boONrfXzkvTfIM0CVOTyKXrWypjPBgfh2zErbJh35C2c8X
/mOOXquRAQUkpG0OFwSsUxUzN4zxBXZa7OEDeAYX8dB56xkcQ6yHa6BKbUuae5Ws
8bhm4Log5FbTGF/NhIBAimjtYOfWUobEwaCqDm7evO2gbbSCHg6iOeW39L8tD15O
DBe3Vfdr/LpdjqjLrOnRqwTaEC8c+MJsV7FbrYJayx4LezO9WTwjDpvLyVI+9SwU
kq2/MrYFNLHg/boVTC2B/gtwSqbL38mn19gp3E5FgXDWkvH7UJCpzbWpmy3pb/M6
RL/MZr6i7u3VQl786FiJtoHfvUNxCWBkRgSgeGs9iDY/k6RRK2Si1v3Ak8fxSr7P
UoexaJdrXPYtzNg8U2r/Ur8KQ4NV83AY6+Elv8WVRqs6UHRairoVI9QvjBOgaGnU
a97epzpr1/HJEPQOd0Be+pyG4Yj/DnOy8bQQXtAnYu1ZKF+RJIL0etvbegwPUTym
fxLp7JqUbdPiMXqJAe/4+rE8RFsj+T8kgCuRx6nxPkjEClJS/AsWLylkTF3vRYY2
irc8I5j6CF3GYBwNUQqpxhmJ/l6Kga4YOpzx4B6LMS5pJnHqHTzocE6R+AfyceKL
8QaLqv5bMCg1WrklpnbJ
=aq+R
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jan_2013_10_24_18_+1100_k3U+dOuryatBn+rV--
