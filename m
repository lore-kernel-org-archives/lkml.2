Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1KDLWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 07:22:13 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36889 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab1KDLWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 07:22:12 -0400
Date: Fri, 4 Nov 2011 12:22:10 +0100
From: Borislav Petkov <bp@amd64.org>
To: linux-stable <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL 3.1.x-stable] AMD F15h cache aliasing fixes
Message-ID: <20111104112209.GB8020@aftab>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
user-agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

as previously discussed, here are the 4 patches needed for addressing
the issue in $Subject. I'm sending them as mails but I have them also in
a git-pullable form in case you'd like to verify them:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git l1i-3.1.x

Here are the patches on the branch above along with SHA1s (from the
bottom up):

388e48924e2a891c42262ce2a8bc2479bd5984ec x86-32, amd: Move va_align definit=
ion to unbreak 32-bit build
31743a0af6a31c82897eaa55b81b41a8d5e48094 x86, amd: Move BSP code to cpu_dev=
 helper
277d13f2fdd7af1cc785d627835c67af2865defa x86: Add a BSP cpu_dev helper
4143701b737dfb1443be126910330e570d4041a7 x86, amd: Avoid cache aliasing pen=
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

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOs8rhAAoJEBLB8Bhh3lVKBiEP/RELz1+X6SQo3uZ6y/zxrE+B
bhNaq2nR3fmf+TuJox8FJOebptd4lp9QXYu/f8uEavSPXhIo6WeMM3LoNiUQsniN
TC0WNiDHCsQwzn1Gq8mjUbfs+TII9I+odIxU4WDUYCy4tdwqX6PV0mB8BS8i+QQH
7zgpNXfgEf3xtpbo7n20NMPryD9m/eEP7Xmu0y1Cm7hXhv+IPlToKf9Q/xn5hQB2
7nZw1NxxpB7ZnsiFgUjp6b9x9RGxUJGKzKkwmI6txSDIwyHwEh+GAkvzIQ9pUp58
WM1I1VL2PK/lSTUgUAVOzZWmpai2gwWwPZt32P56sd9RIgYhlOxkGrlwy1BS6qbl
czN8IDC9zCAnBaym3blIxtNqYmNS9sru4WAwmkoERwz2yM7aqsYe2h3opW0npS4e
6h5mv7wBDap3uhdEcNYwl+SFs589wC6e25fCVyCrQmSISZafwnvXJzN73KH8sPfc
dvI8hJT3U3W/RhfqaGqMJClVJdVbUAVU4OxTA8BIrlFmmgEIYOt8/11ifZ6GiSSm
PD4QHWR6ftMRWRxe8zPz3kmiK/qS7HSnMPCTMDkrRg8oHBX1Hj4NPqjI0ilwmhFd
Zq6TKESH31V2n29PXOjHVnb7GBz5OKckrjbs+4ORGqnX+kMS8PKzMeAcZK8BZJ/O
1b1yvcdggagexXXAIgoN
=20q5
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
