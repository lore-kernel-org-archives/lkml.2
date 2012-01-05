Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab2AEVj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:39:29 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:36068 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab2AEVj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:39:27 -0500
Date: Fri, 6 Jan 2012 08:39:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] use generic pci_iomap on all architectures
Message-Id: <20120106083916.9588034bde22a6803e327aa9@canb.auug.org.au>
In-Reply-To: <20120106083141.9c14a8d2d09539c6a6c0db75@canb.auug.org.au>
References: <20120105145836.GA2751@redhat.com>
	<20120106083141.9c14a8d2d09539c6a6c0db75@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_08_39_16_+1100_fWTFNI2h7.fvc2OV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_08_39_16_+1100_fWTFNI2h7.fvc2OV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

On Fri, 6 Jan 2012 08:31:41 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> [I am not *just* picking on you - others do this as well ...]
>=20
> On Thu, 5 Jan 2012 16:58:36 +0200 "Michael S. Tsirkin" <mst@redhat.com> w=
rote:
> >
> > Linus, please pull the following changes for 3.3, thanks a lot!
> >=20
> > These changes have been on linux-next for a while now.
> > They touch a lot of arches and have interdependencies, so merging
> > separately seems to make sense, I think.
> >=20
> > The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b=
2610:
> >=20
> >   Linux 3.2 (2012-01-04 15:55:44 -0800)
>=20
> So why have you rebased this?  All this stuff in in linux-next based on
> v3.2-rc3 since December 5 (and that version will be in linux-next today
> as well unless you update your linux-next branch in the next sort while).

OK, seems I was mistaken (and mislead by the above.  Your for-linus tag
just tags what is already in linux-next and based on v3.2-rc3 ...

Sorry about that.

So why does you pull request refer to "commit
805a6af8dba5dfdd35ec35dc52ec0122400b2610", I wonder?  Is that just what
"git request-pull" produced?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Jan_2012_08_39_16_+1100_fWTFNI2h7.fvc2OV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBhiEAAoJEECxmPOUX5FEVAMP/1HQGJhwIPRdiVQeL2nA0SU1
k/w0hbMzBbosnQr/aOyTgePHVOikWZXXtCBZK1Crs9moygHsZOeSf21xlmc8UMeT
63lCIN8jBDTJhkzIYjQEuWedlRb6LPUR8Ae8mAL7/1bEGIqLP4qgqx1/DonAGQuO
bXJDmEgECElheYi+Dl1QY7qMmrFjefaT2dPOE0xi6ifJ4UI3N3VEfTNiL/5KPGtv
N0mXrIp0Jj/3qof8sG0GiyBgbDuAizV9EGcTssH8d3btnptyJga8LfO8kEci7+2M
OSdzoIadSetw3995jxWLFp0IKAX98sRjUDuKABmPJqH9BWkLFsGp6mtPP+O3KiLm
j41DMZ3k9phEK8kkY9XXtp1A7RGZxyitEwwVi5vShfoTx/X5YH0Mu4p15BQtkiL/
tIwL5U/nc0c2SnZDSyj0bKHa8CdmkIhQ0ueOr7pcaw33BqsXF1JhZniai98uTg5G
JkKBOrI3Pod8szfwiGCt/KYJyHliYozAKGRK9Db9r7VuYmyejCoATFNQsI1Q2pBJ
0pcpQglT0dkcb0nLjkvpwnnHRY6asALtHMxruFIJp2ppWzhbxZFXuXhPq12TW1AG
2c1H+/mDsbdPYRxamUHbtY2lZnkf9zzLYu/BFObOptqL6Gl7W5/e7AnvbjFx4WzT
ibGvurE9AprvqfbrzA4G
=FdN5
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_08_39_16_+1100_fWTFNI2h7.fvc2OV--
