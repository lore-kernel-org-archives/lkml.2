Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab0JRO4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:56:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55943 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab0JRO4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:56:34 -0400
Date: Mon, 18 Oct 2010 16:56:20 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: zhangyd <zhangyd6@gmail.com>
Cc: dwmw2@infradead.org, Artem.Bityutskiy@nokia.com, ladis@linux-mips.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: chips: Add SST38VF640x NOR-flashes
Message-ID: <20101018145620.GA22538@pengutronix.de>
References: <1287454010-2718-1-git-send-email-zhangyd6@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <1287454010-2718-1-git-send-email-zhangyd6@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 18, 2010 at 10:06:50PM -0400, zhangyd wrote:
> Du to the wrong sector size description(The actual sector size is
> 8KBytes/sector, but the reporting size is 64KBytes/sector),you can get
> the wrong size of the memory. So they should be moved to the jedec_probe.
>=20
> Signed-off-by: yidong zhang<zhangyd6@gmail.com>

NACK as long as Guillaume has not finished updating the SST-support for CFI=
=2E He
said he is working on this at the moment, let's give him a chance to finish=
 :)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAky8YBQACgkQD27XaX1/VRtz6ACeMLJleCWrFki71rpj+0ELYala
A8sAnA6Frg62shANhZn7xEW1196rHBxr
=P1xd
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
