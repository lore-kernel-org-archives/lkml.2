Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2CIGVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 01:21:48 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:43063 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2CIGVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 01:21:47 -0500
Date: Fri, 9 Mar 2012 09:23:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Grundler <grundler@chromium.org>
Cc: Jonathan Cameron <jic23@kernel.org>, devel@driverdev.osuosl.org,
        linux-iio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Bryan Freed <bfreed@chromium.org>,
        Jonathan Cameron <jic23@cam.ac.uk>, Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH] staging:iio:tsl2563 rewrite probe error handling
Message-ID: <20120309062358.GA3337@mwanda>
References: <1330967759-18660-1-git-send-email-grundler@chromium.org>
 <4F57465D.1000402@kernel.org>
 <CANEJEGvWm83ucH8RH5HK_otTae2AxpUsvLV1XDA9=-JOL1kMGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <CANEJEGvWm83ucH8RH5HK_otTae2AxpUsvLV1XDA9=-JOL1kMGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F59A173.0003,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 08, 2012 at 07:51:07PM -0800, Grant Grundler wrote:
> Hi Jonathan!
>=20
> On Wed, Mar 7, 2012 at 3:28 AM, Jonathan Cameron <jic23@kernel.org> wrote:
> > Fundamentally an excellent patch fixing some real issues,
>=20
> Thank you! :)
>=20
> > but just
> > because I'm in that sort of mood I'll be fussy about the fact it is
> > one patch.
> >
> > To nitpick, I'd have prefered this to be two patches. First that fixes
> > the issues and the second that adds the additional output. =A0Actually
> > should probably have even had a third making the white space changes.
>=20
> Yup - I see/understand why. I need to improve my git foo and work
> habits so it's not hard to play with a series of smaller patches
> rather than one patch that does everything to one function.
>=20

If you use git citool then you can just highlight and right click on
the lines you want to merge.

regards,
dan carpenter


--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWaH+AAoJEOnZkXI/YHqRLd4P/3PiuKjZpB/FZp0/U1D1AeD6
5inkSQCfrGxUoWB3tVuv6aHR6RRyLIkyWwnspn3bPWcShqCcXDmWClz/UAJRiZz1
KgpghMOAcCX6MJwHolL84G5ZXTKS1eNACUR5I9cAlHBZH9P/NdlibpFaaMbxbM8H
FwGzKtdcf+BWFAUmWqmnNfFfW9OyvIXtoHaYKHTJpH1P9lhCS8AJh5wHHunKE/sj
cdLpMZUm2GoqjFYcgvKfP5f5f4M5/DxbM+38Y7NfT1d05yOkEJFVaRqy6eSFMh3T
JEEAkurb2MjMbIGhQuTC3HScNnHzKTjWOvYue/oBTi2wixKVPT9Bg4gB5BlGWj45
YzU+y6yF7A8LNWJfgVl4sP+zzUL6+eGH7Sy652isWbEw1PZcEbcZH5nYU7s78Btg
vrMMwKOj45yHYCY5PWEu7F4LmPLMVAEwpJ46A/JXGTb2yPfasvg52MPs9otoD1Eo
mp/Ov853o8L7UbLhKDRApX1PWdq6rGrSxXVQUABio9ldlkM94Z32Lg2bYqpvN6Qp
1p9QTzqKy34fguqOI9JGQD+j+DJOj64/UU+6NZk2TxpK9Fa3KRx7qY4ivlpzD9uU
fdwG6Lqq5LLG4MovDZku5zeVL53U+K17su6Q6bY6jJclui/8eqaGqNR3UkmLywK5
2kEWnwAlN/z/ygVFWP/a
=GRHG
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
