Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2K1X0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:26:15 -0500
Received: from mail.vapor.com ([83.220.149.2]:39867 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2K1X0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:26:14 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2012 18:26:13 EST
Message-ID: <1354144802.5396.3.camel@pi>
Subject: [BUG] NULL pointer dereference in 3.7-rc7 (syscall_trace_enter)
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 29 Nov 2012 00:20:02 +0100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-tGEKt0HHKgB39h6TQ4N4"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tGEKt0HHKgB39h6TQ4N4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,=20

Due to unexplained dns problems, I'll be using google plus to post the
photo of the bug output.

https://plus.google.com/photos/110698868656495230656/albums/581600585448273=
5041

I'm sorry but my knowledge is limited and current caffeine level is low,
so I'm offloading to someone who has these things handled ;)

--=20
Ian Kumlien  -- http://demius.net || http://pomac.netswarm.net

--=-tGEKt0HHKgB39h6TQ4N4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlC2nCcACgkQ7F3Euyc51N8wZwCgi62ad2KV4A9bVwHzC1Ce7vBA
y5kAn0f7Lv/fQQ/x0gIjE5A7CqYXhIz2
=8d7J
-----END PGP SIGNATURE-----

--=-tGEKt0HHKgB39h6TQ4N4--

