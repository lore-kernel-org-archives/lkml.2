Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0E0Pe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:34:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52196 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891Ab0E0PeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:34:24 -0400
Date: Fri, 28 May 2010 01:34:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, matt mooney <mfm@muteddisk.com>,
       Kirill Smelkov <kirr@mns.spb.ru>
Subject: Re: linux-next: manual merge of the kbuild tree with the kernel-doc
 tree
Message-Id: <20100528013402.a350a3bd.sfr@canb.auug.org.au>
In-Reply-To: <4BFE7EAC.9090408@suse.cz>
References: <20100526115346.da5a02aa.sfr@canb.auug.org.au>
	<4BFD42A6.6060206@oracle.com>
	<20100527025020.da0c1bb7.sfr@canb.auug.org.au>
	<20100526095606.beed820e.randy.dunlap@oracle.com>
	<20100527090923.c17a7ed4.sfr@canb.auug.org.au>
	<4BFDB60B.50106@oracle.com>
	<20100527110357.f295d4ef.sfr@canb.auug.org.au>
	<4BFE7EAC.9090408@suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_May_2010_01_34_02_+1000_sqxwlP44PrCRRhVK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_May_2010_01_34_02_+1000_sqxwlP44PrCRRhVK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Thu, 27 May 2010 16:16:12 +0200 Michal Marek <mmarek@suse.cz> wrote:
>
> On 27.5.2010 03:03, Stephen Rothwell wrote:
> > Hi Randy,
> >=20
> > On Wed, 26 May 2010 17:00:11 -0700 Randy Dunlap <randy.dunlap@oracle.co=
m> wrote:
> >> uh oh.  OK, thanks, I'll restore them.
> >=20
> > Thanks.  I picked them up.
>=20
> I reverted part of the kbuild patch so that the two trees merge cleanly
> again.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_May_2010_01_34_02_+1000_sqxwlP44PrCRRhVK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv+kOoACgkQjjKRsyhoI8zY0wCfUXJDC51668zuNM4j97m54l2c
0OsAnRtqNLoPwYMdS5+uv9HCtNABbRno
=0I4X
-----END PGP SIGNATURE-----

--Signature=_Fri__28_May_2010_01_34_02_+1000_sqxwlP44PrCRRhVK--
