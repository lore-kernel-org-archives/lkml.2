Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0KLOBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 09:01:45 -0500
Received: from ms01.sssup.it ([193.205.80.99]:60089 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932212Ab0KLOBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 09:01:43 -0500
Subject: Re: [RFC][PATCH 09/22] sched: add period support for -deadline
 tasks
From: Raistlin <raistlin@linux.it>
To: Luca Abeni <luca.abeni@unitn.it>
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
        Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <4CDD453A.70502@unitn.it>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334050.8661.150.camel@Palantir>  <1289503054.2084.156.camel@laptop>
	 <1289503883.6525.107.camel@Palantir>  <4CDD453A.70502@unitn.it>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-n8Qx5F62TFvU11rQVYvB"
Date: Fri, 12 Nov 2010 15:01:28 +0100
Message-ID: <1289570488.6525.415.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-n8Qx5F62TFvU11rQVYvB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-12 at 14:46 +0100, Luca Abeni wrote:
> > So, what you think we should do? Can I go for this latter option?
> The one with min{} is at lest correct :)
>=20
Seems that Peter agrees (and I'm Tommaso would agree too) so, copy
that! ;-P

Thanks,
Dario
--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-n8Qx5F62TFvU11rQVYvB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdSLgACgkQk4XaBE3IOsRQSQCfb9jvcYNfoFuu8y8yA8wgseVe
oecAnR7qGzUt2uZzEwcB8rMgZmj4NGwx
=PChD
-----END PGP SIGNATURE-----

--=-n8Qx5F62TFvU11rQVYvB--

