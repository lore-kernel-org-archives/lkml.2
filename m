Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0KKTdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:33:35 -0500
Received: from ms01.sssup.it ([193.205.80.99]:52728 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755208Ab0KKTde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:33:34 -0500
Subject: Re: [RFC][PATCH 10/22] sched: add a syscall to wait for the next
 instance
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
In-Reply-To: <1289503317.2084.158.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334104.8661.151.camel@Palantir>  <1289503317.2084.158.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SLVdGm0ARJW/GLNp6UxW"
Date: Thu, 11 Nov 2010 20:33:24 +0100
Message-ID: <1289504004.6525.109.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SLVdGm0ARJW/GLNp6UxW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 20:21 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:35 +0200, Raistlin wrote:
> >=20
> > Introduce sched_wait_interval() syscall (and scheduling class
> > interface call). In general, this aims at providing each scheduling
> > class with a mean of making one of its own task sleep for some time
> > according to some specific rule of the scheduling class itself.
> >=20
> Did we have an actual use case for this? I seem to remember that the
> last time we seemed to thing job wakeups are due to external events, in
> which case we don't need this.
>=20
Might find out something, but I mostly agree with what you're saying.

> I think we should try without this patch first and only consider this
> once we merged the base functionality and have a solid use-case for
> this.
>
Consider it as already dropped! :-)

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-SLVdGm0ARJW/GLNp6UxW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzcRQQACgkQk4XaBE3IOsTD5ACcC2KQLblKSsVkkvNsD7rvsUci
P+IAoKia3Hg1k2QQwXksFZyYYySeZ1a7
=s4rS
-----END PGP SIGNATURE-----

--=-SLVdGm0ARJW/GLNp6UxW--

