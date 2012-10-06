Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2JFXvv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 19:51:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33690 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2JFXvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 19:51:50 -0400
Date: Sun, 7 Oct 2012 10:51:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: Re: Please add back the asm-generic tree to linux-next
Message-Id: <20121007105139.bbb7f7603147965546c41309@canb.auug.org.au>
In-Reply-To: <201210061254.45804.arnd@arndb.de>
References: <201210061254.45804.arnd@arndb.de>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__7_Oct_2012_10_51_39_+1100_dTok+ebBH90ODHpV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__7_Oct_2012_10_51_39_+1100_dTok+ebBH90ODHpV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Sat, 6 Oct 2012 12:54:45 +0000 Arnd Bergmann <arnd@arndb.de> wrote:
>
> I haven't used my asm-generic git tree for the last year, but now I have =
some
> patches in it again. I was (ab)using the arm-soc tree for now to get the
> few patches into linux-next, but the URL is still listed in the MAINTAINE=
RS
> file and I should really be using that one, since it is mostly unrelated
> to the arm-soc work.
>=20
> Pleas add
> git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git master

OK, I have added that back.  You used to use the "next" branch (which no
longer exists) but are now using the master branch, correct?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__7_Oct_2012_10_51_39_+1100_dTok+ebBH90ODHpV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQcMQLAAoJEECxmPOUX5FEypYQAJIbdVwGUfowV7kzUZQYeoTK
REv8q7yhQdVjC2b0zcvAAxbpOONcBSBUprd/t/5t2ufQiGsWEqXGxix/RjwVRAxo
xNQlolqG6fXAZ0ZyzFPLLCQtkCVXdMLfIcYbDCiACWiwFJxKp7d0VwXE+ijTzjWP
rqQTV5TpcSVjPiGjim6AsSf6a5e611OXGPFsP77yOAnJzNzQtoJWbDJQQgipoMks
5Z3KvXz2+xrGuE6eJ+ZH5yPOJr9DIRA5AH2lR7/TS9HewUGERy4R1M1YqGW9Qe08
Sm+f7g7CgZBsP/bysO9saWHlUu3bvM2/te1k6fKJeR34rwYmZ/lWAVbIp0YUdu+Y
jU6HVacE4R9V13inmi4FL766ke1+W5feq87Q/ZwC2HbQThPlWDwbKP4dHDymUezn
q/hDBEFwTOXed25aoKq6mvt2M99Rkf9Z6N7Sduqq30n/Tb+O5EsRhYSHWMPQ5lbf
uvMXcHTMGIjtcXD2+iOw+1K69U46UlwU28s1FHwaRjLdIo+kdJxTzWv9iZP9zXHw
lpDjQe6GxY/r7LXxW71WTklZt9JXvFKV8nTMhHOzaXvtqJHKN8B1ZSaEQhlS3M+H
VSaC2ERvZGchheIviiUvR/zcWVVVgJ9ZzCE0Q/okwZ22GLMir1Yj/MvJSBlBteRI
215iXZsyEY7e/qjqHPlS
=NPiB
-----END PGP SIGNATURE-----

--Signature=_Sun__7_Oct_2012_10_51_39_+1100_dTok+ebBH90ODHpV--
