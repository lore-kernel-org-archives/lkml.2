Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2IZGBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 02:01:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48165 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2IZGBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 02:01:38 -0400
Date: Wed, 26 Sep 2012 16:01:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120926160127.c34cb6d3e5dcc9ab32e8b573@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Sep_2012_16_01_27_+1000_M8LjVwyiXBMI+2kR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Sep_2012_16_01_27_+1000_M8LjVwyiXBMI+2kR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/key/af_key.c: In function 'pfkey_add':
net/key/af_key.c:1476:9: error: implicit declaration of function 'audit_get=
_sessionid' [-Werror=3Dimplicit-function-declaration]
net/core/dev.c: In function '__dev_set_promiscuity':
net/core/dev.c:4573:5: error: implicit declaration of function 'audit_get_s=
essionid' [-Werror=3Dimplicit-function-declaration]

Caused by commit "audit.h: replace defines with C stubs".

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__26_Sep_2012_16_01_27_+1000_M8LjVwyiXBMI+2kR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYpo3AAoJEECxmPOUX5FEvZQP/1shf6QORAUryr+0j2HMuAtv
cxpkKm/l7PRrR27+Iq5Sy/RB1XNwCjiQoJeJ/lpYw+hNMhLsDe4doRQku9WO+O14
YVVd+PgmvLG+pAvyIIGDj+4futJuczOkqCO2QbONrbate5MgA5VU9jKIPSeEHJY7
W/+BPRlOFCALTuMi4srkPEpLx+0mA06McOhINC93Ci1PFHmJmDI0Xblb/yr5T4O1
9xqldWQZdhglW4H4H1eO2q8YPJQA0tA+hLsRKEWvA3V/GAcDOghRRp0BOZ3IZvQ5
VFqtF25ucmdFq/dlfYLjdTBqH2SFPcU1EgvEyxnv6XcTW5AKc9Uwlm44GxjUhP2u
5Zg7XuIOcifzYmflQWYfZXqxsTaK5SWIpx1L6KCS4CY66URS/kqhm/z57c3Pc0Vo
QMlds+3yFOvINkBtpUtgKrl3nuEu0KHpm0wjdTDs7x+aMovJMENykcgIxk3NQOI7
lcF/xcBTUfYUzmG8j6uPVd91a/AmJloEn76dkO+msVoT6Pt/boKDKpv1wsg6IJjx
zSZ1kgMBsLKzlyZbgUEm56vSFUCc+JlTkobIRI/N+01cWUOnJRiOVrg78lV/+dWS
crIctOZPU7IF2z/GNtfyerk5CyhVvNuovI7UOgTTJZvQt0vZJvZ5IICgeTRYSDCK
EgKDgjhDhDfuCUZjPvYR
=DgOC
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Sep_2012_16_01_27_+1000_M8LjVwyiXBMI+2kR--
