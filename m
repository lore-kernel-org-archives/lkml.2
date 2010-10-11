Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab0JKIdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:33:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54096 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab0JKIdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:33:45 -0400
Date: Mon, 11 Oct 2010 19:33:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Dimitris Papastamos'" <dp@opensource.wolfsonmicro.com>
Subject: Re: linux-next: manual merge of the sound-asoc tree with the s5p
 tree
Message-Id: <20101011193336.835d9f78.sfr@canb.auug.org.au>
In-Reply-To: <009201cb6916$a9441740$fbcc45c0$%kim@samsung.com>
References: <20101011133519.cf4fcaa8.sfr@canb.auug.org.au>
	<009201cb6916$a9441740$fbcc45c0$%kim@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__11_Oct_2010_19_33_36_+1100_73iDKWib.=XHZo5N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Oct_2010_19_33_36_+1100_73iDKWib.=XHZo5N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kgene,

On Mon, 11 Oct 2010 16:33:48 +0900 Kukjin Kim <kgene.kim@samsung.com> wrote:
>
> > Today's linux-next merge of the sound-asoc tree got a conflict in
> > arch/arm/mach-s3c64xx/dev-audio.c between commit
> > f08269d850e4ee0cd028cf5279cc08259d0469df ("ARM: S3C64XX: Change to using
> > s3c_gpio_cfgpin_range()") from the s5p tree and commit
> > e4b6b74ffd32d114227a5dcfe814e2cecd80554b ("ARM: S3C64XX: Fix fallthrough
> > bug in i2sv3 gpio configuration, improve logging") from the sound-asoc
> > tree.
> >=20
> Hmm...how can/should I handle for it?

Don't worry about it.  It is trivial and both I and Linus can take care
of it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__11_Oct_2010_19_33_36_+1100_73iDKWib.=XHZo5N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMssvgAAoJEDMEi1NhKgbsBt4H/0FP6xYppD5XfVQhEUeY/AXF
tCCrRrKYTkpWF7fsaid10gwXosk0uEt6sMXYtZDGLgOK/WTJ5ZL0KI+EIxGlxMXI
7JtO4Hlcgtt71EnQAllarvAxtk/uX7FDOt1HTeZdgN25hDkAg48grk+Zq2KGanRo
BlkQgrnRfJvXz7oRC22PU6WDPtBotosDFhu/MCCHP/I5WHGZcX/cVGpcHsOsq74e
GxxuRoqe7ltJjc/qHHENOqoxIFLUKdgVH+wIlGnlH1CHklbKrSjFZiHO0uzQMs1S
CG/gE9u9D8bzrVNnlELHsGrQdg6PkMzGgZOBSItVfDEoOoccsOCjU3BslDMUxsI=
=cLvY
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Oct_2010_19_33_36_+1100_73iDKWib.=XHZo5N--
