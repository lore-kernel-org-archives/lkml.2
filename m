Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0KBDU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 23:20:26 -0400
Received: from ozlabs.org ([203.10.76.45]:34670 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab0KBDUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 23:20:24 -0400
Subject: Re: [PATCH 04/39] arch/powerpc: Update WARN uses
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1288662607.366.249.camel@Joe-Laptop>
References: <cover.1288471897.git.joe@perches.com>
	 <c6c46b5924e1cc9720d3ad76e6c11e982bd661e5.1288471898.git.joe@perches.com>
	 <1288609334.10671.4.camel@concordia>  <1288622509.366.237.camel@Joe-Laptop>
	 <1288657560.16790.8.camel@concordia>  <1288662607.366.249.camel@Joe-Laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XOQysx5rOrhKcB0rmu3R"
Date: Tue, 02 Nov 2010 14:20:21 +1100
Message-ID: <1288668021.16790.30.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XOQysx5rOrhKcB0rmu3R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-11-01 at 18:50 -0700, Joe Perches wrote:
> On Tue, 2010-11-02 at 11:26 +1100, Michael Ellerman wrote:
> > On Mon, 2010-11-01 at 07:41 -0700, Joe Perches wrote:
> > > Pretty much.  Format coalescing is generally preferred for grep.
> > Really? Grep doesn't work anyway because you have format specifiers, an=
d
> > although you can try and guess them .. good luck, 0x%lx, or 0x%llx, or
> > %#lx or ..
>=20
> grep "Breakpoint at .* will be disabled"

Sure. For more mundane and repeated error strings the .* can be a pain
in that it matches too much.

But whatever, I'll start writing my code with uncollapsed string
formats, and wait for the torrent of make-it-80-columns patches :)

cheers

--=-XOQysx5rOrhKcB0rmu3R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzPg3UACgkQdSjSd0sB4dI/NQCgwzC0RlDBg5aaMaSPUILHJBNG
8t0AoIxsvGRBg2MY8WLgUVud+EmaYAPU
=46vd
-----END PGP SIGNATURE-----

--=-XOQysx5rOrhKcB0rmu3R--

