Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2IYG4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:56:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56047 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab2IYG4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:56:05 -0400
Date: Tue, 25 Sep 2012 16:56:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20120925165603.7676aa78ed5cfbf8a21fb734@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_16_56_03_+1000_L3nJ4gmufoNL9jLI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_16_56_03_+1000_L3nJ4gmufoNL9jLI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
arch/arm/mach-vt8500/bv07.c, arch/arm/mach-vt8500/devices-vt8500.c,
arch/arm/mach-vt8500/devices-wm8505.c, arch/arm/mach-vt8500/devices.c,
arch/arm/mach-vt8500/devices.h and arch/arm/mach-vt8500/wm8505_7in.c
between commit 100d45970327 ("ARM: vt8500: Add support for UHCI companion
controller") from the usb tree and commit e9a91de7602a ("arm: vt8500: Update
arch-vt8500 to devicetree support") from the arm-soc tree.

I just removed the files and can carry the fix as necessary (there may be
more work required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_16_56_03_+1000_L3nJ4gmufoNL9jLI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYVWDAAoJEECxmPOUX5FEcA8P/iLMiga6JWuYDHzKzvCSQhPA
CUEsc7qTY2iOXajSJ482+ZTYMN9zgXQmMhC2CQUKiQZwIyCltmmZcKTM5I+FFhbS
6fkOFHwdUpEkfnArRmP/k7cbtGSPbKLlxVtVuo4CVyvN+XwLYQEA2JY+QuYOqsjf
xbd6+0vxvJzhbWDOZ++QJIyVoF3hGliLitO9Q7OwEs00dVx8HS6QzSOkLZ37cZ6g
6qvEWALD2nNobCL1P5v7Dx4tv+FydZVN5VHzNq+lZ6e8AM7sbCgz+/3jhjRd4Rse
8vZCQZcY1r7Fvfmr0DMKMdOU9RHo67NKhyPqIUB5pl/v1WmFWiKLvIl0nHBi4XWF
e0sA2O5rF//Jdt+PA+hkYjQi70HaWAtJ1iQodQCP4Ecslh3rD+u8ni7CmakoOnXp
8gNe0uIOWgpaqEGH9uySRONbEv/7HzQIribXDDGmOKEqFrzsiBUpc9YLWw0Eh27t
aOQTGiMmUhxFs36xnWSUfVltZVsDmjBIRWA0DQaT98vuaOpDROPRZWolpzykntVO
iX/8MPP11yy0NXuP1X1BUps2IxH0yvUpYAeNszzT5hIPLy5zJnFUrpoF9GyzIFH8
rJ/I2eSmbzcvQr9Cl8GD4PkYRLYvj0qhneMt/GojAmuN56ot35oyUxU1/2quQPJ1
d4xBniDbFw49GEPKjY+x
=XYEY
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_16_56_03_+1000_L3nJ4gmufoNL9jLI--
