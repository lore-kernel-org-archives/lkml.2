Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab0FUBBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 21:01:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46058 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab0FUBBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 21:01:17 -0400
Date: Mon, 21 Jun 2010 11:01:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: import of the i2c quilt series failed
Message-Id: <20100621110108.e8ce0bcf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Jun_2010_11_01_08_+1000_hbLJO2oRUrljhQKg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jun_2010_11_01_08_+1000_hbLJO2oRUrljhQKg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

The import of the i2c quilt series failed like this:

i2c-drop-preliminary-probability-checks.patch
error: patch failed: drivers/i2c/i2c-core.c:1456
error: drivers/i2c/i2c-core.c: patch does not apply

I have commented that patch out for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Jun_2010_11_01_08_+1000_hbLJO2oRUrljhQKg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkweudQACgkQjjKRsyhoI8xTnwCeLM61hy24keaZOX2rdBnQTuwf
UGQAnRPsjfnxKcJ5MPuFTXs2OFOIixWh
=tfmZ
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jun_2010_11_01_08_+1000_hbLJO2oRUrljhQKg--
