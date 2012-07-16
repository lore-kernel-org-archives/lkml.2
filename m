Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab2GPGgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:36:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64917 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2GPGgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:36:43 -0400
Message-ID: <1342420278.3213.2.camel@brekeke>
Subject: Re: [PATCH] UBI: Change the default percentage of reserved PEB
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 16 Jul 2012 09:31:18 +0300
In-Reply-To: <1340977901.3070.210.camel@sauron.fi.intel.com>
References: <1340953061-15728-1-git-send-email-richard.genoud@gmail.com>
	 <1340977901.3070.210.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Q4UVS4v96Tippv7fQVN/"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q4UVS4v96Tippv7fQVN/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-29 at 16:51 +0300, Artem Bityutskiy wrote:
> On Fri, 2012-06-29 at 08:57 +0200, Richard Genoud wrote:
> > The actual value (1%) is too low for actual NAND devices, a huge
> > majority of device has 2% maximum bad blocks (SLC or MLC).
> > (Actually it's 20 blocks on a 1024 blocks device, 40/2048...)
> >=20
> > Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>=20
> Thanks. But I'd like to wait a bit - Shmulik's point is fair and the
> current way UBI reserves PEBs is probably not the right thing to do. If
> we are going to change it, I'd like to have this patch to go together
> with that change. Just because it is better to change the default
> behavior once, than 2 times, to possibly upset/surprise users less
> times :-)

Pushed to linux-ubi.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-Q4UVS4v96Tippv7fQVN/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQA7U2AAoJECmIfjd9wqK0qaYQAJrRGteavUhVw3wnXrbIBgRA
hMndsGnuyGTVKH568o2VLa/2wjf5k6xMMb7Uke70DPdJvKwBlXoiLMoeS9uZMReW
UNMwCz3v9O478t0+wEFNUf+LgIGu8o9deNqfdNwRlaalnKvcKkBcGr01HlbVVO3P
cRKuQCyjhurOi7u/XGn9BPwKCgTpw5PAs73BkhxmKw/PnJbfmSQjTT1tPxy0QdzQ
z2qMfpJh3Efm3nFqaL8mGWPmFZ2+BT/qtK9Xswo1DXfnpTvjzzX36ETqfznU/XRH
ANFNIS63l6wUrd02VLjZno1/SvPM+1ZcsWpdotYKAb17Gi3XsB7Yxw4rv/YBQreM
n9B/AUkWAfELbFPlvQO2X0oXLlH+8Wv5MpycP0A177qGGG+UpRHkKqJek/3NpB/b
0oXk3VQlms4Qv/ax9J8MmiuQ/C+1A9xo+BQGVaBlgcaPYRpGIyk2+iLIJVdLHddT
2wyfXwvVeMMyeM03J9vuhsePYes6D/Mkn6Eb0aUEQn6O6XeuZ5NNJSRevJkdMGvS
4WT5OWODLeLfxOHcrLXQMRzDc41ALvuLPj+6GagcK1Hvn5kYOE2ngUhIiYeCQ43J
/Wx1bbP2rEfthVrAxCg1nflVdKDnbgtqLQ8UwrWArWvjMyfSEZvnBnc6KeTCeXRU
C1M8G2IF7sCGVowmGpeL
=dczD
-----END PGP SIGNATURE-----

--=-Q4UVS4v96Tippv7fQVN/--

