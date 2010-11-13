Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab0KMVIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 16:08:31 -0500
Received: from ms01.sssup.it ([193.205.80.99]:58915 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753675Ab0KMVIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 16:08:30 -0500
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline
 tasks
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Luca Abeni <luca.abeni@unitn.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289584295.2084.343.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334546.8661.161.camel@Palantir>  <1289513573.2084.199.camel@laptop>
	 <1289576177.6525.509.camel@Palantir> <1289577841.2084.302.camel@laptop>
	 <4CDD7C65.9090400@unitn.it>  <1289584295.2084.343.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hygah2aJiKh1Sa/afnts"
Date: Sat, 13 Nov 2010 22:08:16 +0100
Message-ID: <1289682496.6491.550.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hygah2aJiKh1Sa/afnts
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-12 at 18:51 +0100, Peter Zijlstra wrote:
> > BTW, sorry for the shameless plug, but even with the current=20
> > SCHED_DEADLINE you are not forced to dimension the runtime using the=20
> > WCET.=20
>=20
> Yes you are, it pushes the deadline back on overrun. The idea it to
> maintain the deadline despite overrunning your budget (up to a point).
>=20
BTW, although I share most of Luca's and Tommaso's viewpoints,
triggering bandwidth enforcement at runtime+something instead than just
at runtime doesn't look all that bad, and should fit nicely in what we
have now, without much twisting.

It's just another way to interpret the runtime, and it seems feasible
(or at least plan-able as future feature! :-P) to me... Actually this
was exactly what I was asking and what I wanted to know. :-)

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-hygah2aJiKh1Sa/afnts
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkze/jgACgkQk4XaBE3IOsTKAgCcDdngmjb282jmKbHxG8afoVu8
mxIAnREk98lXGp2iiL4XtPaJiP2xIYcv
=MOx5
-----END PGP SIGNATURE-----

--=-hygah2aJiKh1Sa/afnts--

