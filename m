Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0ICCBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:01:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50308 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab0ICCBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:01:37 -0400
Date: Fri, 3 Sep 2010 12:01:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warnings in Linus' tree
Message-Id: <20100903120128.2a77e38c.sfr@canb.auug.org.au>
In-Reply-To: <1283148482.3707.167.camel@rui>
References: <20100817112439.18f9d958.sfr@canb.auug.org.au>
	<20100830114222.3a1f53e6.sfr@canb.auug.org.au>
	<1283148482.3707.167.camel@rui>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Sep_2010_12_01_28_+1000_6rKDUBvFwRBoHYHD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Sep_2010_12_01_28_+1000_6rKDUBvFwRBoHYHD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Mon, 30 Aug 2010 14:08:02 +0800 Zhang Rui <rui.zhang@intel.com> wrote:
>
> patch attached. :)
>=20
> Use module_param_cb instead of the obsoleted module_param_call to fix a b=
uild warning.
>=20
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Sep_2010_12_01_28_+1000_6rKDUBvFwRBoHYHD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMgFb4AAoJEDMEi1NhKgbsGHcH/jfOGWPdw62CX/3WyjdKLOAu
XBF703woU+yjkYCF5+6iQZWff/VMi44+XUuy/5ptwVdvu28FGx5lhIdjf5HQhC6m
U2AJ+rG4UncoMRpLWA7a4blOOas5EHw08HSDZ9VPo+5qbZcfia8ArlzWrlnjt6Nd
YCD4wFGemVU+IzaK7t53HxyqQglcZp5NilpAHisTlKs6w3SJqA5SnT84smwcHrxK
kivTG0dzioDbiNtCPA2eDEQ2v606GgRhCEYdvJPpniI4mRnexZ6LrXzcQ9oWVkWB
wprdAgcBQQSF+AWIoUXbD8ticZSvztSqoGsX2N1xaXIbjmaIwlhTfWo4/PWcxp0=
=xNw5
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Sep_2010_12_01_28_+1000_6rKDUBvFwRBoHYHD--
