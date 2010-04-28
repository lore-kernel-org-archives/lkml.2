Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0D1BLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:11:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36013 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251Ab0D1BLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:11:40 -0400
Date: Wed, 28 Apr 2010 11:11:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
Message-Id: <20100428111132.ebac2723.sfr@canb.auug.org.au>
In-Reply-To: <20100427.101804.13765995.davem@davemloft.net>
References: <20100427152516.580ee620.sfr@canb.auug.org.au>
	<20100427.093430.258110898.davem@davemloft.net>
	<20100427.101804.13765995.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Apr_2010_11_11_32_+1000_jn7dfcqYdQx=Vq_H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Apr_2010_11_11_32_+1000_jn7dfcqYdQx=Vq_H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 27 Apr 2010 10:18:04 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> I just committed the following for this:
>=20
> bridge: Fix build of ipv6 multicast code.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Apr_2010_11_11_32_+1000_jn7dfcqYdQx=Vq_H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvXi0QACgkQjjKRsyhoI8wWggCgoj6VCrdcJWvRUrS9ixAleLwS
axAAn3vPQTYzm63OaKlVEBXCJhkvqopn
=OhYO
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Apr_2010_11_11_32_+1000_jn7dfcqYdQx=Vq_H--
