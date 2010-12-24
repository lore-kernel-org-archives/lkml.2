Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab0LXIUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 03:20:15 -0500
Received: from ms01.sssup.it ([193.205.80.99]:35091 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751673Ab0LXIUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 03:20:14 -0500
Subject: Re: [RFC PATCH 01/15] nohz_task: New mask for cpus having nohz task
From: Dario Faggioli <raistlin@linux.it>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <4D145339.1080205@cn.fujitsu.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-2-git-send-email-fweisbec@gmail.com>
	 <4D145339.1080205@cn.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UxXOurhOtNN9RUbL9R5u"
Date: Fri, 24 Dec 2010 09:19:56 +0100
Message-ID: <1293178796.3182.2.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UxXOurhOtNN9RUbL9R5u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-12-24 at 16:00 +0800, Lai Jiangshan wrote:=20
> On 12/20/2010 11:24 PM, Frederic Weisbecker wrote:
> > =20
> > +config NO_HZ_TASK
> > +       bool "Tickless task"
> > +       depends on HAVE_NO_HZ_TASK && NO_HZ && SMP && HIGH_RES_TIMERS
> > +       help
> > +         When a task runs alone on a CPU and switches into this mode,
> > +         the timer interrupt will only trigger when it is strictly
> > +         needed.
>=20
> Why it depends on SMP?
>=20
I guess that's because you need at least a ticking CPU for timekeeping
and stuff... Right?

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-UxXOurhOtNN9RUbL9R5u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0UV6YACgkQk4XaBE3IOsS7VQCfYOH5A5UGlJSM+ZSTKtkJ8Bos
0BwAn0akwEPdmiwVK/9VonkdZ3Xc27Fk
=deaT
-----END PGP SIGNATURE-----

--=-UxXOurhOtNN9RUbL9R5u--

