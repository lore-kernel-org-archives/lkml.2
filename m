Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550Ab0J0A3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 20:29:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59101 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933523Ab0J0A3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 20:29:12 -0400
Date: Wed, 27 Oct 2010 11:29:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Gross <jesse@nicira.com>
Subject: linux-next: build warning from Linus' tree
Message-Id: <20101027112904.461a0143.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Oct_2010_11_29_04_+1100_fW4QsOLKUqgp1zYU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Oct_2010_11_29_04_+1100_fW4QsOLKUqgp1zYU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

While building Linus' tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/net/igb/igb_main.c: In function 'igb_xmit_frame_ring_adv':
drivers/net/igb/igb_main.c:4110: warning: unused variable 'adapter'

Introduced by commit eab6d18d20fc5b5ba04a7e7fcd6f357197870e51 ("vlan:
Don't check for vlan group before vlan_tx_tag_present").

Sorry I didn't catch it earlier.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_Oct_2010_11_29_04_+1100_fW4QsOLKUqgp1zYU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMx3JQAAoJEDMEi1NhKgbs8dwH+wV6qS5UGpXyJ7kh9kXC6HhG
t1+HiFzeVmzhjc4gN76VOEfyntsd76mHCSarJHiC0HkRkj81Kcpd1k429oo+ZjkT
e60XD6cwUNltw0oWfkvox8cQStJZva3seIbDfDAOkfGSbsITPF7swhhBRTdIu3IF
G8unOc05OPL9HxlKlLZmX1TIclH1AuCBm4lMs2k0bELrCvPOaUILpbH00jo6fSxW
+RkRe2e9onWCyIVM62T3/yEdEbHdsxTuDV/kkryf6DNL+jDO9azY6UnePpmWdWr0
sGcp2KYo2uJbYrcH1xCrBLuzWzdJ4nMU+CLMpHvc2X1DE1nfZV8J3jcnK4kGizo=
=1+Ge
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Oct_2010_11_29_04_+1100_fW4QsOLKUqgp1zYU--
