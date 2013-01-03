Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3ACXFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:05:52 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58838 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab3ACXFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:05:49 -0500
Date: Fri, 4 Jan 2013 10:05:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: linux-next: bad merge in driver-core.current tree
Message-Id: <20130104100540.3671b46eb7de73374db7f786@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__4_Jan_2013_10_05_40_+1100_EMELcG8XNOLH0r9t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Jan_2013_10_05_40_+1100_EMELcG8XNOLH0r9t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Happy New year!  ;-)

Today you added a merge of v3.8-rc2 to the driver-core.current tree.  It
added the file drivers/i2c/Module.symvers which is a generated file :-(

Please consider rebuilding your tree to get rid of it.  Also, you might
consider removing all the patches that remove the __dev* stuff as they
are really not urgent, cause many conflicts (and will continue to do so)
and most (if not all) are not acked by the maintainers of the subsystems
that they should be applied to (did you send your revised versions of
Bill's patches to those maintainers?).  You might consider sending
separate patches to fix the coding style problems after Bill's patches
rather than modifying Bill's patches as some of Bill's patches are
turning up in other subsystems (as happened with i2c).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__4_Jan_2013_10_05_40_+1100_EMELcG8XNOLH0r9t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ5g7EAAoJEECxmPOUX5FEreUP/RPCWhrtmfiKy7R5hWaDe4uI
uOWkJVsxEV0tJcBkLjqY2PhYbWyZ52AY4iq8djqmMrLhAypZ+fxM8LtIoHXdRib2
ILw9SoSDiMNYj3ihEYKOfiuQQXIok8fP3K11yCOPlMmy9xd7bX0sJLXxmvA+3uPC
oBfucBrh5sBq4IXE+8wAACFdi7KeM8u1s6JkqTjMLHRkSGO6tn1FpDJvVnrJv4nB
9zQviaP2GcOrtIrjR7+YcoxzFXdFxUgzym2ipvovb3o8QQQ8sjM+PmumVQ/DM/Fe
ZMiRg0YEIIao5JS9I+7QTJuwU+NTEVKEErjz011zUaMvhyrMsbioSJSsvlAWbAQr
U0VybggbnR+79lonRPedlDKQgg2MhdVt/RLmy9qVnACmY88BupsWLSPq5WxZ+3gH
DbRA/DXOSBCZM+1ZKM7D8LEnxIjhV3vmASlJWchcjBwXrAsbk+a0Mxw4mVwmvROv
eEc/IH4Et4Kx0A5tkAa6lhy7NV8jNbgY1QD7fFB8lpucHPAsx0HxB/NaO6lFDg+E
g29MXMJsXqrh03920iVcvfE4sBpBSLUo520GhaFWwBYNfXofLksYiag5FeQaYXgG
1SN3prT8RTzhB4Ot727MESzr+C6LzDiDORMnxztOasa1sVp5rP8V/QCskL++o4FK
KDiH+s5FUsDA1CLmQIFu
=vnCW
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Jan_2013_10_05_40_+1100_EMELcG8XNOLH0r9t--
