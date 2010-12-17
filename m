Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab0LQTOs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:14:48 -0500
Received: from ms01.sssup.it ([193.205.80.99]:50999 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753523Ab0LQTOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:14:47 -0500
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Dario Faggioli <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Harald Gustafsson <hgu1972@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1292612385.2708.108.camel@laptop>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	 <1292596194.2266.283.camel@twins>  <1292612166.2697.68.camel@Palantir>
	 <1292612385.2708.108.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qn3NLmO3Huvt/yzQt19P"
Date: Fri, 17 Dec 2010 20:16:42 +0100
Message-ID: <1292613402.2697.88.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qn3NLmO3Huvt/yzQt19P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-12-17 at 19:59 +0100, Peter Zijlstra wrote:=20
> > However, converting the basic mechanism into a CPUfreq governor should
> > be easily doable... The only problem is finding the time for that! ;-P=
=20
>=20
> Ah, I think Harald will solve that for you,.. :)
>=20
Yeah, I saw that... Help is a wonderful thing, you know? :-P

> > And, at least for the meantime, this seems a very very nice solution.
> > The only thing I don't like is that division which would end up in bein=
g
> > performed at each tick/update_curr_dl(), but we can try to find out a
> > way to mitigate this, what do you think Harald?
>=20
> A simple mult and shift-right should do. You can either pre-compute for
> a platform, or compute the inv multiplier in the cpufreq notifier thing.
>
Yeah, I was thinking about something like the last solution you just
propose, but we'll consider all of them.

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-qn3NLmO3Huvt/yzQt19P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0LtxoACgkQk4XaBE3IOsSrKwCeMV8U/pkTDrCgXxoN60Zma1Ar
SJkAnA3NAfAQYDXeVhOvNo7/lmXEmlud
=hVAh
-----END PGP SIGNATURE-----

--=-qn3NLmO3Huvt/yzQt19P--

