Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab2KLAJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 19:09:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39123 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2KLAJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 19:09:38 -0500
Date: Mon, 12 Nov 2012 11:09:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20121112110935.eee5f582f16ab07c9faeabb1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__12_Nov_2012_11_09_35_+1100_r.XhkYmBkL.eNKL1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Nov_2012_11_09_35_+1100_r.XhkYmBkL.eNKL1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "sms_ir_exit" [drivers/media/common/siano/smsmdtv.ko] undefined!
ERROR: "sms_ir_event" [drivers/media/common/siano/smsmdtv.ko] undefined!
ERROR: "sms_ir_init" [drivers/media/common/siano/smsmdtv.ko] undefined!

This is better than Friday, but still not quite there. :-(

I have used the v4l-dvb tree from next-20121026 again.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__12_Nov_2012_11_09_35_+1100_r.XhkYmBkL.eNKL1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQoD4/AAoJEECxmPOUX5FEvGgP/07RGSo63kAMbiw+MOV5mmYi
WIueVbF3lNNC4XQvmO5oV3sjkzg6aURpPTtXBg1/TjI70jqCgao44AHBOw5DLhlm
MxNkC+Gp3PtMGaTURnw3uWz2QiKMqMc3cOH6BQkfCWWoEoZsp3PRqxbEUGsUuqNJ
IRo5ohaJAoBYF0Ub3VWgjAffRuS2wJRnNErc0EsEj+5bdcIwAzuiqWXYyavcdYs2
MLOMRKEPoz7QmB8uYTYmMzr1A2AUDqP0VIfnBJIctWZSRbUBSHbQRX1b7u4+JbK4
isP4P7UqhofaPVnOKVtLOYvPpQmQ7zXGgUUCUke79l3LhE7o2Dp41FVoPcpE45ZU
dmc7LEpowufRuUQk0K0pU4Kz/LSAho4cVB3KE8xrLmWnOxRYoIHiWQmlKVZrMUsm
sgAvg+ffq8vbCfufX/xagov7efXF0DL8IIOTl1Q1aVjKwOAcyPahZJdaJ74dXWTA
Yl/TsqqybxypZXh23/DFR0rrkSiBrKKYOgHn2M1wLC67y8YeBsE/6uGXUS42TNui
qEa26uUUyvR5jTLBeej2CPF7TqTl8LOPxjOjyaMfu+hGYTQROr6uljRGK8oelusH
MdAP1rjaJ3PNqFy9+Lrwpy2Cp5EjQxJdEk9rTaLyhKsi8piec3Cn4pJF9a9LpfDb
DQCw+zpW6bmfk6rf8lks
=67qG
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Nov_2012_11_09_35_+1100_r.XhkYmBkL.eNKL1--
