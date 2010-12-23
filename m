Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0LWOpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 09:45:20 -0500
Received: from ms01.sssup.it ([193.205.80.99]:44901 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753051Ab0LWOpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:45:19 -0500
Subject: Re: Sending some form of notifaction when sched_fifo throttling
 kicks in...
From: Dario Faggioli <raistlin@linux.it>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: torbenh <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Gregory Haskins <ghaskins@novell.com>,
        Nick Piggin <nickpiggin@yahoo.com.au>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, vatsa@in.ibm.com
In-Reply-To: <AANLkTi=1v6YG-Vc7uZFvqO6K0fAuZ-o9A7hxeZVVAHm3@mail.gmail.com>
References: <20101223113926.GH14960@siel.b>
	 <1293110258.3390.41.camel@Palantir>
	 <AANLkTi=1v6YG-Vc7uZFvqO6K0fAuZ-o9A7hxeZVVAHm3@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xeb6AyB6Pmi+dXH4snxy"
Date: Thu, 23 Dec 2010 15:44:56 +0100
Message-ID: <1293115496.3390.49.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xeb6AyB6Pmi+dXH4snxy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-12-23 at 15:04 +0100, Dhaval Giani wrote:=20
> > ... If you think you're fine with some /proc (and perhaps cpuacct, if
> > cgroups are being used) readable, I can try to come up with something.
> >
>=20
> There is no point in putting it in cpuacct since cpuacct can be used
> separately from cpu.
>=20
Which would mean that you'd need both for having such stat. Anyway, I'm
fine with putting this in 'cpu' as well, just trying to find a consensus
on what the right place is.

> > Do others have some idea and/or comments about that? This is
> > ABI/interface, and that really scares me! :-P
>=20
> IIRC, your patchset had something like this for getting the
> statistics? Starting fromt hre, would schedstats be the right place?
>=20
SCHED_DEADLINE patchset has both signaling capabilities and some
statistic reporting, bat it's a different thing.

I think schedstat could be the right place for _this_ thing here, but
since each cgroup could be throttled, we also need something which is
per-cgroup... Don't you agree?

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-xeb6AyB6Pmi+dXH4snxy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0TYGgACgkQk4XaBE3IOsR80ACeMmYYpuqlvRUUSaNn/y3M56lC
Hy4AoKr1fPt+HCUckLNfKsbm7sY0EDsQ
=q1aZ
-----END PGP SIGNATURE-----

--=-xeb6AyB6Pmi+dXH4snxy--

