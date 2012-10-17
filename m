Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2JQCLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:11:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42279 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935Ab2JQCLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:11:16 -0400
Message-ID: <1350435527.26833.63.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 038/147] block: fix request_queue->flags initialization
From: Ben Hutchings <ben@decadent.org.uk>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Date: Wed, 17 Oct 2012 01:58:47 +0100
In-Reply-To: <20121016225948.GA3027@herton-Z68MA-D2H-B3>
References: <20121014143533.742627615@decadent.org.uk>
	 <20121014143538.966779793@decadent.org.uk>
	 <20121016225948.GA3027@herton-Z68MA-D2H-B3>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9uKuO6ivUrQaSaD0fqSH"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9uKuO6ivUrQaSaD0fqSH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-10-16 at 19:59 -0300, Herton Ronaldo Krzesinski wrote:
> On Sun, Oct 14, 2012 at 03:36:11PM +0100, Ben Hutchings wrote:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Tejun Heo <tj@kernel.org>
> >=20
> > commit 60ea8226cbd5c8301f9a39edc574ddabcb8150e0 upstream.
> >=20
> > A queue newly allocated with blk_alloc_queue_node() has only
> > QUEUE_FLAG_BYPASS set.  For request-based drivers,
> > blk_init_allocated_queue() is called and q->queue_flags is overwritten
> > with QUEUE_FLAG_DEFAULT which doesn't include BYPASS even though the
> > initial bypass is still in effect.
>=20
> Since QUEUE_FLAG_BYPASS doesn't exist and nothing in
> blk_alloc_queue_node is set on 3.2, this change is uneeded then,
> but the patch should be harmless anyway.
[...]

Thanks, I'll drop it.

Ben.

--=20
Ben Hutchings
No political challenge can be met by shopping. - George Monbiot

--=-9uKuO6ivUrQaSaD0fqSH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIUAwUAUH4Cx+e/yOyVhhEJAQoX2g/496Uy0j1saSu2rjSOIxYFZVYkoI0dZi+d
1O8p0c1nDpC6GBWWvzQBdAcRJHaR+GfXj5SVw/QNVwkb2jJp3u2oAoEBRUihES6z
B1AHO27YcSwZ3eXEs2FXPEN1udJw7+zXzuLFTCyPeZUJuzFtcwKm+j5iDFDZwju0
BRv0pOfxV5P/nrZlubjjf8CB1qdWXOYh7Bblp61ezkkKLzgepEnzUVflvn5Vfd7r
pIM4JrG7f53WJsJ3P1W8IBfDEnsRKJSc3cD9AOnvglXoWVdnbXWZPW4oUiSBSo1H
ZmJ5MjHXj6dTz86QFLTbh3jPZ5iZJbyjfpo9tjT/E/LpDS24kuEzs4Z7O4lG8lJm
OjvZea+6eR01q7wp5QZ1laLkAuMaCDMTEkhaVysNt1uxTGERMx67zZJ9h3YbnZgL
UvDSHvvI1yLAcaJMboKecuxHF6GwO08oW+XXZLQn8x8UaG/VOtfqTJWXsrTXmByV
D9holnXk1CWJX9yPyJCLDW29v27WuN2M9FRv2E5teLRmxClMh6kODYW3hF4uevTY
Chp7SG9HcJWrNPDNM9a+9kO4ZjnkWMTPS0rX/9K/x5HKRIiueIyCS+Zn1ROeZEEz
6r4YJTUDN4iNCuiyh88w5ZO3rYWAW877i+F76g2vx+yUU6jCzJ1tUK0lXoS6AqqN
mEzgFXSgRg==
=W5zk
-----END PGP SIGNATURE-----

--=-9uKuO6ivUrQaSaD0fqSH--
