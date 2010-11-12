Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab0KLS5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:57:14 -0500
Received: from ms01.sssup.it ([193.205.80.99]:47387 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752967Ab0KLS5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:57:12 -0500
Subject: Re: [RFC][PATCH 18/22] sched: add reclaiming logic to -deadline
 tasks
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
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
        Bjoern Brandenburg <bbb@email.unc.edu>,
        "James H. Anderson" <anderson@cs.unc.edu>
In-Reply-To: <1289577841.2084.302.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334546.8661.161.camel@Palantir>  <1289513573.2084.199.camel@laptop>
	 <1289576177.6525.509.camel@Palantir>  <1289577841.2084.302.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Zh8QQ6O/uyG84mq7bD71"
Date: Fri, 12 Nov 2010 19:56:55 +0100
Message-ID: <1289588215.6525.697.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Zh8QQ6O/uyG84mq7bD71
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-12 at 17:04 +0100, Peter Zijlstra wrote:
> On Fri, 2010-11-12 at 16:36 +0100, Raistlin wrote:
> > But at this point I can't avoid asking. That model aims at _pure_
> > hard real-time scheduling *without* resource reservation capabilities,
> > provided it deals with temporal overruns by means of a probabilistic
> > analysis, right?=20
>=20
> From what I understood from it, its a soft real-time scheduling
> algorithm with resource reservation.=20
>
Mmm... I've gone through it (again!) quickly, and you're right, it
mentions soft real-time, and I agree that for those systems average CET
is better than worst CET. However, I'm not sure resource reservation is
there... Not in the paper I have at least, but I may be wrong.

> The problem the stochastic execution time model tries to address is the
> WCET computation mess, WCET computation is hard and often overly
> pessimistic, resulting in under-utilized systems.
>=20
I know, and it's very reasonable. The point I'm trying to make is that
resource reservation tries to address the very same issue.
I am all but against this model, just want to be sure it's not too much
in conflict to the other features we have, especially with resource
reservation. Especially considering that --if I got the whole thing
about this scheduler right-- resource reservation is something we really
want, and I think UNC people would agree here, since I heard Bjorn
stating this very clear both in Dresden and in Dublin. :-)

BTW, I'm adding them to the Cc, seems fair, and more useful than all
this speculation! :-P

Bjorn, Jim, sorry for bothering. If you're interested, this is the very
beginning of the whole thread:
 http://lkml.org/lkml/2010/10/29/67

And these should be from where this specific discussion starts (I hope,
the mirror is not updated yet I guess :-( ):
 http://lkml.org/lkml/2010/10/29/49
 http://groups.google.com/group/linux.kernel/msg/1dadeca435631b60

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-Zh8QQ6O/uyG84mq7bD71
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdjfcACgkQk4XaBE3IOsQYWgCcDRpbZtcv8TO9ci8dLlTHPvVc
YqcAoIvYPN4N7GIPA19JTSjStddShW40
=8AhR
-----END PGP SIGNATURE-----

--=-Zh8QQ6O/uyG84mq7bD71--

