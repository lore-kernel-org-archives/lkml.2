Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab1KDLLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 07:11:19 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35687 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1KDLLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 07:11:18 -0400
Date: Fri, 4 Nov 2011 12:11:15 +0100
From: Borislav Petkov <bp@amd64.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <greg@kroah.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL 3.0.x-stable] AMD F15h cache aliasing fixes
Message-ID: <20111104111115.GA8020@aftab>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

as previously discussed, here are the 4 patches needed for addressing
the issue in $Subject. I'm sending them as mails but I have them also in
a git-pullable form in case you'd like to verify them:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git l1i-3.0.x

Here are the patches on the branch above along with SHA1s (from the
bottom up):

bf27c8742db1e2c01bff6e8e2cce3b14d5d6cca5 x86-32, amd: Move va_align definit=
ion to unbreak 32-bit build
57d8c29f231049d7b10a497c8afa42dba4672a70 x86, amd: Move BSP code to cpu_dev=
 helper
28b1d99bcde97b468585bdf6c94fa51931d2a1aa x86: Add a BSP cpu_dev helper
5c303905f98ab4e378488c919cc60483d59002ff x86, amd: Avoid cache aliasing pen=
alties on AMD family 15h

Please apply,
thanks.

--=20
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOs8hTAAoJEBLB8Bhh3lVKC8UQALLoMV6oQ/1zt/MUnjueL+qX
zYuZTOzCJ1ntdgX3aZMb1k2+pQM3UiXbPEnN7Tz6zNDHH/NcrjUrMBizWcqQagQ5
6MDJj+diw4dhFa++5vz1z9yp3kb+GHwzQMaOD8l5Nk7E1u62Nh7WFoOfqg/Jh4Oq
PGmXNH/ewzYFNAWom2HDiDCsFG6YGkG0bXFPpyZ0MlrMM1ol9XVQ/l3ekUqrjMR7
nW7uVSgHU1gxoFMcDs7vhKttA0ubcCX1AN0+J/UQoOo60CjgSP2KVPbSvCJbXu/x
n9+SzO3OROS27Db6IikBtgR8hnQ/S2EkoUUQRQg4A4FAi1xeTfZLopndZcU7DSBJ
GTIHmu1vGKT86b9GrKznm1ktMYyHMMn7tKcLmWsA4PYRjW/W36FAkJX5y2qSeAJj
ylRCL5Kd8h+A2QCxySO+00GXOd4EqxEJoQOUWmZBsc84jJyy5J5JbZfGMLJHsJuK
D/xTc0kkOFlzg37gyuH4HTa4P2vd+yuIdWBvIlG5ZCaou8V/NAx9yHGg2NwPmZlw
NOYTcW6GdH3ymhVnhhYefi6u1KTeXWGIWmo2gGdeEqg5NFIsV+y0Js+LoDh1kZIA
Z/ZYN37zVqRdz5jZnxzhY5xPJ3Gc8VH3HpgIf4857DFacwL1OVUBRFMd75rmbi7G
kOeuf9r/oEaBkCqvDqJ6
=D+g8
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
