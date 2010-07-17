Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145Ab0GQUPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 16:15:07 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:59644 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab0GQUPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 16:15:05 -0400
Date: Sat, 17 Jul 2010 22:16:04 +0200
From: Nico Schottelius <nico-nospam@schottelius.org>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org,
        linux-kbuild@vger.kernel.org,
        nico-linuxsetlocalversion@schottelius.org,
        linux-kernel@vger.kernel.org
Subject: Re: I did a git pull and a plus appeared
Message-ID: <20100717201604.GA4904@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-nospam@schottelius.org>,
	Pete Zaitcev <zaitcev@redhat.com>,
	David Miller <davem@davemloft.net>, jeff@garzik.org,
	linux-kbuild@vger.kernel.org,
	nico-linuxsetlocalversion@schottelius.org,
	linux-kernel@vger.kernel.org
References: <20100716121802.65fdfa24@lembas.zaitcev.lan>
 <4C40BAD1.8090908@garzik.org>
 <20100716.131521.55876531.davem@davemloft.net>
 <20100716182609.4cad56e1@lembas.zaitcev.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20100716182609.4cad56e1@lembas.zaitcev.lan>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.35-rc5-00025-g2f7989e x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey guys,

Pete Zaitcev [Fri, Jul 16, 2010 at 06:26:09PM -0600]:
> > The "+" comes from scripts/setlocalversion
>=20
> Right, found that quickly, but the question is what the authors' intent w=
as.
> I cannot tell from the code. Folks at #kernel seem to think the plus means
> "built from a tarball", in which case this is a bug (the kernel was built
> from a cloned tree).
>=20
> I can easily add '+' to the list of filename characters in my terminal,
> just thought to ask in case it's a bug.

I'm soon on a long trip, has anybody fixed it already?

Otherwise I'm having a look at it.

Cheers,

Nico

--=20
New PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
Please resign, if you signed 9885188C or 8D0E27A4.

Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxCD4QACgkQ19zI5DGHffDrCwCfXatluxtP6gcWHrHwilFQLZ96
JYkAoI078XE7NG7qdYQcGBbl/5kJ52Gd
=A3V6
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
