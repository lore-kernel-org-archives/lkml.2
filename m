Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2GEId5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 04:33:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40831 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab2GEIdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 04:33:54 -0400
Date: Thu, 5 Jul 2012 18:33:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Modra <amodra@gmail.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20120705183345.ee84ec1048a19aa1c7129578@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jul_2012_18_33_45_+1000_611tFbWnbaq1mpxy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jul_2012_18_33_45_+1000_611tFbWnbaq1mpxy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

powerpc64-linux-ld: drivers/built-in.o: In function `.gpiochip_is_requested=
':
(.text+0x4): sibling call optimization to `_savegpr0_29' does not allow aut=
omatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibling=
-calls, or make `_savegpr0_29' extern

I got more than 60000 of these messages before I killed the link. :-(  I
am not sure what has changed to do this, but it may have been masked for
the past few releases due to other linking problems.

I have left this broken for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Jul_2012_18_33_45_+1000_611tFbWnbaq1mpxy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9VFpAAoJEECxmPOUX5FEr/YQAIx9U+6XTE36nEohZEY6fKJL
hffLwEBbdUk0HWbk5x9oMTltSKK00V+Xgu/IJ7OCpsIbmWvZ10sn7NYqrSYmmO4B
aArh0od6j/Gd4cLKwfgBzTzMYI74XHHjGCm5t5yOzihFjDZwK9peg81RCqgbQ9YM
CjQDAuDgoI5Mx05/Bqg8yT70ACBOjsRV0n+0CslLu9+FanqHTvIPPQSQsZ/wbWu2
O/2v6nv+ZImgDkdUedzm1KGug61s3GJir8OSdcHb0RZYGgd+CAAT3mobtbA563PW
9r/1AfWJgcXnvDxJ2b/7QrBJ3lej0Wi6y/o5yjdQw80iR7dLKZ7ObonPZ7jHTm96
oFIXv0fA4SFS9H0pmNN0X2tIKL/ZZVF5Y+Yohzo4pEbSONNZY73/v+U9YYbOV+c1
w1GHfee6jvTem76IkXgGqotCYtXTa+21c5FaJgg+gU/FlmrSqpSSkdYriEPi+5CC
hW6/xrt90m1zQ4MSc9bp8yA47IKlPETTtSyymZ1nMjxzgvARo/sABEKNXythN3l2
X3kmaeK1ZGF8VBz1E/M1jzEOiSEoQupr3O0A3D5bjAQUCDopeaRVMz8xl5qB5Gfy
hVGCehopZMbW51+q9OHN92DcDFZaKuVi/NDKXMlrXuZNPNFkpdkETk5dM2JmWO33
XKNmYjZB0RyM7Q/XDY6k
=qvIb
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jul_2012_18_33_45_+1000_611tFbWnbaq1mpxy--
