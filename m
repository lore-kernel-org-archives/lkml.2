Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab0L2Bvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 20:51:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53376 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab0L2Bvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 20:51:39 -0500
Date: Wed, 29 Dec 2010 12:51:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pinglinux@gmail.com>
Subject: linux-next: build failure after merge of the final tree (input tree
 related)
Message-Id: <20101229125129.d48fb6fc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Dec_2010_12_51_29_+1100_s=k8CMBnnwdo22ns"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Dec_2010_12_51_29_+1100_s=k8CMBnnwdo22ns
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/input/touchscreen/wacom_w8001.c: In function 'w8001_setup':
drivers/input/touchscreen/wacom_w8001.c:287: error: implicit declaration of=
 function 'mdelay'

Caused by commit b8fe15cb1b435928f9967d660e925fe7afb32787 ("Input:
wacom_w8001 - support pen or touch only devices").  See Rule 1 in
Documentation/SubmitChecklist.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Dec_2010_12_51_29_+1100_s=k8CMBnnwdo22ns
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNGpQhAAoJEDMEi1NhKgbs43oH/0EeARxiviQ/McnLkhv6K9H5
XMM37AGQTrxmUzcZDHok2okl94soMiWoKNwxopsuPdhaB82Y681VR1LEZvD2BVPP
XP4kyIIaD2slSwLHIZrjsBAuGHKmTOxqZiNLfNm5lSJpUMw2wBQl6qtAjnX0huMI
Zt9zTrBcRQ1mF26q6BVIuXhyv7i0nGZG/IE4x6TmY/yRYPHVLyY5wHVfcfeh0pqZ
o8uvgL6G5KD1Al7jn21XwL2gmsfw8PIWYz2apljco9iW/fAOdiqMTHS3V3sMEG+i
my6ylVMSiFnnNncvnkE8znmjSnrG0saUfkPdHllDhKPbomj5BwxBrwDONKpaQRE=
=wVgD
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Dec_2010_12_51_29_+1100_s=k8CMBnnwdo22ns--
