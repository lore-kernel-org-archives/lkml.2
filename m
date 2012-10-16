Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab2JPNbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 09:31:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44278 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab2JPNbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 09:31:33 -0400
Message-ID: <507D61B0.5010602@ti.com>
Date: Tue, 16 Oct 2012 16:31:28 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAPDSS: Correct check for the callback pointer in dss_dsi_disable_pads()
References: <1350388281-20397-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1350388281-20397-1-git-send-email-peter.ujfalusi@ti.com>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigDB8C1FADA9A170AE373454F3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigDB8C1FADA9A170AE373454F3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-10-16 14:51, Peter Ujfalusi wrote:
> Appear to be a copy-paste bug: the code was checking board_data->dsi_en=
able_pads
> while calling board_data->dsi_disable_pads.
>=20
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>=20
> Hi Tomi,
>=20
> not sure if this need to be included to 3.7

Thanks. Probably not needed for 3.7, as we never hit that bug with the
current kernel: if dsi_enable_pads is defined we also always define
dsi_disable_pads.

 Tomi



--------------enigDB8C1FADA9A170AE373454F3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQfWGwAAoJEPo9qoy8lh71/UAP/iNqJxlJYTWp7tSJl8HOVCSS
SeePumroGi+alSai0Nivk3tZ6x/RBRkTKcIo2xqufUIcW/J5ZQd1sK8SYLt9q7Sd
3G55mGfEuLlxCGNURf3rBn08JCXVakHyc0eWn15xVx9uZTehav4ckpr535S8j3mp
wtWyzmRlJm+Bpb0pW/4Vyf9FXk/meNqibVDx3xWUVvsZ5qk0HCQVi7HGFmZOL8Xs
2QL8bZS605whbvevSbLe2YYoCOErRVKHw6t48hsqSOf/D9Dgq11gCOFvO5FGQ+5z
9nc27jd/f8s3NIeVMOOxuaJT5bl4md2FSYwskFGRFbxQbZa+7ACKoQ0o9GR1vjFD
4VMuFOHlrjKcCcKlOXxoxNioWhB9SYkcoYAYdz+qRWUtgkv9xlGAwrIJqD3EoFVB
f8OCmyB9QhQp6KrdNttnlsDTFCp16LYAqiaEgmXJV++kcbeo5ZYlY3myMO901kWw
7v8tXhV8m6abmv5l6ucdQszuFGU5Jx0jSAq910deD0wNOYpq6KcwtDsh0TdfQoPk
zudAEjyulxWTb/w3MR7pSW8rX12SXSJXwHkYs7UqsqiShGkHb0+hvBGnxoPsm4Y+
Hl1wXlEfMTQzwNpA9fRkl3/KAwWHU82qWECReVqsGXTLEL6mn4fQ+sijiS6HxsQ5
vyXs3Yq71E2eyQmfYlHm
=PAmv
-----END PGP SIGNATURE-----

--------------enigDB8C1FADA9A170AE373454F3--
