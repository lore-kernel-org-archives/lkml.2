Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab2CLKuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:50:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43072 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556Ab2CLKuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:50:14 -0400
Date: Mon, 12 Mar 2012 10:50:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Use DIV_ROUND_CLOSEST in
 wm8350_isink_get_current
Message-ID: <20120312105011.GB3110@opensource.wolfsonmicro.com>
References: <1331518676.2558.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <1331518676.2558.5.camel@phoenix>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 12, 2012 at 10:17:56AM +0800, Axel Lin wrote:
> DIV_ROUND_CLOSEST performs the computation (x + d/2)/d with better readability.

Applied, thanks.

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPXdTWAAoJEBus8iNuMP3dh9MP/AhhKE9RQRn+ATC3K4LUuZ/i
dPUvrDecn+RO1EJod6QACYMiri1wyc5a8M/NpTxm43JHIDlbJBndI4nrt+c2aK9A
4xNuBSa0lFekDrA/RTb6q7Ue4+jG57SBp2Han7B0td7Q7q0lxKWdczJYOG++OBDz
1y0nOd/JMUzYe7nW9wFJ2gYG2CazlhppwrZ4iaXgvoQ2gDIdp4YcPGsHjLiiFovU
Ul4Sr0a8SsshEetEx5bjPO4bNE7JT3v65Wx2+P3QvIXLDzH8ADRNDSmWZVUQlYGW
/C5XMmmdZ4wyCChs6dBzqeX5lWgWN5Rh+ZDr2O3RoVvU5+/2pr6SM2halZLyQ984
RCwaegaT6ezWDn88h4uNiQ0WBoK/aLGtOczk1y3yF01j5L7Qp6YHm/HUf1dqtDQ1
wLEgwB7Gf48eKzEKXyZJ5pXHxIOUXFP66YWEmHYQKloOi20U2aC/vfoANpZmMBfu
n1rm3lx4lPsug32YEgOOJ4povvnxclW7BWgEUTB9re9onthvNMs2if9i03T19Q6Y
IqzonMRbBzeSjXCyts2VmBaSXPZWDVuaH0o+ZREYSZB3M4ps2JI514HQE2tvxU9e
b5pQGz4vLhH0TKzlq0Q0MsnU4VAPHE+YH9X4p96gq5kWBh8+S6e/6itCxyLiT21y
lpglBkbcNrhafYCDMIlX
=0jQz
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
