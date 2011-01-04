Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab1ADSIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 13:08:51 -0500
Received: from ms01.sssup.it ([193.205.80.99]:48724 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751022Ab1ADSIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 13:08:50 -0500
Subject: Re: [RFC][PATCH 0/3] Refactoring sched_entity and sched_rt_entity.
From: Dario Faggioli <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Gregory Haskins <ghaskins@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Darren Hart <darren@dvhart.com>, oleg <oleg@redhat.com>,
        paulmck <paulmck@linux.vnet.ibm.com>, pjt@google.com,
        bharata@linux.vnet.ibm.co
In-Reply-To: <1294159303.2016.167.camel@laptop>
References: <1294156524.6169.147.camel@Palantir>
	 <AANLkTi=wCmetef0tjfvdHtZMS9x4eswhL_xAM5Ybdwq+@mail.gmail.com>
	 <1294159303.2016.167.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ju6dzRm/Kh5B3e20Ox28"
Date: Tue, 04 Jan 2011 19:08:25 +0100
Message-ID: <1294164505.6169.193.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ju6dzRm/Kh5B3e20Ox28
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-01-04 at 17:41 +0100, Peter Zijlstra wrote:=20
> > Peter, isn't sched_fair_entity a better name?
> >=20
> >=20
> Yeah, it probably is..
>
As you wish. I know it's just one letter longer, but be prepared for it
to break a lot of lines, since you may find four of it in a row! :-P

Thanks and Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://retis.sssup.it/people/faggioli -- dario.faggioli@jabber.org

--=-ju6dzRm/Kh5B3e20Ox28
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk0jYhkACgkQk4XaBE3IOsRzsgCbBgrobAHdONnuyXNyNxPNO72i
VpAAoIXb/kaO4p3d3afCmSFamLG/dE/L
=JKjL
-----END PGP SIGNATURE-----

--=-ju6dzRm/Kh5B3e20Ox28--

