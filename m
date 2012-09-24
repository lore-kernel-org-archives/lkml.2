Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab2IXOgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:36:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40451 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab2IXOgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:36:47 -0400
Date: Tue, 25 Sep 2012 00:36:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jaeden Amero <jaeden.amero@ni.com>, Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the final tree (tty tree
 related)
Message-Id: <20120925003644.aa90318c8f407539b08db48e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_00_36_44_+1000_wkf+ysHMo.9yi7=P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_00_36_44_+1000_wkf+ysHMo.9yi7=P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

fs/compat_ioctl.c:868:1: error: 'TIOCSRS485' undeclared here (not in a func=
tion)
fs/compat_ioctl.c:869:1: error: 'TIOCGRS485' undeclared here (not in a func=
tion)

Caused by commit 84c3b8486044 ("compat_ioctl: Add RS-485 IOCTLs to the
list") from the tty tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_00_36_44_+1000_wkf+ysHMo.9yi7=P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJQYG/8AAoJEECxmPOUX5FEEtQP+Nae7xUPEsQgxshnUErdlBnj
ulthyGxbluAzy7D3Vn4IZO1FboaBkzCQI9cZDvbQF1Fz10Uxg+1qtcOjvAgAQkRr
qSVtYGoPq0p9TI1zf9x1sB+F8IEnUCU8IiwBZReYVaybNXUBhRpB4Ms+L6mmLxIM
Vlp59xxtS9MjhQ6x7JV45TJ/N8uo7wr23fc+D/Q7npTd7+IC9nZ6D3XW2uWT9cvi
r4LdjnEol77hWlSaRicmWgrvK0f8Rud2v9kOo/Ung/XHAXtbS5zpjsQuKO1JDycp
rCDwiOYIsmztxqhLNrnk1yJ6ywf0eiSPgL0m0g7bRKZeX7HpxCuOxVDJkqvBb6Gd
9/fquNGwt3cCPu+mVO+OgiDcmOvs4lYgHlbszDESy9DvmqdIKtKFh60S1+EtfPkm
AkW28C8Dls5SA6KHpe994XnEkg7qxrAY/mqGiGXCSKnv9Lp57hD1Jug2XWkjySAx
Jt0AW84grfMWbdMupfHay+DJmrbbg0zTO0dpuANx8Oam65UMA+hmIe+n0cjmS0Bg
H0a3JtIS5xIZHfZEIgOz4TUb4g1JQx/CP1XLklrHIO4CPwVJ3nzPEhCMj6KQNx3T
4rzvBUtBSBLQmu55JKpYk/VNjQoRNocFqGd0Ag7RYctuw/GYuwSzEQ8EuzpNo0i3
nXbzeUh8NBxUvwTt5es=
=WyWy
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_00_36_44_+1000_wkf+ysHMo.9yi7=P--
