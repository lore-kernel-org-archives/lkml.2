Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab0KLVbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:31:12 -0500
Received: from ms01.sssup.it ([193.205.80.99]:46301 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757228Ab0KLVbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:31:11 -0500
Subject: Re: [RFC][PATCH 13/22] sched: add resource limits for -deadline
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
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289505471.2084.191.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334250.8661.154.camel@Palantir>  <1289505471.2084.191.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gSGwQ7wTACyWdGmyayrD"
Date: Fri, 12 Nov 2010 22:30:55 +0100
Message-ID: <1289597455.6525.786.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gSGwQ7wTACyWdGmyayrD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-11-11 at 20:57 +0100, Peter Zijlstra wrote:
> > In fact, this patch:
> >  - adds the resource limit RLIMIT_DLDLINE, which is the minimum value
> >    a user task can use as its own deadline;
> >  - adds the resource limit RLIMIT_DLRTIME, which is the maximum value
> >    a user task can use as it own runtime.
> >=20
>
> We might also want to add an additional !SYS_CAP_ADMIN global bandwidth
> cap much like the existing sysctl bandwidth cap.
>=20
Mmm... I think we've never discussed much about that before, so here I
am. I'm currently asking one to be root to set SCHED_DEADLINE as his
policy. Normal users are allowed to do so, but just under the rlimits
restrictions provided by this patch.

So, first of all, are we cool with this? Or do we want normal users to
be able to give their tasks SCHED_DEADLINE policy by default? Maybe we
want that but up to a certain bandwidth? Is this that you mean here,
having two bandwidth limits, one of which !SYS_ADMINs could not cross?

Sorry for being annoying, but I've never got any feedback on this, while
I think it's something really important.

Thanks,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-gSGwQ7wTACyWdGmyayrD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzdsg8ACgkQk4XaBE3IOsRGvgCfTAUDyL4oSdcyBRBDFr93csrq
5WcAn0SE30rUOPxEhkxZfE/wpkGe9G0j
=zxnx
-----END PGP SIGNATURE-----

--=-gSGwQ7wTACyWdGmyayrD--

