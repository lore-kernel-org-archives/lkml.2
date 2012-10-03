Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab2JCPTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:19:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47014 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932546Ab2JCPNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:13:54 -0400
Message-ID: <1349277229.16173.24.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 026/180] eCryptfs: Improve statfs reporting
From: Ben Hutchings <ben@decadent.org.uk>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: Tyler Hicks <tyhicks@canonical.com>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>
Date: Wed, 03 Oct 2012 16:13:49 +0100
In-Reply-To: <506ADCEB.1040109@canonical.com>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
	 <20121001225158.719221314@1wt.eu> <20121002054655.GA17360@boyd>
	 <506ADCEB.1040109@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LQXaHRwQMeixGo4aDGaS"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LQXaHRwQMeixGo4aDGaS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-10-02 at 06:24 -0600, Tim Gardner wrote:
> On 10/01/2012 11:46 PM, Tyler Hicks wrote:
> > On 2012-10-02 00:52:23, Willy Tarreau wrote:
> >> 2.6.32-longterm review patch.  If anyone has any objections,
> >> please let me know.
> >=20
> > Hi - Please drop this patch. It incorrectly calculates f_namelen
> > and I haven't had a chance to fix it yet. When I get a fix ready,
> > I'll forward the corrected patch to stable@v.k.o. Thanks!
> >=20
> > Tyler
> >=20
> >>=20
> >> ------------------
> >>=20
> >> From: Tyler Hicks <tyhicks@canonical.com>
> >>=20
> >> commit 4a26620df451ad46151ad21d711ed43e963c004e upstream.
[...]
> Tyler - this is the same patch that we're carrying in every kernel
> from Lucid to Quantal, right ? Colin has verified test cases for this,
> so I'm curious what you think is wrong. Something unique to 2.6.32 ?
>=20
> https://bugs.launchpad.net/ecryptfs/+bug/885744/comments/5
> https://bugs.launchpad.net/ecryptfs/+bug/885744/comments/9

As I said in <1344208574.13142.59.camel@deadeye.wl.decadent.org.uk>,
pathconf(_PC_NAME_MAX) needs to report an upper bound on the maximum
name length, not a lower bound, so that readdir_r() can be used safely.

Ben.

--=20
Ben Hutchings
For every complex problem
there is a solution that is simple, neat, and wrong.

--=-LQXaHRwQMeixGo4aDGaS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUGxWLee/yOyVhhEJAQpYbg//SQRYDL66oU3YT5dzEUuGKbb4jSH3kW1p
PFdoenFgWMd+RKb4Jcq6IYmEpIf3L27ml6tjlrKGgYeQLV427b7V+CJar/nV0rM1
vsVuBf8gqxGvE8jXxfe06V6GkGK4fEwxIhimh56JuiJhImXf/nfSnwWn8awCt4HK
veKjFIICDj0esB6ZpG+0oyVPtGmORUpK2qkM9TjvBKDlsj9CxsCsAnIi1IQ0VsjQ
8muF96/ojDBmuSYKQY6oVcMxa4kia5KnMAou/9EqOo8EX4CHNdUKONe7ZpKlcofS
KlzZSYckZ81MWt5mfZ4fYLRHMrWBtTpP1lHvsYwWLy4M3BXbIUxH/ROqJh9z2opt
o+5A+vpRQzMgs46IWojzJcO525TlxhdpAQ79+znnN2D8nWR3TbPqpOmxrYAicZos
/lde3jFDUiAW4swWXzvZ0gbg5iEqgwZ5u44XggE/Jul1uygTiVz/nEj9jnG9oMt7
ibRardLAosfXX2n6/itW1r7K988f6bWNPkew3gkAc8zH7jqoq3klp3Y/AMK4gnKK
O0eN+LQIa/383bPwaYa9e6QGsGzSB82QJ90NbdY7enNOb/JIKyRwD9AK8YT+LhOV
AGazES9kJNQ9KOq5eXNw8s4+aoxWAaWBzgJwyY0/h5uHaAhytwEAx6Qf+bB2/q4Y
i7lzcMXE5pg=
=QO26
-----END PGP SIGNATURE-----

--=-LQXaHRwQMeixGo4aDGaS--
