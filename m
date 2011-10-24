Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab1JXWRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:17:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35653 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab1JXWRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:17:50 -0400
Subject: Re: [BUG] Re: mtd_stresstest module bricked my dockstar
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Roland Kletzing <devzero@web.de>, adrian.hunter@intel.com,
        linux-mtd@lists.infradead.org, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Oct 2011 01:16:54 +0300
In-Reply-To: <20111024212455.GC6326@pengutronix.de>
References: <69501156.1798237.1319395066798.JavaMail.fmail@mwmweb003>
	 <20111024055705.GA4020@1wt.eu>
	 <B10F15EA8AB74E698DC0D94563A30BE7@samsungnetbook>
	 <20111024195313.GA6326@pengutronix.de> <1319490276.12314.9.camel@golum>
	 <20111024212455.GC6326@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-D+ePolUnIfEekThgAwNo"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1319494666.13057.1.camel@golum>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-D+ePolUnIfEekThgAwNo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-10-24 at 23:24 +0200, Wolfram Sang wrote:
> > Yes, we should use -1 as the default value, and print a scary warning
> > message when the module is inserted without a parameter. We should
> > probably also put word "destructive" or something like this to the
> > module description.
>=20
> I would volunteer to do this tomorrow if nobody is working on it at this

Please, go ahead. I'll try to pick them to my l2 mtd tree ASAP so that
they get merged this merge window. I guess we also want to cc
stable@kernel.org.

--=20
Best Regards,
Artem Bityutskiy

--=-D+ePolUnIfEekThgAwNo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOpePWAAoJEJtuLFy+q7fe5PMH/1mGbxGZy0ar3bRAW0r/1jmf
OyOKTZzt2wyyfY0KAUhCdGRZf1d+MLjSeLvaO3/td1G0NliLXGVhgwt6ezK4djM1
Q54DxhZrLZHWnsk+CHkXGd5SkVS7GD/d46/7NIt+OxWzERZOQ3xcberSKuhF98Tf
0VvVv2402k3ku+wZFJ7Dg9WqyON0258vVd7B/Ap49d/9wtWnLG/cqwJyn9OeNDiS
CHOBUBUoJEXyzsxaU5lcXQsuX2KGX13KkXHuIvUHZT/2ecH8CWLBwzMfsj+mX5DE
+qyhAL4jyR0dZRqoXBeAy2BgwRHK1hzIp+Ad1Gbk8hE3q8dPM209hEzzpFUHlwo=
=1DVm
-----END PGP SIGNATURE-----

--=-D+ePolUnIfEekThgAwNo--

