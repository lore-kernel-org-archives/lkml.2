Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab1G2Omb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:42:31 -0400
Received: from fsing.rootsland.net ([62.141.37.30]:40475 "EHLO
	fsing.rootsland.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1G2Oma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:42:30 -0400
X-DKIM: OpenDKIM Filter v2.1.3 fsing.rootsland.net 3072512FC81AC
Date: Fri, 29 Jul 2011 16:42:26 +0200
From: Stephan Seitz <stse+lkml@fsing.rootsland.net>
To: David Miller <davem@davemloft.net>
Cc: stse+lkml@fsing.rootsland.net, maciej.rutecki@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: IP forwarding regression since 3.0-rc6
Message-ID: <20110729T164027.GA.2e63c.stse@fsing.rootsland.net>
Mail-Followup-To: Stephan Seitz <stse+lkml@fsing.rootsland.net>,
	David Miller <davem@davemloft.net>, maciej.rutecki@gmail.com,
	linux-kernel@vger.kernel.org
References: <20110725T141145.GA.2ae38.stse@fsing.rootsland.net>
 <201107281546.33227.maciej.rutecki@gmail.com>
 <20110729T091342.GA.06bf4.stse@fsing.rootsland.net>
 <20110729.003620.1377780539620085743.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <20110729.003620.1377780539620085743.davem@davemloft.net>
Organization: Minas Tirith, Gondor
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 29, 2011 at 12:36:20AM -0700, David Miller wrote:
>I really think this bug will get a lot more traction if you report
>it to netdev@vger.kernel.org which is where the networking developers
>are actually listening.

Thanks for the hint. Luckily, Eric Dumazet reported the bug already to=20
netdev.

Shade and sweet water!

	Stephan

--=20
| Stephan Seitz             E-Mail: stse@fsing.rootsland.net |
| PGP Public Keys: http://fsing.rootsland.net/~stse/pgp.html |

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4yxtIACgkQXse+NwPOAZ71VgCgrKZRUChTQnUIwBXaGUSawn/9
NJsAoKBhBq6BkUi77NLx9tMxkcfaWmZN
=/hZ0
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
