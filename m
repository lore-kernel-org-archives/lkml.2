Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657Ab2ERMGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:06:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:55705 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756599Ab2ERMGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:06:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="154400201"
Message-ID: <1337343005.2483.38.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: nandsim: don't open code a do_div helper
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>
Date: Fri, 18 May 2012 15:10:05 +0300
In-Reply-To: <20120516192145.GB2913@herton-Z68MA-D2H-B3>
References: <20120516192145.GB2913@herton-Z68MA-D2H-B3>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-kl0hgMyQTcJf8zN8e+Vs"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kl0hgMyQTcJf8zN8e+Vs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-16 at 16:21 -0300, Herton Ronaldo Krzesinski wrote:
> We don't need to open code the divide function, just use div_u64 that
> already exists and do the same job. While this is a straightforward
> clean up, there is more to that, the real motivation for this.

Did not remove CC -stable, added Nicolas' Ack, and pushed to l2-mtd.git,
thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-kl0hgMyQTcJf8zN8e+Vs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtjweAAoJECmIfjd9wqK0LT8QALD1JoILwGnwKWCBbjFE1NA9
9QONyTCfwnNjixaMZmPjB6DxfaMZuOkaNjFcEIbjpOrOn6tsQi2jhJN582i7nFuA
4p8pG53DtHqEY+D6NH1dlGPo3Rvb6WWDbidlbvDec9evy8rJgehOeippwFaKXD48
H5HESa9ahMZHyyOTzXSVFEFBcwSPcb0/8WuUNveP50mQkQ8Y06pwVqNTsc3/sYDh
eXUdifZBmxl7WLCMmuSwxiBeTPd2KpMArGE3ki9qTTphm0tf34aI5vC2Q+5jbe6W
pe7GM9mMptH/umTxFsyiTl3CYabeG/mFQRCQ+JLEJDtBKczIKHt28yPsORzKoq7L
frjoPisd53erQGGL544SlRg7WG6HbFXgRe0IDsIJHFik90Z3pdwUbfNF+vpbAb9D
T3ZOqpfiwPsHJNFYpEsu+henfsun3tco8jUHW68vkkJIR71RncQ80B8wGvmerIN8
fZDiGYjrtLUbuU8rTA5kyuSl44kcAOpGZps/ShRUghChFzAaIcszZCtDNNbgEJe8
q5sMXlvGWK+T/MpKPlvK3AfVFHgOzVHFAr+PyMThcV5VJumT/NVt4ec0GMALjNC+
7z8i+4ZKqfudylLP+0/zUfTdj+nQN/jAWjgYbt81jta1euIQXVDnnrq6YOe0WZtQ
zmaSem0hz3ypdKvYVhkx
=UVlr
-----END PGP SIGNATURE-----

--=-kl0hgMyQTcJf8zN8e+Vs--

