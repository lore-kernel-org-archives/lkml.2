Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab0GLEPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 00:15:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59708 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab0GLEPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 00:15:53 -0400
Date: Mon, 12 Jul 2010 14:15:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amerigo Wang <amwang@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: linux-next: manual merge of the trivial tree with the v4l-dvb
 tree
Message-Id: <20100712141546.ae508a32.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LNX.2.00.1007112241280.4741@pobox.suse.cz>
References: <20100706152529.371c7800.sfr@canb.auug.org.au>
	<alpine.LNX.2.00.1007112241280.4741@pobox.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__12_Jul_2010_14_15_46_+1000_9AZsh/02rrt2/IDM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Jul_2010_14_15_46_+1000_9AZsh/02rrt2/IDM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

On Sun, 11 Jul 2010 22:41:48 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wro=
te:
>
> thanks for reporting it, I have reverted the drivers/media/video/ov511.c=
=20
> hunk.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Jul_2010_14_15_46_+1000_9AZsh/02rrt2/IDM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMOpbyAAoJEDMEi1NhKgbsaXQIAJoPluxZX1SVz12dBm9AdmUm
i5m0pLpFOQk/fMoGv1RJWRHGm/zJMXaP/K1547l7jrol/nbPk2NftFZ8CqJ9hobo
abxbiF45ynXAZXXjesc4fpr3uHLm6YTCPo9w+tPK3kMeWRT8rK2W+6YrhR7aRCiU
5TfSyvbvKKpEdBqxLoA2T8vwPH3x8U2SGg6z2AmKjw6wG16IhRE8h4vq76WeGby+
6hcwwVAaqY7Eqgc4KsmflLgJBrtFKFs499lnGcbrjbVkrxNpCQUwHqPUPZmIsaLj
d9vhlqFP2ngq9GTfPnNCVAn1ziE5F+N6t0P2UrMCTQNHUB4uOuXzPfW036P+a24=
=g1r8
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Jul_2010_14_15_46_+1000_9AZsh/02rrt2/IDM--
