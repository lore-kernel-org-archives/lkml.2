Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0L2Xvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:51:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50698 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab0L2Xvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:51:38 -0500
Date: Thu, 30 Dec 2010 10:51:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pinglinux@gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (input
 tree related)
Message-Id: <20101230105130.5d27a82b.sfr@canb.auug.org.au>
In-Reply-To: <20101229023457.GA4206@core.coreip.homeip.net>
References: <20101229125129.d48fb6fc.sfr@canb.auug.org.au>
	<20101229023457.GA4206@core.coreip.homeip.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Dec_2010_10_51_30_+1100_TYfNkWvLShv5dawP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Dec_2010_10_51_30_+1100_TYfNkWvLShv5dawP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

On Tue, 28 Dec 2010 18:34:58 -0800 Dmitry Torokhov <dmitry.torokhov@gmail.c=
om> wrote:
>
> On Wed, Dec 29, 2010 at 12:51:29PM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >=20
> > drivers/input/touchscreen/wacom_w8001.c: In function 'w8001_setup':
> > drivers/input/touchscreen/wacom_w8001.c:287: error: implicit declaratio=
n of function 'mdelay'
> >=20
> > Caused by commit b8fe15cb1b435928f9967d660e925fe7afb32787 ("Input:
> > wacom_w8001 - support pen or touch only devices").  See Rule 1 in
> > Documentation/SubmitChecklist.
> >=20
> > I have reverted that commit for today.
>=20
> Thank you Stephen, I'll fix this up in my tree.

I note that this commit has been redone in your tree (as commit
11a862ed9f04558e222fa15a5fbd76698fed11ff) but there have been no changes
to it at all (except the commit date).

I have reverted that commit from today's linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Dec_2010_10_51_30_+1100_TYfNkWvLShv5dawP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEbBAEBAgAGBQJNG8mCAAoJEDMEi1NhKgbsDT4H+J1AvUYDmIp7PPTRZz8p8fCd
csHb5LpEdkwtgzieOx1pfs3Yl+YO/1XpQk+7edRBDme1zmDWrE/4iBdr1No45ADi
1TCkkxNLC4bhFv5JOefkN9vYkJBJmgWddls2YS1IPc9Eop6Gd1gVGO+gcakiat3J
zauoSI5CW1x6rbAb55wglXY9zZGdIy9cRt5IImxMbKZUeBl1x5nAKxfK/YrbaAa5
cFin4NnJz/PLUidqNcTEEpxIVzzQi4/wvgclu69FpBl6GMDQd//yJaC10redG7Qk
sP+vHITmW32ZTizxHccCPv+I+TPSbzNKGPzOQjb9GndgrdyYbZoyEfAFwBZ2gQ==
=5GyO
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Dec_2010_10_51_30_+1100_TYfNkWvLShv5dawP--
