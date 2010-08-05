Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab0HEAbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 20:31:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43852 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759233Ab0HEAaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 20:30:55 -0400
Date: Thu, 5 Aug 2010 10:30:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: inux-kernel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 4, add a new git tree please?
Message-Id: <20100805103050.3c201cdd.sfr@canb.auug.org.au>
In-Reply-To: <20100804222350.GA2220@phenom.dumpdata.com>
References: <20100804151035.14678528.sfr@canb.auug.org.au>
	<20100804222350.GA2220@phenom.dumpdata.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__5_Aug_2010_10_30_50_+1000_/yV4MGOlC85o3oCm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Aug_2010_10_30_50_+1000_/yV4MGOlC85o3oCm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Wed, 4 Aug 2010 18:23:50 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracle=
.com> wrote:
>
> I was wondering if you could add in your awesome tool this extra git
> tree:
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
>=20
> (the head of it please)
>=20
> It has this patchset: http://lkml.org/lkml/2010/7/27/246
>=20
> that I have been carrying in=20
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git
>=20
> but I realized it should probably not be in the swiotlb and was hence
> wondering if you would be OK adding in that extra git tree?

Added from today, but only because everything in it is already in
linux-next from your other tree.  I assume that you will remove this stuff
from there.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Thu__5_Aug_2010_10_30_50_+1000_/yV4MGOlC85o3oCm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMWgY6AAoJEDMEi1NhKgbsRp8H+gKleEj9YuyGF7yCuqZoUp3m
x8gRtaTC509xOQRGWvQXrB8z0sOs6FeJknHvxt79z91rI0MWOL39D2vf5ZQG3+D+
9CFXrsKbr0bKJ0KakHvgWD+vo35cAWWHGMbIMqQPWZzL2MDddQRXNTMB2Pp7oLQR
AbV3MP+RJ+ZvSDD4HWRb5dN4gYppJBWlkbI9CSf6Y3+sKO9CmDAeGGdCaNOLvpBl
DCp+W3zr3Tk4SUyjPulmikiFK22vYa8gKY3Dus68wvoiELZnQe67QY+hExey8apu
lzTbx+45gSEk+1DASHe17kqfThFGGqY6jYNHcyRaSqLDXOebyGr6b3ajqFxBSi8=
=Ghr4
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Aug_2010_10_30_50_+1000_/yV4MGOlC85o3oCm--
