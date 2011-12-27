Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1L0XhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 18:37:09 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:48544 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1L0XhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 18:37:07 -0500
Date: Wed, 28 Dec 2011 10:36:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20111228103657.203bd438eabc392eb3363bb6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_10_36_57_+1100_Zy4m0cPnLSj6SP12"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_10_36_57_+1100_Zy4m0cPnLSj6SP12
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-s5pv210/init.c between commit 3fa754c298b7 ("ARM: 7248/1:
S5PV210: introduce arch/arm/mach-s5pv210/common.[ch]") from the arm tree
and commit afba7f91e640 ("ARM: SAMSUNG: remove struct
's3c24xx_uart_clksrc' and all uses of it") from the s5p tree.

I just removed the file, but the latter patch will probably need applying
in some form to arch/arm/mach-s5pv210//common.c.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_10_36_57_+1100_Zy4m0cPnLSj6SP12
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+laZAAoJEECxmPOUX5FEm6kP/jKDK5Yx0nDph/IIQpt7crR1
AV7LYZ3tB7veMcpn0IyMOnOH8GbVmjA7PEioc6AaY4tDnRbZReWateIU6E7TzkK4
2SzLs8fDxRU7QJyRtLXoJ+rLG1uh+RPVQLQ9plM1oDw/ys3kNh4oJjk6bdgiI5s7
G8wWHeSVdtnqUpF87z9763AotBy8igli+W9AnaDrd4npDrqCLN/pLZTJMyejMCmk
EeBsBYl4bETK06WLov7Zp1TfQgqJfhTixFl0muwp3JlgYTooje9yUtR2NaURl5gr
arercjPRHS2eH6w2hmV1++YBnjyAlxSXou/pkyu2Coi7ex7/0IqoPg+RJ/ZLMAtm
N97NQ/4VdVN5ITbQx5C3UKykP6hGAU2EKO0GpjgzVIVOwxf9auDBC/JllagpD+Tr
HcoQ/lQ0rumBm3XpuNKthMr2hyypnMaEjSkHEoqyvjxKO3YjjiGd1iiQn5Yh6k1Z
B/ZaKO3YrJjmYL5GSp76PVRF76eTeiJbtKN86Y8THG432lsvmK/xOtCz8O7hSsZW
UR0SUjjj1pr23ySSwn29oQl8UlirrJX/dybuPMLltn+w/vCo4w1ZLz4bMMaDhYdW
GFaBDOoIYeucCCegtsLf/R9K+5/zXg5Z/JTUEitCBtk56Iq7od2N8vuMLgt0TPYB
k1zrDgIJBaor1cc5WXiW
=A5DH
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_10_36_57_+1100_Zy4m0cPnLSj6SP12--
