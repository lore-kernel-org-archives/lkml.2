Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750991Ab2HGEVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 00:21:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65202 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2HGEVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 00:21:23 -0400
Message-ID: <1344313269.1865.2.camel@kyv>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: artem.bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, nyoushchenko@mvista.com
Date: Tue, 07 Aug 2012 07:21:09 +0300
In-Reply-To: <50200096.1070002@nod.at>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	 <1343919530.25013.116.camel@sauron.fi.intel.com> <50200096.1070002@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Nn58eDGVPtk4M2H+25t4"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Nn58eDGVPtk4M2H+25t4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-06 at 19:36 +0200, Richard Weinberger wrote:
> I think we enable fastmap only if a MTD device has more than
> UBI_FM_MAX_START*2 PEBs.
> Any comments?

With double space one can make it power-cut tolerant, because you should
be able to have either old or new fastmap at any point of time.

--=20
Best Regards,
Artem Bityutskiy

--=-Nn58eDGVPtk4M2H+25t4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQIJe1AAoJECmIfjd9wqK08GIP/iejXLF9PCHFiNCFKTdc6hvO
Z1ltsQLsSC1cdY0GjL7724hHWdzY++TW+tEB52NjklWWGJ2mYMIRa0mZEJJqO9sM
hAwI2i8RaAMPfCUl6NBNR3VggR0uo7D47WCkaNCrCnMshhKzF4mkUz6We3otYxoG
8t2GgrAGfy47168UuGUGawpnszLwG7HUF9KsqOcfE0Kv07uxc3D6xxLCZ6r5VwOM
8AQ5GEpWQD8NHg59p64zCxrPy51H+Z4kzAkbzVODPVvZYxXu8UBU+UGNGZa7rEYO
eUIhWqp+8Vn5ji5ZklrXWr97P1My9jrkchtPHZvT46RZqpmXzK/5o06q2+zQuVBm
lYkzczRcq0ZHLz6v9Ss5Fq/oSIW3eoZt8ou2Jp3jhgrPPNb/cZofH5JCDopTyJ+/
+2cuqLkqrC8A7Ux3SsjWmCheqEclx0rLJB6+rJuYF7WvHa0aVlZP4PEWqzr8YUlb
78Xqwj//OupvF/9Z9UK/UHkJeK+sTgPkum3dgekWGdxdKdD//zdSACa/ssk7xZpm
h8Z1SKIEku1LP+0Bt4dChxSdh3N4Ts74VdCZjT1CpmkMBIOVck1Fbsi5M1oUUhes
RU3ZS3nfy7Ryr1Gkx8XJQSlC82rQ5aMwn4YZ+5WeOKnOiEulEoEj7zy8vAHCgdPE
T5st5wJS5vbD/FI/epVr
=ctYu
-----END PGP SIGNATURE-----

--=-Nn58eDGVPtk4M2H+25t4--

