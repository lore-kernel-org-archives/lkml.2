Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2DYPdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:33:13 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65129 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755258Ab2DYPdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:33:09 -0400
Subject: Re: [PATCH -next] mtd: fix sbc2_flash build when PCI is not enabled
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Tim Hockin <thockin@sun.com>
Date: Wed, 25 Apr 2012 18:33:02 +0300
In-Reply-To: <4F8C780D.9010702@xenotime.net>
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
	 <4F8C780D.9010702@xenotime.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-JuECyCsuI5LDt9lG4JKJ"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1335367986.6356.12.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JuECyCsuI5LDt9lG4JKJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-04-16 at 12:50 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>=20
> sbc2_flash.c is a PCI driver, but its build fails when CONFIG_PCI
> is not enabled, so make it depend on PCI.
>=20
> drivers/mtd/maps/scb2_flash.c:237:1: warning: data definition has no type=
 or storage class
> drivers/mtd/maps/scb2_flash.c:237:1: warning: type defaults to 'int' in d=
eclaration of 'module_pci_driver'
> drivers/mtd/maps/scb2_flash.c:237:1: warning: parameter names (without ty=
pes) in function declaration
>=20
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy


--=-JuECyCsuI5LDt9lG4JKJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPmBkuAAoJEJtuLFy+q7feiIgIALof73CXbgSHfMUNoGAFrBRJ
ngSktsu+8fR32v5EUadpPYYtgHL1wEg+BuRDWsPaEH1mLsSVEHp8VKRDiKRMrbjP
gqk5o8sxtv0WSdhL6gJJyKv0Sk4ac0RRGLZU/ql1ehO90K+kmy8Euzq8t0PJ1D+o
gtCSft8lG+GzhSTi2s5xeZIQzEhJF8strXtYqjmKSlaLS8JAPmKT99kJUVmA7p0W
7SKmpJEyduPEWo6droAJmI3klQN9gP6w6PaOGrhgmdJLmBY+7IYcMgU4WjCHpOWi
OZgwotr+bKL21DCOCa+8wuWtzUD0iAiIf6B3kyNzmp5SAYqwSL65RBAprI0TDyc=
=apWk
-----END PGP SIGNATURE-----

--=-JuECyCsuI5LDt9lG4JKJ--

