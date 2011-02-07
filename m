Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1BGPK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:10:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36121 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab1BGPK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:10:57 -0500
Date: Tue, 8 Feb 2011 02:10:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Message-Id: <20110208021045.699654ca.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTikw7j5Q7CGZK=Xbcgubt9LYBGiXf01wQ4nbg8NR@mail.gmail.com>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20110208011324.d5371c4c.sfr@canb.auug.org.au>
	<20110207141829.GK10564@opensource.wolfsonmicro.com>
	<20110208014432.2c9288e4.sfr@canb.auug.org.au>
	<20110207145031.GL10564@opensource.wolfsonmicro.com>
	<AANLkTikw7j5Q7CGZK=Xbcgubt9LYBGiXf01wQ4nbg8NR@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Feb_2011_02_10_45_+1100_r4fpwZf8VNv_J/_S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Feb_2011_02_10_45_+1100_r4fpwZf8VNv_J/_S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert,

On Mon, 7 Feb 2011 16:00:55 +0100 Geert Uytterhoeven <geert@linux-m68k.org>=
 wrote:
>
> $ git grep "CONFIG_PM is not set"
> 7cf3d73b4360e91b14326632ab1aeda4cb26308d^ -- arch/ | wc -l
> 256
> $
>=20
> 7cf3d73b4360e91b14326632ab1aeda4cb26308d is the commit that introduced
> savedefconfig, so that's a safe revision with untrimmed defconfigs.

Yeah, but we can't tell if CONFIG_PM is turned off on purpose in those
defconfigs, or just off because noone explicitly turned it on.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Feb_2011_02_10_45_+1100_r4fpwZf8VNv_J/_S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNUAt1AAoJEDMEi1NhKgbsHQMH/i/hm9i9pisjmv3T05ZtS1jd
HgYORtkriKnCr5bl98Tleo9nzTmyGrY0d0TcWHsLcsRrtM89RFAatikMApZwxe47
hI9kf9rdFV7B4w7FhubvnB3A3rEgiC3URdfP2hUv1K9y37c63HPTRinXNL6wkvG3
yhiCGFHfllqZxO5xmP5tJcHvjzAShoDHnFK12nvYZq0jMgbF65oEycw+wZpKvCqH
nR8L373rsCOEG4Si06SxOvUbY30OvQOvWnC5fsY1/NTTi/2R+z690leNr9tEMxbN
tHv1OjvxO4oim3p9nGSsKJJqSb8aJb2XHzaXo9A+X73xzGVSHBf/PzDrD5cyzbQ=
=Wf9n
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Feb_2011_02_10_45_+1100_r4fpwZf8VNv_J/_S--
