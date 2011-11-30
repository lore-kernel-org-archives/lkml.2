Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab1K3Jur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 04:50:47 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:58425 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab1K3Jun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 04:50:43 -0500
Date: Wed, 30 Nov 2011 20:50:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the vhost tree with the hexagon
 tree
Message-Id: <20111130205030.ed1e48bf5588a1aeeb2f4a3d@canb.auug.org.au>
In-Reply-To: <20111130064553.GA2393@codeaurora.org>
References: <20111129142259.78d3e10678c8e9d8376d52aa@canb.auug.org.au>
	<20111130064553.GA2393@codeaurora.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Nov_2011_20_50_30_+1100_jsCO=y6F_4xuNS1N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Nov_2011_20_50_30_+1100_jsCO=y6F_4xuNS1N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Wed, 30 Nov 2011 00:45:53 -0600 Richard Kuo <rkuo@codeaurora.org> wrote:
>
> On Tue, Nov 29, 2011 at 02:22:59PM +1100, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the vhost tree got a conflict in
> > arch/hexagon/Kconfig between commit 5237bae0d8c9 ("various Kconfig
> > cleanup and old platform build code removal") from the hexagon tree and
> > commit4673ca8eb369  ("lib: move GENERIC_IOMAP to lib/Kconfig") from the
> > vhost tree.
> >=20
> > Just context changes.  I fixed it up (see below) and can carry the fix =
as
> > necessary.
>=20
> I was figuring this would happen.  What would be the best way for me to
> fix this?  Maybe rebase my patches on top of the vhost tree?

No, just ignore it.  Linus will fix it up when he merges the trees into
his.  Its pretty trivial anyway.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Nov_2011_20_50_30_+1100_jsCO=y6F_4xuNS1N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO1fxmAAoJEECxmPOUX5FE3WIQAI1b2vM45UIY/Ef0xp52fm6o
dQqIP+cOtMpkSJZhSMOYMPccehMAJdqTxsTB7ObjpsOCBRKWw0O6E2DksATlAgrY
ZDMa4KGPrHhtnzyfdR4+SH6lx5C/Sp0JqGe/QuPhG4eT0xxCfolp0qYoqxNcpteH
KlEN0PYuENoojMEMr+ctMvn0MJnsu1RwlbDnhJf10Asq4e0FbKUi7KFTd36ZNOKB
Ys51HdU6nFR1MZzHMfSFLHKDwt7gw8gFy5aBL/1bUYGX2R/ovzxsxzUJGoZ8nPku
I/GJPWKban49O6ZH214yRIXwht2Cex+GsoWMbmv+2mi5lmEqzd3EVgzLy1xPgrFn
IuRwVpBM3mAbi3XnF6jamt1RhGhdMhTv+lON33qmStsksOjy9BfS7EHWi7cqd1mb
8ksrvUiBo8SJA7CGPtjF0vWV4ChwD43Kwlvzp2AGumIWbYxurwileWelLeeRQFSF
/PF8reo0L6+UfYH6QsdjfKWEUiqccFkLxnUyYYqrUC2srKnnq8oJPj7sZn7MQnjb
XhY/ErZ/X/un1S0UeLa0CwyJiYWRaVaoTZDncnKQvSDTMln/bESjZyCkllR2w5LJ
Cb91FMYCVw9U7P6ztOrUx5dTvwnpXSZlU7DzGtCHDG5n5zFYZKtx71O1EHyoqlSP
6xQEakZONcOd2w8x3ckk
=+due
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Nov_2011_20_50_30_+1100_jsCO=y6F_4xuNS1N--
