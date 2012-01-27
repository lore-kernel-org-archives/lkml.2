Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab2A0RaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:30:19 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:54762 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751404Ab2A0RaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:30:15 -0500
Date: Fri, 27 Jan 2012 09:30:10 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] drivers/pci/hotplug/ibmphp_ebda.c: add missing
 iounmap
Message-ID: <20120127093010.0e5ed4e0@jbarnes-desktop>
In-Reply-To: <1326362117-29371-14-git-send-email-Julia.Lawall@lip6.fr>
References: <1326362117-29371-14-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BBce8C/O+yAOE0dS2NNbLY0"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BBce8C/O+yAOE0dS2NNbLY0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jan 2012 10:55:16 +0100
Julia Lawall <Julia.Lawall@lip6.fr> wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Add missing iounmap in error handling code, in a case where the function
> already preforms iounmap on some other execution path.
>=20
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

Applied to my -next branch, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/BBce8C/O+yAOE0dS2NNbLY0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIt8iAAoJEIEoDkX4Qk9hqHoP/2v/TQk+Q4xj8Mb0sSwFKpHE
Ta2JgqnZZ08sp6bftqo/KCmsh4PfwMlvM0rmj7VETqT76dfj5BTY1dvh/xc8g4//
GUS7nsN0U4u9eL7lU+PNo5j+yoi+V6tfcvJPWcUCu0mpzkSKa9/VrtUOIXBqzO+9
KMpMkdocbOPXjGl7GohjBE8JKFunGUD5eYUx9nfsAIojoopqYYIqVriLwIIsBNSS
Dq/aejBnDOsl5nCw8R8zfnXA/LET8Do8q8bD2v4HREXDJ3xMpAXqpOF8vI/1mIFs
tdfkE213cP3BKIPUE4PP9GYixif7zgE7ddM3Oqyh7KwBuJDgPAFiYGG6u2jl+rsb
t55jV+AL5A8xI9N8xa3gdD2NY/tSDw9+I/e10xLul/U9xHLQKk4GKuBcjiuQMx/T
nFeum6uLrzJEpUz7VAjn5D+oaAIjfzXC/LvbUW3hXmkMlM+NEWMGOtCNF/33oiQ+
b88HQ8OFA54Akik7g6BfpsaIkDB/I9ZKIxBI+oDwNdHiiMxxtH6Tfh0MtZBDOIrE
Cfp3phNdCN5aGmI3WOBmVanZvKvRZY2L0OLmFuY75r/4om080Xvxe7LjMkLMIFFy
zhwu+ZvuDPpv20fmXGBV8GeBbVV1aP+apfiFXZMuzgh9Jh11VBa3PmofGyD4xMir
ejqGf75x9ELQV3QgtEzv
=FmcO
-----END PGP SIGNATURE-----

--Sig_/BBce8C/O+yAOE0dS2NNbLY0--
