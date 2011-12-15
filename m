Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab1LOCRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:17:19 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:49070 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1LOCRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:17:17 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: linux-next 20111214 - lib/Kconfig help text issue
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1323915434_2907P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Dec 2011 21:17:14 -0500
Message-ID: <12464.1323915434@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020B.4EE958AB.007D,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1323915434_2907P
Content-Type: text/plain; charset=us-ascii

Seen in linux-next commit 7e8dec91 ( crypto: GnuPG based MPI lib - additional sources (part 4))

> diff --git a/lib/Kconfig b/lib/Kconfig
> index 4af07ec..d411de5 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -283,4 +283,14 @@ config MPILIB
>           It is used to implement RSA digital signature verification,
>           which is used by IMA/EVM digital signature extension.
>
> +config MPILIB_EXTRA
> +       bool "Multiprecision maths library - additional sources"
> +       depends on MPILIB
> +       help
> +         Multiprecision maths library from GnuPG.
> +         It is used to implement RSA digital signature verification,
> +         which is used by IMA/EVM digital signature extension.
> +         This code in unnecessary for RSA digital signature verification,
> +         and can be compiled if needed.
> +

Two issues:

1) Typo - "this code in unnecessary" should be "this code is"

2) The help file says "It is used to implement verification", and then 2 lines
later it says "this code is unnesessary for verification".  So is it implementing
it, or not needed for it?  (I suspect it's a bad cut-n-paste from the
previous section, and needs 2 lines deleted, to look like this:

+       help
+         Multiprecision maths library from GnuPG.
+         This code in unnecessary for RSA digital signature verification,
+         and can be compiled if needed.




--==_Exmh_1323915434_2907P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFO6ViqcC3lWbTT17ARAtOKAJ4ikscELZAMEIp6LZx3jlklAFCp3QCbBDBi
NuHJXnWUgX4PagwR0X5xxPw=
=a1l4
-----END PGP SIGNATURE-----

--==_Exmh_1323915434_2907P--

