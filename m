Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2HRRg0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:36:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42619 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab2HRRgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:36:23 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 03/11] blackfin: defconfig: Remove CONFIG_MISC_DEVICES
Date: Sat, 18 Aug 2012 13:36:21 -0400
User-Agent: KMail/1.13.7 (Linux/3.5.0; KDE/4.6.5; x86_64; ; )
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        uclinux-dist-devel@blackfin.uclinux.org
References: <1345307035-3545-1-git-send-email-festevam@gmail.com> <1345307035-3545-3-git-send-email-festevam@gmail.com>
In-Reply-To: <1345307035-3545-3-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8992123.02eE095VI4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201208181336.23682.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8992123.02eE095VI4
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 18 August 2012 12:23:47 Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> commit 7c5763 (drivers:misc: Remove MISC_DEVICES config option) removed
> CONFIG_MISC_DEVICES option, so remove the occurrences from the config fil=
es
> as well

Acked-by: Mike Frysinger <vapier@gentoo.org>
=2Dmike

--nextPart8992123.02eE095VI4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQL9KXAAoJEEFjO5/oN/WBVIgQAJh+fvBeU2W2Lu18cJecJtpR
I/u1k92dtR4DSheeCtJ/EOoHBsTIjQCuHNZehJEMdBzqadgceLnWSD6j4e+qvwUU
3xrsWxSZFANSgHK4EJLNK5phHOwDB16OgIiorKV2L2h1ANcCVVK+t1VbtjOWDwjL
Wd4+8WhVDRRnPwoBoGKB5tiXq2Z0sar4I0XKG8YQT0wDXeMaqHft7V4I8zwukMQ0
1FO0vCiJiO3xaXBIEHMgpH50TmpIQ6tVLedXSkg5KtPWajMoCHSW57CLx2CQkwae
o1a6PSIO6L/HBG6kFM0tCsaucFfmvrHQMgbv9A3tbsFPlqhyvPcBT3dFBuiX9v4e
jvgIiSuO8Gb2KS4pAU8bFGSEn7nDSV0FTqJ8r4EBz5NLhsGjkZI4x85pLPKl6rEB
/gcU/+I5YjFDmnZ0qKfr70136EYY9ACxnVj6zHoqhPnHsTVqDPlaxaWXq2ifH8GL
m359gyoNKakdAWvPhwwk3R2hbvN5hmT0Xh3uOTk5YDLEa7xE+RuCgF5CVLfNinfx
QCenCFAJtnq4w46gBOCxFW//ixBiDG8f/N4KVhKniQrYuZZr6vVnxJ/LhO2Vu/nO
i2bSAqCFtIsRA/ZNRaQ6qJ3fEkhdfvtLzgKT3gIr645Oi+f8giuKYcLP1eWTBt6Z
hyItBXpHn/Iu/Uj6gan4
=ZnKZ
-----END PGP SIGNATURE-----

--nextPart8992123.02eE095VI4--
