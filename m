Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab2LMJya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 04:54:30 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47589 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2LMJy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 04:54:28 -0500
Date: Thu, 13 Dec 2012 11:47:15 +0200
From: Felipe Balbi <balbi@ti.com>
To: Paolo Pisati <paolo.pisati@canonical.com>
CC: linux-omap <linux-omap@vger.kernel.org>, Paul Walmsley <paul@pwsan.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>,
        Robert Nelson <robertcnelson@gmail.com>, Felipe Balbi <balbi@ti.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] regulator: core: if voltage scaling fails, restore
 original voltage values
Message-ID: <20121213094715.GA1916@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1355389980-5532-1-git-send-email-paolo.pisati@canonical.com>
 <1355389980-5532-2-git-send-email-paolo.pisati@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <1355389980-5532-2-git-send-email-paolo.pisati@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 13, 2012 at 10:13:00AM +0100, Paolo Pisati wrote:
> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
> Tested-by: Robert Nelson <robertcnelson@gmail.com>

please read Documentation/stable_kernel_rules.txt, you'll see this is
wrong.

--=20
balbi

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQyaQjAAoJEIaOsuA1yqREL4gP/A+fOc+wfK72PXrFdLPseFzD
V632DqpylP29pXx5TPiK1fmiwdnA8wGBnD/E6EuExrhTemX3FlXJ6LZm64FrMDwf
rWZRDHyaHso2me7DfFQBLCzU+uOuNAWqEmolp4WTa8jFqJTwyhvlAtrN/e6X5DbB
nHNR/z9DE9t9e/2Z3ae6Z0lsXiig8hP49sgb5EumhcS/0Sg8y3mSIkmNm7LNUARF
gFonnJjUp9V2BDpkbBalhK1jh2aa5ZmyNytp83dRLIxiNYujjwAd5foajhnA8Bqn
Zt7m8i4ueWxFFy7+E9ddaNTG3Ri1/p3J4sXbaXylX7h5j29k6h6/CZSHymjWK+1Z
jHXnVy9K3ZxethbAb+6eAmQ5guR4PXDlTsCZ3jGHKm54k0yMBoIzo5Iks51YqmUw
U2d0JrkSdD9n9J4CGhPTtc9nTsTa9oVX2RU/zJJLOlzaNDjzycX+oPCwjbPbsxmj
U+1jGmle3RWEWTGSK4SnnHhTqKIzvFXLJ1VopwIo8V5COb9NlJEI850jybB2iu2n
zArrDzpDNDVzomIiWYnnKjhAcSpX26qUVbQuvkjHCvwz9kuWZejHrMQ4AuMLxFfz
ORP2Q+opSQeYpkWZi+k5a5otv28nqx3DySxN6qIHw3gvQABSWXG2HfJUS+D1rrPH
+XTPi4kRTwO4WMwZ+/Tg
=ZObJ
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
