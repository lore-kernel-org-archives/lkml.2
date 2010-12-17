Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab0LQSnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:43:01 -0500
Received: from ms01.sssup.it ([193.205.80.99]:36160 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752109Ab0LQSnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:43:00 -0500
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Dario Faggioli <raistlin@linux.it>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Harald Gustafsson <hgu1972@gmail.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1012171630330.12146@localhost6.localdomain6>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	 <1292596194.2266.283.camel@twins> <1292596369.2266.286.camel@twins>
	 <AANLkTinGkf3a4_sw32b4UqAmpUU+i6fDmDUT8tXdw14D@mail.gmail.com>
	 <1292599007.2266.290.camel@twins>
	 <alpine.LFD.2.00.1012171630330.12146@localhost6.localdomain6>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7MGPi23zBQhg9JtNzDXe"
Date: Fri, 17 Dec 2010 19:44:54 +0100
Message-ID: <1292611494.2697.58.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7MGPi23zBQhg9JtNzDXe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-12-17 at 16:43 +0100, Thomas Gleixner wrote:=20
> There's that and I have yet to see a proof that running code with
> lower frequency and not going idle saves more power than running full
> speed and going into low power states for longer time.
>=20
I was expecting a reply like this from right from you! :-P

BTW, I mostly agree that race to idle is better. The point here is that
you might end in a situation where frequency scaling is enabled and/or
a particular frequency is statically selected for whatever reason. In
that case, making the scheduler aware of such could be needed to get the
expected behaviour out of it, independently from the fact it is probably
going to be worse than race-to-idle for power saving purposes... How
much am I wrong?

> Also if you want to have your deadline scheduler aware of cpu
> frequency changes, then simply limit the total bandwith based on the
> lowest possible frequency and it works always.=20
>
That could be a solution as well, although you're limiting a lot the
bandwidth available for deadline task. But something similar could be
considered...

> This whole dynamic
> bandwith expansion is more an academic exercise than a practical
> necessity.
>=20
Well, despite the fact that Harald is with Ericsson and as not much to
do with academia. :-D

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-7MGPi23zBQhg9JtNzDXe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0Lr6YACgkQk4XaBE3IOsROgQCfY5SNuX5trgolEapMJNaXuOt8
hBMAn2Ao5v9CpWx/zuUoF2oC1hFPMRGZ
=mxHu
-----END PGP SIGNATURE-----

--=-7MGPi23zBQhg9JtNzDXe--

