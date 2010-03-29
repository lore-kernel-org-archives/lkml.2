Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab0C2B66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 21:58:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43933 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755574Ab0C2B64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 21:58:56 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bzolnier@gmail.com, gregkh@suse.de, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100329105129Y.fujita.tomonori@lab.ntt.co.jp>
References: <alpine.DEB.2.00.1003282040480.4731@ernie.pinecrest>
	 <1269821357.8653.231.camel@localhost> <1269822285.8653.251.camel@localhost>
	 <20100329105129Y.fujita.tomonori@lab.ntt.co.jp>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Q8rv1qp9uJMdiTBLXAoa"
Date: Mon, 29 Mar 2010 02:58:48 +0100
Message-ID: <1269827928.8653.307.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] rt28xx: Make PCI_{MAP,UNMAP}_SINGLE type-safe
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q8rv1qp9uJMdiTBLXAoa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-03-29 at 10:52 +0900, FUJITA Tomonori wrote:
> On Mon, 29 Mar 2010 01:24:45 +0100
> Ben Hutchings <ben@decadent.org.uk> wrote:
>=20
> > To avoid recurrence of bugs such as <http://bugs.debian.org/575726>,
> > change the type of the first parameter to linux_pci_{map,unmap}_single(=
)
> > from void * to struct rt_rtmp_adapter *.  Also do not define the macros
> > PCI_{MAP,UNMAP}_SINGLE() when building the rt2870sta driver; they are
> > not used and if they were that would be a bug.
> >=20
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>=20
> > ---
> >  drivers/staging/rt2860/rt_linux.h    |   14 +++++---------
> >  drivers/staging/rt2860/rt_pci_rbus.c |   12 ++++--------
> >  2 files changed, 9 insertions(+), 17 deletions(-)
>=20
> I think using dma_map_single directly instead of inventing a wrapper
> function make the code more readable.

These functions are not quite simple wrappers, unfortunately.  So while
I think that is worth doing it is a separate change.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-Q8rv1qp9uJMdiTBLXAoa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS7AJU+e/yOyVhhEJAQKrhxAAp+1mlpLImDFwQQWVuBs0i5ErYgDG/5Tu
gx0Nn6jMifHApbN7bdmjWPImQ6jTvtMsjw74qNsGnmR34bikiTDijt/6PjHjT0AV
LP0aB8wubofGCKDVYKaXbUpIrSmE4KLRnYqefsoOKr460Fn/6elfk6O8avdMfNUy
/r8cpJIGyz9lLOi7jL3jHPELKPBmFg8Fmr+YEuKtwhrIpKTRrva4s7L1r6g/vmHO
JwRW2uL5BeDfGn338P3kxAdazc5oQp6cGHSh6VQpJjqwgDhXqZ7vbIe/MebfabOR
u/sIWfeywBCAJt5837Oa+lsOfT4knISNNW3h4WpKhcMIrWric35VGOv0dGhrhnM4
Jp2ON0VN00eropgYY1OwXqLo+qg8jxpAlQAftNn5ssHGKZ3lTSz+JrSGJMX4DSra
jq18RFgKw1Rf/pOEVpNmiMqETYJ8AOrHUAgbGJeH+G+jteubexPzcDoOgzRKE4zT
UIFjB+cEiqudYRLmmtQxKLjDRxyuMrc7WXNQQ+G0R+LStWi+7YENZ1nx2t79aCQw
+PGbBWlS7iIjkhY/i7mmaEhWj6Ua6azUsXeyJBLd37ok2GMURbljByeIxcBwr8Gl
YcbQtdZcNn7MYyaaZtZZNwLquYGsRQi/VkXvh/VZs9ZuobH6tWL7uGeFVEJn30zt
7HPp+MP8Z9E=
=qdpd
-----END PGP SIGNATURE-----

--=-Q8rv1qp9uJMdiTBLXAoa--
