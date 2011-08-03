Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1HCKgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:36:13 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:54361 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872Ab1HCKgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:36:09 -0400
Date: Wed, 3 Aug 2011 13:36:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@stericsson.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        users@igloocommunity.org, Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH] usb: musb: ux500: set dma config for both src and dst
Message-ID: <20110803103603.GE11080@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1312299219-9562-1-git-send-email-per.forlin@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="so9zsI5B81VjUb/o"
Content-Disposition: inline
In-Reply-To: <1312299219-9562-1-git-send-email-per.forlin@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--so9zsI5B81VjUb/o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 02, 2011 at 05:33:39PM +0200, Per Forlin wrote:
> From: Per Forlin <per.forlin@linaro.org>
>=20
> The dma driver requires both src and dst to be set.
> This fix is needed in order to run gadget mass storage.
> Patch is verified on snowball.
>=20
> Signed-off-by: Per Forlin <per.forlin@linaro.org>

applied, thanks

--=20
balbi

--so9zsI5B81VjUb/o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOSSTAAoJEAv8Txj19kN1v3QH/R1+FeW6ugWAWGL/NoGrogHQ
FcGhQlPalWFpx1Uxe7knoJhATnyxI7oATKOIRKDBo/B7rHsjettBD3Fqj04xJ6N3
cYF+TXDXa/WWakguIykofRJG9r5loR4yptN4pJCX1HlFR1B66NPk0bEMNYDBpuGY
QkUerpm7OeI1QixIabsK2PNyp1CmZilJiH5fn5VPG35MVMHftNJqzzhmSqBhJdFG
MSzgh5XbQRrA5a6TydEHgcpE+m1lQY05eooUreenHsXYIhjNvFyM3/S7xwVf69PA
AE+WVMbDeKZuK0aoGdozsNd2AFJoTlD/PKY7FwM7tUwuZNvO4Tw3s6eMg8qdRj4=
=gcFW
-----END PGP SIGNATURE-----

--so9zsI5B81VjUb/o--
