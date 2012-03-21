Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab2CUItG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 04:49:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:49250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2CUItC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 04:49:02 -0400
Date: Wed, 21 Mar 2012 09:48:56 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bernhard Walle <bernhard@bwalle.de>, Bernhard Walle <walle@corscience.de>,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] mfd: Add TWL4030 PWM driver
Message-ID: <20120321084856.GA17472@avionic-0098.mockup.avionic-design.de>
References: <1332262083-9375-1-git-send-email-walle@corscience.de>
 <201203202202.12060.arnd@arndb.de>
 <4F697201.1090206@bwalle.de>
 <201203210839.06258.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <201203210839.06258.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:O/m8mVbw43paPx6H2BHDAj3o9Jr5coU++u8MOvkTBIs
 b9WCz3lTgpj1hm/dgMaDHlEW1kUiyqD8i3gi6kbG857xOB/h4g
 9yem3M40nkGQTDF6o5hcQ6FOj0oDaK2+LOVg0LGCBJmBCzJ+Uk
 Ngs+ZPFsA5b/zc+IAu1QkHvXYoQNbQ6GUexYG5YieypqGaGj/A
 qlLng7cZXgB7oidaPZhPZynbpvdKq187CpBs2jjwaFxhfmb33L
 RsAWL8n25KuI5C1dj/0AUhuUjz0TdKGDWYwmZNvVEi62irpS9/
 lVtLfbytq443v8MoRtN5P4Lda9/CVBQ60yM5tyxUKB0KOsADo8
 R0KXMx+vEJbvOBrCa+W7cBTgQkxSV+3kX4HyXsZku7RJavS7sX
 BgEcTiEvP9nUQh7fh5+Y9J4BJaiQXOPLNo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Arnd Bergmann wrote:
> On Wednesday 21 March 2012, Bernhard Walle wrote:
> > Am 20.03.12 23:02, schrieb Arnd Bergmann:
> > > On Tuesday 20 March 2012, Bernhard Walle wrote:
> > >>
> > >> This PWM driver uses the PWM of the TWL4030. The driver for the TWL6=
030
> > >> PWM has been used as mode, but the PWM registers are different.
> > >>
> > >> The driver can be used and has been tested in conjunction with
> > >> pwm-backlight to control a backlight LED of a LCD touch screen.
> > >>
> > >> Signed-off-by: Bernhard Walle <walle@corscience.de>
> > >=20
> > > Since it's too late for v3.4 now and we will get a new pwm
> > > subsystem in v3.5, I suggest you change the driver to work
> > > register with that subsystem instead of just using the old
> > > header file. Note that drivers/mfd is not really the right
> > > place anyway, because this is not a multifunction driver but
> > > just one device driver that happens to be a slave of an mfd.
> >=20
> > Does that new subsystem already exist in some tree?
> =20
> Thierry Reding has been busily posting patches, so he probably has
> one that you can use, but I couldn't find it now.

I don't have a public tree anywhere. Does anyone have a recommendation where
I could set one up? github or gitorious are the first to come to my mind.

Thierry

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9plfgACgkQZ+BJyKLjJp+oVwCgpj2ZSzvNTRmhsVW+1cmO07ek
4oEAoIPHh/23A5nbbK95PetCskZVUSN+
=gJls
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
