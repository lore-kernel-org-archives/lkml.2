Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1K2Smm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:42:42 -0500
Received: from www17.your-server.de ([213.133.104.17]:60918 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab1K2Sml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:42:41 -0500
Message-ID: <1322592151.1534.78.camel@localhost.localdomain>
Subject: Re: [PATCH] coccinelle: Add patch to use kcalloc instead of kzalloc
 for array allocations
From: Thomas Meyer <thomas@m3y3r.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Date: Tue, 29 Nov 2011 19:42:31 +0100
In-Reply-To: <1322232368-28814-1-git-send-email-lars@metafoo.de>
References: <1322232368-28814-1-git-send-email-lars@metafoo.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ysWIb+0M7YwK+nF2PPbz"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ysWIb+0M7YwK+nF2PPbz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Freitag, den 25.11.2011, 15:46 +0100 schrieb Lars-Peter Clausen:
> This patch adds a coccinelle patch to convert array allocations which use
> kzalloc to kcalloc. The advantage of kcalloc is, that will take care of
> integer overflows which could result from the multiplication and it is al=
so
> nicer to read.

Hi Lars,

I did run your kcalloc spatch against 3.2-rc3. are you okay with if I
send the diffs to the LKML?

mfg
thohmas


--=-ysWIb+0M7YwK+nF2PPbz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJO1SeXAAoJEK2Y/UtDbsHsFnwIAIm2IprSleF5kgPiLFjI532D
W7XGPYFVO0XFLLTga5F+od1GYes6K26RGo51P6JRMq1UWA2elTwPhMTsqw3WP4kl
jVN2r8Mf9HODe0XOFiIXF4/DYEI6OeE8xOfZdbTkp7hM1pO/TJOvzHgerkZIXr/8
dWfmYwOM1vi4wAxs+z9CnpJW4bR7q14s+s7hqHk994oSL+VBV2OSB/7GKIHB7djL
+IkrXPZJbOnFTiJzfdjNdtGGkFCvzduHnC6nAGbVZkCPz8go3fs58Y8kccMqRgd2
/I3bJlF1XI6UcX/FhakAHClu10q7BZMUWHmNjGvTb98RMz0tj6At43zEAScxvz4=
=UmpY
-----END PGP SIGNATURE-----

--=-ysWIb+0M7YwK+nF2PPbz--

