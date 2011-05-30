Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab1E3FA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 01:00:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54789 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab1E3FAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 01:00:24 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Richard Zhao <linuxzsc@gmail.com>
Subject: Re: [PATCH 1/4] clk: Add a generic clock infrastructure
Date: Mon, 30 May 2011 01:00:21 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39; KDE/4.6.3; x86_64; ; )
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <1305876469.325655.313573683829.0.gpush@pororo> <1305876469.326305.518470530485.1.gpush@pororo> <20110525104750.GA3959@richard-laptop>
In-Reply-To: <20110525104750.GA3959@richard-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2029812.zPG0nvav84";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201105300100.23541.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2029812.zPG0nvav84
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday, May 25, 2011 06:47:50 Richard Zhao wrote:
> On Fri, May 20, 2011 at 03:27:49PM +0800, Jeremy Kerr wrote:
> > +struct clk {
> > +	const char		*name;
> > +	struct clk_hw_ops	*ops;
> > +	struct clk_hw		*hw;
>=20
> If we don't let it void *, why not put clk_hw_ops into clk_hw too? It'll =
be
> more easy to define static clocks.

because the ops should be const, and possibly shared among multiple clocks.=
 =20
i.e. if i have 4 SPI buses, there should only be one copy of the ops struct=
ure=20
but 4 clk_hw instances.
=2Dmike

--nextPart2029812.zPG0nvav84
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJN4yRnAAoJEEFjO5/oN/WBWsUP/ju7IPaUdnUMvaKVYQlWo8/2
1vYy3HZ0/Mf4pBTj6JZIBJtHjsF3oPALLfsQC51yZlFnrrz3wyuGQDPG8WdCJIbF
pWXvyAUWwwhMshH27f4O0f3X/D68IeL0/vmvUnxc9sXPJfPLI6PuyM07o8QzWLW3
nmFDlf6tWQh54SNGmbH4pc8AWMvM9j7LpPZy57spC5ty7GkYZBIleyyHB1VGgHBZ
h2zNEoGYbFaJIMRlB6MFfmC+o52kfMr+7GBzkDfBmfS/7NLWZxUUN1dTBfYgj+pR
XXEWBLjtVdhEApy7j8jb1HFav3ese6J/2g1uOOeR26f/hhsVAYyOloK/pPBAQVQG
bYDL0jPQkWYLlR1gFhD1UkbTUbgK6q24LAOmbm+H3cFluLpwdlP3auc0MAIkN8mj
MR10XIZqJnWT8IteS11ze5QN6FYUcSxQeYdRX/kwydeseoOMmxrwMhoOTn00bDIg
fkFlooDK3QiOqVD0LPZD/2keJJzRwaDylJhWPUdTOqAOjByvI/UuImdcaDBGvxOr
fpZgOmw140VY0b5AG15WbRQBQVG4jWi2JO1FWbOyvW+uD8ov7mGN+P1EpAJwhKe1
Zw9R5qikTYfbvJX7LpW6r77K6SntFcHMuzR3+THipnLI+S+dTYyd0KJv91sNBaaS
A+OnU2ysDTiBaWiIL5ko
=2WjN
-----END PGP SIGNATURE-----

--nextPart2029812.zPG0nvav84--
