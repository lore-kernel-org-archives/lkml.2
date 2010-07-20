Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab0GTJol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 05:44:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32818 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758408Ab0GTJok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 05:44:40 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Yulia Vilensky <vilensky@compulab.co.il>,
        Geert Stappers <stappers@stappers.nl>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100720074659.GA32073@oksana.dev.rtsoft.ru>
References: <1279584175.4883.226.camel@localhost>
	 <20100720074659.GA32073@oksana.dev.rtsoft.ru>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VbnAtc3kNuesuLzmJz+A"
Date: Tue, 20 Jul 2010 10:44:26 +0100
Message-ID: <1279619066.4883.249.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] ds2782_battery: Rename get_current and get_voltage
 operations
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VbnAtc3kNuesuLzmJz+A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-07-20 at 11:46 +0400, Anton Vorontsov wrote:
> On Tue, Jul 20, 2010 at 01:02:55AM +0100, Ben Hutchings wrote:
> > commit 9b9ade6b612e562c4a5bd02ef38cc32e10f3f9ba "ds2782_battery: Add
> > support for ds2786 battery gas gauge" introduced an operation named
> > get_current.  Since get_current() is defined as a macro on some
> > architectures this driver no longer compiles on those architectures.
> >=20
> > Rename get_current to get_current_now to avoid the macro.
> > Rename get_voltage to get_voltage_now for consistency.
> >=20
> > Reported-by: Geert Stappers <stappers@stappers.nl>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
>=20
> Thanks for the patch, but I have a similar fix in the
> battery-2.6.git tree (for -next):
[...]

This fix needs to go into 2.6.35.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-VbnAtc3kNuesuLzmJz+A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATEVv8+e/yOyVhhEJAQJh5RAAmyaHwunuD0wG3Q5aKRhPYbDyRG2CHLdD
bK+KmtP1+FYYwIpJyyDqf9mVyY9DPd0vDKp23OXB6Hgl9hB2SLYTxRtDwjOlhdL9
RPdfvKT4k6dOL38HlBNZiMM8gz3welVs8XPw34SinENOJLdQI1RXIH8vLMZuMgZk
fo23nblphyc2kdBaFNhCp1w03ItSo+RysnUATcFmrB4rDOlLXED3EDDjrTrWA0pe
SzKVopdhrZDTGfUGjzf5PJgd7jg9RF5G67823olBH39kmAOM/nJw6OvTd/QAp5MX
BKsF0y/C1OlJ69FjED2ADeiK94WYbtZNUNmhUq9CfAzLnhOWi6DYNf3HcXt1biZt
C2JnfZiHiIiAzJIYFdrGNvfbNhC1gmKwPKs9tprRIhpbB78lkJKkY5ih1NSCb3a8
rkX2spPAoIv9K36n2/Iuwp2A9jrClEb2/tVRQAJAt60Doaj0+uYdM5kCVmHaSaee
lIO3/DDi+mX/Rixg7S6I69puNAH3BOaLB8Xa0aGiuBRsGMG8/OGJZIQgqjYiqD4r
zpP/xrSSM1kJTiYVfVohKXDDDWZuysoN+he+y515O6HoJEIT4KVlP5SaJ16nII2b
SswbfeJldxE9kBmqCjWrHCKiqwXV2MhgCXe4yU118Wl9tfPFbxfFINWg5J4d+8zk
gqHkX7trof0=
=eXdK
-----END PGP SIGNATURE-----

--=-VbnAtc3kNuesuLzmJz+A--
