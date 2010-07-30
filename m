Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340Ab0G3CGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 22:06:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43162 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750Ab0G3CGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 22:06:30 -0400
Date: Fri, 30 Jul 2010 12:06:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>
Subject: linux-next: build failure after merge of the security-testing tree
Message-Id: <20100730120624.f3112742.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Jul_2010_12_06_24_+1000_DHEHe.bPcx6MQavJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Jul_2010_12_06_24_+1000_DHEHe.bPcx6MQavJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the security-testing tree, today's linux-next build
(powerpc ppc64_defconfig) failed like this:

security/Kconfig:144: can't open file "security/apparmor/Kconfig"

Caused by commit 32bd8e5273c0be4189274ab55c4d16862f0dd87d ("AppArmor:
Enable configuring and building of the AppArmor security module").  Looks
like a file was missed.

I have used the security-testing from next-20100729 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Jul_2010_12_06_24_+1000_DHEHe.bPcx6MQavJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMUjOgAAoJEDMEi1NhKgbsYSQH/AmqUD0ab+wYD7bgq/lWy92H
dDLqZJCBvvqVMFHPDM+4E63W/bNVUVCOzhId+JaUB9qOngjRWrMdE53wQDD1eVIB
2crewW0JWbSY/QrOlT7aib4dQqSDpV/yoo4mCcO1RAxLx3z4nJNtD5niO2gUfRWe
TYFoWcIU7V3CQelXGa7i4cTbpe9St8vvuHBRf7Sfxy3evFC/AxpIQuj6fHgHWzXF
RmNQDQcL4M2bEGJjVl+dHZ2nbMdT9SFnmjnGdeeOjkgMDSuRMooCUYTgPXvCKaDh
s6lR435+Mu5BePZ59pfVcqdtAgGEb5NXRlifawfgw/M+tNWe3vrjnhEDPiyu9ZU=
=jmh5
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Jul_2010_12_06_24_+1000_DHEHe.bPcx6MQavJ--
