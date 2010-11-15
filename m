Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab0KOVfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:35:07 -0500
Received: from ms01.sssup.it ([193.205.80.99]:33235 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758515Ab0KOVfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:35:06 -0500
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline
 tasks
From: Raistlin <raistlin@linux.it>
To: "James H. Anderson" <anderson@cs.unc.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>,
        Bjoern Brandenburg <bbb@email.unc.edu>
In-Reply-To: <4CE17DD2.3060807@cs.unc.edu>
References: <1289588215.6525.697.camel@Palantir>
	 <80992760-24F2-42AE-AF2D-15727F6A1C81@email.unc.edu>
	 <4CE17DD2.3060807@cs.unc.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zlnX+UMjfhQC+ZGUrRnw"
Date: Mon, 15 Nov 2010 22:34:48 +0100
Message-ID: <1289856888.7033.101.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zlnX+UMjfhQC+ZGUrRnw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-11-15 at 13:37 -0500, James H. Anderson wrote:
> Sorry for the delayed response... I think I must have inadvertently=20
> deleted this
>
NP. Hope it's not my fault, due to GPG and stuff... :-)

> If you're talking about our most recent "stochastic" paper, it is about=20
> supporting
> soft real-time task systems on a multiprocessor where resource=20
> reservations are
> used. =20
>
Actually, we were talking about the previous one, which (if I got it
well) didn't include reservations, and that's why we were wondering how
to integrate it in the scheduler (which _is_ reservation based).

Now that this one is out, going for it simply solves all our issues,
also considering that it says something very similar to what we (Pisa
guys :-D) are familiar with, since we investigated this stuff too
sometime ago (actually, Luca did).

> However, such methods would be easy to incorporate. =20
>
I think it really should be... Actually, I'm under the impression that
we don't even need variance/std-dev of the execution time to be part of
the interface, do we?

> I gathered there was
> some confusion about whether we were using resource reservations.  Such
> reservations are actually crucial for our analysis as they allow=20
> independence to be assumed across tasks.
>
Yes, as I said, this was because we were looking at first paper. Now we
got it, thanks a lot for clarifying! :-)

> I hope this helps.
>=20
A lot, thanks again.

Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-zlnX+UMjfhQC+ZGUrRnw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzhp3gACgkQk4XaBE3IOsT+oACgopRjLcmL7/bBe6b84rjjnJ/h
+7wAnRLeAuBDuwW3oFz1jrF85mMVVawf
=LU9t
-----END PGP SIGNATURE-----

--=-zlnX+UMjfhQC+ZGUrRnw--

