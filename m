Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2JOXKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:10:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40711 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab2JOXKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:10:01 -0400
Date: Tue, 16 Oct 2012 10:09:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the kmemleak tree with Linus' tree
Message-Id: <20121016100956.01325e0782b6c0aa1a2c2683@canb.auug.org.au>
In-Reply-To: <20121012152205.GA13957@arm.com>
References: <20121010140644.0235454126ca50b7f60d1f59@canb.auug.org.au>
	<20121010045553.GB3975@swordfish>
	<20121012152205.GA13957@arm.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Oct_2012_10_09_56_+1100_FOD1RZxjXvpcgAFA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Oct_2012_10_09_56_+1100_FOD1RZxjXvpcgAFA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

On Fri, 12 Oct 2012 16:22:06 +0100 Catalin Marinas <catalin.marinas@arm.com=
> wrote:
>
> I've updated my kmemleak branch now. Stephen, I guess you can remove
> this branch since I don't have any outstanding kmemleak patches.

Done.  Let me know if you get enthused about it again :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__16_Oct_2012_10_09_56_+1100_FOD1RZxjXvpcgAFA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQfJfEAAoJEECxmPOUX5FEC1kP+wQcClw+taGs29sYnM6Vzc5y
thcSGis+eB/PR1MwpqBFDQQ36N6PXU7T8sP+bfvAkb1EyYsAa7mcdxV8ohrYfrdS
xIiu/kDw6IXUbOQwy3i+2/gSo+lgumCTyhY2oe9N+EUAoRE++wcnIb+QSWMudO+j
uTKY3qiktyXFY3S4DJvmIVaUkJDyO3OuwzBE22ko2RBZl4rGmZddL2hUqFa4kR3C
VwwPEWMdCb3YyTFpkRkMTaUgR3zHE4rtgjCYIUbvm8jJNbI9jEzkuU+Ns7d9RUPp
9ilbf6WK5Wafns1EUpuQHHMrcY4oeXw7hFNwrPyvMHXf+7zwtfdpT27KSL1GoML+
2bKMiy6VwjUeWLJv/UJobvkFEXm217L7u0pZBlSRtYz6qvET3T0kvYhhfgSSeL64
pY4FNVq5y/5XWFL/JIUEULSVgi/okO/j35KtDSxM0wWCMKRlNsESzOjUsNyp7qw5
ZRQ/YTJKuv31ySMd4vnylw5TpSgeERLW5fQC5J6Zis79mFLCchJV5i/UY3my9Ijn
Cv+fhkmp3+b7gEuDelOcHBzyxMwKxVE7CPQ4M5Y5hfrHt4DyvDiF8QUk63Z2pQcX
ufV9xh9nYjJPwm2X5qky/njGiDi9rZ+H5hg00+SVfOUKoJxOgYk92hrd8OGUiSKa
7Yw+KId5tOU5wiIfut1u
=qZV7
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Oct_2012_10_09_56_+1100_FOD1RZxjXvpcgAFA--
