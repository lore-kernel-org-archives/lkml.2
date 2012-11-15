Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2KOHSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:18:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55441 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536Ab2KOHSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:18:47 -0500
Date: Thu, 15 Nov 2012 16:18:39 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [Q] regulators: 3-current-regulated supply
Message-ID: <20121115071838.GI7599@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1211150749290.684@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I/5syFLg1Ed7r+1G"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211150749290.684@axis700.grange>
X-Cookie: Cold hands, no gloves.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I/5syFLg1Ed7r+1G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2012 at 08:15:15AM +0100, Guennadi Liakhovetski wrote:

> parts are pretty simple - DCDC step-down, LDO. The first step-up DCDC=20
> isn't a problem either. It's the second step-up supply, that I'm having a=
=20
> problem with. It's output voltage can be regulated by using either a=20
> voltage feedback or the three current feedbacks. In the current feedback=
=20
> mode one has a choice between a manual mode, in which case you just choos=
e=20
> one of the feedbacks and everything is simple again, or in automatic mode=
=2E=20

This almost certainly has no other function than to drive a LED string
for a backlight; it's not sensible to represent it via the regulator
framework at all.  Just implement it as a backlight and/or LED driver
and have done with it unless you can find some other use for it.

--I/5syFLg1Ed7r+1G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpJc7AAoJELSic+t+oim9BuYP/RCJeMx+3x63o3ppFVtg20Zl
3UYOYAmCEl4eT0DfX6GH1flzn9QtQsX4R8LEPco8hsWBtumXX39Vi3leKGCNjesZ
zbqhKpQfmuqeh5iSEzl3DUXBEwsbDfP8gcZ/QGmcrpxeex+JzPnTkT6YsbeSffcc
yin+gZZfOkzQaj6+F1T2gwpXVAyaW2bURkrtyvbDaYzDwwFOijYj1xBvY4sJLxXS
0E0BolT4kCz9hu3YzkcgFUPFdrhtvIXcBf4PWChsZ/JbxoCwipeFsHd76Hqmb41s
2pcCHevTyEaANqtGW/PI9svCZg4RnkXRoQ6y39oHU4R2nFYEfL6cYR1rgke1cVnX
U4KWwpNjcCC9z/fr6GYyQkA4TZ3AJqSPzC43GnWVXfVqaKXhi5sXouo3i5mGVNmM
60PcBrBYlt1w6xOoJ1g7YnAHABF8EyHvmsf5RHdX/AYheDl3/7QqLrQuzubjZ1EV
nqe08QBmKIt/e6Evto1vZlbgfGvOzTwWs7SZexu1YhCATDdfIxV0xB/WdOeRCRP/
Nr7lv2uUjFN4W3xEqdStzKX+I4VXsFsSogoC5WGJcSzS1lSm8N9eMIoZavJig/yH
NA+VvDuzpTArPxJlADZUfp2PzSf7uKlQOrOL0XESvfS/MmLktFRT29bPdacI5s58
+NweqJRxCFsew1UGal6W
=Pl7t
-----END PGP SIGNATURE-----

--I/5syFLg1Ed7r+1G--
