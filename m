Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab1CaXz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 19:55:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45727 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1CaXzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 19:55:55 -0400
Date: Fri, 1 Apr 2011 10:55:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: linux-next: manual merge of the gfs2 tree with Linus' tree
Message-Id: <20110401105545.b2873be4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_Apr_2011_10_55_45_+1100_sHo0oCUyvPFOTSvF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Apr_2011_10_55_45_+1100_sHo0oCUyvPFOTSvF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

Today's linux-next merge of the gfs2 tree got a conflict in fs/gfs2/log.c
between commit 721a9602e660 ("block: kill off REQ_UNPLUG") from Linus'
tree and commit 7ef2a4f51303 ("GFS2: Use filemap_fdatawrite() to write
back the AIL") from the gfs2 tree.

The former removed some of the code modified by the latter, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__1_Apr_2011_10_55_45_+1100_sHo0oCUyvPFOTSvF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNlRSBAAoJEDMEi1NhKgbsg+IH/jXg1+wEfsJeOuXdKpJUG+vA
uvhJ/NfieOFDksnwwzuPdVaCaCJEwwf1CV3F+rtVmx97mGKPnp2t7YVFBNELlHVr
XmFZniVGYY5sJhPcbYMxtfXPA6pP6K36eZV3jkEVILVmFTELliNDLM6YuUFe9FAG
sC4bd3epGJmp5aDTrhpoXZdgRE5Z7Q2PxOlV8qAdXilqBfzIino41xWPLcbkWq29
02u5Vhy4w2M8TCMfH4XyQfrOJKTIvcGKtMmYWma8Fm8E8Z0/vwuTCfKVZRJdCIX/
R9wEtgrfSay6bU/pn+c1ivXRg+fgqT1/0dlxjY/kWx1k+4GyxQrg1JSVbpLiXDk=
=iS92
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Apr_2011_10_55_45_+1100_sHo0oCUyvPFOTSvF--
