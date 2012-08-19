Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab2HSTcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 15:32:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61527 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab2HSTcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 15:32:10 -0400
Message-ID: <1345404726.1930.10.camel@kyv>
Subject: Re: [PATCH 3/8] UBI: introduce MTD_PARAM_MAX_COUNT
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Date: Sun, 19 Aug 2012 22:32:06 +0300
In-Reply-To: <1345214124-5478-4-git-send-email-richard.genoud@gmail.com>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
	 <1345214124-5478-4-git-send-email-richard.genoud@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-AAhfxh7Dwq6rt92Kx1fe"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AAhfxh7Dwq6rt92Kx1fe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-17 at 16:35 +0200, Richard Genoud wrote:
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>  drivers/mtd/ubi/build.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
> index 82d11e1..1f45f51 100644
> --- a/drivers/mtd/ubi/build.c
> +++ b/drivers/mtd/ubi/build.c
> @@ -46,6 +46,9 @@
>  /* Maximum length of the 'mtd=3D' parameter */
>  #define MTD_PARAM_LEN_MAX 64
> =20
> +/* Maximum number of comma-separated items in ht 'mtd=3D' parameter */
> +#define MTD_PARAM_MAX_COUNT 2

Fixed the spelling of "the" and pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-AAhfxh7Dwq6rt92Kx1fe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQMT82AAoJECmIfjd9wqK0Ze0QALf7Mo3Va/E1sGJTz3CK5pZ0
O55/dztnOr1eJZVvE2fKLtJMfEbgoA5kP+1/DWDdUIUuvwhmAWvMhKpyr7Kmi+Zs
CL+MCWRPCRGa3jhl6NfZbVSdn+1Smbrh1MR297PEy1kEG6qo3FL0T3jTvyrp1KYc
h8CNbRZbubvXnQlaC3y4m67blQY92wFYj8Hml65DyKlTIn1HLDOxUulVB7s9cYQz
5yUW6nfggu/OIP1CNlhIuC44TAtIUzBiK3G5MYco4s+WLXMsCF/Wh8/V4SuzG0xv
jN188o+AiR5ZFblxLV08qJ0YK8hsIs3BlzF8HqaxjddNXVrQo6X2MwdGq+otEDg8
boRuRGCq/o8ORGiz41UnCIIL3oxCvPHelSanDlobcL9xCBvYXXUBrimzMScApA81
70xxN4CZlIsWt+y+Wob9I/UEkaGaFj7TLewTgeLB5WRR+W6fPDsK6cL1AK9qlNQP
yycDk3A2qziSSinXlhexc/8qycFbTTYQkJZl87OXG0bsb9nCkC5j28t1Pdy56UUF
yHl7G8/uymCVcKYsWztY6peMdVvjnNpeK1P3KBMWZVszmoVpFRPOCsB2F4VmZYa8
JLX1iXV83XvvJ/FLVrYI56qjQZ4lu0g1PX+jUtfN7fa9BKjFrl7C9/PbmUlBXjDY
9cp4tALfFcsCsWKOhteJ
=Pztl
-----END PGP SIGNATURE-----

--=-AAhfxh7Dwq6rt92Kx1fe--

