Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2G3B4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 21:56:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37561 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932Ab2G3B4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 21:56:48 -0400
Message-ID: <1343613397.4642.63.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH for stable] cx25821: Remove bad strcpy to read-only char*
From: Ben Hutchings <ben@decadent.org.uk>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: gregkh <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 30 Jul 2012 02:56:37 +0100
In-Reply-To: <CALF0-+Unvjo_SZom-x2b7X0kLg90GHeiQhXpQPh58fA=Dj5gpQ@mail.gmail.com>
References: <CALF0-+UJamw8fiB-rcX0WdYRAFnAdYxPoPQtMzG=5E2T8wz2yw@mail.gmail.com>
	 <CALF0-+Uk-5hKMnwi4FO5CBSgH6+QNsz1n8faN5rQxXvgSWVGNg@mail.gmail.com>
	 <CALF0-+Unvjo_SZom-x2b7X0kLg90GHeiQhXpQPh58fA=Dj5gpQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ayX3cGZkrNfmXkqZb/WA"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ayX3cGZkrNfmXkqZb/WA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-24 at 13:59 -0300, Ezequiel Garcia wrote:
> Hi Greg,
>=20
> This patch is already in Linus' tree and I really think it should go into=
 stable
> as well. You will find this bug in every kernel from the moment cx25821 w=
ent
> out of staging.
>=20
> I just read Documentation/stable_kernel_rules.txt, so I guess it was enou=
gh
> to add a tag "Cc: stable@vger.kernel.org" in the patch (right?).
> Now I know it :-)
>=20
> If I'm doing anything wrong, just yell at me.
[...]

An upstream commit hash would have helped, but I found it anyway.
Queued up for 3.2.y.

Ben.

--=20
Ben Hutchings
It is impossible to make anything foolproof because fools are so ingenious.

--=-ayX3cGZkrNfmXkqZb/WA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUBXp1ee/yOyVhhEJAQqj6Q/9Gqje+4j7+SWS3dMqeIpSoADIQ5zI2ZM9
saJcXeytSu+GyX66zDKesmT6Td6IHFukYCfFX5Q6EKoTEArnIlppy9iRuqF5w0oi
2Uh4OWmi9U9yJjlA5CJbO6lTSMxte8fusaYR+RO4L2JcUG4s+9gttHD6jqg45sG7
vAZoYQmGH03kw6ojn64B8QxgAsQFXtObnzSBRsRPztzjXw46euEHPXodDcDQ7v6t
qgk5yZRvxWfqNk229yIIrisxdNt7tZSr29Ayc3WCUtPc3oDOUuphzHkVxvdPsxmz
VKAe7CLRHCcCJmgKf6cloWDOQ06+XjD1ljmwklqWqnsmg86xzMlUgVs2E4KqLatS
sQIWxxaTNb7G6ETgZ5tFYCzQ1wvb6i5Y4SZ5g0ObA1j3sK48uwA6RtmJSlgI1z1W
rrUA5W/D+Dtqwg29DHJU2TevRiYlAKQCYEqJOGZomuTnmp9I6+g8R9m7kM4lUiuX
oZhOVYqsL7d2MJ9kSXWZWR4dbJNQRBhPtVSgwrK974z15YFDQ7qWNQXluELMyCAx
qWugXD/cUQppqG40dAteiURsymHXXPPdfvOWstyNMAEFhXry7OB0PaGRkIhQaWl7
5heO/6haAnW+vN92A/0oEF/lRp0OUA9mrXBnMaIhnvaNRS/hR2TQUJXFtpbEmhxy
INEMUtJ7scc=
=oJmJ
-----END PGP SIGNATURE-----

--=-ayX3cGZkrNfmXkqZb/WA--
