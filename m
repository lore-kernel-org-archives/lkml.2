Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2EULRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 07:17:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41590 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107Ab2EULRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 07:17:38 -0400
Date: Mon, 21 May 2012 12:17:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC/RFT 3/7] regulator: ab8500: Use
 regulator_list_voltage_table()
Message-ID: <20120521111734.GC4983@opensource.wolfsonmicro.com>
References: <1337481021.7204.1.camel@phoenix>
 <1337481215.7204.4.camel@phoenix>
 <CACRpkda7BdaJsDdfaWXW466Yi687EAms5MAmZySVQ_xrAZNoXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oTHb8nViIGeoXxdp"
Content-Disposition: inline
In-Reply-To: <CACRpkda7BdaJsDdfaWXW466Yi687EAms5MAmZySVQ_xrAZNoXA@mail.gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 21, 2012 at 12:43:16PM +0200, Linus Walleij wrote:

> Acked-by: Linus Walleij <linus.walleij@linaro.org>

> Hm, probably also already applied, whatever.

It was but it's not made 3.5 so I'll add your ack - review for the
ab8500 has been a bit patchy so I have been tending to apply things
fairly quickly rather than waiting.

--oTHb8nViIGeoXxdp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuiRDAAoJEBus8iNuMP3dRxkP+wWpjlOSLJj9fILUFb86ybW2
9KvBTjV4fU8P/64OMXVkReJwpvfZgDUMDY2MnfAK2CuyoIiH0QoTyU0erU6YBNJY
Kj4iPWzgWCVba0DUGmdaFiQiExgaD0ew84S14VeG5GhjCMrKdb2o69VuhKV1Zext
INU16A1zQytiqDL067ZR+GJ9IE2wxu6u5wTyN/7gI+aLbgyAdgyCc9HY3nFOulis
tVS6dlPqea2lv3/olMfuPMWMscfGkY2J2RGc5eeN89+bH3RxL6qaD8VxqKfiR+9j
/BnHJq2KvlbudVb1u5UnYyh5tatynFVr4FnvsW/R+2py0L41jR6V9xWjHfLeznSH
1JmFJ0Yzg+eMy9uoGVP3XiSDtukwd58ajz2DPOaBwjT2E9eFALHVdBzr+md/NWN+
eJKwiSsvnP/UoFqZh27aTzNQUJYX52jFTOaaQ2l8KscnhWK73MVMvrAgTQ0HMAx8
Mo2Pv60DAXbWaUT4hu4ieGMdFhiv7Kp2LTu/fkZMcNh17CWoaw0+lOzYS2p0ToO0
AbU4crEU6cNrMiPoVTxqxD6s5iB9QrVgwz8TnwmhwoXuM8eyeLqAPsAOq6xTVy/H
vf7jutBXDZmvggsrZo++JnAlUDhFisXq0OEFVDcvogRl8VVrY9KV9pNJL6Bp5Lzy
8gJtE12SyeK7hTAj+pnn
=ht4V
-----END PGP SIGNATURE-----

--oTHb8nViIGeoXxdp--
