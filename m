Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab2EaWEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 18:04:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43848 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab2EaWEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 18:04:14 -0400
Date: Fri, 1 Jun 2012 08:04:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: linux-next: build rebase of the drivers-x86 tree
Message-Id: <20120601080404.64da2644d5b26c7101e1e274@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Jun_2012_08_04_04_+1000_JrJ4Rqn1_MJZkniX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Jun_2012_08_04_04_+1000_JrJ4Rqn1_MJZkniX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

Looking through the drivers-x86 tree rebase today, I noticed in commit
62cce7526629 ("toshiba_acpi: Only register backlight device when
interface is read/write") that a memset has been added in the wrong place
- about line 1100 in function toshiba_acpi_setup_backlight().

/me mutters about not rebasing before submitting to Linus ... :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Jun_2012_08_04_04_+1000_JrJ4Rqn1_MJZkniX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPx+rUAAoJEECxmPOUX5FEryMP/A1AHeJ+eRN3HBLNlmUMTogt
Bbep9HKpufGz8ph23TQw8SxUN/DYsaMsjlvKGo0a74RzpcJSOvUlBLhd9+HiJ1eB
T6jUd8ENfnt3MHs1r9yyUJ9cCl9nMqI9bPhBoKc/I0U4XxTCvCxzc2+xZ69iYwGd
KlR8/d1yDP91CDNxr9PwABwvQFFu7unbDYGm5M8T7Igvph4YKS0PLzcbQZ705Bwz
rq7CRb+jqMHHfPJwGpm5seWqlc2jKhGrQZd9ITVoXJyyIZ6jFmhBIsUDo7Hr9yLS
UCptFTK7qDN45IAPDDe65v2yO1Q0K7FGC5TBFgIwv8r+M4GqgaT1TYtloq55bAa5
Jfnyh3EMn3T0vxTonmsGbARy2OMwq0ZqyJbsRVdyheuFv2lSgDMEA9LXvx1dOkaL
YxS6Mj3CR98R6QRfKpYzsDWNydIRiLgU1WhKlnWNhy/bbbhYMGVNzJU+2RnsdiVc
s7i4BuTC1wE9kz2zSo4lpQxTwab33iGYb7yBW7qa7jkPlFd+2a918hgyh2aalXA3
nAJihhw/su3rx5CY1U6iEWlrotnS+mPGlNPNOC8MooaXNYYzwZDiwtycjJ85dn1J
wYLONCpErjaKBrv23PAd6ImetShu97sOrKnRaKj73Dk3rfvlsPvUQKHYLc4qCBBB
v4wIzUel4IDjb8qTmc6R
=KLLh
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Jun_2012_08_04_04_+1000_JrJ4Rqn1_MJZkniX--
