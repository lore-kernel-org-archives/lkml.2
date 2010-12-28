Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0L1Ka0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 05:30:26 -0500
Received: from ms01.sssup.it ([193.205.80.99]:39837 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752225Ab0L1KaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 05:30:25 -0500
Subject: Re: Sending some form of notifaction when sched_fifo throttling
 kicks in...
From: Dario Faggioli <raistlin@linux.it>
To: Bharata B Rao <bharata.rao@gmail.com>
Cc: torbenh <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Gregory Haskins <ghaskins@novell.com>,
        Nick Piggin <nickpiggin@yahoo.com.au>,
        Dhaval Giani <dhaval.giani@gmail.com>
In-Reply-To: <AANLkTinch3-FHaOKTnfYnFLnG5uyRNfmpZP=RpLzJOrf@mail.gmail.com>
References: <20101223113926.GH14960@siel.b>
	 <1293110258.3390.41.camel@Palantir>
	 <AANLkTinch3-FHaOKTnfYnFLnG5uyRNfmpZP=RpLzJOrf@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-p2VBI/GKwgL2GSPzUz0A"
Date: Tue, 28 Dec 2010 11:30:10 +0100
Message-ID: <1293532210.2899.1002.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-p2VBI/GKwgL2GSPzUz0A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-12-27 at 12:13 +0530, Bharata B Rao wrote:=20
> > Do others have some idea and/or comments about that? This is
> > ABI/interface, and that really scares me! :-P
>=20
> You might want to note that CFS bandwidth control patches export some
> such stats via a new per-cgroup file cpu.stat. It exports 3 statistics:
>=20
Yeah, I saw that. What can be also done is to extend schedstats and then
apply it to cgroups as well... I think Dhaval told me he has some plans
about that, am I wrong?

> nr_periods: Number of enforcement intervals that have elapsed.
> nr_throttled: Number of times the group has been throttled/limited.
> throttled_time: The total time duration (in nanoseconds) for which the gr=
oup
> remained throttled.
>=20
More than reasonable reporting, to me at least. :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-p2VBI/GKwgL2GSPzUz0A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0ZvDIACgkQk4XaBE3IOsQnGQCgpeDJR/SfMmy1quC2MFdvroIB
Nc4An2vs2yvLZ/KD/1YYGQdROTiX2Tt/
=8nXh
-----END PGP SIGNATURE-----

--=-p2VBI/GKwgL2GSPzUz0A--

