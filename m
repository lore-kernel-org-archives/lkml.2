Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2BWU1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:27:12 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:57564 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932209Ab2BWU1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:27:09 -0500
Date: Thu, 23 Feb 2012 12:27:04 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: move pci_find_saved_cap out of linux/pci.h
Message-ID: <20120223122704.262229fd@jbarnes-desktop>
In-Reply-To: <1328948321-14791-1-git-send-email-yinghai@kernel.org>
References: <1328948321-14791-1-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tsLomWQFrA3wsJf0ZIWtMrM"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tsLomWQFrA3wsJf0ZIWtMrM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 11 Feb 2012 00:18:41 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> Only have user in driver/pci/pci.c
>=20
> Don't need to put it in global pci.h
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org.

Applied, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/tsLomWQFrA3wsJf0ZIWtMrM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRqEYAAoJEIEoDkX4Qk9h9dkP+gPf9iROfuwJT8v8xBdImNVp
gYnOJRejGG1wXiOY0T2xe/fZStdGkoTt1PFiY/V0MJsdFz/x2d4mp6fp8bs1GFkP
3DcJe6uiGX2hcXACzVc2McBHUSrRUCQTT+358c/lxgmxzfHZBncN7kRVWvULN7iP
kOHC0n9XsVz3vO3L7hZ6At/j04u7sFo6P+9jGrNgmar305Ts4OiMOhK9GOs2dJjy
/wXiHx3SB0DbwP/HGjMZ012faTQx3wLGr3xaml8XbSP/BziGofiMvuTqjD7MiAHa
6X6y5hZA+eXJL0AQkB6E9ZRKCqocpPXr4eLDGUWrbMp+KNHA96/BUd6Tp7mHTWXR
oTLjNZp6IS9HiCkYoHGiK/vXp2xz9JRgZDxSbNXcPvnCXJT9o3oMYtIe8bIW4H0i
XPUM3v4Z+tyTp0499TvbV51BoqSf8c0QGeEWikgOJMTgBLm8xuTlxlYBUBREvxip
LFOi2dwCBoI8T+5fHQFQbJTTDi/P00ykw4gxOSr9r4c+7t4HqSJvqd7Kljp5u9g0
+wK6izD9hOUzrndAH25k1KZzeiw8FAJzDizWr1SviBcpesJeqDNdo0XNZZI8iO9c
/aUogsqutnHDVQlRAv9xuiVYevupENS+R9UI3mqRInw+KGX3nFiS8Pi8oiYHFy6z
BGSvRussP4kJts9eSBxN
=Jq6Z
-----END PGP SIGNATURE-----

--Sig_/tsLomWQFrA3wsJf0ZIWtMrM--
