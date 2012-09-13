Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab2IMFu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 01:50:57 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:35899 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424Ab2IMFuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 01:50:54 -0400
Message-ID: <1347515447.7471.12.camel@lappyti>
Subject: Re: [PATCH v6 0/4] Runtime Interpreted Power Sequences
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org
Date: Thu, 13 Sep 2012 08:50:47 +0300
In-Reply-To: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gzBHsi+GVVosWN9StYJ9"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gzBHsi+GVVosWN9StYJ9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-09-12 at 18:57 +0900, Alexandre Courbot wrote:
> New revision of the power sequences, taking as usual the feedback that wa=
s
> kindly provided about the last version.
>=20
> I think now is a good time to discuss integrating this and to start looki=
ng for
> a maintainer who would be willing to merge this into his/her tree (I am
> especially thinking about the power framework maintainers, since this is =
where
> the code is right now. The second patch in this series enables the pwm_ba=
cklight
> driver to be used with the device tree, without relying on board-dependen=
t
> callbacks to support complex power sequences. We also plan to use power
> sequences in other Tegra drivers, and other people have expressed interes=
t in
> this work during earlier reviews. See for instance
>=20
> https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-August/018532.=
html
>=20
> and
>=20
> https://lkml.org/lkml/2012/9/6/270
>=20
> There is probably some more details to fix and improve, but the current s=
hape
> should be enough to know if we want this and where - therefore any sign f=
rom
> a maintainer would be greatly appreciated!

I want to reiterate my opinion that I think power sequences in DT data
is the wrong way to go. Powering sequences are device specific issues
and should be handled in the device driver. But I also think that power
sequences inside the drivers would probably be useful.

 Tomi


--=-gzBHsi+GVVosWN9StYJ9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQUXQ3AAoJEPo9qoy8lh719rcP/jyzp7W4J8YX1Hsn7F+h/YpP
ZiYdW9bVvlEN0s72haK5+chjNX7+ukvowIWFY38qppvVDn3eJlvkpxuGjO+5khPZ
ACvArt9tlt7AQJcyqQ9plD1G22o5KaV6FWz9b1D0KObflDCe7yk0nTS+cpIscx4t
ktc0dNGu7I1GnqgBDVBgjFJ0ceMtPpOVYuwXqtOIhoDzHkeG50PRWVCuFS3aaa8A
gV8AJjMuFhDTTEI/R31X1hZg6L/QpT7p0ASUmGe41H293FoI3a2CzPxnOm6oqeth
Cr7twC9FCINJRVR6q669NKf4I2bGhd572m8UZsLpMEN7re9atsMK4HMQD1WmAatj
/fQ9jQh35UVXJblVb/y/REr4ZtiEiYxlG1pdWNjl2UobUPhW198QgkxIA8S5+VlG
/9Y9tPZaz0PJdWbfeQpwEvxyy+vhsNK2KIEPl87SDHGF6xf8sxgLRT5dg9QhY3Hw
d+IDfcwiPF76Yg+0UlkX70gfq+Qon7AnvN5Z7XEiDou3iZVXnstm2UmDup+KDZXH
yTurR3iNbXudp7YXeicwtuYPWgnqAI5sp5A+E5oT2hI9GAiNROs8/vErgjyJj7Cs
gx87Q+7nLdO71J7aUW8/cxXYlkTOCrJ6gALFOUhFp6SUuyqZMiMy0LEm5jK/NkNf
7nfg9R9HGl132dJL6A8c
=Aqwb
-----END PGP SIGNATURE-----

--=-gzBHsi+GVVosWN9StYJ9--

