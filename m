Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2KMHx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:53:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2KMHxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:53:54 -0500
Date: Tue, 13 Nov 2012 08:53:48 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Zhang <markz@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: tegra: Add Tegra30 host1x support
Message-ID: <20121113075348.GC8409@avionic-0098.mockup.avionic-design.de>
References: <1352467202-27903-1-git-send-email-thierry.reding@avionic-design.de>
 <1352467202-27903-3-git-send-email-thierry.reding@avionic-design.de>
 <50A1FAB0.8040700@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline
In-Reply-To: <50A1FAB0.8040700@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VmsyqY0bO2yNH6158Qevc4kMC2Hyak7QRL6Hd2PIIOr
 eEkoydl5zYQzKaT6wBxwIrMg/psEKJEkQjiYZERmyqH7Xxxhoo
 yB1ttkGuSlBKM/5SP2Qwsfb8fAGEHHIpjitt3wgjDr1+qsUdMl
 5grm/EI8U9E4+6eM72UJO4z8eAm4o0tfUUI3tKQHlNTMeuvjkK
 lT6jL3MPtdJsqwCTmXmvg2QPHoHVkn8HjfkmHlKsK4Fmg78Y/w
 cNlKGB+pADT59MYmywpp8QnlWNInSZ3oQmqORa/fr4kjFcI6Dj
 5LJ3L1MedcZMmCujQpYcshSRQcD1cNj+3etoczn4LVVbfOIRUg
 9wnPEqBTsy74rGTyBQ/z4ssNxCn/BYOasAcNn5HZmgqRz1HBcm
 QLl8hkETWCBI0FI5Rxj8SNNEvA55DhGtImDbYRwilHLDRLoGPh
 O/YNs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2012 at 03:45:52PM +0800, Mark Zhang wrote:
> On 11/09/2012 09:20 PM, Thierry Reding wrote:
[...]
> > @@ -1337,6 +1337,9 @@ struct clk_duplicate tegra_clk_duplicates[] =3D {
> >         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.2", "fast-clk"),
> >         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.3", "fast-clk"),
> >         CLK_DUPLICATE("pll_p_out3", "tegra-i2c.4", "fast-clk"),
> > +       CLK_DUPLICATE("pll_p", "tegra-dc.0", "parent"),
> > +       CLK_DUPLICATE("pll_p", "tegra-dc.1", "parent"),
> > +       CLK_DUPLICATE("pll_d2_out0", "tegra-hdmi", "parent"),
> >  };
>=20
> The tegra-dc.1's parent should be pll_d2_out0.

I've explained this my reply to the Tegra20 support patch.

Thierry

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQofyMAAoJEN0jrNd/PrOhvDYP/3CPS5KecOvh6oAUbb6dc8SH
BrdqxKkj3YjXH/27xFG06m/XUIqcDGDQ9kyAxvYw4nAC7ydRPVBjfZViW3Zi+8dw
Ihmy4TcawZR2oyVdxGJYetEKKxBTcGb8jBpJkJZr9kS9YJH5bqrJa+wKjdJtSIxG
Ix57he97cn00CCfuxBGC9DepsAigeAx+VSGiVzvQKR84qx3J54eHntcYAVo8j9/c
WA+FClBjvcn/BQw5Zt6akwQ6APWTYmCLfoyko7ApnH4cl48bT2h36XdfmPOufDVf
6CaMi50SPCpTD378JHAG4ewNZ0Q1VzqodkQDxWMiEtSTjzx6H4Yft8eNjZONOSTY
v/7f+6owVxNPXUYrnJxBb6W8JgfZJgo11/h1YPxidFHE8YGMOojHKLa0Nwf23+/B
Whei1HU80W9tRhvJwuTorO46XsJalK4w3cKY8Df6GhM0Lmg4VO5y6iOqdBzY0YEo
R373onKge2PATOcduPtw+MRa10P4jLLBysYV0250ebI1zy1I2fhUxV14+so9GnAv
NO88ePLRWDLaHMJoojdumcX/JJIUQhHZD0ecClf0eBwSHi6qvs4U7ioHe2hfWdev
FKgNd+Rp/dYhMcW0y7BX1XuhPHOqs6p1VhdYdud0q5wKJjk4qlbI8lFK71DP5CYk
/2kGdRfewjzGaGwDmyl7
=iIF1
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
