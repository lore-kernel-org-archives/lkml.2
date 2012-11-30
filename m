Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab2K3LLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:11:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:38310 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075Ab2K3LLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:11:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,191,1355126400"; 
   d="asc'?scan'208";a="227100587"
Message-ID: <1354273947.30168.91.camel@sauron.fi.intel.com>
Subject: Re: [RFC/PATCH 1/1] ubi: Add ubiblock driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        michael.opdenacker@free-electrons.com, dwmw2@infradead.org,
        Tim Bird <tim.bird@am.sony.com>
Date: Fri, 30 Nov 2012 13:12:27 +0200
In-Reply-To: <CALF0-+UVNwAcEe5UVK9MdKYGwwubCi70DRXdWaojEUDg3uR+Xg@mail.gmail.com>
References: <1353451183-18807-1-git-send-email-elezegarcia@gmail.com>
	 <CAFLxGvxuRtbvTob0j-YgfK6Ydz9TVCdjD5NOToyyKQb2S7bC9Q@mail.gmail.com>
	 <CALF0-+UVNwAcEe5UVK9MdKYGwwubCi70DRXdWaojEUDg3uR+Xg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-t9H/mpfk7CtLw34LVLXn"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-t9H/mpfk7CtLw34LVLXn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-11-21 at 07:20 -0300, Ezequiel Garcia wrote:
> Yes, I thought of this.
>=20
> For now, I decided to keep the implementation as simple as possible.

WRT atomic LEB caches and barriers - I guess if there are users who
would prefer higher I/O speed to the power-cut tolerance, you could:

1. ignore I/O barriers
2. use plain leb_unmap/leb_write instead of atomic leb change, which is
faster.

There could be a switch, probably an ioctl? But this is not very
important now, I am just throwing an idea.

--=20
Best Regards,
Artem Bityutskiy

--=-t9H/mpfk7CtLw34LVLXn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQuJSbAAoJECmIfjd9wqK0FJkQAJWgCsQ7n3z1qaffKQWHJjvz
YxYMudjb9G1uhKkzDQBxnj7Qj5+LFj1YRdnz48Pu/6bGtoUQgw8Bx04FowABNDtR
3z+cZl1Qrj9Zgosx5A08OaaiVcePkkS3TuEH/DTVIswi0hd2h2J4O+iJS5e6uALw
lFHqj8K5zH9H7DWiUFuHK/Nva8XzARgbpKjyJ0d79r0jII2gbBFbzF/uLqrhv15Z
iV9bqwlBfrh8InCRu067PONejfW46RF6nGKP4hvxWXSR5XdtOdKALFTnG38zm4qG
1XNhNjSuW/U8bRKdAxbr2Kd+DBx3bW3AI4pbba/vAuYH5SIoZChZTbscUYSawphF
DicCCorwwyXO7J/imSPqTzmMkoic6iwSwbsBTxDN66O/wp1ZEpvIIr/xIph/tKCo
T8GiQnzZtnLmUVdOZ6gaOPG3nPCAeSZXSBDRPaNgkxSblE6Va7xJqQWfm9shtDk8
U9GMaD+dR+9jqlyRGGaEP/Y/u/v+2O1XUKQxQgkNZV4noOVgKNdIrqU8Xk5pxYOd
gTJfEhrrCPIQRPkrHaybV8zZ27pZS9W4amWViFtd7AP03pIfaVuxCv3ab1Co4811
c4Gweqqi7jjlzg+jjTFB/4hF3//oL9p1ukEG/z6NuYcQ+wPSfxBr3Cfxd2PEKEyj
2TBbRZz+kqUEk31cyC5C
=2pVT
-----END PGP SIGNATURE-----

--=-t9H/mpfk7CtLw34LVLXn--

