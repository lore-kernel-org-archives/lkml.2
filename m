Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab2CAFkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 00:40:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47954 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2CAFkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 00:40:16 -0500
Date: Thu, 1 Mar 2012 16:40:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: linux-next: manual merge of the arm-soc tree with the gpio tree
Message-Id: <20120301164001.77a063ceed2deaf37cf68e3c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Mar_2012_16_40_01_+1100__NlsNF0lVyww3oiO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Mar_2012_16_40_01_+1100__NlsNF0lVyww3oiO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
arch/arm/mach-omap1/gpio16xx.c between commit ab985f0f7c2c ("gpio/omap:
cleanup omap_gpio_mod_init function") from the gpio tree and commit
63325ff235de ("ARM: OMAP1: Move 16xx GPIO system clock to platform init
code") from the arm-soc tree.

OK, I can't decide which is correct here - the former adds this code
inside the loop (even though it seems to not depend on anything in the
loop) and the latter adds it before.  I have used the former (but am
happy to be corrected).  And both commits remove the code in
drivers/gpio/gpio-omap.c.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__1_Mar_2012_16_40_01_+1100__NlsNF0lVyww3oiO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTwuxAAoJEECxmPOUX5FEjGsP/2J72evCuAZQ4xO3CAgBtG6j
Q+06bVPyE7nLPK0Hndsza2b3q61tl2WihLyPywrIwh5VoASkp2JOag12o41ISQFJ
CQddKsag18vjAsC8dfo1w5aZSps836d988jUQssqeXpVWfxc/dVnbqcT1r+9/RTL
B8xzorhfx7tnnEjKuuIp57K+0OY3XXA+baNLPMvXT4sx+SysFFkbxZ8EUugKaC/I
psv9Gq1WjwX9yHQipgTlqd9hbHnyVVwR67nyWePstl5Y/KPBQz7pa9P2mprNl3iN
hQmHUlgkmuAH+wN5/JaI4URSM8/4cvTFi0GrctKdmMRZs/3QS1iWnnIPbYCA4tWo
ueLmu6OO8gi/JytYJsMRpLpXm/ykVDYjLS1v+KTEoPeHUPWfqKYfdu5K51mNjoxR
No7pvG7cDri0cY+FGHdEqx5GHr7+9mWel/avQahPuIIaAL+4Bm0vOC12Q8Q92QFn
CSQ1j78FVCZbwDGi7Ru7AVET+EROFQissSFlfAhZ/u/41OxTlB9ovlgrJ0FqiOlL
LEnhulIAbW6lUBBtF2dEQypcP79dMz2zK67C0mcKxqjouADyj7ZDC8PohXVcBtpL
NSB1kwMh+Q3kF7iH8gwMTSkrn4n38rWBaaUF4HAwxa/ocgzZP9zDGuaiCpY/MHRc
z5xJGIbjXwNuePMQRVxR
=vxJ+
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Mar_2012_16_40_01_+1100__NlsNF0lVyww3oiO--
