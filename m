Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab2FKEWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 00:22:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46429 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2FKEWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 00:22:16 -0400
Date: Mon, 11 Jun 2012 12:21:38 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Message-ID: <20120611042136.GK4218@opensource.wolfsonmicro.com>
References: <1339148851-19289-1-git-send-email-yadi.brar@samsung.com>
 <20120611033701.GC4218@opensource.wolfsonmicro.com>
 <CAKew6eW4QgXDEG9XM9-sjw1_D7GrMeZYo81AEQyfkCE5qsLHXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="enGqbSaueFq5omEL"
Content-Disposition: inline
In-Reply-To: <CAKew6eW4QgXDEG9XM9-sjw1_D7GrMeZYo81AEQyfkCE5qsLHXw@mail.gmail.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] regulator: core: Add regulator_set_voltage_time_sel
 to calculate ramp delay.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--enGqbSaueFq5omEL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 11, 2012 at 09:49:39AM +0530, Yadwinder Singh Brar wrote:

>=20
> Actaully I had posted V2 for this patch with a little correction
> (i.e. converting ramp_delay to uV/us before using for
> DIV_ROUND_UP)
> +                       rdev->desc->ramp_delay * 1000);

> I missed to write it in patch summary.

Yeah, I did actually apply that version but picked the wrong one to
reply to when clearing out of my inbox.

--enGqbSaueFq5omEL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1XIaAAoJEBus8iNuMP3dKeEP/16SOjEyeTppUdC9eSSUeD/a
fkGeEPEVaJZEkfVdCeIn8Z9ifQorqF+Amb6fa8/jO71+w55MRthEYXk2rkPngtYQ
Gk5kpZTtJaNl2v1YIrzrEt3ksi+1QEOvgNT7jyx+RV1nkf0PLv85BlD4etxVjF5M
NNqYVJmjUL7J3xcGhpwf1HO1BI8fivzjIJV+0bKO+rJLt7+heBSHNob/DaTfnCQ2
vFvdwBa/xnjCv00WY2wG965oE7dufPzGvqhGAYILZ8EQFzBQapXz0UVK+NsTnwR6
MwDlJ2jSWXlv489AKcyjfOOZghUTfh6sUJVjAqLb+kSO9rLchf37mWudVY1ynWiN
vLcn0NhNGGxcV0FGWHRzNVO0bPn1Zlv8QuLsTB8A9HTfs3bPRNumJA/xhydfOidI
d3aPH6hB4atj2VO+xtYB2jS2frJ82W7Vg4HbwWqblEGJI7q91G58orho2slOAVNK
PU/e6CfVzge3IoPg3dTMOpBsxqWXd6n3aimTmsFOT6irL/qlXZTbfxXF20BR20Fk
d6DDiuJKpbHEXK+yO74cqvNz6vGREKmTS6i3LkgjBh93XKNV1yRhLMYYsYcW46/r
hfiWCvC+KcDzm8q76sd/daUEqn8MePcsOdQ704Ydc6lYKEQ9Jgxz95S/wbuhAhDa
R+Y8JoP5Ywu5DyFTeFMg
=1N/i
-----END PGP SIGNATURE-----

--enGqbSaueFq5omEL--
