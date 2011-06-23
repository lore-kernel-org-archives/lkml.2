Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab1FWB3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:29:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43631 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758238Ab1FWB3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:29:16 -0400
Date: Thu, 23 Jun 2011 11:29:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: brcm80211 build busted on big-endian
Message-Id: <20110623112903.1d7f9e9b.sfr@canb.auug.org.au>
In-Reply-To: <20110622.132301.937541188453252019.davem@davemloft.net>
References: <20110621.193641.1605224831578508501.davem@davemloft.net>
	<20110622154022.GB19027@kroah.com>
	<20110622.132301.937541188453252019.davem@davemloft.net>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Jun_2011_11_29_03_+1000_u4gYHxrvrIDUZu4E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Jun_2011_11_29_03_+1000_u4gYHxrvrIDUZu4E
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 22 Jun 2011 13:23:01 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Greg KH <greg@kroah.com>
> Date: Wed, 22 Jun 2011 08:40:22 -0700
>=20
> > For big endian, I agree, which is why I thought I fixed this up so it
> > wouldn't build on other arches than MIPS for the moment.
> >=20
> > Is this blowing up in -next or in Linus's tree right now?
>=20
> Yes, on sparc64.

Yesterday's linux-next allmodconfig build on sparc64:

http://kisskb.ellerman.id.au/kisskb/buildresult/4241857/

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Jun_2011_11_29_03_+1000_u4gYHxrvrIDUZu4E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOApbfAAoJEDMEi1NhKgbsr9sH/0NBeRVgzr8GhGWZ9j0t5q8o
2DkLRtgcLOATDOik+XYrktbXiJb32gfsA0jz0I22v4RefwhfScRm2TwlKEUh7nv7
i9kRhWrRj+UZmoXEWlIaxO7B2gFrjQ9KjzLChEvDI0piD6WBqjc2QXlquYbouVNy
fih2QFW3fo8+UAErJxovd7HKYCR8PzUbgoTaxP+u7q8acQ3sm6V3neoGMXCtui26
uxz4lfU9IsbL8mEuQTr56/LqaymO7m2diqu/2wo5twbAjBHLXul3xY2Fe3OzLJuY
WqgyXjiTSA9moiSZPHhpecrsYSh7dg9prJrEGj0STuqP33ddjp8dd54qpyOMQp4=
=/FkJ
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Jun_2011_11_29_03_+1000_u4gYHxrvrIDUZu4E--
