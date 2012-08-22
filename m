Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab2HVQ7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:59:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54499 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932992Ab2HVQ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:59:36 -0400
Date: Wed, 22 Aug 2012 17:59:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 0/3] spi: omap2-mcspi: spi cleanups
Message-ID: <20120822165933.GU7995@opensource.wolfsonmicro.com>
References: <1345615515-26745-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B9I4cJCE9PLEoxgz"
Content-Disposition: inline
In-Reply-To: <1345615515-26745-1-git-send-email-shubhrajyoti@ti.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B9I4cJCE9PLEoxgz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 22, 2012 at 11:35:11AM +0530, Shubhrajyoti D wrote:
> This patch does the following
>=20
> Calls the pm_runtime_* functions directly.
> Remove the MOD_REG_BIT macro usage thereby removiing un-needed branch.
> At remove dont use the autosuspend runtime calls.

Applied all, thanks.

> The following changes since commit 23dcfa61bac244e1200ff9ad19c6e9144dcb6b=
b5:
>=20
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-08-21 17:22:22 -0700)

When sending pull requests please always base them off a tag of some
kind, normally one of Linus' is a good option if you've no special
needs.  This one looks like it's based off -next so can't be pulled into
any other tree, -next is rebased daily.

--B9I4cJCE9PLEoxgz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQNQ/pAAoJEFJkBDiqVpZ4bl0P/3edWnyJpaN6LXP4W/6w2XZR
CqxH9YHjPCzLq8QGaltIofp2AItL478YENaEWGCc9nCCFdeY+qMdFwX0ypy1+faT
rkY15ttIOrxHKsCRumnLVtO3q61oRDEDpKNnDUAilNL+T32FctfxIsU+gr3tfblm
3FgbxBEUIBi5fRh5oP/UHW+dhRQREe1rylj1NmmxNm6lLdSPW3fuW5LdQcWD8BmO
UxgxTOCE90ESaNOud6aT8zQVWqMuly/OJvYidmrHXi27VCW6D3ajpVVQMOPZH95+
DpLeRTlTvvYnpyQY5fK6isZ/xKJ7FeUI9c9FGn7LhPOdv/0N2/0wYyVIb7o2ZszE
u01VV8aBUFT+gwAU68NAB6SvYNIiLtdXLbP7/DBCNjR1qurIeDS2lt25guBmF+lm
bKFBMuq1+olK+ao/KN+cRTlC22I3epAo6Eh5oYw/lv3bblXtcGNrjLkVeJ+iBm81
NpyqSILb8AyHrkLTpTWMgPLG7MXxsTs1TNG20TQlR+XpPy045GcxnZwgnZotc3i6
XduMxEjENBU0xFNxd1r61pv8O+udbxuDZdmtkLk8A6Bn18j0pP/wA4EmWkxW9b0e
3kr225X+7C5bc5S04t6rPudMgCsY29Cznv6kjvc+KREbO4ocEeSj8RntwOHSUKJC
829vlRehXAXxrPFbfRiv
=rc9U
-----END PGP SIGNATURE-----

--B9I4cJCE9PLEoxgz--
