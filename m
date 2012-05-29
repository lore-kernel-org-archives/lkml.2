Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab2E2FKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 01:10:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40357 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2E2FJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 01:09:50 -0400
Date: Tue, 29 May 2012 15:09:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: linux-next: build failure after merge of the final tree (sparc tree
 related)
Message-Id: <20120529150937.3e643f49e030becbc02c11c6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_May_2012_15_09_37_+1000_6BAQxjMEj4/XmjbZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_May_2012_15_09_37_+1000_6BAQxjMEj4/XmjbZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

In file included from arch/sparc/kernel/prom_common.c:26:0:
arch/sparc/include/asm/leon.h:221:9: error: unknown type name 'irq_flow_han=
dler_t'
arch/sparc/include/asm/leon.h:224:10: error: unknown type name 'irq_flow_ha=
ndler_t'

Maybe caused by commit 93bb32f632c9 ("sparc32,leon: clean up leon.h")
which exposed much more of the header file.

I am not sure what to do to fix this, so I have left it broken for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_May_2012_15_09_37_+1000_6BAQxjMEj4/XmjbZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxFoRAAoJEECxmPOUX5FEPNwP/iDdmbZAiXP52zk62bvCmxsG
7W66htRtmYUyKdl3vGHUZodrQJLSFACWvkob3JyjFFoXYk/N0xImqeS/i6XJczrQ
as4ivM8VzOpav0oPa6Cna/0tn8T5GIhJeDXyD15vnLtpSwMsiQFGIOpEnv29gPMB
/ieURAZRaXL0ZPhVPWxrC2n1mPvGqeOWLVrRtqbzzMYzTMLWmk7Ap4y4GvTIxzcu
BRSgtBpUGqMPxsz5kOHsyzJp3zG2jGqrNqJmlFlnpNFnR9vsBEak1C5P2GB6XRrE
NA2DvwK91QsHCot12F5/JblC/l8evI2eEa5GqUIYa0u31cZp9hH+MUFnAjj3gdpd
ffIOQJJc7zhnd68hfryOH6YTnkHVndh1Dqkbf3tSjK7mSMq229dQ2LvqQc0Ylv1E
oT2CFALm23Y9cFKP7mKfeBpQ59oDKrWpUO1VVIxsBh72cWg04SZJpWvEZmpj0fid
4ehELprS4aZIolHQQxkyN6rwT5xidN51B4ujVfMji30a8fHyGz4HSdXEkUBTzdSe
ocMz+Au/TrWiByJCNVAkY2e+pWA5aR7Z+RDVFK2WYeD6c/3OaoaQO3dr2Z9vXmKc
RtZuQMhTIhEKns+Bj3D13ZWy6i8TY0ORW01VnItyIRD/wXLo9XX4gjoGAK1wn1mV
CweYr6nJwVkcSACzf1qt
=YA1/
-----END PGP SIGNATURE-----

--Signature=_Tue__29_May_2012_15_09_37_+1000_6BAQxjMEj4/XmjbZ--
