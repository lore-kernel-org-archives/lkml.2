Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab0KWCeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 21:34:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:32899 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab0KWCeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 21:34:08 -0500
Date: Tue, 23 Nov 2010 13:33:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlJpY2hhcmQgUsO2amZvcnMi?= 
	<richard.rojfors@pelagicore.com>
Subject: linux-next: build warning after merge of the v4l-dvbtree
Message-Id: <20101123133356.ca69b41a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Nov_2010_13_33_56_+1100_hsb=T8jAG0NaXCKx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Nov_2010_13_33_56_+1100_hsb=T8jAG0NaXCKx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

drivers/media/video/timblogiw.c: In function 'timblogiw_dma_filter_fn':
drivers/media/video/timblogiw.c:151: warning: cast from pointer to integer =
of different size
drivers/media/video/timblogiw.c: In function 'timblogiw_open':
drivers/media/video/timblogiw.c:671: warning: cast to pointer from integer =
of different size

Introduced by commit ef6ce9acc5f87e253c97dfd5301f8036f937f595 ("[media]
[1/2,v4] media: Add timberdale video-in driver").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Nov_2010_13_33_56_+1100_hsb=T8jAG0NaXCKx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM6ygUAAoJEDMEi1NhKgbsN4MIAJMA12Dr5BpBSdNUralnwciV
njAZXVTWvV/rzcBhMtNHRT0b1BEPA5Rq15W1q4ACmjpxWTRmdWC+rqCEu4F+dp55
MsubQhqrKmGgcYazYxygBR/dWg6wWG9twXQwGfOabQXFnif+zoboU+Lq9M1UNdUc
JdPtEvGUTfujN/g+DrntZh7qjlLyFI3sctAvzcJPY6Vn8Aj7CqIpqc+YOp0cMcYQ
ueAlcpz6ZDaA0DfaGzP01SA9upDID4YrC9iI37aDvOfAqMxnN5YpRs7k1Tq+v/y+
MWD1Ns1+wX8WFvRSipMQgxq6R/eLnsHr8QL+7aum7A288RTMJPfoG94HQwHVk84=
=xR4M
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Nov_2010_13_33_56_+1100_hsb=T8jAG0NaXCKx--
