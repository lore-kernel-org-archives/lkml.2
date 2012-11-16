Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2KPU4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:56:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2KPU4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:56:46 -0500
Date: Fri, 16 Nov 2012 21:56:37 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: Add of_find_backlight_by_node() function
Message-ID: <20121116205636.GA27469@avionic-0098.mockup.avionic-design.de>
References: <1352469878-4532-1-git-send-email-thierry.reding@avionic-design.de>
 <004201cdc2d0$c1920210$44b60630$%han@samsung.com>
 <20121115065140.GA21208@avionic-0098.mockup.avionic-design.de>
 <001201cdc30f$65a17be0$30e473a0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <001201cdc30f$65a17be0$30e473a0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:+Qp/cK9s2WafPZLIoWg4UP5eG5LdfYskmLaCtJ4w/4t
 kFqdhd5EGg4hXjuFaUmymWrBQzoW12ovO2lz/5WVRJw4H6mrOW
 ClnU+VxRlpCGzSf3qzUbCeqxsyN7yANmn9bKKleFjhXhCnV7ae
 XgRq4pnonF7YPYfG99FMlgWXAizZCQOeS1U7jdYkQ1f7FtLUMi
 xDc6qbhM77lONJ8FHC2/UZrVkhGlXu5hXapOyCSTP+1+CSK3hX
 Ls/QJmXTa9HdRGPpM7PAwmoEciTO+5vWTm0VtzR5agZ7xShzgO
 rg0tpJZ9A1EDzUWKUCRbro2kDGb7Ls3AqaYFNtbdh+VtiIcxof
 iVBIAqmdfAXVVp6r/JzHsF1hjreT7/Pp03FNqScq4eJqnT64k9
 PU7rSm7FRxYN52sn2Og5Bi+n362nvLB6ViJ+ZGEeCzBg1s7/Dr
 ByUAP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2012 at 05:58:35PM +0900, Jingoo Han wrote:
> On Thursday, November 15, 2012 3:52 PM Thierry Reding wrote
> > On Thu, Nov 15, 2012 at 10:30:11AM +0900, Jingoo Han wrote:
> > > On Friday, November 09, 2012 11:05 PM Thierry Reding wrote
> > > >
> > > > This function finds the struct backlight_device for a given device =
tree
> > > > node. A dummy function is provided so that it safely compiles out i=
f OF
> > > > support is disabled.
> > > >
> > > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > >
> > > CC'ed Andrew Morton
> >=20
> > Yes, the backlight subsystem isn't very well maintained, so I should
> > have added Andrew in the first place. Thanks.
> >=20
> > >
> > > Hi Thierry Reding,
> > >
> > > The patch itself looks good.
> > > Could you explain when this API is used?
> > > Thank you.
> >=20
> > I use this for the upcoming Tegra DRM driver in order to hook up the
> > backlight with the DRM driver via DT to allow switching off the
> > backlight when the corresponding DRM output is switched of using DPMS.
> > Basically what you have is something like this in the device tree:
> >=20
> > 	display {
> > 		...
> >=20
> > 		backlight =3D <&backlight>;
> >=20
> > 		...
> > 	}
> >=20
> > Then you call something along these lines:
> >=20
> > 	np =3D of_parse_phandle(display, "backlight", 0);
> > 	if (np) {
> > 		backlight =3D of_find_backlight_by_node(np);
> > 		of_node_put(np);
> > 	}
> >=20
> > And then use the standard backlight API on the returned pointer.
>=20
> OK, I see how this API can be called.
> AS you mentioned, it will allow Tegra DRM driver to use
> the backlight driver.
>=20
> Acked-by: Jingoo Han <jg1.han@samsung.com>

Andrew,

any chance we could still get this in for the 3.8 merge window?

Thierry

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQpqiEAAoJEN0jrNd/PrOhK7cP/RYi+y4AaxgU2MYHIsU1ymiE
ssNsEp4yZZD3uydDrpMUJEwyznnBJeGhd21SEg7drz2+dABafgGt3G/7PqA/xu43
Xv07AaSbOyqVGubIon9ssrzj27s2jTwjXUeu2fzFlPbIFZjMorP7HoeuLRYy5yce
ZcsRy40juP7htTT1LlYwxpwh6RWK26kqzCQNMXVz+T7TQRmzGiM4MCOf/gQ89D2T
SX134RTtKM63YXqrSdpC81XUpDicWKr4nOwGQ1c9e/bDg3kc45xBOYvGUD3zfPrR
i38R3NIEIlvuAJRzXCFL0b3MK/E8BFWg4jON0qQgn9Kk9TqS0sNtYNSKga1c1K6N
1u+VWNLY13lIYT2sEUgqKMcZIVU+YZaprfiLuKn2epMxm5ecINJANm4ZvwYHBhV4
PqrxNhY7CKRPxRPYP2U+6ETOq6Q7KP5u9amrtP9nsKgBno1crC8BUuMG/0+Bwojp
SaqXdNorPE0Knn3TiGppH2JMx5n2E45EZb+WhtGr4//OAGTgvwrTxApVx5mRya/I
mEAx3Aec0o/c4kVJk0b9CeV01Plh9hLqjGdG7x17v5NWt/u+RqI/XbqNoOhC2Hbb
fPYhiAo+3p3qX9hDvXW5u+W/tbG6xLZbCN5DJXVUvJGFR+XbP6ea2JQWujP3bPDk
PIWJ8zlY5pYD+dSfA2py
=Z5Mn
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
