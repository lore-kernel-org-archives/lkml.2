Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1IWJwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 05:52:53 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:49151 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1IWJwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 05:52:50 -0400
Date: Fri, 23 Sep 2011 19:52:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Wan ZongShun <mcuos.com@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [linux-next next-20110922] build failure due to missing
 arch/arm/mach-nuc93x/Kconfig
Message-Id: <20110923195236.6a885bf02e6161f537d22347@canb.auug.org.au>
In-Reply-To: <1316697473.6704.4.camel@phoenix>
References: <1316697473.6704.4.camel@phoenix>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_Sep_2011_19_52_36_+1000_C1v/t0nG7DT_hql7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Sep_2011_19_52_36_+1000_C1v/t0nG7DT_hql7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Axel,

On Thu, 22 Sep 2011 21:17:53 +0800 Axel Lin <axel.lin@gmail.com> wrote:
>
> I got below error with today's linux-next tree (next-20110922).
>=20
> $ make menuconfig
> scripts/kconfig/mconf Kconfig
> arch/arm/Kconfig:972: can't open file "arch/arm/mach-nuc93x/Kconfig"
> make[1]: *** [menuconfig] Error 1
> make: *** [menuconfig] Error 2

This commit appeared in next-20110922:

commit 6adc1e7ff19d9befdbb7781b26fff42bb0bc21e2
Author: Nicolas Pitre <nicolas.pitre@linaro.org>
Date:   Wed Aug 3 15:50:38 2011 +0100

    ARM: mach-nuc93x: delete
   =20
    This architecture received only generic maintenance since December 2009
    when it was originally submitted, and no actual additional support since
    then.  It has no defconfig entry either, meaning that it was never built
    by the ARM KAutobuild.  Incidentally it currently doesn't build either
    when CONFIG_MACH_NUC932EVB is selected which is the only possible config
    choice.
   =20
    This is therefore dead code and should be removed.  If someone wants to
    revive this code, it could be retrieved from the Git repository, and
    ideally be merged in mach-w90x900/ instead.
   =20
    Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
    Cc: Wan ZongShun <mcuos.com@gmail.com>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_Sep_2011_19_52_36_+1000_C1v/t0nG7DT_hql7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOfFbkAAoJEDMEi1NhKgbsUdsIAJMatBv0uSyRNkgCYg42JK64
AbChu6socbKmTduhJGq5rMgamy+nOFjJKFbDsyZOJl9S2A1EI/qmbuQ4InLiL3QO
VBUjYtBNVGZUVG1eZ96b1hL4WJ0/WVfZhHZfr5e+PkSAM7op0KYCZeDdZfzz2Zqe
5lL3YbTO+f8ocRAD22zuHIXT1w7owQeV+R67ttjQyU1Qych/IKM8kXj0X3tgtR6g
LypKZnIX9UfaDF0t89PD0aLTqGevDcm4GHZWfC/30bnTae+uBa//RFywGa9BGot+
kyswmUpkNTwiywYEwg068/20Pe60dfNzoIt7MKgp3t6M4zOfIqJgkN0T6FCAHAI=
=5JNj
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Sep_2011_19_52_36_+1000_C1v/t0nG7DT_hql7--
