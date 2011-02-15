Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1BOCQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 21:16:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52250 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab1BOCQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 21:16:23 -0500
Date: Tue, 15 Feb 2011 13:16:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the bluetooth tree
Message-Id: <20110215131615.39f30d8a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Feb_2011_13_16_15_+1100_GWTpjdYxO87W6YDX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Feb_2011_13_16_15_+1100_GWTpjdYxO87W6YDX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

After merging the bluetooth tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "l2cap_load" [net/bluetooth/cmtp/cmtp.ko] undefined!

Caused by commit de5b38d18ca4f3f8b8e297211c3226c2a63226fe ("Bluetooth:
remove l2cap_load() hack").

I havbe used the version of the bluetooth tree from next-20110214 for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Feb_2011_13_16_15_+1100_GWTpjdYxO87W6YDX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNWeHvAAoJEDMEi1NhKgbsTSEIAJMvkeabqg7Y6dobnrsnmNxH
pEw3WMp7qLpb8KKkbPbJ+P597tJDYk9DrP6C6qyT4AaqNkgEwS8gGc3bSuhQPzCX
TxAVAo46bAcofuLurkl/Ux8ZWT1QX17586ZCdG3AqmbWVS9+9IHQzBm1Syxa8cer
UhvNLYeXw+51gav7ZaI2jhV9OpRLr/1UYPGF7obzucWBT4UnmQ9o7QymLutvfMm7
NVbAyyxDPAktgXErq69DsaG8PumY6P/NtWtPSZLboPujC8Ovb7iUjZPwxfluqNkk
Pbw1jR0A8ybwi8/G6pEiEZvDvlHfl+1bYl4DxDBALzdDFhGfTPX+f3Zhyxv1I90=
=6eya
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Feb_2011_13_16_15_+1100_GWTpjdYxO87W6YDX--
