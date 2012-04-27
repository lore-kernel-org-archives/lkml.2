Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2D0F7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:59:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49418 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371Ab2D0F71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:59:27 -0400
Date: Fri, 27 Apr 2012 15:44:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Kees Cook <keescook@chromium.org>
Subject: linux-next: build warning after merge of the akpm tree
Message-Id: <20120427154420.1161da65e7bcc2322857e6b2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Apr_2012_15_44_20_+1000_1R1dW7dLa5g+j+6O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Apr_2012_15_44_20_+1000_1R1dW7dLa5g+j+6O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build ()
produced this warning:

kernel/sys.c: In function 'prctl_set_mm':
kernel/sys.c:1779:6: warning: 'error' may be used uninitialized in this fun=
ction [-Wuninitialized]

And this is not a false positive (I think).

Introduced by commit 5455a20be1a6 ("c/r: prctl: extend PR_SET_MM to set
up more mm_struct entries").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Apr_2012_15_44_20_+1000_1R1dW7dLa5g+j+6O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPmjI0AAoJEECxmPOUX5FEqlMP/2drI3rLMnBEY0IY1nbmh9HX
eHRjFFsXRX5jbL+9b/kZekGBxDH0ujjIqfRIfqY6z8jpKiB94zEtReA0P8huA2LX
ySpbR5QNaiDbLy86/oUtYczN7qCG0GNWNVoIKfsQ0KvCTs/rVJIqxnm1MAde+TkR
2y2bfzZK9Nmw/musg22fvnFNNdvBt+u8KHc1F36NATAfWAHnH+MdmOKWuUjh53Xd
yWp5A16UaqJDvXba5KqLVVGToHbwc6B3f8aQDjA1xEFEqO8/tqWDMlzlJ9fPFK2I
8QrUvp8Ybf85uAI8amiqwoy+j0He8l6qiHkPViLTxqPqsvPNvlPZIZ6qtgE7Ft1S
87JQ2siDkMx71lxcZ9u+TCk9j7yuvEjL3OqMS2CJrcOkhp0kdryrCZ9OYDKIJRWl
KCQz+WiL1ExtrFPr2l9AJjJVDd/L8q3Bd9n3Jge92keoLWTxG7xQECaqObCaCc0V
7EX3QAzFSPGE6gFfh6AijhEocx0Bk7D1vjLxIarKFMBicZ0okd6Uy8C+A66DA/JI
gCGJElGSQCkDyWQKDYHvGyPviRRviHvifHB3KJ1G8SeSUGx9t7HKmWgxhhgbVmOA
kIPfCW6ghJpF96TrmhQ8L2JdpgnNg2VrKU6GSnmaBwktrHESCkWpi+8RFBkLgR8F
lbWW0RaDiKnC6nNkASVd
=fdgR
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Apr_2012_15_44_20_+1000_1R1dW7dLa5g+j+6O--
