Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab2B0QJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:09:20 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:43041 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753004Ab2B0QJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:09:19 -0500
Date: Mon, 27 Feb 2012 08:09:12 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: Re: [git pull] drm fixes
Message-ID: <20120227080912.5e2163ee@jbarnes-desktop>
In-Reply-To: <CAPVoSvSvQv14dM6EWTi3YxUtxNWB8+kypDHSwkYTiWpBxL2eug@mail.gmail.com>
References: <alpine.DEB.2.00.1202221952430.18534@skynet.skynet.ie>
	<CAPVoSvSvQv14dM6EWTi3YxUtxNWB8+kypDHSwkYTiWpBxL2eug@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/N13b/AIHGgBYRG+LJ88uSYt"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/N13b/AIHGgBYRG+LJ88uSYt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Feb 2012 21:19:20 +0100
Torsten Kaiser <just.for.lkml@googlemail.com> wrote:

> On Wed, Feb 22, 2012 at 8:56 PM, Dave Airlie <airlied@linux.ie> wrote:
> > Eugeni Dodonov (4):
> > =C2=A0 =C2=A0 =C2=A0drm/i915: gen7: implement rczunit workaround
> > =C2=A0 =C2=A0 =C2=A0drm/i915: gen7: Implement an L3 caching workaround.
> > =C2=A0 =C2=A0 =C2=A0drm/i915: gen7: work around a system hang on IVB
> > =C2=A0 =C2=A0 =C2=A0drm/i915: do not enable RC6p on Sandy Bridge
>=20
> That last patch about RC6p looks wrong.
>=20
> It does:
>  GEN6_RC_CTL_RC6_ENABLE |
> 			(IS_GEN7(dev_priv->dev)) ? GEN6_RC_CTL_RC6p_ENABLE : 0;
> But I think this was meant:
>  GEN6_RC_CTL_RC6_ENABLE |
> 			((IS_GEN7(dev_priv->dev)) ? GEN6_RC_CTL_RC6p_ENABLE : 0);
>=20
> Or did I get the operator precedence wrong?

You're right, no cookie for Eugeni. :)  This would have prevented RC6
from ever getting enabled though, which should have the same effect as
the patch intended, though at the cost of higher power consumption.

Fix just sent to Dave anyway.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/N13b/AIHGgBYRG+LJ88uSYt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPS6qoAAoJEIEoDkX4Qk9h9W8QAInRevDJrrCAoAdhe56rmdwN
g1+sxpWnHZJexnflfucfJiz1BDuKSwaItC8e+UJ4bio2afgb3fsxrivC6Y80N6MU
Is567r1rrgvViAyr/elUKnXSCEn7kqE+fLzLIJp62upNmtRmcLXaE7/Lbd0LxJcP
BzqcyCsYUhJHaGY1QYSPPyb8cjlte4zQRSMxpGP6FPuZv7h5GgEH6a7husSVxJDZ
E65k0n+c75ZFeNtHT6bgkJdK5u2jXi/Da3NA7NdV1y1RTjIDJ9Q32aMDvAnmrwtz
tfVYZmwdAsZ14WH7Isj2laUn78M+Tmz6E7bZVlM7TgEhbc5EDaiIj+4hk9lgTWfW
WjZkbRMiPtHY/vFBXQBrnes4hKtmcKKX0G8D8NhzLkJj+JN2OqYJ4ZUJFdpP2qRP
ynba5Wam5u3ptsndyGyTsH6BsqdYG8otbUFiVdRoKIK6LPxHwCeNXVoRMYZfV5B8
lmPbI4BCbkjnJRvFFfMAfh736DCk7uXkjOmG7lhC+6KsNhOaNS65n4IdiJQy6FRB
EZuvdxd7O4yhSHXrSyv38+oXcocFhewCq5HOtnj4oAocOhDWgz4llMzHIM61VZ0r
056w5eu85xM5CvVpJquAv10cXGq3oE7ZwkuXsvjAOYgFprfZNK2vd5aU26kAII92
bkuok+621CtMzBu/BrWK
=JqeQ
-----END PGP SIGNATURE-----

--Sig_/N13b/AIHGgBYRG+LJ88uSYt--
