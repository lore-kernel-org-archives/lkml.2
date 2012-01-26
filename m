Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab2AZQUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:20:13 -0500
Received: from pyr75-3-78-192-68-46.fbxo.proxad.net ([78.192.68.46]:46039 "EHLO
	molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab2AZQUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:20:12 -0500
X-Greylist: delayed 7090 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jan 2012 11:20:11 EST
Message-ID: <1327594823.2062.0.camel@scapa>
Subject: Re: [3.2+] BUG: scheduling while atomic: swapper/0/0/0x10000100
From: Yves-Alexis Perez <corsac@debian.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-usb@vger.kernel.org
Date: Thu, 26 Jan 2012 17:20:23 +0100
In-Reply-To: <20120126161539.GA2098@kroah.com>
References: <1327587732.2296.25.camel@scapa>
	 <20120126161539.GA2098@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-V4n4T/ZdGDJu1d3Rm0d0"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V4n4T/ZdGDJu1d3Rm0d0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On jeu., 2012-01-26 at 08:15 -0800, Greg KH wrote:
> Very odd, it wouldn't seem that this patch would cause such a problem,
> as it is "obviously" correct.
>=20
> Kuninori, any thoughts about this?  Should I revert this from the
> tree?=20

Something puzzles me. Just after posting I noticed that 3.2.2 was
released, so i tried it (vanilla), and I didn't get the BUG().

Will git bisect work in a forward way (3.2.1 is bad, 3.2.2 is good).

Regards,
--=20
Yves-Alexis

--=-V4n4T/ZdGDJu1d3Rm0d0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJPIX1HAAoJEDBVD3hx7wuozvkP/ArldgNDOXMXnw72EMQElCp3
h+Uzng/QfNXB+QL2L1gG5rDFDcogRvjcS9lH6GX6oALIvocJ7izu0oq/WPqrziFA
Tt7oZAGNpz0qDRWjXKaSkGZh1LesZL3ibod7ORnzlJ210nskY0+GssIDo3GGMTeH
IJgh7XQCoQ7lVVZHmb7k1pZaP/iwquMwT/3GB8Z1YVDS3EO29GMb/yxjx4HTfH5h
SHhRK4SVEYmyOA98tEJzz/hUeg13lx8kBp2wAt2aehZXt7KPs5e0F+y3TeuhRscf
LHGAEtEUO/9Ks426J1zaPK3byHTxGzzGWgXV5Z6Tb0pFfztyFCGaYoCwFg3uz6FC
PHaL7vpRvyFajfllBnynPFn2EljQeGGn8E1sCNPjInZvYBjK9re/0pcwXgJAL4iV
ePNT14CmERx8KgjTmaMgit4ZusKkzj+imBxKqZrypjBGS0zarI3cFfYQhFYIzkZW
mfNwIpp+DIPs96uQHVgaw+oXxcNFcnjGte8+JutJc1Zz/SOXkAE2mB3Rh1r6ably
it2XlVYnqHO5GkiJWSiVaSS5TdSKRGKzYxvSqiG9hWkSwuPyH1KVId7NOHCy643p
tOsS1lMvpP6VtepHBmb8aW9rSKs01427IQ/LV5ybbEX7Ps3iRD+rMrc7hKBrKf4z
Lv0ORq+ZWnf6D8zUmy4S
=ROJM
-----END PGP SIGNATURE-----

--=-V4n4T/ZdGDJu1d3Rm0d0--
