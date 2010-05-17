Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0EQGKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:10:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47271 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab0EQGKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:10:06 -0400
Date: Mon, 17 May 2010 16:09:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: linux-next: build warning after merge of the usb tree
Message-Id: <20100517160958.b5208a24.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__17_May_2010_16_09_58_+1000_bD1CeZzwTOMvuUZ."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_May_2010_16_09_58_+1000_bD1CeZzwTOMvuUZ.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb tree, today's linux-next build (powerpc
ppc44x_defconfig) produced this warning:

drivers/usb/core/usb.c:596: warning: 'match_device' defined but not used

Introduced by commit c8a3789b05e2ed43d8fd98934edbf66587cd3f96 ("USB:
remove usb_find_device") which removed the last user of this function.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__17_May_2010_16_09_58_+1000_bD1CeZzwTOMvuUZ.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvw3bYACgkQjjKRsyhoI8zZDgCgtBapz7oA071W9D2Q5MYwvFzm
TfcAniNtnoPWrTzj8VmbE3w81I4qjPIM
=z4bt
-----END PGP SIGNATURE-----

--Signature=_Mon__17_May_2010_16_09_58_+1000_bD1CeZzwTOMvuUZ.--
