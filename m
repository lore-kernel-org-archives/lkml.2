Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1FVEq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 00:46:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55941 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab1FVEqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 00:46:24 -0400
Date: Wed, 22 Jun 2011 14:46:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: linux-next: manual merge of the tmem tree with the xen-two tree
Message-Id: <20110622144611.a900a000.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__22_Jun_2011_14_46_11_+1000_tJVE2w1K40frC__G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Jun_2011_14_46_11_+1000_tJVE2w1K40frC__G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Today's linux-next merge of the tmem tree got a conflict in
drivers/xen/Kconfig drivers/xen/tmem.c between commit afec6e04922d ("xen:
prepare tmem shim to handle frontswap") from the xen-two tree and commit
ac33c46b42ba ("xen: enable frontswap for Xen tmem") from the tmem tree.

I just used the xen-two versions of these files (as they look newer).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__22_Jun_2011_14_46_11_+1000_tJVE2w1K40frC__G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOAXOTAAoJEDMEi1NhKgbs1NgH/1ITRD+eCuL3p/gybTErYwJw
8kB8qJM7lQV7om2obgBfkYLtfEO/bGMk0/HkxWD52xgctbQEgQ6+PHP5IM4f9dmQ
g1Wx7kpTXGKxJk+31ayZrfv3l0S4Bx23WKJRws7AcreyKiMPGrUjNH91HUrcLxUr
JZYWld4JNO3xXgNvgpCRJcnBGrS3D+wVHgWFYn0WjiLqotxO88u94RaClm1t0fw0
IAVLT0L7Ns9Nrk6o3PrVE5fAGZg5peUDENZ/oUq6MvoexnXrYcaVmohHyHfIWh4W
CGVurRUK1wENkdm5EYwfbbGjb5aR81kSNjtHnW/cW0a/dmLfCAewCyDpMPqs6/I=
=6JRP
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Jun_2011_14_46_11_+1000_tJVE2w1K40frC__G--
