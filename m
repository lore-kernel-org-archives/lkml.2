Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab2AaLMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 06:12:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48220 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695Ab2AaLM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 06:12:29 -0500
Date: Tue, 31 Jan 2012 11:12:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the regmap tree with Linus' tree
Message-ID: <20120131111226.GB18444@opensource.wolfsonmicro.com>
References: <20120131135950.0da0eb3e0da92b9a3b658354@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <20120131135950.0da0eb3e0da92b9a3b658354@canb.auug.org.au>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 31, 2012 at 01:59:50PM +1100, Stephen Rothwell wrote:

> I fixed it up (I think - see below) and can carry the fix as necessary.

Yes, that's the fix I've got.  I'm kind of surprised git didn't figure
this out for itself, the tag I sent to Linus should be pre-merged into
my -next branch as it was sitting in -next for a while.  I'll probably
merge Linus' tree up at some point when he tags a new -rc.  Thanks.

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJ8yTAAoJEBus8iNuMP3d4S4P/2L1kUmfJ49/jwsI8NuhLQZe
Z6qHHp3gciPf8N8Jbtm9lc9WKj9YiDs9Ha0jXJeZY40auwcivqwYsyfFOkfwHFxq
lRr0hWPvvQ0kk1tfkzrkNhMN3EjhMEzBjcQ4CmCZfdKtbKhZgoUvEEc2a13bla72
EMM6ASOZdZVeIsT2878SGzPU2F5gr0s9nnZKU7WHReURWNNSzH4dMdnkMrGKwdST
tHaMuT9YLQowq04QOQsUEV+YoWithonhiG+d9Wp0UK27ZPhNyW7ZNX+YxmH4c4nt
idxYhOOzI9Su9nkWFkRiAMyCujXEmWUTF0PIfgDb9UxKzJhIFxw1Ara+JQtCuVGZ
r6NJ2/ESCjTNGRxnXtogbjt6XJ6o7OCPCvIY4Wtnbl8Kg0qqCuEoO2NxB7mRQeQV
vF/usphT/9QlihyiHOfkI6M1KBKv2ojoYoiu6MCYJ3PUuJU7MHaFTKplUF43ecj9
7xddsLLSSN7pjE8D8OtkJBsr0jV8i3NkmHyWEMFVA/Ea2LpOPnnnfMDwyc2Mhk3p
/Sg0DszaVaFACrMoqJGJubV9c1HG8ThmBZRxcqP3Y4svkDG699Szck/ptgrLGIU4
qb46qASKnNGCg8SEEMq2RahaZTgfcNxZeAI26Mv31EZr31SH8aLpa3uSAqZUXLEi
5aNDY8AzsSjHqFeCbawi
=0H8a
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
