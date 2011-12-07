Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab1LGUYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:24:25 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37391 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab1LGUYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:24:24 -0500
Date: Thu, 8 Dec 2011 07:24:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree (pci
 tree related)
Message-Id: <20111208072412.e9cf00f9bcdbc4450fe2d2d4@canb.auug.org.au>
In-Reply-To: <CAErSpo59CuEBbu4QWMkK23TyXafhMLOh1G7Z8YxojqiQmCM0Fw@mail.gmail.com>
References: <20111207170533.3dea865573c916e79d274eca@canb.auug.org.au>
	<CAErSpo59CuEBbu4QWMkK23TyXafhMLOh1G7Z8YxojqiQmCM0Fw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Dec_2011_07_24_12_+1100_2MMqbw3gXn5Slf.A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Dec_2011_07_24_12_+1100_2MMqbw3gXn5Slf.A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

On Wed, 7 Dec 2011 08:08:43 -0700 Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> Thanks for doing that, sorry for the trouble.  I don't have a set of
> cross-compilers, unfortunately, but I will inspect the rest manually.
> Do we have to discover problems one-by-one, or can you tell us about
> any other arch build problems at the same time?

Well, I only have time to do a couple of arches by hand during the day,
but overnight we build almost all arches - see
http://kisskb.ellerman.id.au/linux-next .

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__8_Dec_2011_07_24_12_+1100_2MMqbw3gXn5Slf.A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO38tsAAoJEECxmPOUX5FEUkcP/3KoJYmNBaLHmcqaA8rxwtYK
8tQrbbIqsjy6+dhhgqk8QmLAjKHTbaFm2cqUlFnU7JxgHAgQBJEqpDxeNP2Ikd+z
8qoDOz1qZfjIQM9mkCtxQDiqR4a6yTfrbmtAePGHjLgfszgpvpJukpToQGyx0cN7
k+CZp3nF827bAHL1XTLmo9oY5H395avYWuhHAdCMRp8Nd14CTX0ZtXV+dQcl8Usi
YeDVPkd1dxoU9MWwCmzOJ07SQdg5edCNJwNIZnLS9SoCqjmkX5s4AutWQnZqi87o
uQ08fBm4qjWXpffTdAMUbpHyZiRULtwtdHdDvvzLF3gjHu8kHAC5z8udLHQIh0hJ
Xb8zQBDFGPM4aBttRLcZaeUIOZHoPLJPfcHncjv0iLhjFq8Gy9PC5GKYfq2uF+1z
gG8CFPeSEVI2aJ7p4Dyt/cfRr00BWq4Vcl41C7pRxrEiIdqvYZPZGvxLwXllD2pj
9ZZAwjQte0kwd1/9D8pGCjvgvtC7Qg89X4GyfcCtltrc3RT7yyBlhk1vEe7GBi4p
nalBC6on5mwM62dp0219f1Zn9ScqwFGXBSkF2xLXalSAwMilZeTavTeInKAAN0Zd
S3FmyEzOXuvrFBnftDEwC/p3zTULQ+kfP2wHjM/D10uxz5EQ+8CaBD10jPN/K+XZ
4kquX9iWphVHr28EZPGl
=P3iD
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Dec_2011_07_24_12_+1100_2MMqbw3gXn5Slf.A--
