Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2HPMQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 08:16:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:32458 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab2HPMQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:16:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="asc'?scan'208";a="209304007"
Message-ID: <1345119652.3393.220.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/8] exofs: remove lock/unlock super
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: bharrosh@panasas.com, bhalevy@tonian.com, jack@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>, adilger.kernel@dilger.ca,
        tytso@mit.edu, hirofumi@mail.parknet.co.jp,
        mikulas@artax.karlin.mff.cuni.cz, Al Viro <viro@ZenIV.linux.org.uk>,
        hch@infradead.org, dushistov@mail.ru, osd-dev@open-osd.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Date: Thu, 16 Aug 2012 15:20:52 +0300
In-Reply-To: <502CC4AA.6040702@gmail.com>
References: <502CC4AA.6040702@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-6sBgPhYtD9+LrspW8toj"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6sBgPhYtD9+LrspW8toj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-16 at 12:00 +0200, Marco Stornelli wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
>=20
> Remove lock and unlock super operation.
>=20
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

Acked-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

--=20
Best Regards,
Artem Bityutskiy

--=-6sBgPhYtD9+LrspW8toj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLOWkAAoJECmIfjd9wqK0YtwQALU8zaQcyw0iF+l0kRBOJdh7
QvEvo3bbRDhXieFpp8gn5HqI1g+2p0ulegntnRAAWWFb8umErTfP+/djgB+IlYVK
EHBZ/dEqlIzfEsRDgswCH9L3jxc1CAu1VbbWykS3RbRB8bx0NUzKqRNW46iB+gsj
RYmovyS6NG6usdoa5SdBIwpVhm9Q2y/+ENdEbfAkS0mmsWa2tPxR3qy7znyuzjHw
CG+BGIJZ6mJMaCryl53opN0zfQ11ehBoy7A/i1UcdEgdA5RFKEV8Q2nfy5GJ6ofA
zZ9u6GeSX7otBcPjFU/8sLYX3PNvFiWHtHCAWTSt8EacbO5Kpf9qsw+TDyCr/CBK
o+AxXFOLup3p893ZVtUb3MQOuMOqKoCfzLQx/54iF2Tejo53ww5r4JCpdRHxTqdB
PHlzmCf1KLZ8tcA4EYxV6eo8pBWEQUr8Qme69B/9ZgzfyitvEVoWKl6alEUnxDF7
0RwPfqRO/bqpmUR9+hrMRn1jftB0w5cFqjpngmBz6Qekqzl6qFrRjdDfY0yNIp8z
NkYQRFY9mJiK0uzpwkCSU+enS0bBzlh7pyPrci0XS8QNfGR/zNeqGCnxk8otNUr+
rXhmS7YhERr22Uf4JH039dPyaIL6EnnbnYzteneHkQiYtfHyqhsegDXgmeliadXT
G1ny+BUbsmV8cdDLlqMT
=yzKf
-----END PGP SIGNATURE-----

--=-6sBgPhYtD9+LrspW8toj--

