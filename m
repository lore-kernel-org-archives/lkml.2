Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1BGPT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 10:19:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43337 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab1BGPT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 10:19:26 -0500
Date: Tue, 8 Feb 2011 02:19:16 +1100
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
Message-Id: <20110208021916.68b33b37.sfr@canb.auug.org.au>
In-Reply-To: <20110208021045.699654ca.sfr@canb.auug.org.au>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20110208011324.d5371c4c.sfr@canb.auug.org.au>
	<20110207141829.GK10564@opensource.wolfsonmicro.com>
	<20110208014432.2c9288e4.sfr@canb.auug.org.au>
	<20110207145031.GL10564@opensource.wolfsonmicro.com>
	<AANLkTikw7j5Q7CGZK=Xbcgubt9LYBGiXf01wQ4nbg8NR@mail.gmail.com>
	<20110208021045.699654ca.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Feb_2011_02_19_16_+1100_RU6ztOlK9T1etgNE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Feb_2011_02_19_16_+1100_RU6ztOlK9T1etgNE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Feb 2011 02:10:45 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Mon, 7 Feb 2011 16:00:55 +0100 Geert Uytterhoeven <geert@linux-m68k.or=
g> wrote:
> >
> > $ git grep "CONFIG_PM is not set"
> > 7cf3d73b4360e91b14326632ab1aeda4cb26308d^ -- arch/ | wc -l
> > 256
> > $
> >=20
> > 7cf3d73b4360e91b14326632ab1aeda4cb26308d is the commit that introduced
> > savedefconfig, so that's a safe revision with untrimmed defconfigs.
>=20
> Yeah, but we can't tell if CONFIG_PM is turned off on purpose in those
> defconfigs, or just off because noone explicitly turned it on.

At least some of the powerpc defconfigs were added with CONFIG_PM
disabled.  I assume that was on purpose (though it may not have been).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Feb_2011_02_19_16_+1100_RU6ztOlK9T1etgNE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNUA10AAoJEDMEi1NhKgbsKAIIAINqFv/+1ZVtMUG2Vuu0xZ60
VM8bA3qsw6va+NbUFGaw5nYcElIy0LLkHj0xt/6/qCa4fwgpSu+EI0cqinJLlziA
nqtOuuSZKVnAi6tP5pD0jX4XD69c67vlMVDrEkw3fCx9lc/bIIaQZsYHLEP2EWP+
pX6WiKPvHkUBcWZpCF0+kADQKr6lcOLLGgQYP4EqWXBXwj4qM09UoTc4L9FANYiT
pfJNSUkaVKrhG/5LNm3HFcCUYEK5e+sFesM6yi1CDe4PZnexkGgZk5cdAl9Sr3TW
021GIELnVa8yVO2xlfx9aBR0srG7WkTCiJm0dZuLlQC9CJ+fPNrKCxth4YzRQNA=
=XWKe
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Feb_2011_02_19_16_+1100_RU6ztOlK9T1etgNE--
