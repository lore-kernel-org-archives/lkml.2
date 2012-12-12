Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab2LLSI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:08:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:41905 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab2LLSI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:08:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,267,1355126400"; 
   d="asc'?scan'208";a="232908588"
Date: Wed, 12 Dec 2012 20:09:04 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: introduce numa_zero_pfn
Message-ID: <20121212180904.GA21909@otc-wbsnb-06>
References: <1355331819-8728-1-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <1355331819-8728-1-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 13, 2012 at 02:03:39AM +0900, Joonsoo Kim wrote:
> Currently, we use just *one* zero page regardless of user process' node.
> When user process read zero page, at first, cpu should load this
> to cpu cache. If node of cpu is not same as node of zero page, loading
> takes long time. If we make zero pages for each nodes and use them
> adequetly, we can reduce this overhead.
>=20
> This patch implement basic infrastructure for numa_zero_pfn.
> It is default disabled, because it doesn't provide page coloring and
> some architecture use page coloring for zero page.

Do you have benchmark numbers?

--=20
 Kirill A. Shutemov

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQyMhAAAoJEAd+omnVudOMPT0QAKSyz4YV0qNR9W71xQGBT6Z6
JsRgBvuVf9ukcFFjvqhS5Ax1PmdWDfWdhxcvYPHlfdYHDHl18S6rba9A15po2+sC
4Uz51Ac3BnXI+BK6A53fqHfnL/+QKNzLlmDcrYRE1V1QOxezQhTnC3K3O3L+3kyv
wmpKK2dL8YKe/pg7+bgWHmad4n3uW4LE+wUsqfX022SgaGL8oxPwGkr6G1EkBaZG
eQOj3DNRzj2bwzg9rQ2n9PP+wc58CzbmAvJvB6QO1Nycs7ALH8iVeXYJGWkjPCdV
iIP5or7xFTSWb6OQL2uq0e9WvHRHIgMC6HMrB9wjJ0QzYsnIMbWb509ElIudpt7+
bYAxpqSY6DD/6pBPIBB7Upd1bKZnAJU7MgrpofQtUpoHfP2LET3L5g7Ny+UXcUMX
U36Jj7WJmUzTmkKfMXU04z2oz9BJmZU63KRpHdoHZzmsaZx8bEaO+NC/pBQqwIDq
2l+ODIFSNPchy6XGzM/jCv+5m4+gC2mWg5YpWxQFKnGIxvz0fbGDm2K+TlV2LygH
NkhvdiEL2IFxdsC2HQs5DOp1BPOC0lJM+kVlz1j8YJvpn/MPZByvJDL+JD+ddsUk
m7rPAFB+C4jKohWOcaD7CcPa1h29V3Q2JL+teN9Xc8cqttu3ayUlbEEq8zD7dfUN
p/jCUX1hZZZNRHx9L/H7
=w9qF
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
