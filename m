Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab1GKGar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 02:30:47 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:56532 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757158Ab1GKGap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 02:30:45 -0400
Date: Mon, 11 Jul 2011 09:30:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Felipe Balbi <balbi@ti.com>,
        lud <linux-usb@vger.kernel.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] usb/gadget: fix net2272 printk formats
Message-ID: <20110711063037.GC2680@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110707172544.867b980a1196db005b577c14@canb.auug.org.au>
 <20110710114147.c4ae629f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline
In-Reply-To: <20110710114147.c4ae629f.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 10, 2011 at 11:41:47AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix printk formats for dma_addr_t:
>=20
> drivers/usb/gadget/net2272.c:740: warning: format '%08x' expects type 'un=
signed int', but argument 6 has type 'dma_addr_t'
> drivers/usb/gadget/net2272.c:859: warning: format '%08x' expects type 'un=
signed int', but argument 8 has type 'dma_addr_t'
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

already on Greg's queue:

http://git1.kernel.org/?p=3Dlinux/kernel/git/gregkh/usb-2.6.git;a=3Dcommit;=
h=3D7b30d19a5736b930c39cd7212ae9409ac0df525d

--=20
balbi

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOGpiNAAoJEAv8Txj19kN1J+0IAIg6ExbEPIxWVwzmObJDGNv+
oaBeM5t7YIWh4hXEzlO+QOeEkMX9Kc92SloWOk1UwcYMZ6AY/w0lvEsfu0/ftuqN
/mBz/u9hMXqLaCiYhFOzJfR8m2lMJVFRzny3uY+riCy2TkKYMDP/qS4ZoilME1FM
p2mQBJ9+zn4xB7Oau+RJ9J3JT+6ROI6mfEVSNqQ1h8CaDwKHShRw2OjciKZJQoIH
Vbs0yrWoZtFR7kKvQveJtWUWRinS2hXNwLpsTNmCM+MpmByBtLW6qJZ5M4yTxXcr
Baf5JEomny0wa6t8wg2FFNBsuBGHoPjGfnp+JMqiC9P7uBD1SmUCWE+B6kwB7S4=
=ob5N
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--
