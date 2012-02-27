Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2B0HF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:05:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49033 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2B0HF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:05:56 -0500
Date: Mon, 27 Feb 2012 18:05:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20120227180546.1e9b77d538caa211e06bdf5d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_18_05_46_+1100_7LBKH6w+slysEf.L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_18_05_46_+1100_7LBKH6w+slysEf.L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

lib/atomic64_test.c: In function 'test_atomic64':
lib/atomic64_test.c:26:2: error: implicit declaration of function 'BUG_ON' =
[-Werror=3Dimplicit-function-declaration]

Caused by commit cf86c17fe37dnn ("kernel.h: doesn't explicitly use bug.h,
so don't include it") from the moduleh tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__27_Feb_2012_18_05_46_+1100_7LBKH6w+slysEf.L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSytKAAoJEECxmPOUX5FEp1wP/3HOBCcBXWa5qaL1efVOhV9w
5dZBMX9+9KYMlCNcv0fUhkoHgNNH27LZgHRyt0r1DFssb5/uhtdYqfevjD3tWreQ
7f/NdWlzOBNmQG1bx7Nl7lFsFNMjBvIjVMQzznHXYrO01tC/c7ED6DgZjbKY50e+
92T5lXShJZsqwxUaLnuXjwj/1GNFe/iQGyrYtxKbTRM5tU7m4xzJyHkAUL8i0M9X
BKk+OH2w6dPOg025oF921x1uO3h1dpV/s3BeT15aYC5at28x5LQfHKeEKDWyijHj
Ls+/4iT4Y1Qp5/cbuIo4EdGFVrL3wTcImqTprIhQ7U91IXjOK2Ji7pezROOvdaUF
zoiZHD80undPC1JXBWid7+M2QfyrGUei2q56XOyWLB/wrn63OXfncGr6o0YEQvXj
QV32ge+mUiCqy/jfqpiLT9iFvdEIrwELxoTTgpJ24ykMktUTHZnfqHod5WnKNRvm
z7Rjg7YfGWPS28y4cem5WPuFGE3e5UQgR13ZhTjnRFxb5HHwVfK2g5E8TKK13758
ZEtO9unxfoC090LK/qXIGu2/weJ2GySgyjoxIPTdf13wGUsbWVcFn04Jw471ZxQi
2mXuEWLMdkk8YryccDAeMcw+Eo+OazsHxMaX5S/Ydz42jYNG8h79aAD2dE6FuV59
1qhIwlTwXPw8UT4bQwZ7
=kf5/
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_18_05_46_+1100_7LBKH6w+slysEf.L--
