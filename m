Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757666Ab0KKAgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:36:49 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47245 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757653Ab0KKAgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:36:48 -0500
Date: Thu, 11 Nov 2010 11:36:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: build failure after merge of the voltage tree
Message-Id: <20101111113638.eb3101d0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Nov_2010_11_36_38_+1100_GRS5+9T7KZQXAx1="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Nov_2010_11_36_38_+1100_GRS5+9T7KZQXAx1=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Liam,

After merging the voltage tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/regulator/pcap-regulator.c:155: error: expected declaration specifi=
ers or '...' before 'unsiged'
drivers/regulator/pcap-regulator.c: In function 'pcap_regulator_set_voltage=
':
drivers/regulator/pcap-regulator.c:175: error: 'selector' undeclared (first=
 use in this function)
drivers/regulator/pcap-regulator.c: At top level:
drivers/regulator/pcap-regulator.c:251: warning: initialization from incomp=
atible pointer type

Caused by commit d2f03ebfe8c63d1e3e1ab2352dd32d161546003e ("regulator:
Report actual configured voltage to set_voltage()").  Please always build
changed files ...

I have used the voltage tree from next-20101110 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Nov_2010_11_36_38_+1100_GRS5+9T7KZQXAx1=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM2zqWAAoJEDMEi1NhKgbsKAEH/1uMePJretJO6erdyhBO1NOS
OWAONhp3MBj2/eXEh8JSjvqbKH+dmg7jUe0oMI+zacmOTbPiBInKSv+TQdbSOb8O
DHVUJp9dK2mZDG886LcGS0PwOvgeqjmkicNKF4uTr3HSQjxIGh3IrexwNzctxZXY
/XpxJcvlJLiMGP9CwId0WXLCUJKp0TWs9RuI2JFZGVhv0vQVG/FcDe0IYxb7+DoM
yodT96cHULDS/4Df06ZZt0+7RIZhogn8YSmkCYantJUEPVRSXqXAD7S/U/JeP56x
mYieo2LtN0BvxCHMoR/Q9ESl7hX4MRano8phWfKdzeQYVhsT89OSiEApf6tVMZ0=
=82ld
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Nov_2010_11_36_38_+1100_GRS5+9T7KZQXAx1=--
