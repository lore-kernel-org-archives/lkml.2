Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2EEJvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 05:51:41 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58586 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2EEJvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 05:51:39 -0400
Message-ID: <1336211495.2027.3.camel@koala>
Subject: Re: [PATCH 7/8] kbuild: move W=... stuff to Kbuild.arch
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Date: Sat, 05 May 2012 12:51:35 +0300
In-Reply-To: <1336205926-13946-7-git-send-email-sam@ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org>
	 <1336205926-13946-7-git-send-email-sam@ravnborg.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-8ERgxoxeY/ZCIL/LCflI"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8ERgxoxeY/ZCIL/LCflI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-05-05 at 10:18 +0200, Sam Ravnborg wrote:
> Prevent that we eveluate cc-option multiple times for the same
> option by moving the definitions to Kbuild.arch.
> The file is included once only, thus gcc is not invoked once per director=
y.
>=20
> Another side-effect of this patch is that KCFLAGS are appended last
> to the list of options. This allows us to better control the options.
> Artem Bityutskiy <dedekind1@gmail.com> noticed this.
>=20
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Artem Bityutskiy <dedekind1@gmail.com>

Looks OK, thanks!

Acked-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

--=20
Best Regards,
Artem Bityutskiy

--=-8ERgxoxeY/ZCIL/LCflI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPpPgnAAoJECmIfjd9wqK0RwQQALLRyZe4GqSVplO4BvCrWciZ
uzCspMmMt/sidopREivrYmHC+4rfEEFZWYxUjNZAW9HAid1Y+O/VnaSLQGL8+As3
4QFa11iik7MbwCk4hJHLCmBKiLxAv0+NCGl+GjHSrHUIGNhJjfvG8GpnWE5QGzQn
s1GfTxUWcHYU/cSF5s/InaLOvZ2qKOgCOzI5nmoyYc67DoXZJEUl/nWkphqELOYM
n8pz8JikSkDSfM5LB9H0sV8lUo2oDILxXT3wg04RKZxcZZGSoPw7lx9NF+n+RIqU
peuxM+eAT+y1anYOyYZGtNgbsi30rReiERZ9Wh1EaMunBzyZ6pUQnl3DLTnZKMK0
Ci3yjsJHWXl3IhUvJlrEsl7GeVz7Y5hsT+qPh+ZChPQGcEVGrvpiCePRye9G1oFo
UaL/A3jLOX4PsPqHLC7S8E1YsrECodUgydiZAD4827TRDlH1rbqO0IC0KRA/omWi
CjzFSDByKjJ6CLTbKa9+KCpFoq9c/GmZNfOXh9jn5FnEz1jF4tfXuEYSvJVxe6wg
wFEv1Z57d+SXUEfCLfQVsNcTV/qEy56GlDTVA7zbyqeHPb3GuT26FCc+g1ysdnYJ
3D3bbhSE4BsUzJh1UyoG4dJGaaEhblfA1TUVsLMSjFm83BdcRfOpYdKNs8jkYN5X
O9vuun/x3ZzkEUDWOLvE
=XccO
-----END PGP SIGNATURE-----

--=-8ERgxoxeY/ZCIL/LCflI--

