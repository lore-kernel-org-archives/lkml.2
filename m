Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2FLKuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:50:07 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:44785 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092Ab2FLKuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:50:05 -0400
Date: Tue, 12 Jun 2012 13:48:05 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: tony@atomide.com, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, balbi@ti.com
Subject: Re: [RFC PATCH 0/3] usb: musb: add new phy driver
Message-ID: <20120612104803.GD10901@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1338388466-3565-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <1338388466-3565-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 30, 2012 at 08:04:23PM +0530, Kishon Vijay Abraham I wrote:
> This series adds a new usb2 phy driver. The device for which is created
> by the ocp2scp driver. This also uses control module driver.
>=20
> This series converts twl6030 as a comparator driver (previously it was
> also the phy driver) and makes use of omap-usb2 as the phy driver.
>=20
> Instead of notification mechanism by power chip to omap glue to pass dete=
ction
> of any events, an export API has been added in omap glue. Both twl4030 and
> twl6030 will call to this API to pass any event. (twl6030 is used in omap=
4 and
> twl4030 is used in omap3).
>=20
> This series depends on:
> *[RFC PATCH 00/11] OMAP System Control Module* patch series
> However System Control Module driver has only dt support, so wouldn't
> be able to test this patch series. However I'll adapt omap usb2 phy
> driver and musb driver for dt and send it asap to the list.
>=20
> This series also depends on:
> *[PATCH v3 0/3] usb: multi-phy support* patch series
> *[RFC PATCH 0/5] omap: add ocp2scp as a misc driver* patch series
>=20
> Compile tested only.

are we getting new version of this series ?

--=20
balbi

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1x5jAAoJEIaOsuA1yqREJYwP/RLKAKWYnGYoYz8E7Lggu0bt
RSbGzbXZKRwdcjBMXcfuC2mn5N6/Rt1sXql17FTs8xCKmEWlRk5HuMiCf11suP6u
V0EMo0xQXAjbg6J5avGW0il/hFEkGTuiwFo28dPuusfIAZF9dlfOdhhCgnvdpewD
LSUezklnSqW8MmgZzSZWPHtvXWxj5ueGsqjU7BbizFLp+CXzWAouTFQHVWC7BLeP
G6rUHaFCtoUN1pd/j8TEXolam0DhlzBtlBRr36701Cwgr6cmQtLReS4IjvAMyOig
yvd6RwHUnDXBN6swk4FizLOpAeg4+G6pxryH0z5Z0fYHAuPeAMNMdU9eWpGgFVOJ
/ZrYzgj2ByGfEFK8qm7aU27eC5UFxu9kWK191xFu59ZfpBV9YNbYC/sXp2InOm5u
kOe1WV02BNvN2xDDFi3WkdJdCfQ5zGgqLPq/iC5SqIkg31fNPNLNZ+VgNuDMecwL
eN65rJHj/0L5U0MHKtCNdCHAC5tL0cmO8vrUl1H+slJS+j+597A1upNkPeM+fJcn
THe0wgcPlYl4cyKc/vwGtWFBSSZjVhAUUAVgJli/XlpbI0EgccaeQPAB/Fz05wKG
xqF48q7K+LsL790ykYihVWs4v7fuPOvJNJHOUmryqZBuFrwkuQrh3Snykl15M7C+
/FhuubKggz0z0/YKw1sA
=aUcN
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
