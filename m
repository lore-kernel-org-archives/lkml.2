Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1C1CKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:10:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51424 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab1C1CKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:10:33 -0400
Date: Mon, 28 Mar 2011 13:10:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: linux-next: build failure after merge of the mmc tree
Message-Id: <20110328131018.96742ebb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Mar_2011_13_10_18_+1100_qi=OX9N35.Lf57Fu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Mar_2011_13_10_18_+1100_qi=OX9N35.Lf57Fu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mmc/host/tmio_mmc_pio.c: In function 'sd_ctrl_read16_rep':
drivers/mmc/host/tmio_mmc_pio.c:56: error: implicit declaration of function=
 'readsw'
drivers/mmc/host/tmio_mmc_pio.c: In function 'sd_ctrl_write16_rep':
drivers/mmc/host/tmio_mmc_pio.c:73: error: implicit declaration of function=
 'writesw'

Presumably caused by commit b6147490e6aa ("mmc: tmio: split core
functionality, DMA and MFD glue").

I have used the mmc tree from next-20110325 for tdoay.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Mar_2011_13_10_18_+1100_qi=OX9N35.Lf57Fu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNj+4KAAoJEDMEi1NhKgbsdO8H/077H8NhTQkSwLv3sBV/GAV2
3ffyZxYZDu9YhdiZ1LyQ8C3YTG+TOGn4+rOY2whqcaTx7yZN9utmip81KrIlsrFl
DchOCCiHWgm5JpEh36Fs/wQZTwp89wbH1hwWQbW/wT16LwMF5KpkiG5tc4UD+tIc
q2RN6Vf8/ZW3FAboGBLZburcgr+7xw6D2jcarI9kWl/Jiz3ebEA/fKMF9th62Et2
r8GygCkjNfPJOtdVpGXCWH3pQ9ttZxIpYluj08ifFt2lHjFMQZmdeFiiS2sjeJ1S
9f3Bdr4He7uJFg1osJyKNzuHnmSWnrdkks7vZwXw86nSr4ySeRyw2UJvASf8jlM=
=RZrO
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Mar_2011_13_10_18_+1100_qi=OX9N35.Lf57Fu--
