Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab2BWUKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:10:20 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:46662 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756554Ab2BWUKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:10:17 -0500
Date: Thu, 23 Feb 2012 12:10:12 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Fix device class print out
Message-ID: <20120223121012.5933f563@jbarnes-desktop>
In-Reply-To: <1329691812-23665-1-git-send-email-yinghai@kernel.org>
References: <1329691812-23665-1-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YtxB/K.l/6sTtVFmYmCYPzi"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YtxB/K.l/6sTtVFmYmCYPzi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 19 Feb 2012 14:50:12 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Found debug print out about class is shifted.
>=20
> | pci 0000:f8:15.2: [8086:2b56] type 0 class 0x000600
>=20
> code is trying to print class with 6 digits, but use shifted class with 4=
 digits
> valid value as variable.
>=20
> Change to original dev->class directly.
>=20
> also remove not needed calculating of local variable class, because it wi=
ll be
> updated after pci_fixup_device(pci_fixup_early...)
>=20
> Also unify type print out when class and header is not matched.
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to linux-next, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/YtxB/K.l/6sTtVFmYmCYPzi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRp0kAAoJEIEoDkX4Qk9hdT4P/i6WZXI37JWBKG/2dDFTqojz
UUkgux8hCMsv9MOg35fBi4iLjjjwqt8vX3qwDPmnkvaxAZj8dLX0Vj9zUeFlJCkR
TnYAqNE4vwkSqgGLZ49G6dk0xrlREm43/7USDVUy9ip844t/fF/QtnBS3zQQxeuG
it4w+ZfMIVPk4pX5QkbcX2yY2imPAVG4vBfGSL88RtyrhQdnS+V1sv9KXYdh2THu
u74ENZoerdBlc4wxBxYvo5Jv2aPMjnLb4jNibFuXOawhw5yL+w0ku8mdK6Ye/hiS
fSykT4bmCdUYiDJk8gUNZ4KIhxxIoefjLcTtmGaazGcHPersuHG4K8GTSMY/Ur03
WySphAXFmdf3V7waD87AsAUSGZefJmfXhaL+wNp+I6U0Y3ck5VVCn4CYfPPcxTH/
uX/Qj1haty2htm/KtZWEK+lVj0OywGQwbvJFQ8h2T7JCvTS9AxYV2r5DlhuI6q/u
+hZdf4iFtscw6K87MTIcdhTF9q/Up5qDxTFnEil/xMHgNQJUba7K9RGpasyQ88kF
Q0Wm/aRdVh9Z/rcBLFDhmA0cUZTsfaYa02wGroxlXBsXxXWkkjyCDJCJtszNw7I9
boUi6Tgo/jUOrkmaeX5JCeLtH2A+x76OAteyZXt01Bz9bqnGMSoNh3Zx/VBw0e5B
8D7l+oB+acngEpYNpI0I
=enx6
-----END PGP SIGNATURE-----

--Sig_/YtxB/K.l/6sTtVFmYmCYPzi--
