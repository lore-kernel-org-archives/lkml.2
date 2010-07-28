Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0G1BYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 21:24:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38971 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab0G1BYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 21:24:21 -0400
Date: Wed, 28 Jul 2010 11:24:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: aelder@sgi.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 27
Message-Id: <20100728112416.9b160b59.sfr@canb.auug.org.au>
In-Reply-To: <1280255743.2002.184.camel@doink>
References: <20100727160708.722c39c1.sfr@canb.auug.org.au>
	<1280255743.2002.184.camel@doink>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Jul_2010_11_24_16_+1000_glV14rAL+Tp/5teu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Jul_2010_11_24_16_+1000_glV14rAL+Tp/5teu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alex,

On Tue, 27 Jul 2010 13:35:43 -0500 Alex Elder <aelder@sgi.com> wrote:
>
> The XFS master branch has been updated.  It includes
> a fix for the problem caused by this commit:
>=20
>     0fd7275cc42ab734eaa1a2c747e65479bd1e42af
>=20
> ...which was is the cause of this linux-next build failure.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Jul_2010_11_24_16_+1000_glV14rAL+Tp/5teu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMT4bAAAoJEDMEi1NhKgbsxT4H/3mEBBUUFcZ5Pqr3JrjDbRTq
Gmu5gNTdOu6BUnJBfQlk7MX+1KgQdVTKU0mMPhY2M7pDzsrIalr8qGH1M6zXP4qz
BYDi4Yz57Dl+3jYMaqxZOIHwrNAd4sj0RJaYg4VK3Cm9yO5yMJvX6iTM+w3jNvaS
e7BGGmtp+bC9IAw2pgWlKpASd+nWbyVXcPXTn4zeIj2F3obn/Pg5CrWq2w3xz18n
4ZNH1OEtlv4LeYiGMbkjaIdwqNKjdBCD+SkpRAjBtPoU8H2qIpiy7Dkg9629OXHc
Pj7JuJ/6ZAp//XxlEibrgsUbymasqLj/BOVARgePYSEJk1Lpmlf9jV06ycqndPo=
=SEPZ
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Jul_2010_11_24_16_+1000_glV14rAL+Tp/5teu--
