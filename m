Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2LNAKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 19:10:34 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48359 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2LNAKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 19:10:31 -0500
Date: Fri, 14 Dec 2012 11:10:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: John Linn <John.Linn@xilinx.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: linux-next: fetch failure the xilinx tree
Message-Id: <20121214111027.d191eaa1799c0ce194aacfa7@canb.auug.org.au>
In-Reply-To: <50C5F1CE.30402@metafoo.de>
References: <20121209162442.15fbb8509569c193bfd88986@canb.auug.org.au>
	<50C5F1CE.30402@metafoo.de>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Dec_2012_11_10_27_+1100_FkFJu2dA5sgRNdHb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Dec_2012_11_10_27_+1100_FkFJu2dA5sgRNdHb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

On Mon, 10 Dec 2012 15:29:34 +0100 Lars-Peter Clausen <lars@metafoo.de> wro=
te:
>
> On 12/09/2012 06:24 AM, Stephen Rothwell wrote:
> >=20
> > Attempting to fetch the xilinx tree produces this error (and has for so=
me
> > days, now):
> >=20
> > fatal: The remote end hung up unexpectedly
>=20
> They renamed the repository from linux-2.6-xlnx to linux-xlnx. I stumbled
> over it as well.

Is this the correct thing for me to do?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__14_Dec_2012_11_10_27_+1100_FkFJu2dA5sgRNdHb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQym5zAAoJEECxmPOUX5FERRAP/R+ePLKApoAX9+sYOXHVKp/l
/a0DPsn2YLROCSF7K5/I/DUI3P7CvE+AiErKOyer3+7iFmZ8lM7RGZp77mnFmXhq
8wD9/GBlPWExqXcad2ZKsYiYLYrsJsJUd24/WFjpAv2cKWXU1kWLNvXGX1VTLAz4
Lc4Q/Vj8fqPzS8TTc6uueYS/IB51X4jizSVSi70tDlGrDOsQGQ9vG2aCm1LFRNHW
rN8LoRdwpeFDL9LRtllz6Rg6HsDYlvJBMHp7ST5J9Vetv01VP/g6fSCBQU5Wc/Ew
ZnjYoYhxfbFnB1Hb+C/mCLIEuD5rfrafZOLn7HM9XiJP9myFqVnystlUlgIF4bvL
bCR79vUA/1BRBH8tB5b6pjO4WXgHj1jJHRMOkpOWIf4nbO7pJo7fdZUXQCtmupMH
WtTUEwNhiIdwn0/JrF3t4IK8tJ49d/efUS8EOC8u/EyPtP1IPfJPLLQB/9tRDl7D
zCTvDe4uScm/FZ3y7jBBS8E5i93KWvoOtGN1iGEYrO3XIpm7EOt84kZCoqrSsuX3
8RBUIrCVfkRSQgtpkwAckofZy+FdquauwrCf99+i005tS//vJxcvfhLneQKrvzvz
cn/bseusmaX+8zY6td5IOdcSVq8S8qBTolaSVYF5mCzAg1pqScTVkXs/x3eiQNss
9HmlfKeG0uOOhLPvMHKh
=J1cn
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Dec_2012_11_10_27_+1100_FkFJu2dA5sgRNdHb--
