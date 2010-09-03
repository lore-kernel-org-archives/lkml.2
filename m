Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0ICBl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:41:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58110 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab0ICBl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:41:27 -0400
Date: Fri, 3 Sep 2010 11:41:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (galak tree
 related)
Message-Id: <20100903114118.8a46b1ec.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Sep_2010_11_41_18_+1000_CiB39WqCAg1_D/Lw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Sep_2010_11_41_18_+1000_CiB39WqCAg1_D/Lw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kumar,

After merging the final tree, next-20100901 (and later) build (powerpc
ppc6xx_defconfig) failed like this:

arch/powerpc/sysdev/fsl_pci.c:484: error: redefinition of 'fsl_pci_immrbar_=
base'
arch/powerpc/sysdev/fsl_pci.c:313: note: previous definition of 'fsl_pci_im=
mrbar_base' was here

Caused by commit 7e03a809c8e0eb5121fde8295b6218bd336a3792
("powerpc/fsl-pci: Fix MSI support on 83xx platforms").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Sep_2010_11_41_18_+1000_CiB39WqCAg1_D/Lw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMgFI+AAoJEDMEi1NhKgbs4pEH/R5GxJxoWkv9qTx94QlOrSJU
CLxGPoo6aykH7v137K7h40dvjJaLqT8/Q+WQT7dxL2/eoL65Hkd/6sPXcSg9QJfm
WcicF4yETHimFzHZgbXlPTnZj/KKGskYyX+azigLG9UJzWIIfq7umwcoLlXi/37X
jLp6pp+z8qbjzQWloB/Ps20vIeOTg2EZVlr6z3Pj3lppFFz5f9X0IG3oPpWfx/Du
xayX4qX68HZzVnvO7O9qLjAknf5q5qcCEEA8Nx9QNLP1iesNPdV9nan0XMtvT3P5
hjPdz5XZ1o595cxxtwkZ0QtaA2KbGxOkpP0fSVGjJzOwI2221l5oViuaMt/Ts18=
=RkJy
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Sep_2010_11_41_18_+1000_CiB39WqCAg1_D/Lw--
