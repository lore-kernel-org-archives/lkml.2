Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1HCNbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 09:31:48 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:50764 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752956Ab1HCNbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 09:31:42 -0400
Date: Wed, 3 Aug 2011 16:31:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: Per Forlin <per.forlin@stericsson.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        users@igloocommunity.org, Per Forlin <per.forlin@linaro.org>
Subject: Re: [PATCH] usb: musb: ux500: set dma config for both src and dst
Message-ID: <20110803133138.GO11080@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1312299219-9562-1-git-send-email-per.forlin@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ga5bsqHr1s/xcZEm"
Content-Disposition: inline
In-Reply-To: <1312299219-9562-1-git-send-email-per.forlin@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ga5bsqHr1s/xcZEm
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

should this go for stable too ??

--=20
balbi

--ga5bsqHr1s/xcZEm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOU26AAoJEAv8Txj19kN1fsAH/R+Y08GI7xOmWfHctMbDVwXB
pqofjg2dTyYGTJZtaHFmdm+lyFHp0t1yyEVT+kQ+nKyxsj27u6zqfsodetGtxZUx
FfhHM8MnJ2ogXeGsZfbOcBeRdlpr/sLhRIk4crzB6RpBBdnlA/yT1Gy1mfbmOtWB
X/lseFIVOSIXu4qdmWqPPcnX3MLiWNJ0yjmNz00V493S8YWcdlqdjlLmi2sfyOUa
cl8GFmgR6su7qJYck3iF5qAS9uEhACYCLkrk6Cfdc+9e/TXjxjVJmym2X7nhhXEE
QDCDFihe72AzR5ZWJa/D1HGM5hsUdGHtAMj03MZuSzTHvAxtTdWMD1Rlv3RyEnQ=
=t1N4
-----END PGP SIGNATURE-----

--ga5bsqHr1s/xcZEm--
