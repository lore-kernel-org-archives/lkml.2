Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2DFBKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 21:10:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42211 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753867Ab2DFBKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 21:10:16 -0400
Message-ID: <1333674603.443.43.camel@deadeye>
Subject: Re: [ 101/175] mm: vmscan: forcibly scan highmem if there are too
 many buffer_heads pinning highmem
From: Ben Hutchings <ben@decadent.org.uk>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stuart Foster <smf.linux@ntlworld.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Fri, 06 Apr 2012 02:10:03 +0100
In-Reply-To: <20120405202435.GA11562@suse.de>
References: <20120330194845.531765417@linuxfoundation.org>
	 <1333422093.443.32.camel@deadeye> <20120405202435.GA11562@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LfEy5Qp4WzyXjVJvixVC"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LfEy5Qp4WzyXjVJvixVC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-04-05 at 13:31 -0700, Mel Gorman wrote:
[...]
> > > Addresses https://bugzilla.kernel.org/show_bug.cgi?id=3D42578
> > [...]
> >=20
> > but this bug was reported against 3.1.9, so the fix is presumably neede=
d
> > for 3.2 at least.
> >=20
> > Presumably the upstream change doesn't apply cleanly and would need to
> > be backported.  Is anyone planning to do that?
> >=20
>=20
> It probably does not apply cleanly and considering how the bug is
> triggered I was not treating it as a high priority. Nikola Ciprich
> (added to cc) had said that he might try backporting it and I would
> review the result. I have not heard anything since. I can take a look at
> backporting it next week if it is considered a common problem.

I really don't know; I'm happy to leave it to you and the other mm
maintainers to decide if it's worthwhile.

Ben.

--=20
Ben Hutchings
Reality is just a crutch for people who can't handle science fiction.

--=-LfEy5Qp4WzyXjVJvixVC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT35Ca+e/yOyVhhEJAQqlOA//Wqh3rUsSbzyQgp0bNPbVmZrFo+3o/VQC
nwG/KUY+t6xANhdER+Cu3FDizUZswK5z442U1ihV3a6QoVnJZ+HwfAarfAfMm7G9
2vJ6NFSdMOobd0FgrZi7xedtBNzLk5esbWd9Pb8v4KcZTDW34oni7VQhBXew0muq
3EsTpLq2/vt0CUFXyxiRr3CoE4QIRwZCNxDzpdrQb5yIwLp3X7u+nJkAdWRDcpri
rgCz6GQ6FjgC/1jCGejdg838/ofzlxIIbwUtfgqo3+JXCDq51lq8T8NtHxr7XsXA
bH3qVo9AxJpKh3mszuwuZBs3aKKHamhc8Ohgdq96olYYuNi3+uYn70lm4JZwXYQf
qtlSxHZtdOQtnbn27a9agSlK5wfH5ic/9PUTwmqNYCdU5ILkc+fVFN/WrNyHqgdo
poBmHWw7CHvaQ9LAImOhMqKaF9JdXOTl92WX1Yif6lTHsblWW+HU2C8dvuq16LA0
bRO2mIQvpbwTxCc67CnGJpuhnhuThVS4IxoveaA1EHZ1T/OffplnL5upPWGB9y3Y
KBY380V/P20440fMgUlhLYo18SS1qlS0c104g5yfHU3UCto5Ne5b15npwwaXmZRg
XO8HWhSWC4CKOS9AD3b3GhnNbQbd7UUN4gsVzvLl9xvHBwRwRYcrkbQt/a1SzJwv
16IG6XIhvqg=
=RLi7
-----END PGP SIGNATURE-----

--=-LfEy5Qp4WzyXjVJvixVC--
