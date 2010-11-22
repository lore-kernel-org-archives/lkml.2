Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab0KVAsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:48:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60937 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab0KVAsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:48:11 -0500
Date: Mon, 22 Nov 2010 11:48:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: randy.dunlap@oracle.com, catalin.marinas@arm.com,
        linux-kbuild@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, lacombar@gmail.com,
        xiyou.wangcong@gmail.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Revert
 "kconfig: Temporarily disable dependency warnings"
Message-Id: <20101122114801.2eee4c4d.sfr@canb.auug.org.au>
In-Reply-To: <20101029113731.5c7c54b9.sfr@canb.auug.org.au>
References: <20101011145930.11fe570c.randy.dunlap@oracle.com>
	<1286889586-13483-1-git-send-email-mmarek@suse.cz>
	<20101029113731.5c7c54b9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Nov_2010_11_48_01_+1100_QpA0UhRlZBHf2=LP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Nov_2010_11_48_01_+1100_QpA0UhRlZBHf2=LP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 29 Oct 2010 11:37:31 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 12 Oct 2010 15:19:46 +0200 Michal Marek <mmarek@suse.cz> wrote:
> >
> > This reverts commit 71ebc01, which was a 2.6.36-only stopgap solution.
>=20
> I was hoping that we would have the number of these warnings down to
> something reasonable before this revert made it into Linus' tree ...
>=20
> I guess fixing the V4L stuff will become a bit more urgent, now :-)

Is there any chance that the V4L kconfig warnings will be fixed?  It is
quite irritating for those of us who do allmodconfig (and allyesconfig)
builds ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Nov_2010_11_48_01_+1100_QpA0UhRlZBHf2=LP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM6b3BAAoJEDMEi1NhKgbsXXQH/0d2JlNkYZjGGJcmTedyZ74Y
ozEWGjHSDKdRp4eBwIZHMqzeSmDFhjviUeDPe49bVYsvg+bqJiPpNcpOK3ZAybIi
6LdKaKl/w9nsLiCZoRCA0qSI6dEQIw4Bxy0QBbl+KrDjlEHz1d3SyNNpls7Xf0qw
la+s8S65/sS46m9oyTcexDHkF4KjhqfAnl7CMhfouF2hf02EuLIp/u8gMqnqEaTi
kY4K5XxKP4uKSp8BFpXPEiTrsFRaIIvSkUjsaS0o/tYn0sGNiCEdhx7FzSnjbX9H
QvPyuL0T5xSshWJZeTtXGmiRZrAtqQcrF3/KXsOpAzfU3xGPFuq7dRte1MVmSgQ=
=P9YP
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Nov_2010_11_48_01_+1100_QpA0UhRlZBHf2=LP--
