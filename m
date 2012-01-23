Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab2AWFF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 00:05:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51202 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab2AWFF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 00:05:57 -0500
Date: Mon, 23 Jan 2012 16:05:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Henning Heinold <heinold@inf.fu-berlin.de>,
        Varun Wadekar <vwadekar@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>
Subject: Re: linux-next: manual merge of the crypto tree with the tegra tree
Message-Id: <20120123160546.b3b6b80e3e40499cfa3193f7@canb.auug.org.au>
In-Reply-To: <CAOesGMgH0owngSkJq72Wf01Z7YSsD9pzRZWtzSvZt+Q7ZA6qng@mail.gmail.com>
References: <20120123120933.6d4c9cc7050fce2e9fbc9d3a@canb.auug.org.au>
	<CAOesGMgH0owngSkJq72Wf01Z7YSsD9pzRZWtzSvZt+Q7ZA6qng@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Jan_2012_16_05_46_+1100_2IXEGPjDVirOfqUk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Jan_2012_16_05_46_+1100_2IXEGPjDVirOfqUk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Olof,

On Sun, 22 Jan 2012 20:24:16 -0800 Olof Johansson <olof@lixom.net> wrote:
>
> I should cherry-pick in the same change as Herbert is carrying, and do
> the rest of the fuse changes on top of that. I'll do that for
> tomorrows -next.

Only if its going to get much worse or you need the change.  The conflict
is trivial ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Jan_2012_16_05_46_+1100_2IXEGPjDVirOfqUk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPHOqqAAoJEECxmPOUX5FE9b8P/2s4vgeF9ja6zJvC+q7fw3pB
BVMYS9x2EKeC9e8jJKMHVG80qsxBgqKcRxHLp+eAXhkAufgNoX39wGuyu/paLrQn
V8dhTWORMdg+bvcqJYLK5G9E88bt2FmgaLjRNgjGR54nDYly9MtBJ9C0ohi50RoZ
JqpsymwZx+W5MvpHw9cXRHnz2OYw8ZXLp4mP8WsvkhR/Yklgewpx6OYmILUG2Nga
RBfOw1A7zl/Salvl0uh05+kSD2F9w/QrBfoWqKZox1/YDymqSqZZJy1ymOtUgunt
VnE3KhxAnH7+G+7ifr+QsIiuMAdzgg7ekmq1qrUF9sKQayq5bkiWdUwYEXSmZdXY
RJ4VRBnUg+/XWD77qn6SPQju5Zf/PNRvHgjjA6QxlFqjvv0T4VQ7qHem/XO2xDgK
cHvNiFFGeuPP1GAfGNInogKcRmCeRETO98/A/iD5Vd57cJ1N8d41+cm6gCERHQlz
9iAYKqrLopXObUb5UumlswRh2JnFd7Fvk22gPICGqKD+l/DgGCbAd6Tj/OzhcA5e
wSeWsVyiYjYVJKJcnzicKNNdSU25/gAx6LvlQWPgCnQwBdKYEUA+9xvYKS6e0p4S
dpLLCQIzdtiyJWKWPyNq8YFQpEb1spW7N78aNZhO/HzTHFPj9gxwK7r6zyXIKg+k
GklqdnkLKbUGmYgAXXkZ
=PjNx
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Jan_2012_16_05_46_+1100_2IXEGPjDVirOfqUk--
