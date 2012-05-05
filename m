Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab2EEEyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 00:54:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58914 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2EEEyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 00:54:05 -0400
Date: Sat, 5 May 2012 14:54:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pierre Carrier <pierre@spotify.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Landley <rob@landley.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] procfs: expose umask in stat and status
Message-Id: <20120505145403.e73ce6633d2930ecde461bcf@canb.auug.org.au>
In-Reply-To: <1336186227-1941-1-git-send-email-pierre@spotify.com>
References: <1336186227-1941-1-git-send-email-pierre@spotify.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__5_May_2012_14_54_03_+1000_OMi/byFnVYFRCK6M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_May_2012_14_54_03_+1000_OMi/byFnVYFRCK6M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat,  5 May 2012 04:50:27 +0200 Pierre Carrier <pierre@spotify.com> wrot=
e:
>
> A new stat field uses decimal, contains umask or -ENOENT if !task->fs.
> A new status line is displayed if task->fs, and uses octal.

It would be good to tell us why we need this, of course.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__5_May_2012_14_54_03_+1000_OMi/byFnVYFRCK6M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPpLJrAAoJEECxmPOUX5FElW4P/3M2xOkz3DehkJK5ws2h+yq3
QJ05Vq1vs2HJAuEECDGYHTSDv7Ck8Y4WCvGTMGSbGyIBeZt/GA09UXMGOTUEYNXC
m974x5pIs/TsvXZbg5tzqV9dubssvuawA9edcNxmvCpCJxGp9hu278P71jJWpDPA
ewX+4ARdgaEIVcoAIC2ycOR32pRb/PQCbTJyDGto4lRS23UU5S7zxEedaQRkcWQS
iRyr9RddtWalTUpTdnt0waN5ERaCaO/VaTD1iBJcK6Rzr/atGkAi7FzBY7jzk7Mi
u0v+yWKZHg1nH3ePlj9RJ2ZZeAKkqCB7MvaHCC918hee/sbSHHdcynPJIiKypXbG
YSHu4tSW8bWDcpXW+jqeU4C3z/5IXfLFTrqbO7tPLjtyLIg3QeFS8rWjy7aL4XV3
h/YDSGlTeQqmNIet5zv+BBAUoXeAOU794KZmVmENQaHk7U2ncJ+r0zMwDocqZMRO
dixBMBVMRVmVvWByuByQLl9PVtZXIe3GQlULEhPtNwOu71vV+KmoAyNHVtTpGRhH
XjHBg+ahU2auy8rsXNBDIiWjzgbbsy9+ByqES9B7mSRmlet1hyC2nd83BwY+RVcT
l8RuwvCu39TyYylOPwI5g6rNiBEyFekBkifzlGYTEOnIBu2jilc+QHRZ+F56Dy9m
WYycFbu7Bh1r7sX2gBhF
=sxgb
-----END PGP SIGNATURE-----

--Signature=_Sat__5_May_2012_14_54_03_+1000_OMi/byFnVYFRCK6M--
