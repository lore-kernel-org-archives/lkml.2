Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2FKG2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 02:28:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34796 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2FKG2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 02:28:14 -0400
Message-ID: <4FD58FFA.9020408@debian.org>
Date: Mon, 11 Jun 2012 14:28:10 +0800
From: "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Richard Zhao <richard.zhao@freescale.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com,
        Richard Zhao <richard.zhao@linaro.org>
Subject: Re: [PATCH RESEND] mfd: anatop: permit adata be NULL when access
 register
References: <1338774989-4416-1-git-send-email-richard.zhao@freescale.com> <20120604021315.GB2857@b20223-02.ap.freescale.net> <20120611061925.GC2552@S2101-09.ap.freescale.net>
In-Reply-To: <20120611061925.GC2552@S2101-09.ap.freescale.net>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig7E22C6FF6B2B6E9D6383C39C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7E22C6FF6B2B6E9D6383C39C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

(2012=E5=B9=B406=E6=9C=8811=E6=97=A5 14:19), Shawn Guo wrote:
> On Mon, Jun 04, 2012 at 10:13:16AM +0800, Richard Zhao wrote:
>> Cc Paul's other mail address.
>>
>> On Mon, Jun 04, 2012 at 09:56:29AM +0800, Richard Zhao wrote:
>>> From: Richard Zhao <richard.zhao@linaro.org>
>>>
>>> It makes anatop register access easier. Anatop has many misc register=
s,
>>> which may not be a specific driver.
>>>
>>> There's only one anatop device for a running system, so we use a glob=
al
>>> variable to store struct anatop.
>>>
>>> Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
>>> Cc: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
>=20
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Ying-Chun Liu (PaulLiu) <paulliu@debian.org>

--=20
                                PaulLiu (=E5=8A=89=E7=A9=8E=E9=A7=BF)
E-mail: Ying-Chun Liu (PaulLiu) <paulliu@debian.org>


--------------enig7E22C6FF6B2B6E9D6383C39C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJP1Y/6AAoJEPgLgUbQQog2bZMP/2SXw2jWmDajJ4HymvI3+ifp
QHRimkmLeS7uDiaCrpZ6niqJTDfF2cl4N4cDe3ND3JCnJymfM/dyM/6ov+i/vf1b
EUHe+3DtigNcW6vM4hHuezySY+3gGgQnb1Q2BbLFbU6lDX2jAD1PmpAzZfLRk7Be
35A+SDLj+yxseTySdV8U2rs0wxdycBhmteqbWZnv3BVZVn/flrbUxfhkcWgLVqVY
oJmSLb4Zq4cUCL/D6RUgCzotpTUJam5Tj7jOnFTqhkvHf74BGf1LAAUamE+gZSmM
5KAIVIl+SxFqkipJh6PPifZyyrnZHAiY5ncojgnM884v9MkXYAU8IxNBsFI2408t
3eyVLW0fiyUfU5MRWIpmpvvT8eoK+v6+uGf4AlCjyC0Vv07wCDBDuszkeGyVi63o
I0qP8TotaSpeSXdR93pJvcKkCaGs77Z/7ATn5fCfxtxH/k+QsLdGzsoD48K19YW2
QZ5nHGOBQ3pFpZJO3Huj9zlxkrBghgYMQZNHiTCb69S3simx2kp9bOn7EhNur+rE
2cMwrwgR6sODjeKy0lKkIsQrHfXY2QFEKvTMrDnewFtZGU13K9dTpsU2FyHsSdSp
MW5NuU1Rq+62ydaliAoXnI6u86Ra0jP9BnRUZ//SMzHjJlMCDIVaIc/fGk7SoGWx
uF9f3a9vKF5oXCTVv4Gt
=9gBo
-----END PGP SIGNATURE-----

--------------enig7E22C6FF6B2B6E9D6383C39C--
