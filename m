Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab0ETBEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 21:04:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56658 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab0ETBEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 21:04:24 -0400
Date: Thu, 20 May 2010 11:04:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pannaga Bhushan <p.bhushan@samsung.com>
Subject: linux-next: manual merge of the samsung tree with the  tree
Message-Id: <20100520110411.c16ea156.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__20_May_2010_11_04_11_+1000_78m+3TAwlpX7hPB."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_May_2010_11_04_11_+1000_78m+3TAwlpX7hPB.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/mach-s5pv210/gpiolib.c between commit
ea5f50706385b61c1c0d24271bbe7c6e93129fbc ("ARM: S5PV210: Add GPIOlib
support") from Linus' tree and commit
026fcae436e846b0cc1db8d4af11890dfdde3689 ("ARM: S5PV210: Add S5PV210 GPIO
support") from the samsung tree.

Two versions of the same commit.  I used the version in Linus' tree as
that was dated later.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_May_2010_11_04_11_+1000_78m+3TAwlpX7hPB.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv0iosACgkQjjKRsyhoI8zpRgCgpy8JCtEpcNytnTBYC8smHTR1
NZMAnj5vTxui2c09oRh1a34XWPFIkJf/
=DOVg
-----END PGP SIGNATURE-----

--Signature=_Thu__20_May_2010_11_04_11_+1000_78m+3TAwlpX7hPB.--
