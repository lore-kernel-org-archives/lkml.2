Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1BUEff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 23:35:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35687 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627Ab1BUEfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 23:35:33 -0500
Date: Mon, 21 Feb 2011 15:35:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the i2c tree
Message-Id: <20110221153522.8a0b29bf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Feb_2011_15_35_22_+1100_hbvJwkYQ88cKR+mx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Feb_2011_15_35_22_+1100_hbvJwkYQ88cKR+mx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

After merging the tip tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

drivers/i2c/i2c-core.c: In function 'i2c_do_add_adapter':
drivers/i2c/i2c-core.c:799: warning: 'attach_adapter' is deprecated (declar=
ed at include/linux/i2c.h:149)
drivers/i2c/i2c-core.c:804: warning: 'attach_adapter' is deprecated (declar=
ed at include/linux/i2c.h:149)
drivers/i2c/i2c-core.c: In function 'i2c_do_del_adapter':
drivers/i2c/i2c-core.c:985: warning: 'detach_adapter' is deprecated (declar=
ed at include/linux/i2c.h:150)
drivers/i2c/i2c-core.c:988: warning: 'detach_adapter' is deprecated (declar=
ed at include/linux/i2c.h:150)

Introduced by commit 95529c656b97b08c7a92504f98650a229f03ae04 ("i2c:
Deprecate i2c_driver.attach_adapter and .detach_adapter").  We normally
fix up as many uses of an interface as possible before deprecating it ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Feb_2011_15_35_22_+1100_hbvJwkYQ88cKR+mx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNYeuKAAoJEDMEi1NhKgbswjsH/2PtI4ewaU8atDO/IRh3Gy5I
fUFzkvbxKaVeP/NtlFlf60uUsiEifzmRogqFkncqVkbRBXd+Yot4A8CTkWdBFkwL
AUZ9llOii0CSEskxAgAH6nP2Vo5+fCuZTDTbjEnTFUdj9L2bA73kKMcamTBEgYkG
Q2OvEWppfiXNg3tuPjnWGfqTxNgBc22bjexmY3X3PA1F1NxE4Sj2LZ99imsxRyJZ
/nLNeDGtPhn8Jn1+kKcU3iaIVtn9bftKC3evznbRv1ETnkI1UI38lKa8wIzCyvN1
uXHQ6G8x0KHjkARwnyCTvsWZmKg8XcBLDbd0o1QBbxP1YHcjU/O2kZPPqBKLyA0=
=A5zY
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Feb_2011_15_35_22_+1100_hbvJwkYQ88cKR+mx--
