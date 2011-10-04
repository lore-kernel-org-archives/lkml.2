Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1JDIGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 04:06:10 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:49718 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1JDIGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 04:06:06 -0400
Date: Tue, 4 Oct 2011 19:05:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20111004190542.3ae8a2d575b936520ad36c52@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Oct_2011_19_05_42_+1100_WkCJQHv.R8ksb6Ol"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Oct_2011_19_05_42_+1100_WkCJQHv.R8ksb6Ol
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/iio/industrialio-buffer.c: In function 'iio_show_fixed_type=
':
drivers/staging/iio/industrialio-buffer.c:108:7: error: '__LITTLE_ENDIAN' u=
ndeclared (first use in this function)

Caused by commit 8310b86c3cd2 ("staging:iio:scan element types: introduce
endian description to the data format") from the staging tree.  Missing
include file ...

I haven't bothered fixing this for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Oct_2011_19_05_42_+1100_WkCJQHv.R8ksb6Ol
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOir5WAAoJEECxmPOUX5FE2aQP/RcROePylH428++LczcPlclT
FLaZ9ULVa9RAvfQQ3x0e0w9GmFBYiJ8pzD35Lk9kI64qGJJ5Rnz/YESQ+rlYVjYr
p9N86BFUf0PPkxK8G/vmGgb06bTVBuWHatlagUMyetkWalzKlDWM5kYkRfcQVSrE
KErra0qXwI7ad1/ChxIL1q74c2FDPAcuyrEidJPx6JrGFD0ttJCFryMlXgn8hEOx
OeX8ZJAu+sOlvJmBLSqo1SZ7vYPbgi4S1Uxjh1+dI+0xnXcmcgaBI0rnlujCzspM
bnsbVn2E54DWnuTCntjHQ119Z0XCldkd63JAREpUtFgoFdCkBB+fPeX73qeMGyyh
x4b+Bn1tV0WwX23oLHrspvT/vvzBJ2uQa6wU07ivVtEITQrjr8MW8mIpTouRyWDs
3yPZQujxMSdaOgIsz0HJu79kHJMEa1v+zwv9Z2kw7Ye4h9GazTtvcSWZVpVzclCH
vOuS0y1SP4XJMKzmwiHzl3F3pGthWDh9zZXd4/y3MmOVVRitdwKF1humAji5x2dx
1pO/DuxDDXW6Dp0kG56QhyOp2LomTgIYqcVcGM8WP1Pq7QiPp/r9J04/xsZBOZ3J
TVjAucW9cfc4rZ9KDQYHeyRjIl+xYim7LVqJxVLhmpGyEZ8s9l/ZHJIkSyvVi26n
erP/tz5RJId74T3pzTNi
=Kn6D
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Oct_2011_19_05_42_+1100_WkCJQHv.R8ksb6Ol--
