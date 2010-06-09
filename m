Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab0FIAFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 20:05:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35586 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab0FIAFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 20:05:34 -0400
Date: Wed, 9 Jun 2010 10:05:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: unable to fetch i.MX tree
Message-Id: <20100609100526.913a49bb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Jun_2010_10_05_26_+1000_rd2Q_=i07bcBpbxt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Jun_2010_10_05_26_+1000_rd2Q_=i07bcBpbxt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sascha,

When I try to fetch the i.MX tree, I get these errors:

git.pengutronix.de[0: 92.198.50.42]: errno=3DConnection timed out
git.pengutronix.de[0: 2001:6f8:1178:4:230:48ff:fe91:5e78]: errno=3DNetwork =
is unreachable
fatal: unable to connect a socket (Network is unreachable)

I will use the i.MX tree from next-20100608 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Jun_2010_10_05_26_+1000_rd2Q_=i07bcBpbxt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwO2sYACgkQjjKRsyhoI8wqOgCfc99pteN+bFviIu4I0n1yKclk
IzEAnRCcns7OpdYjAmz+ZBq1LSD/YVpq
=IuV+
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Jun_2010_10_05_26_+1000_rd2Q_=i07bcBpbxt--
