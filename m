Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab1DXECM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 00:02:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57328 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716Ab1DXECI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 00:02:08 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20110423180450.GB25379@merkur.ravnborg.org>
References: <1303580576.4815.3.camel@localhost>
	 <20110423180450.GB25379@merkur.ravnborg.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-8so05D3HjDmT2hE1IYvt"
Date: Sun, 24 Apr 2011 05:02:01 +0100
Message-ID: <1303617721.3032.88.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] kconfig: Avoid buffer underrun in choice input
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8so05D3HjDmT2hE1IYvt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-04-23 at 20:04 +0200, Sam Ravnborg wrote:
> On Sat, Apr 23, 2011 at 06:42:56PM +0100, Ben Hutchings wrote:
> > commit 40aee729b350672c2550640622416a855e27938f ('kconfig: fix default
> > value for choice input') fixed some cases where kconfig would select
> > the wrong option from a choice with a single valid option and thus
> > enter an infinite loop.
> >=20
> > However, this broke the test for user input of the form 'N?', because
> > when kconfig selects the single valid option the input is zero-length
> > and the test will read the byte before the input buffer.  If this
> > happens to contain '?' (as it will in a mips build on Debian unstable
> > today) then kconfig again enters an infinite loop.
> >=20
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > Cc: stable@kernel.org [2.6.17+]
> > ---
> > Roman has failed to respond to this after 5 weeks and one reminder, so
> > please take it directly.
>=20
> No-one has heard from Roman Zippel in several years.
> I have suggested Michal Marek to take over the maintainer
> role - as he in practice is the kconfig maintainer.

Can someone please update MAINTAINERS then?  What is the point of it if
people don't update it for years?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-8so05D3HjDmT2hE1IYvt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATbOguee/yOyVhhEJAQreXg/9Gze77M+YCwucdIY8tsNJodnYFcG4M/wX
RK14b5Pc2ViSlPX6nRuAZYW8+wYwizjqQLhw/eVVEhkgih13lvo1iljm46FXxIFy
ffHIwZ7oDA/bVdH0yBF6RGP9Y/UmEHr1RH2g2a17KYnpL/u7Dj6dTlbjZjyJ9NvP
ojKATVSFj8w5AKNQbYyiJ/0cn7gRNKDw/i6F9ad42eyvBMzRjWj1wn+0+/hX5o/J
vGLuxtMGtVrV9NG+S159RKlRep8vSi26j1bGSHJVpdwGLjJ44HFK27FLgC+wdvlM
dB8HPJpcKTqMOVY1tnC21uqSRVHlA4P6UQDIwoyfzfbRJp/luvRx7KdhAR+2MzWI
HTAyUa3k1O2NTmZzbTe4kcWOBunnRe4kFc5n3aYn6ZYu87iqpfjWiVK7Zl2R1qID
zxINcHD+DMScnuSy8B/06r9YbPvx484Uc/4hCtj9e2FIGW5fmxUlgOHcAcGklE0w
NDNpUfIyrVenznNz73gxRObXPuTwU5SLaFOnyhX7Y/INZbgT6suMgEIYJ5lHgn8t
I5Ci4+qdMYa1rGgC1xjHvl8BZ+VHXOgJEaALCOX8Z5G7wIknZHo5OqA88yNDxKUB
kSc21AmHdjoeTx3UsLd6saV87xZNVeAiYxYwDUn8QqI0XEjocJYRKU9V7JLxkmw1
r6zP33K5YiM=
=tprU
-----END PGP SIGNATURE-----

--=-8so05D3HjDmT2hE1IYvt--
