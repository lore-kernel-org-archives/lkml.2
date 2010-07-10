Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0GJJOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 05:14:39 -0400
Received: from ms01.sssup.it ([193.205.80.99]:39874 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752059Ab0GJJOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 05:14:38 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1278685800.1900.212.camel@laptop>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685800.1900.212.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3cKtL5LtsPCHn6RipzvS"
Date: Sat, 10 Jul 2010 11:14:27 +0200
Message-ID: <1278753267.4390.102.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3cKtL5LtsPCHn6RipzvS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-07-09 at 16:30 +0200, Peter Zijlstra wrote:
> On Fri, 2010-07-09 at 15:38 +0200, Raistlin wrote:
> >=20
> > Therefore, here it is my proposal:
> >  - if the programmer specify both period and deadline, I act as above,
> >    running the _only_necessary_ test in the kernel, assuming that
> >    userspace performed some other kind of (correct!) admission test by
> >    its own, or that it is cool with missing some deadlines... What do
> >    you think?
>=20
> It would be good to provide room in the interface to improve upon this
> situation.
>=20
Well, room is already there, problem is decide how to use it.

> One thing we could do, although this would make the proposed scheduler a
> wee bit more complex, is split between hard and soft realtime. Only
> accept P=3D=3Drel_D for hard, and schedule the soft tasks in the hard sla=
ck
> or something like that.
>=20
As said in the other mail, this could be done, just let me know as much
as you can how you think it should happen (scheduling class, scheduling
policy, two (or more) separate queues, ecc.

Btw, Dhaval introduced me to the obscure world of IRC... I am (if
everything worked! :-P) dariof on #sched and/or #sched-rt, so feel free
to contact me even there, if at te PC I'll be glad to discuss even
there! :-D

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-3cKtL5LtsPCHn6RipzvS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw4OfMACgkQk4XaBE3IOsSpKgCggdpCWGZvvZLG7f+2lTBTHgJH
TSEAn3pAmzXwxbjAG5iHq3SkIXl5mWZ6
=lslU
-----END PGP SIGNATURE-----

--=-3cKtL5LtsPCHn6RipzvS--

