Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0GJVwq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 17:52:46 -0400
Received: from ms01.sssup.it ([193.205.80.99]:50523 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752958Ab0GJVwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 17:52:43 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Raistlin <raistlin@linux.it>
To: Harald Gustafsson <hgu1972@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <AANLkTin0sj6ONjNcwX6IJHSgi7gKnCzkvD_jaLyOFNjs@mail.gmail.com>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685800.1900.212.camel@laptop>
	 <AANLkTilufL0jgoqQLKjxbu0egN2l6lCkF9JPCxBfV3Gz@mail.gmail.com>
	 <1278786710.1998.63.camel@laptop>
	 <AANLkTin0sj6ONjNcwX6IJHSgi7gKnCzkvD_jaLyOFNjs@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LqdliW6H7GsJvqWkCGfq"
Date: Sat, 10 Jul 2010 23:52:32 +0200
Message-ID: <1278798752.4918.24.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LqdliW6H7GsJvqWkCGfq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-07-10 at 22:08 +0200, Harald Gustafsson wrote:
> > That is a very delicate point, the whole reason SCHED_FIFO and friends
> > suck so much is that they don't provide any kind of isolation, and thus=
,
> > as an Operating-System abstraction they're an utter failure.
> >
> > If you take out admission control you end up with a similar situation.
>=20
> OK, I see your point, and I also want to keep the isolation, its just
> that I thought that the complexity might be too large to be accepted
> by mainline. Let's work towards a solution with good admission
> control, i.e. having more complex admission control to handle this.
>=20
Indeed. I think things might be done step by step, relaxing the
constraints as long as we find better solutions.

> > Embedded people can of course easily hack in whatever they well fancy,
> > and adding the 'yes_I_really_want_this_anyway' flag or even taking out
> > admission control all together is something the GPL allows them to do.
>=20
> Not an option I would like to pursue, it should be possible to get a
> working solution without this.
>
Yeah, I see your point and agree with it. Btw, I think that, even in the
configuration described by Peter, if you --as an embedded system
engineer-- have the full control of your device/product, you can avoid
having any hard-rt task. Then, if you only have soft ones, you'll get
the benefit of having the possibility of setting D!=3DP without suffering
of any interference... Am I right?

I think this could be a viable solution, at least until we have
something better to relax assumptions on the schedulability test for
hard tasks, isn't it?

Regards,
Dario
--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-LqdliW6H7GsJvqWkCGfq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw465kACgkQk4XaBE3IOsS08gCeKTjXJb0uWb7R6RRyjJ3hvna9
uCMAn0/jm8qbjjsUPPGIsTDnkF7xHyO1
=Jwwy
-----END PGP SIGNATURE-----

--=-LqdliW6H7GsJvqWkCGfq--

