Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab2GAA1Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 20:27:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42302 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2GAA1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 20:27:13 -0400
Date: Sun, 1 Jul 2012 10:27:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?UTF-8?B?IkVyaWMgQsOpbmFyZCI=?= <eric@eukrea.com>
Subject: Re: linux-next: manual merge of the pwm tree with the s5p tree
Message-Id: <20120701102702.59edea72baa820cd3ac7c636@canb.auug.org.au>
In-Reply-To: <20120630195847.GA24500@avionic-0098.mockup.avionic-design.de>
References: <20120629164946.97497f3eb94a5d4fbcc6b448@canb.auug.org.au>
	<20120630195847.GA24500@avionic-0098.mockup.avionic-design.de>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__1_Jul_2012_10_27_02_+1000_RxGcWGGcpI/u4=6G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__1_Jul_2012_10_27_02_+1000_RxGcWGGcpI/u4=6G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

On Sat, 30 Jun 2012 21:58:47 +0200 Thierry Reding <thierry.reding@avionic-d=
esign.de> wrote:
>
> On Fri, Jun 29, 2012 at 04:49:46PM +1000, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the pwm tree got a conflict in
> > arch/arm/plat-samsung/Makefile between commit 65ab16fd385f ("ARM: EXYNO=
S:
> > Remove leftovers of the Samsung specific power domain control") from the
> > s5p tree and commit 2663e766c56a ("ARM Samsung: Move s3c pwm driver to
> > pwm framework") from the pwm tree.
> >=20
> > Just context changes. I fixed it up (see below) and can carry the fix as
> > necessary.
>=20
> I wonder, when these changes are merged by Linus during the merge
> window, does he have to resolve these conflicts again or does he get the
> resolutions from you? Or should I rather base the PWM tree on top of the
> corresponding EXYNOS changes to sidestep the issue?

He will resolve the merge conflicts again but he is good at that.  You do
not need to do anything about these simple conflicts.  Rebasing your tree
would effectively throw away any testing you had done and possibly
introduce more problems into your tree from the other changes.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__1_Jul_2012_10_27_02_+1000_RxGcWGGcpI/u4=6G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP75lWAAoJEECxmPOUX5FEiBsP/ikrLx+kgCTrZdyUOi4h/KJ+
SXQdj9CsJhRCffciZrH2ct4RQJ75l8ryxh8z6ya18JN7itj0tmwuqKcgdx0tBtzZ
IV7WeXynKBXJ6Oa33KgDUQJGwaTcx3/OulB6MK7trdSpwYMaiVNNVhAtY/GT931v
+IrT//t3AdIfhSuHFPF71HAm10Odwf8AbRkqRH288MNK2FWc3+phjte0XNcryEvS
jOWPEG2IxOCHAu+hIOBElWHFhYYG2cHCveejEodAEF4+X6ItZDOYw35kqjJ7ZlWm
PISvNzhLUS24ZTk1fBcnmKtfAg6dbGl9kjNT1hY7fiKAUO6NzeMHppojx48itcbN
2OFRhHz0GDc4w39kwk2gPofH8j123iizhTS/d/uuQIegL1rwfBLHVX6Fgn1E9Pem
PaTlw8XmAeaAC2iEDaOSGBRmU6iJGafE7KOm3lhFd2KonD8e4fO/U8t5KpT+B9R7
bvS9CHzbsBTNyJG8yEHDT96pbWhELfw8X3z1HMEEl4Kl6wgaxbUknCY7lLzDkAz5
x4V/A7kjpu2O20e/JOGulP3VXxmk7x5uOv2dm71OiCopNwCKRmI0udEguRuGTqm1
C/TJwJHxN8gcfhvewARrQlJna9NiegUEgcc5ubS0ZNJZjofF488Jw7DQ9u99TAR/
Lc3jQ00BKrUUGmocweYG
=Vl4j
-----END PGP SIGNATURE-----

--Signature=_Sun__1_Jul_2012_10_27_02_+1000_RxGcWGGcpI/u4=6G--
