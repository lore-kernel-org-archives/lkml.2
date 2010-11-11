Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab0KKO20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:28:26 -0500
Received: from ms01.sssup.it ([193.205.80.99]:55398 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752464Ab0KKO2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:28:24 -0500
Subject: Re: [RFC][PATCH 05/22] sched: SCHED_DEADLINE policy implementation
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
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289484787.2084.115.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>  <1289484787.2084.115.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tX18rqwI2qQqW+IwVnGK"
Date: Thu, 11 Nov 2010 15:28:10 +0100
Message-ID: <1289485690.6525.12.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tX18rqwI2qQqW+IwVnGK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 15:13 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:30 +0200, Raistlin wrote:
> > +       delta_exec =3D rq->clock - curr->se.exec_start;
>=20
> This changed to rq->clock_task, the difference between rq->clock and
> rq->clock_task is that the latter only counts time actually spend on the
> task context (ie. it doesn't count softirq and hardirq context).
>=20
Yeah, I noticed later that Venki's changes in accounting could be
super-useful here. I'm already on it! :-P

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-tX18rqwI2qQqW+IwVnGK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzb/XoACgkQk4XaBE3IOsTWkQCggz1+LsvDrekfMQClQzUUHyBz
y+0An0vXk3VohlT9P4J2D/7E6pCr+NEL
=GCBN
-----END PGP SIGNATURE-----

--=-tX18rqwI2qQqW+IwVnGK--

