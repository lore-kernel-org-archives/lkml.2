Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab1K2WAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 17:00:43 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:48826 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1K2WAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 17:00:41 -0500
Date: Wed, 30 Nov 2011 09:00:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: build failure after merge of the final tree (drm
 tree related)
Message-Id: <20111130090033.4b10973c16373a5438514f6b@canb.auug.org.au>
In-Reply-To: <20111129151638.a083e93e21c7917f221af760@canb.auug.org.au>
References: <20111129151638.a083e93e21c7917f221af760@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__30_Nov_2011_09_00_33_+1100_HFTMyivagFrQlSaW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Nov_2011_09_00_33_+1100_HFTMyivagFrQlSaW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 29 Nov 2011 15:16:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 29 Nov 2011 15:11:10 +1100
> Subject: [PATCH] drm: fix up for BIG ENDIAN breakage
>=20
> Commit 308e5bcbdb10 ("drm: add an fb creation ioctl that takes a pixel
> format v5") missed one spot needing to be fixed up in the __BIG_ENDIAN
> case.
>=20
> Fixes build error:
>=20
> drivers/gpu/drm/radeon/radeon_fb.c: In function 'radeonfb_create_pinned_o=
bject':
> drivers/gpu/drm/radeon/radeon_fb.c:144:18: error: 'struct drm_mode_fb_cmd=
2' has no member named 'bpp'
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Not a biggie, but I noticed that when you added this patch to your tree
you lost the authorship ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Nov_2011_09_00_33_+1100_HFTMyivagFrQlSaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO1VYBAAoJEECxmPOUX5FEd9cQAIRfLiiwq2DhENnD0YexYFiJ
hgkP2slrhsZk4vT53DfrO53uh5E+BvqEzF3DUJSCkTSdzTTOPz+YL+8GQ+EkeAvU
xnXNIVgN8coKIfSW6vWS6Mjg0j1ot4NuIUFQZzT3qKWJr8W37qAMZaTkfyMpHA4z
IHPrujrNEONCyjhUbjLLetKISzGvsLorTFuZ6H66+yYkVqioc3lBGc1G7rUnqeS+
vKOTrRzL2kG1dr2JT9dAInuYqcYhGc7JBNMEighXvBjqCTAbnJiSrpTkBZrPrbF2
GHRYWEMUIwPg6eK9iKOjunwoO5e+3Xi+dVoSiZ/vgRycW0Q11O4VxQWkPkkPY4JA
T8MHxUTTrOFEzBBYB0xly4+M0BsJ1f89jEREcwAmtg2kTXqm9kNK13Q69lJENPwx
Cg8w62Qw9TxlpbXZkax6ouN1q7xIGA9Jyn5yttT1XtNbMd7lshW8KBeVCBl7XoyA
U5sDSKnWA5f0xbEoVL7DpIouXsQ78ZVILIbPbVRj5jpV75qpwoLrBJVMLgqoA8U3
y39i/nJOfryffEVYRp1fv9tV/v3CmdrHaAnBcQ0AgdCUUBC+pr61cQQ7qBZKx2jE
X6y9NMOWR0JpwoXo6RSBMN88/ZabUfLN2R8+f/P0APx2G50hDpWiijTck4x8kR5w
AmHwkstpnCblu8rRxsxm
=/gK6
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Nov_2011_09_00_33_+1100_HFTMyivagFrQlSaW--
