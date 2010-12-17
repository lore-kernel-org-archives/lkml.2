Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0LQSqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:46:19 -0500
Received: from ms01.sssup.it ([193.205.80.99]:55553 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755710Ab0LQSqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:46:18 -0500
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Dario Faggioli <raistlin@linux.it>
To: Harald Gustafsson <hgu1972@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <AANLkTi=L9KB_P62Rn7kpuMxbSNnE9U4+EZK6nwqFZ-x7@mail.gmail.com>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	 <1292596194.2266.283.camel@twins>
	 <AANLkTi=L9KB_P62Rn7kpuMxbSNnE9U4+EZK6nwqFZ-x7@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wkbszRoCeILsSJXfWhVS"
Date: Fri, 17 Dec 2010 19:48:18 +0100
Message-ID: <1292611698.2697.61.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wkbszRoCeILsSJXfWhVS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-12-17 at 16:02 +0100, Harald Gustafsson wrote:=20
> > Once you have a governor that keeps the freq such that: freq/max_freq >=
=3D
> > utilization (which is only sufficient for deadline =3D=3D period system=
s),
> > then you need to frob the SCHED_DEADLINE runtime accounting.
>=20
> I agree that this is the other part of the solution, which I have in a se=
parate
> ondemand governor, but that code is not ready for public review yet. Sinc=
e that
> code also incorporate other ondemand changes I'm playing with.=20
>
So, while we're waiting for this to be cooked...

> OK, I can do that. My thought from the beginning was considering that
> the reading of the clock was done more often then updating it, but I agre=
e that
> it has a negative impact on none dl threads.
>=20
... We can at least integrate this (done in the proper, way as Peter
suggests, i.e., _inside_ SCHED_DEADLINE) in the next release of the
patchset, can't we?

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-wkbszRoCeILsSJXfWhVS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0LsHIACgkQk4XaBE3IOsQq8ACfec16I5B2WuaTgDcxDbaz18+u
7eIAn1hrVatTTRIqwKt/R95lW6jPlURw
=Dhe4
-----END PGP SIGNATURE-----

--=-wkbszRoCeILsSJXfWhVS--

