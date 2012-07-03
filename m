Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2GCOkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 10:40:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:36502 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab2GCOko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 10:40:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="166349350"
Message-ID: <1341326690.2979.84.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/3] fs/sysv: stop using write_super and s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Date: Tue, 03 Jul 2012 17:44:50 +0300
In-Reply-To: <20120703151313.36e85254@pyramind.ukuu.org.uk>
References: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
	 <1341323008-29414-4-git-send-email-dedekind1@gmail.com>
	 <20120703151313.36e85254@pyramind.ukuu.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Nt6XxlznzRO3vIDv2KfP"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Nt6XxlznzRO3vIDv2KfP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-03 at 15:13 +0100, Alan Cox wrote:
> > drity and then setting the s_dirt flag. And when 'write_super()' is exe=
cuted to
> > handle the s_dirt flag, we just update the timestamp and again mark the
> > superblock buffer as dirty. Seems pointless.
>=20
> It's the way sysv itself does stuff. The timestamp on v7/sys3/sys5
> reflects the clock on the box. A lot of ancient boxes with no decent
> hardware clocks used to reset the system time off the root fs superblock
> on a loss of power.

Oh, OK, thanks for the info. Do you think I need to take more efforts to
preserve the behavior?

--=20
Best Regards,
Artem Bityutskiy

--=-Nt6XxlznzRO3vIDv2KfP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP8wViAAoJECmIfjd9wqK0UhcP/3rHIGgxYW4tniyRCYVs0PnT
mM5Nb3Hmv/UsyJ62vbLdf5KkFI0jKCHugBE/cL06nhF6C0ojfyua/8GOsJvQrJeN
C3DU4Lm926M5OV4m2JJNCNzp5VSxjeNK/qSLcABmOLkBIvfrOMTB7b8b511DpoIK
p5ZWzj/M5X1A1O5jIemZp56bMnmMbSQ1uiFOe1G9fHz8pXKMl4zkiq8NyyF2yGCr
qbwH8psVrZ3F1vrdDtipGwJtCfDPjwd2XMMKcjKnN4oBbfo+dt2Lr+AAifIZphVj
FnlgtrFjCvw3VQQBQ+a1iNf4WAVIis1u5/nXaZaQY5jgCwZg4zn9ee5IGggaYiPS
nEEFhoqVGqel0ks/+1f44rCUQT7S69y4bqRFaX2I61tWIRK95nkyhidKBbxGiEFc
loNAryhTFlvnYYXvR6UYEYd13nST7xxNWoZLL4Ou2FItugsyE+7PkzQTr/yQqtPN
pfh5IY3LLEzLtCjC3bFmJgfFZVAT2/9C/PO0vQq5gJpA4z/yx0UYYXyVb/r7yE0K
pkNlZCmP7JquhxzF//Av8enc+sWMxeRZZQ08da1mCnD+UbBjwEswd3sp78/UyNaP
6nX0SNWkNc99mzrIN/CbbxSD534oQSyhqNa4/PBCFWIlpNs0RT/jKAjoZ6xxQw+l
mJ157hu36QVPsVcVmF50
=qvsy
-----END PGP SIGNATURE-----

--=-Nt6XxlznzRO3vIDv2KfP--

