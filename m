Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004Ab2EIPeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:34:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54651 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758501Ab2EIPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:34:19 -0400
Date: Wed, 9 May 2012 16:34:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] regmap fix for 3.4
Message-ID: <20120509153416.GB3955@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t8N2qprAjL+0GVly"
Content-Disposition: inline
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t8N2qprAjL+0GVly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-3.4

for you to fetch changes up to 6560ffd1ccd688152393dc7c35dbdcc33140633b:

  regmap: fix possible memory corruption in regmap_bulk_read() (2012-05-09 15:44:11 +0100)

----------------------------------------------------------------
regmap: Last minute bug fix for 3.4

This is a last minute bug fix that was only just noticed since the code
path that's being exercised here is one that is fairly rarely used.  The
changelog for the change itself is extremely clear and the code itself
is obvious to inspection so should be pretty safe.

----------------------------------------------------------------
Laxman Dewangan (1):
      regmap: fix possible memory corruption in regmap_bulk_read()

 drivers/base/regmap/regmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--t8N2qprAjL+0GVly
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqo5xAAoJEBus8iNuMP3dcjwQAJpDZu/Sf0P/UWAltpWjx0UR
K87ltyaGe3EsohC8ASy004A/DK41oObyeICrM04bEjkrs4SJoc3azOqGXjig4ya2
DnzFi8vZYVkp0td5w62osODD45xOzzWcFl/VNVQLZYqVFvA8nhBCyCxvmy7djT8h
Q5Thzuel24Cp6uilQCLliQGbFlnK0CHjZBFyeG5h21qqedJ3VmVLpCEjIAi7p/M+
HXbWzylyotipBgmoE7V8cNJYI6o1PJgt1iwJ70oi0VBUb5ATtZFE0YPj0MMRDH6Q
BIdUbmmRB6BpfPUIWEiLC96lomyZpCf/IuHWHefxkP6QAF8weqLdfaCrIz2AQQmc
0ez9npD5kgTDP8RSNtaeD1HSaXcHCA/TArhjiwQR6Iqb1BiXqAMyDh0ZJDinoQwM
IZcYtdWTkJECq6oeAOBZEghRR9H8E4O84SD3r3gCjMT3s32CUfCVLyDeaKgG4MJ2
xs3RG0fv85GOOzz32zyKN+r9laJSSF+9wKmPtU9SJNsIwPMySF/5WvwaL61Syg1z
PjdaFulbitYrOz7rvANA1hzkI8RctcxLpxEYhSqlxe+d47LPwne6JeW4zCM0PkTV
cxLVXoOBpbxqdyQiYxGOfVALb7yUGo/wglDIWqU8wZ2p6LHFXL0gg4p+zwfXM2BO
X6ksvkN9/YZwWD9UyYNj
=agwn
-----END PGP SIGNATURE-----

--t8N2qprAjL+0GVly--
