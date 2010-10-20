Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0JTUvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:51:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33002 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752296Ab0JTUvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:51:24 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX19Ow4FzfMVODxAuZJr7S4JYCoaEczQ/AotsZWd9E9
	xCn5h9LjQZUwxs
Date: Wed, 20 Oct 2010 22:51:15 +0200
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: The list for a Better Approach To Mobile Ad-hoc
	 Networking <b.a.t.m.a.n@lists.open-mesh.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [B.A.T.M.A.N.] [resend][PATCHv2] staging: batman-adv: remove
 useless addr_to_string()
Message-ID: <20101020205115.GA18087@sven-atom.lazhur.ath.cx>
References: <1287589664-25447-1-git-send-email-andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <1287589664-25447-1-git-send-email-andy.shevchenko@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 20, 2010 at 06:47:44PM +0300, Andy Shevchenko wrote:
> Since all *printf() methods in the kernel understand '%pM' modifier the
> conversion to the string is useless beforehand.
>=20
> Additionally this patch decreases batman_if structure by 20 bytes.

Thanks for your patch. I have problems with compiling due to other patches =
in
the queue. I will fix that and recommend it as patch for 2.6.38.

Best regards,
	Sven

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCgAGBQJMv1ZDAAoJEF2HCgfBJntGfp0P/ApVA8supc//9wBKj/1sapF/
RhEeZq1f8Sj3UjwMXtLb/hcPXH7F61wNs+874f5va94NbGHs7Kal4qxu3UmXpLPW
AfwPm4t1Q3VCOWZwXwvoanItRLr9fLslKZMCwzxYj6VvfbEmejZus+iMIaLQFOY6
jIpQolzfx7vsG5j2yMZuKZhgmK1Ld3RnSMOuyIp9/sGe/4Wlct6A1n8trptRFvPh
6hmjyUeXKcfCYifEolWDL9AdiBq/oTKdEkqEPDsgptGU8ko4N6bEiWmmhYAJA5OY
O2XU90HqP9ODk1j7d0ZzjCXtkVo6JcabFUxrAK4CUsLeUl/h3Mrn/0ai83x1a0NR
EwZ/zd/69b2X3AoPSMnu0mogcrYEBTYUdkUX1o7zlzlbEr700ivUpipBGz2JEV1w
N8k/tylxVNSHt0C4/1DUP8DTzmQHiKwjwFludhudd4r2N3LJB3xD+tVYmB5PWWCp
yHpufpurZmclbu7pR8+/bTUn/NUPX33zM2QzJlNFHw78ru7cwLSUinYc0sdmw4cX
PKqFEMT/3AD13wOiZk5GuHjKPxv9WzHmpseyPjGZgHuieoXDDmh2RQedu/knD8pO
jwbo3n8cvVgltdEGqr8NPRvEKLZunBwnQ3vdu+d3hjl7ge0tLW3QXLLjmqIR6O7u
dvvnm0OtcGE/4D2t90tX
=/RJF
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
