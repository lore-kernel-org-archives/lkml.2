Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2DVO3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 10:29:50 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61646 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020Ab2DVO3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 10:29:49 -0400
Message-ID: <1335104830.28267.16.camel@brekeke>
Subject: Re: [PATCH 1/1] Remove UBIFS_FS_XATTR config option.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Subodh Nijsure <subodh.nijsure@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>
Date: Sun, 22 Apr 2012 17:27:10 +0300
In-Reply-To: <1334419797-28995-1-git-send-email-snijsure@grid-net.com>
References: <1334419797-28995-1-git-send-email-snijsure@grid-net.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-sUApMPphhm3s8kyVBo/T"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sUApMPphhm3s8kyVBo/T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-04-14 at 09:09 -0700, Subodh Nijsure wrote:
> Remove CONFIG_UBIFS_FS_XATTR configuration option and associated
> UBIFS_FS_XATTR ifdefs.
>=20
> Testing:
>        Tested using integck while using nandsim on x86 & MX28 based=20
>        platform with Micron MT29F2G08ABAEAH4 nand.
>=20
> Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>

Ok, while babies are sleeping I had time to handle my inbox. Pushed to
linux-ubifs.git, thanks!

--=20
Best Regards,
Artem Bityutskiy


--=-sUApMPphhm3s8kyVBo/T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPlBU/AAoJECmIfjd9wqK0df8P/2ASR9oO47/Z/VZDApcNT1ju
n1yUyQKN81zsn6LqFwQ1uL/TIUHT/X3TYd4hi1EpzztFocEIAgWJRk/cpOyxTbkP
UozLFLhbwP+m9PqOLXDNgAr3FCS+ZjMERVl0SJw52YLWhRvm73m362J10MUaGPPV
OcFRorgxyjGvSN+EQ4QgeXMqvx+93IYnCsPNICegQSFURKBTtMU95qjMgSPXDRAe
00CPZBCfvNLfN7+yqgH71sH1HfspK5HhLA3CgDiscy0bI+LQTUzrQwLxdpBnk9no
c5SY3InnCNMyPX4rklbLhN7/ABfYft3p9vnsOW4UneOXnNBSYZT0Sq9WfM3X9QAY
b/aqESuTjyoJt2dIcznZjjtaxCTDE/+giQkxNVnh/1PVgtk3XA6sKfYaPU3wfP0j
KoCRnfoesoH58sbA4uFzwFzfVX6NTm6eK12eMU4kEfbWU+OxoutUnAswj3av4sGZ
DkymCDT/YKP+u5rtelwQwiB3YCxXhFhumjrEtTC0dFV8+C3G5FlxJiNBNuBpa/jt
qUO7HwRxcQwF1ZmyFmN6X4JDa/JhTBbt8NLGI9jvYlsuKrxiGcpYs0ckKVeWDHBy
3nAD7BLm0KRkEeHMvziJM+IPFew08vd3/8lDU8sQL5nuOrVPQcLq8Izgp1F014kx
hj2/5LRLf5pGIEdy91i7
=YStA
-----END PGP SIGNATURE-----

--=-sUApMPphhm3s8kyVBo/T--

