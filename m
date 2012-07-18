Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2GRLGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:06:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34909 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2GRLGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:06:46 -0400
Message-ID: <1342609272.7530.14.camel@brekeke>
Subject: Re: [PATCH 2/5] ubi: Limit amount of reserved eraseblocks for bad
 PEB handling
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 18 Jul 2012 14:01:12 +0300
In-Reply-To: <1342607317.7530.9.camel@brekeke>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	 <1341389164-24409-3-git-send-email-shmulik.ladkani@gmail.com>
	 <1342607317.7530.9.camel@brekeke>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-1QRPEq3gGp2nYrI/8Hy4"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1QRPEq3gGp2nYrI/8Hy4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-18 at 13:28 +0300, Artem Bityutskiy wrote:
> >       ubi->bad_peb_count +=3D 1;
> >       ubi->good_peb_count -=3D 1;
> >       ubi_calculate_reserved(ubi);
> We do not need to call this function from here, right?

Err, sorry, it _is_ needed!

--=20
Best Regards,
Artem Bityutskiy

--=-1QRPEq3gGp2nYrI/8Hy4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQBpd4AAoJECmIfjd9wqK0UosQAKuV33VSodFvel02zwb/5T89
VgeulBO/S1jVAkYzSQKYKqVRdUMdIZHrxXgyq4BxfRoT6ZPvUgrVJqkExBg4fDSb
OtM6odLuvWa/GEGzQCkjc3siRHkT1mF8TM4YLScBdPZzvT7zpdO0bqLi6zhRnr9Q
XMs/Zsdp3X6GdbtTZCf5MlascD0Ituk7GerWs6mZP6Bj3+Noi5zfa4HJ5M8rIxNZ
LU/72W8omGgj25MVVOK6I9JPwLxhXjRJAi1cu2BfIAuoCTiBgFYy04qB8k4h0m7s
FmFqmBKBrgy9An2eQHX2MmP8w4o+vRtxtL4Oe0N0r9CHlASK51NP8DW9E7RKtip/
lL1l2AQSmqyiScapjuS7dUE1fLq0OdBCj0yHHFfzER4ReHGOJ2pxdCTTtYrP+/VY
83sLHo32cPz1WU0epjCb/PY2qnUQywSm5xRTidYQ3ZQyvl6snqln3dNq11NdOQS5
Elw3tPRLBaxJkad/czwSwWHVa49LVLlHjhxyRkOt2dGpqoRAMw0m8jEDHABHFZ0E
hmxW/gQb2ZcH1xDC+krZjYBo0py2IOCHeu6o3+5IW+IBhyj86hGKKS6pfB+2ssRk
BP1dPk/aCiwAMquc3RdGgv/KbI6wDriFN85PspZZFiNYOqHl7cOcqH9l4OL4fMxD
Os+CcOkn2EQs93TQlY3r
=x/f5
-----END PGP SIGNATURE-----

--=-1QRPEq3gGp2nYrI/8Hy4--

