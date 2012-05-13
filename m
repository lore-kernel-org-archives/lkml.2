Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2EMXzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 19:55:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47618 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2EMXzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 19:55:02 -0400
Date: Mon, 14 May 2012 09:54:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failed to fetch the cifs tree
Message-Id: <20120514095454.39dd3f95eead6d94ea4f554d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_09_54_54_+1000_K2r4emotbUgJYilO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_09_54_54_+1000_K2r4emotbUgJYilO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Trying to fetch the cifs tree gets this error:

fatal: Couldn't find remote ref refs/heads/for-next

and checking via "git ls-remote" shows that the remote tree has only a
"master" branch that is set to v3.4-rc7.   Something got lost along the
way ...

I will use the cifs tree from next-20120511 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__14_May_2012_09_54_54_+1000_K2r4emotbUgJYilO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsEnOAAoJEECxmPOUX5FELjkP/0lY6aOgpsvP9hnoCqsWNfmS
PYYfhW9y7ZISuTpZWl86yemKGnFMoaHDWOKvno7be6qm4+YLG89E2EzsU8HczMMo
PVylWKF5c3wo11HrvodUTDrh7TcpwX1flDUqtSOCI11+hC4fOTIbM5KeWdaJ8shO
aQxpW7VEVMzTFvdCA4P8rYdN/ouNFlreyPlh9v9etDPasjbzCbbwQ7DqJW3Rc2vf
7ITDTsU9ivMEANy7WReL9kETl8fnwrV38F3qDFSQUpm3NhAqz9hjjdcwQsqzHXfP
AxJ/1OF19hUr/NGxDRoAWFK7Cmy4s9F2ejNhIXH+Vn05Ho/mk+pDiBKaq7wr/KHI
ENzZ43Yxg4HV7Z5A3ncvAGRCv7MAx3GhQs4x36NMnhB1NeFyQjX4Hfa6dE0xwIhW
10NttoehhGneS2NV5bBkdJ3ANKZovyU5jIo81Z3erLF3BQZrn48larkGir+cNwF3
ISnacmmHBY5AlNKPqhgIeB69t66bKdy/W1rW8BORol/59F1vgll4f+RQFOH2sxcs
3A1qgLB9OVKOxKZ5sExQWo2ZszF2vCmCShZn6dgjmyJPJIacZ6xpQ2ayCUPVhpz9
lZReIhJVUPKFpzO3rQn0pIJkejsh7qer+OQF1MDINKJqygoyXS57IiIUCUHLwDzo
N7P7IhlJATkkXoem3z2o
=4GjZ
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_09_54_54_+1000_K2r4emotbUgJYilO--
