Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0HVS2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 14:28:17 -0400
Received: from vps.mortis.eu ([79.99.135.181]:53410 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0HVS2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 14:28:13 -0400
Date: Sun, 22 Aug 2010 20:28:06 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Laurens Leemans <laurens@signips.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Jean Delvare <khali@linux-fr.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] hwmon: f71882fg: Add support for the Fintek F71808E
Message-ID: <20100822182806.GJ6384@salidar.me.mortis.eu>
References: <20100801132226.GE3711@salidar.me.mortis.eu>
 <1280669402-31213-1-git-send-email-me@mortis.eu>
 <4C5950B6.5010503@redhat.com>
 <20100810191117.GN14382@salidar.me.mortis.eu>
 <4C651800.6030804@redhat.com>
 <20100818112418.a25a50d6.akpm@linux-foundation.org>
 <4C7166B6.1080505@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="54ZiyWcDhi/7bWb8"
Content-Disposition: inline
In-Reply-To: <4C7166B6.1080505@redhat.com>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--54ZiyWcDhi/7bWb8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 22, 2010 at 08:04:38PM +0200, Hans de Goede wrote:
> p.s.
>=20
> I've already seen mails that you've dropped this patch from -mm, does that
> mean it thas been removed from mainly too ? If not please remove it from
> mainline / ask Linus to remove it.

Checking .../torvalds/linux-2.6.git you can see it's been reverted in
mainline (see commit f2e41e9).

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--54ZiyWcDhi/7bWb8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxxbDYACgkQZBYm/87l50IXmwCgxh7qivJuTy9E99vbQ96HutJJ
PJMAn214XYG+5pFJN93MIHIa0u8De5ic
=nsfN
-----END PGP SIGNATURE-----

--54ZiyWcDhi/7bWb8--
