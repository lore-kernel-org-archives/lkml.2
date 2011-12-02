Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab1LBUwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:52:34 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:36455 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102Ab1LBUwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:52:33 -0500
Date: Fri, 2 Dec 2011 23:52:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@suss.de>
Subject: Re: [PATCH 5/5] staging: vt6656: channel.c: Restructure
 CHvInitChannelTable
Message-ID: <20111202205257.GB3195@mwanda>
References: <1322784403-20086-1-git-send-email-marcos.mage@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bc2iwAtkAaXP8cWF"
Content-Disposition: inline
In-Reply-To: <1322784403-20086-1-git-send-email-marcos.mage@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4ED93A8B.0059,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bc2iwAtkAaXP8cWF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 02, 2011 at 12:06:43AM +0000, Marcos Paulo de Souza wrote:
> This functions has some code that does nothing, so remove it. This patch
> also fix some coding style issues.
>=20
> Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>

All five patches look good.  Thanks for doing that.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter


--bc2iwAtkAaXP8cWF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO2TqoAAoJEOnZkXI/YHqRfAYQAK++55lealSrdPJG+xRVnULV
hsd4u16HYGXgV4I+HpVOqLHBQ/bFqeSc+e+dC+5OvXfqO+qVbJpoPVbNAcjXvRrM
4ZW5pTRqtuW3o7BHS1c8yIhaExvjaitOR5U3lOf2KbA2NzFD+OnstFM1nnsRwqvJ
BBMxtXUUuE8R0HuMOgyZHLm6g1/ReHQirB6Gtn4HAuqZHEasn+8kxWJbJuI4E/oH
0QjkeUVqGhajBhmJHQ4WIX70ONAMaVXz/EwlMUHfJhR+L2rfjoROn9okIsfXkPfr
o1bvf/TK6ajZtQFo7lImKQdV3Fdk3nkrl4Y1Y0dJyXRMcvpgcuVoX+6IMz/fxVK9
PY0oS51EHEaL9I+Nr1Y9YqZiQZlbDisGxeptZ9pIDrBzgvR5ol4wR7UykIopqRtA
P4uE8VOHNzgPrrHMrFfQWCoFaGyZ/EgMxY8UTvNGpHzX1dkd7ii0UTDKpHXaIFHB
TYczInPOPY+X7X8LA9bdnDzPFztf3naU/TUmBctRg+918vSi3/VE43OnN/xZ4H9T
8IcWikuSvNwdgC01rYGMYQ830RAhqKpSpkHQj/LuZ4jXrzNjxXK4cr0GXCxwR/Et
6x4FDiINCudI/sdBiVsRN0d7Fq220/uz+HmcQzcMze47VMwejCd9KKZnnYDctR1N
vnpNKYEG+gKKwKlyDKSe
=DJxY
-----END PGP SIGNATURE-----

--bc2iwAtkAaXP8cWF--
