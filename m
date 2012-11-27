Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab2K0EhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:37:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40401 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2K0EhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:37:16 -0500
Date: Tue, 27 Nov 2012 15:37:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Bhavna Yadav <bhavna.yadav@st.com>, Deepak Sikri <deepak.sikri@st.com>,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Vijay Kumar Mishra <vijay.kumar@st.com>,
        Vipin Kumar <vipin.kumar@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the l2-mtd tree
Message-Id: <20121127153714.2da0df11b77fc74601482ef4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Nov_2012_15_37_14_+1100_Wwcf=d/Ti0gAHWfF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Nov_2012_15_37_14_+1100_Wwcf=d/Ti0gAHWfF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/spear13xx.dtsi between commit 6d7b42a447f9 ("mtd:
fsmc_nand: pass the ale and cmd resource via resource") from the l2-mtd
tree and commit f631b984ee10 ("ARM: SPEAr: DT: Fix existing DT support")
from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/spear13xx.dtsi
index 701b0d7,009096d..0000000
--- a/arch/arm/boot/dts/spear13xx.dtsi
+++ b/arch/arm/boot/dts/spear13xx.dtsi
@@@ -151,6 -125,9 +165,7 @@@
  				      0 21 0x4
  				      0 22 0x4
  				      0 23 0x4>;
 -			st,ale-off =3D <0x20000>;
 -			st,cle-off =3D <0x10000>;
+ 			st,mode =3D <2>;
  			status =3D "disabled";
  		};
 =20

--Signature=_Tue__27_Nov_2012_15_37_14_+1100_Wwcf=d/Ti0gAHWfF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtEN6AAoJEECxmPOUX5FEA38QAJmYd0G+ppLvQyLBavXygBm+
3v3vZ0LOAot0Mn+32Lz9jT8JaAfsfToyN+iI0fj25bIKWLsrlxDOfleBNqtS1Dv2
vwxRzuZzvmNRAcDo78cHBuOlPCMKnNtop4HImiGOv1ntIJiRkNOBeInvJac8OH01
ahplxt1224v6saf308Xd2c3xIQO1mXljLwTl2Qro2kxjDWpvqfx0lHMgrW6zaxed
oXGijrmeSdFjRAWWr/EVOTzK1qGtRs7UOld3p9MOhG2Bt7C5EPS3Rij9qFJSV62e
tjUPXgYBS7NWfnrQuUWd+4hNayf04nDYIiV60wMb9eKwvRpLtrx+0eJdKQS7PwfU
0JiuGok9cacV7DKu11A0WoA5NxGCr0S3CSzMmKtbd1gvMG1tvxbEGWIuj9baA0rW
Ts6hNK6ScECeBzvbF9Hzys6xNkvYojp5FEbZzaJkIxpOPl2RD6QmrEU8b4qZzHdQ
5TdMKD8rLAOGHYxKtHMUrzqV6996gq8O1QBssTkAIhGWa1rIJnefFvBZtQIbEIrp
2uP+eqGG5thpzPpkQipgYq4oti9KdFznu6p05SWFbEUj/MxDEf09DMnAioGFsct5
8yLfF0hTIDr4F/0RD36ZXNoj3KZewQCy9T4Zz6tGdVspqlv3dKuM9r2DDFslYDG/
4jERWPUj+lfRA9Rp4/bo
=JCVR
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Nov_2012_15_37_14_+1100_Wwcf=d/Ti0gAHWfF--
