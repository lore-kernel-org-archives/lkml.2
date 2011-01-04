Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab1ADXL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:11:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40512 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab1ADXL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:11:58 -0500
Date: Wed, 5 Jan 2011 10:11:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: Tree for January 4
Message-Id: <20110105101151.387a05d5.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTimHm5tgrvosqWPHAb4a_gCBGq5MiAR2tyUNCJPD@mail.gmail.com>
References: <20110104164723.8bafcf7f.sfr@canb.auug.org.au>
	<AANLkTinkEQEhsHGGgJVp_pJohmrOAaa3dCJjNSDKS4Yj@mail.gmail.com>
	<AANLkTimHm5tgrvosqWPHAb4a_gCBGq5MiAR2tyUNCJPD@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__5_Jan_2011_10_11_51_+1100_A23VRP=lr462FLlR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Jan_2011_10_11_51_+1100_A23VRP=lr462FLlR
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anca,

cc'ing Greg (the staging coordinator).

On Tue, 4 Jan 2011 12:14:34 +0200 Anca Emanuel <anca.emanuel@gmail.com> wro=
te:
>
>   CC [M]  drivers/usb/serial/opticon.o
> drivers/staging/cx25821/cx25821-video.c: In function =E2=80=98video_open=
=E2=80=99:
> drivers/staging/cx25821/cx25821-video.c:817: error: implicit
> declaration of function =E2=80=98lock_kernel=E2=80=99
> drivers/staging/cx25821/cx25821-video.c:834: error: implicit
> declaration of function =E2=80=98unlock_kernel=E2=80=99
> make[4]: *** [drivers/staging/cx25821/cx25821-video.o] Error 1
> make[3]: *** [drivers/staging/cx25821] Error 2
> make[2]: *** [drivers/staging] Error 2

When you report build problems, you really need to include the config and
architecture.  If it was a "standard" config, just mention that (like
"this was an x86_64 allmodconfig build").

Thanks for the report, though.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__5_Jan_2011_10_11_51_+1100_A23VRP=lr462FLlR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNI6k3AAoJEDMEi1NhKgbsIdsH/ixoaNSUByrJNlV0KJtG/U6g
rTKArQcR1eaeh/IF+hF0qwXMxg0C18huJhSjgoKj6nYdmSrfrEyd0L/EyHGPsRNz
zEM3WIgr5FbMRTnP88bnt6yzuaNTf6ERfAl9RzH2E/v6anvQwAI/f+S2O0ku2KF2
drsBH+cc67oJfqX/8hdsQLBcHFl+d1zto1BoYGkQ8tn1rPHJ2rmByxHLmdtZZeYP
YGe9a7Z5pdG4qAwkuN/fbTGKsYaNPyDMTOtEX5FcQD2fKF2Fsf9ZJwoZ3yjQUlG0
3pC/aORG7+4z8RFcjmywoesf2un0U5dDeDzXSaNYEmHxuc5gDlTdW0HIhm0rSfs=
=f/yg
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Jan_2011_10_11_51_+1100_A23VRP=lr462FLlR--
