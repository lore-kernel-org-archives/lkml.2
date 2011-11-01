Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1KAHFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 03:05:23 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:43766 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1KAHFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 03:05:22 -0400
Date: Tue, 1 Nov 2011 18:05:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the moduleh tree with the mfd tree
Message-Id: <20111101180517.8a53c259b54ee6df641bb4f4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_18_05_17_+1100_xa4rUCsbv7cDjO+9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_18_05_17_+1100_xa4rUCsbv7cDjO+9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
drivers/mfd/ab3550-core.c between commit 6508204630f4 ("mfd: Delete
ab3550 driver") from the mfd tree and commit 4e36dd331423 ("mfd: Add
module.h to the implicit drivers/mfd users") from the moduleh tree.

The latter deleted the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Nov_2011_18_05_17_+1100_xa4rUCsbv7cDjO+9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr5otAAoJEECxmPOUX5FEFnEP/0sdLACkFwFZpG89tvTGhTzz
SeydRx9ZG72krwGn07KoM8tkjbgzwt2Osa8i+chbKhNiJfea+13AH1s4/Mleu89g
VvB+fm66n6+4dUpCqeVBm+x5h4Jh1Kkl6tk26es0oFrVvzQJEtMmNaci4ORCItDb
l04abgbP9DT73Deb21SSe2XACsRb0Xw0/Udgr8XQ353Q+P1At2IVaEAtd42Z7+2A
1uhDJvTrtBUFxApjM2t7sbHVpbH9Eq0xCbF+w+MzX7ADzP4RC/vpcVNmbAcZbYWj
0jyWo4xhwzQHIcMtCJTzjfYrrA2AhluTck7GdX0P63A15cpCbieMNQZcvWUTdoSp
/vEpFJo1o1etnKt314sM9dXx2zO+YqqI01CPrVkLN7h1w9bko93Pn0GxylHDzx1V
iJ1cpBvUyonDNN6loIR90U0JfsNvveQbeDze/Oz3bxKaoux2swMmcvMVmKG/ZR9c
DrOCJRgnF8R9UQtYaK3ZX/cBp/iKxAGtCZzFoPB7yIU7+hyYY/9kXbQp0DdvaUmK
wsXigJG9fM30fS8e7xAbgfnaVuz6bi8CrOwAPlOum2I6r4vV3mhy2k+8FgVqNB+C
B7Jlx/eCw9BXe2mm35HXNlsZ0XBBcFlcNIAcLQc6qmlNp3J9D8U1gKhZOAbKohph
9mh2Qj2dHzEfUr947kdY
=XFMb
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_18_05_17_+1100_xa4rUCsbv7cDjO+9--
