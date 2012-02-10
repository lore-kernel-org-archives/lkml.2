Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab2BJTCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:02:23 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56696 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759036Ab2BJTCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:02:21 -0500
Message-ID: <1328900668.22240.100.camel@sauron.fi.intel.com>
Subject: Re: [Cocci] [PATCH] scripts/coccinelle/misc/boolinit.cocci:
 semantic patch for bool issues
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Gilles Muller <Gilles.Muller@lip6.fr>, bruce.w.allan@intel.com,
        rusty@rustcorp.com.au, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk, joe@perches.com
Date: Fri, 10 Feb 2012 21:04:28 +0200
In-Reply-To: <1328893887-28932-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1328893887-28932-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-tH9qIoOBSZ6VM/ijDXiS"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tH9qIoOBSZ6VM/ijDXiS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-02-10 at 18:11 +0100, Julia Lawall wrote:
> +coccilib.report.print_report(p[0],"ERROR: Comparison of bool to 0/1")

All of these look more like style/taste/hygiene suggestions, and I think
they should be tagged as "WARNING", not "ERROR".

--=20
Best Regards,
Artem Bityutskiy

--=-tH9qIoOBSZ6VM/ijDXiS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPNWo9AAoJECmIfjd9wqK0GZwP/37m6OsLgLgoSy5unLk5JsXF
/HuViX/ix7fmL25jG6vX4UmBBbcPzBIj31T17aZqCZQSvS9l5mJov/QFt3rmv5G+
CP7QNzLLyfmvL6PYbw6HoGUAzuhIx2GQWSV93w68WeATEvJefOZFnBJDfYnZUFr0
RdSBsQPPicuzoGJV8odu57y3s7kKU0sSwQIfNAJzVomVjmShEdHG+03M3VmrcO66
eGeyvWe53k1Yc+IejxC4YTd7cjNhbdFkTl6imJcfyRdNUUyywRtxbNL6ioF5ADOm
92vrDd+T7xLjZ9kyuW9RSFPhux4KON1ysRIMRLgmkutcGnna0iOS7cgxHhEOCkeD
PMSVSJ5zlw6j11N0w6Ep6gBk7ZMCgcfZ41bTqsRTnaxk4RKuL9N1G3Xe7JOerxt5
EECs/aAdnyg3e8aZjsDpg2z4XyC5Plhy3FqvBmlAZZhtyRLCQFW4u5T0lFu+XDKJ
al7/lKrvoUGgYcx5joMwq8/A7OS8zp3Nx5QRdRFSoJs3fFpQCTpwyI47Xtv4F+j6
pnIehrUhtth5QOTGS85nYreGk8RjGjCCttZs/2V+GsMuX6FVTjgQx5fcreQjaIMB
e/yoHr8ZLz7Y3OfNGndlEuf+IzgQNokpHJGexwiSxjrGALikkB9SGVlGFqiUnQ7h
EvKevXc9zrv1L/beXB5n
=IDRn
-----END PGP SIGNATURE-----

--=-tH9qIoOBSZ6VM/ijDXiS--

