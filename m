Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab1IIKFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 06:05:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37672 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab1IIKFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 06:05:41 -0400
Date: Fri, 9 Sep 2011 12:05:40 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] ALSA: aoa: Remove obsolete cleanup for clientdata
Message-ID: <20110909100540.GJ1912@pengutronix.de>
References: <1315561784.2831.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bWEb1MG/o7IKOlQF"
Content-Disposition: inline
In-Reply-To: <1315561784.2831.0.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bWEb1MG/o7IKOlQF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 09, 2011 at 05:49:44PM +0800, Axel Lin wrote:
> The i2c core will clear the clientdata pointer automatically.
> We don't have to set the `data' field to NULL in remove() or
> if probe() failed anymore.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--bWEb1MG/o7IKOlQF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5p5PQACgkQD27XaX1/VRtV2wCeMwUZIlQBEnfmsfKZgbz+6H/a
ipQAn0ivB/xLvRMgbtLBSZcIQcnH3bWz
=dfHY
-----END PGP SIGNATURE-----

--bWEb1MG/o7IKOlQF--
