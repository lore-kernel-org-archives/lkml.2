Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1AGOWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:22:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36873 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab1AGOWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:22:23 -0500
Date: Sat, 8 Jan 2011 01:22:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the block tree
Message-Id: <20110108012211.1e19f0f7.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTimpVMLGBnP33Ro8MBtW3GJjskg0bBK717Xf-Mh_@mail.gmail.com>
References: <20110107110513.30776114.sfr@canb.auug.org.au>
	<4D26C179.7030704@kernel.dk>
	<AANLkTinyaZfsYv43046LWgu8U3kg6_79y+PTFO1RxtnY@mail.gmail.com>
	<20110107231748.76170ff3.sfr@canb.auug.org.au>
	<AANLkTimpVMLGBnP33Ro8MBtW3GJjskg0bBK717Xf-Mh_@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__8_Jan_2011_01_22_11_+1100_91nnHwaZBJ5k_2pw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__8_Jan_2011_01_22_11_+1100_91nnHwaZBJ5k_2pw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 7 Jan 2011 14:19:33 +0100 Sedat Dilek <sedat.dilek@googlemail.com> =
wrote:
>
> Hmm, I have pulled-in freshly from linux-2.6-block#for-next after you
> published latest linux-next (next-20110107).
> So, I guessed the (reported) issue is fixed, now.

No, the commit that caused the warnings was removed when I went back to
using the block tree from next-20110106.  So it will come back unless
fixed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__8_Jan_2011_01_22_11_+1100_91nnHwaZBJ5k_2pw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNJyGTAAoJEDMEi1NhKgbstd4H/2jQzCcWw6jm5va7h8bF3aGH
ijv/UjpdVYC81UQoaXNGgDyRCrGa1ykFcWJenvKdOueJAeOK3QxvCR2T/Y4BPdgz
DWDAvtKl4ttFD0phmzKP8FCP9Ak+qmRpcQHRAzJq9aJsW0r5gAmwSBCfQZRO4hYk
fbZs1jPCtX2rHIxABznqMPWcikJYhNl4DxQnzk5d0GEeq66zYtzrtt5DJCaWhgqq
sBNuHSEjRexHqAfBJQ5g6Ww/6yTbAAAn2J9aWVNnfo1ziHfLPvQcrq7kZXGzrWMx
DwukcFeWvntKjTV5g5MBbsjH3HhEQcYg6T9v/qxvGcUk6oUYXIOxt21eKh+u8r4=
=dnhQ
-----END PGP SIGNATURE-----

--Signature=_Sat__8_Jan_2011_01_22_11_+1100_91nnHwaZBJ5k_2pw--
