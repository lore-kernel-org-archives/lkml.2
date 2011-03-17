Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1CQA3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:29:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34216 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab1CQA3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:29:41 -0400
Date: Thu, 17 Mar 2011 11:29:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manjunatha Halli <manjunatha_halli@ti.com>
Subject: linux-next: build warning after merge of the v4l-dvb tree
Message-Id: <20110317112932.ded8cbf1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Mar_2011_11_29_32_+1100_wi59DSNBDCrn+GAy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Mar_2011_11_29_32_+1100_wi59DSNBDCrn+GAy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/media/radio/wl128x/fmdrv_common.c: In function 'recv_tasklet':
drivers/media/radio/wl128x/fmdrv_common.c:274: warning: format '%d' expects=
 type 'int', but argument 4 has type 'long unsigned int'

Introduced by commit 38b9da379627 ("[media] drivers:media:radio: wl128x:
FM Driver Common sources").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Mar_2011_11_29_32_+1100_wi59DSNBDCrn+GAy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNgVXsAAoJEDMEi1NhKgbsaKYH/0vNaf7XtdFZDMMojwpmynAY
/hLEVubUKOWA03nfnZ9YIa9XVzT+g0EVB+8tTCiZdJ1u+Po+bnJ0nvgKcgVIay4m
7HQpF8uBU38CF8nSwNz8aI2plJ1IxwIndOtC6eI3Ap+8uqA0GwAXEmR2cGxzcJKg
JOiEts6w0V+LZvM3mVSRXDTa3Za/qZnUKxoh5url7nHq+CMSTQWZS8rqYgdIuI4c
tj6EnoaoLREY6VuEB9/m8kf51mvJZX0/JhC3aqw+Pejn6+9s/ykxVsT/Efxv9EIs
dW5fLFJAv40c0CNhiw2KCFyXwFvlQ75jkf/L5aNvAqVP6jXCvXHL7B2x7ZnA9xU=
=STG5
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Mar_2011_11_29_32_+1100_wi59DSNBDCrn+GAy--
