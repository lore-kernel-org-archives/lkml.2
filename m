Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2DMRDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:03:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:51428 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab2DMRDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:03:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="129166898"
Message-ID: <1334336766.13160.20.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: use module_pci_driver
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andy Lowe <alowe@mvista.com>,
        Russell King <rmk@arm.linux.org.uk>, Tim Hockin <thockin@sun.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jamie Iles <jamie@jamieiles.com>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Date: Fri, 13 Apr 2012 20:06:06 +0300
In-Reply-To: <1333418384.18133.6.camel@phoenix>
References: <1333418384.18133.6.camel@phoenix>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-HDei6lBdvNSrXC/OZxEb"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HDei6lBdvNSrXC/OZxEb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-04-03 at 09:59 +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/mtd/* to use module_pci_driver=
()
> macro which makes the code smaller and a bit simpler.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-HDei6lBdvNSrXC/OZxEb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPiFz+AAoJECmIfjd9wqK0vZ4P/0X3tlh/tLfEnE2FsIXJVWfN
q1ydiQUoQ+QW8AZSDJIUx/3A8T3j8ANks9ZZVi6idcKHR6xvE3lGYTC+HyFZwx//
ztBRJqu3whnwUzIJIjWrzSGcZ/sRFgJtsWd+T5LuEgIkYUhW5DiSELTvie0HjnLq
7n/Femya0eiuYsqeoYnQq0tJMf5vrlgboOpFNaxydeNNw6MkJitHMt+KeDXLJQcb
bpMYHDVuYwxKGQ3sQkQcRRQxO/yIzEnTInUPjjFA2hKQHlRjkv+ywE8jOOEQh+jW
MyaqgdcbU0NE7E0pM9rA7/4+UXcfq4wPbToMjJID0/HGvQ37QXV7oNU2N1T4AK0w
6T222IMZXKKkJDYaCpr7LnJfhEFxMXs+24Rjsq0qa9gRDbsFUsTsKzuwu3NsI+vg
LxlV2Tt/bwZggeqPVmQJUFYuGZ1WAVpuyASxDhrk17v6ZjVQI0LRg73xtnehG/fq
WIkrXtzCuyhYofBOf9PcGZkmkDelLtwPVGAKuYLw5Yrvw8wH8ux/rbzn+ni3/C3K
jvC1fUcCLa+x2DEoUSeiWZ1wQHOoxIIGs+d2mipdwMptKE0sWkZUDoAZax/HqlZt
WfkXH0hUxNjMcu2emcZIKpo51SE3/NoNyPej1yplDV8EcMsxkaW85xK/jrY7feDB
Or1Fz7c3x3IK1WJDgJPp
=Djej
-----END PGP SIGNATURE-----

--=-HDei6lBdvNSrXC/OZxEb--

