Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab1LMUBC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:01:02 -0500
Received: from comu.ring0.de ([46.4.151.82]:35412 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1LMUBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:01:00 -0500
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  1.3 RCVD_IN_RP_RNBL RBL: Relay in RNBL,
	*      https://senderscore.org/blacklistlookup/
	*      [93.223.86.58 listed in bl.score.senderscore.com]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
Date: Tue, 13 Dec 2011 21:00:57 +0100
From: Sebastian Reichel <sre@debian.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Heikki Krogerus <krohei@gmail.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] omap: rx51: initialize isp1704 properly
Message-ID: <20111213200057.GA2965@earth.universe>
References: <20111207193141.GG31337@atomide.com>
 <1323287816-2809-1-git-send-email-felipe.contreras@gmail.com>
 <20111208144044.GA25415@xps8300>
 <CAMP44s2noD4TXBALOc0JkcbVroYFnp3BaSozrQYdUbsv50xuoQ@mail.gmail.com>
 <20111212194445.GG32251@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20111212194445.GG32251@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 12, 2011 at 11:44:45AM -0800, Tony Lindgren wrote:
> * Felipe Contreras <felipe.contreras@gmail.com> [111208 11:52]:
> > On Thu, Dec 8, 2011 at 4:40 PM, Heikki Krogerus <krohei@gmail.com> wrot=
e:
> > > On Wed, Dec 07, 2011 at 09:56:56PM +0200, Felipe Contreras wrote:
> > >> From: Heikki Krogerus <krohei@gmail.com>
> > >
> > > I would prefer that you change this so this is from you, like it
> > > actually is. You can mention me in the commit message if you like.
> >=20
> > Well, you came with the fix, I just typed it down, but as you wish :)
> >=20
> > >> Without this USB networking doesn't work as the link is never detect=
ed.
> > >
> > > What this changes is, it leaves the transceiver powered by default
> > > instead of setting it into power off mode. So not only USB networking
> > > is affected by this. If isp1704_charger is not enabled with RX51, USB
> > > does not work at all. Please change the comment.
> >=20
> > I've updated the patch.
>=20
> Sorry what's the deal with this one? Is this the one to use or is there
> some other patch?

I can confirm, that USB on RX51 does not work with 3.1 mainline
kernel and applying this patch (There's a v2 with fixed Author under
[0]) results in working USB support.

[0] http://www.spinics.net/lists/linux-omap/msg61217.html

-- Sebastian

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO5675AAoJENju1/PIO/qafSUP/i5/AbIdskhNV+6ivSuZm025
tZ/UjriT9X/rHvkJGjTgBTYfO6mageQy4b3GyuoKPsWUNDge6XWtmtYhCFlsX6oq
IsAqtCo3RkXmfKZGqiET+tqO6R0Ytf4BUA92dynQBP95THaFqTUXSuAwAEARLBPe
JCndERxecQ8f/2d+dwAWoZBE6/t2fooohI63vNTe7pctXBZelAkKS14OI0x6oyHf
IQBK7fagRTKC7rUU6iHNi4HYCfc/JjQcWchEKb1sfMsgKkMjcTPA3ie5nLml2D/i
TUIOLXt7kLs1Z+LIqStXlbL+Xkqq+0Qpdsx5Kb77HJMi1PC6PBytKnNmF/1dZhYU
V0C2sNF25EwXS7EWA1UrYBzmA6itv8GBkvdOEoF0ysuykw9etO64953L4IFAv9Ra
G3nt+Y0sVmK0w8sHqtM/kZLB/2u29CejuROVY5lJGFfgMQSIbGoMw/DDrz6c1wfN
YOdRO9TxPJLzISHNVKIWQLtdos9Yi2ru29I+KCmBDCi3cfvuofHF4drdOc4Zawwy
uABp0cdAF7ALNLT8WgUPIDKMLqYr4nsLY2gfFxajfrpL89ZLUxfv+1KE5P95ZwRh
ZA8+nlL2UZqVDfHh9WGZlBtPL/G0u5URnWXLMo4TKV7MBnvvEYZJ3Z+oUQl2a/oW
BIuq3XQRSFPkMvbwBT4k
=jwPg
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
