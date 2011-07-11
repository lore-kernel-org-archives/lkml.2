Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab1GKGaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 02:30:21 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:60168 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756347Ab1GKGaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 02:30:20 -0400
Date: Mon, 11 Jul 2011 09:30:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Felipe Balbi <balbi@ti.com>,
        lud <linux-usb@vger.kernel.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] usb/gadget: fix langwell printk formats
Message-ID: <20110711063011.GB2680@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110707172544.867b980a1196db005b577c14@canb.auug.org.au>
 <20110710114127.ebb0d803.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <20110710114127.ebb0d803.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 10, 2011 at 11:41:27AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix printk formats to use %zu for size_t args, to fix these
> build warnings:
>=20
> drivers/usb/gadget/langwell_udc.c:3274: warning: format '%d' expects type=
 'int', but argument 4 has type 'size_t'
> drivers/usb/gadget/langwell_udc.c:3289: warning: format '%d' expects type=
 'int', but argument 4 has type 'size_t'
> drivers/usb/gadget/langwell_udc.c:3473: warning: format '%d' expects type=
 'int', but argument 4 has type 'size_t'
> drivers/usb/gadget/langwell_udc.c:3487: warning: format '%d' expects type=
 'int', but argument 4 has type 'size_t'
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

already on Greg's queue:

http://git1.kernel.org/?p=3Dlinux/kernel/git/gregkh/usb-2.6.git;a=3Dcommit;=
h=3Db9af9ea45a8dc1c3e7a98319bac90199807cc258

--=20
balbi

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOGphzAAoJEAv8Txj19kN1230IAJFW5kY3vb9erzst0SudAq7K
aB/fHjvC3Wpq7EtdHAmpXrtKoVZPzo5IBF8sBPbOQE1lwgiDHm2S1AXfnqnbbDyi
P/x7/UWVf1e9EXH3utRpXMiOJmfaG9lHR7GStQZtmx8KtFQMXmCzgqJLrfjfGDXa
4hBnLtrOCN7M06O3QsvpbK1FFqGth5XyH64POhVtsryX4TWaJhQRQYud8StRiAZc
AYCmhEeNUywsmmDco1hmnfi8bgbY5/fOo7JvJpCXK9/Q+aUh3gBEktQrBOHu6eDR
0HVlt09X9CQc5y9Q96scxgFDqgNpafbRgsm/0IQogZjWJDAwgAJyhZab4jYcRlw=
=mA7c
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
