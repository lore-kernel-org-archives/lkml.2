Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab2A0SVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:21:51 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:41836 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751705Ab2A0SVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:21:49 -0500
Date: Fri, 27 Jan 2012 10:21:45 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] PCI: remove add_to_failed_list()
Message-ID: <20120127102145.7c6b7606@jbarnes-desktop>
In-Reply-To: <1327140517-14811-17-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
	<1327140517-14811-17-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BYPdVFSFddt.=VdKdLPlsBO"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BYPdVFSFddt.=VdKdLPlsBO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 21 Jan 2012 02:08:32 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> only one user, just use add_to_list instead.

Ok applied up to patch 16, thanks a lot for the cleanups.  See my
replies on the later ones.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/BYPdVFSFddt.=VdKdLPlsBO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIus5AAoJEIEoDkX4Qk9hQDIQAKWWzU/T/FitEXtLiL3zAkh2
vNzEiq8A1aYBu2ueNJrlXJ8aJVDPEuFi2bTFEw7Xj9a9ikzmx6dNqksWbd+930uz
7pzqyCdXjNHBdVxk9IfBePjZKK19tg4k7vFTDZen1SE5nnoGFh/0kGLi6N4W8YOx
6Vleb7tNBfK/a+DdjyoVru5KyI9QWJJvmlnLf5r0sKWYXqg1gIwNg92s2cts9kDa
LAJt1pH7br9An4+q4cB3WBSprRRRX6a+aKvKUbJvWtQpWsuL9CbDADyGCKpwaZIq
CwlphZv+PmUcDCAnG7Dt3e1ZNQpY6bCKtsczb7tjRol3a/TZuHFO/zbQBcU2UG0m
f11TQ7sI8xcUB57tMzKIE6ToFAZVdv06sGWsRqD0YegfwbIhhJ6TAlX24SasQpjP
OpfIb7ywILC9EkmmRTGUVyruMvGUCSkTcoSAQXLxUbJhp1iqm3MWKjR09hFzQxmh
vdqtbzyGDaQobF+6kxpnoqXYwfLJdRHAeTAcI9nCxYuCodWBdZou/JSC0fAN7XtK
Xh+UYeaZHBVfUbabci1Uw2To7uT6OSJx1G2LZP3o5N5ItyJJg13ODHWjvI9/VkP3
hh7cB4UT0hczI9RcAuVniGMJ6DYAOPTwHw+1bqriiKGyzCqbQ4OsStXuJCgSibjk
L261xgOf6ebJmmTdPL9Q
=f9NN
-----END PGP SIGNATURE-----

--Sig_/BYPdVFSFddt.=VdKdLPlsBO--
