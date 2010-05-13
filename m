Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0EMDAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 23:00:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42988 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab0EMDAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 23:00:22 -0400
Date: Thu, 13 May 2010 13:00:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the v4l-dvb tree
Message-Id: <20100513130016.25b76c3f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_May_2010_13_00_16_+1000_1nXgIXgpmQpV0h93"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_May_2010_13_00_16_+1000_1nXgIXgpmQpV0h93
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree produced a mountain of
conflicts so I have used the version from next-20100512 for today.
Please either merge Linus' tree into yours or rebase you tree on top of
Linus' tree.  There are a large number of commits that are in your tree
that have been rebased before being included into Linus' tree and this
caused conflicts with further changes in your tree.

Please consider changing your work flow so that you don't rebase things
in your tree before sending them to Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_May_2010_13_00_16_+1000_1nXgIXgpmQpV0h93
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvra0AACgkQjjKRsyhoI8wRxwCgqWVgiAAF5eMRifmVsJDthfdO
DgQAoIPy6wp+rH3m4tnwrOPut7QlWU/k
=3Dir
-----END PGP SIGNATURE-----

--Signature=_Thu__13_May_2010_13_00_16_+1000_1nXgIXgpmQpV0h93--
