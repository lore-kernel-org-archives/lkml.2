Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab2KNCFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:05:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56728 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932215Ab2KNCFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:05:22 -0500
Date: Wed, 14 Nov 2012 11:05:15 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, swarren@wwwdotorg.org
Subject: Re: [PATCH V2] spi: tegra: add spi driver for sflash controller
Message-ID: <20121114020514.GI4415@opensource.wolfsonmicro.com>
References: <1352852687-25514-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nO3oAMapP4dBpMZi"
Content-Disposition: inline
In-Reply-To: <1352852687-25514-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nO3oAMapP4dBpMZi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 05:54:47AM +0530, Laxman Dewangan wrote:
> NVIDIA's Tegra20 have the SPI (SFLASH) controller to
> interface with spi flash device which is used for system
> boot. Add the spi driver for this controller.

Applied, thanks.

--nO3oAMapP4dBpMZi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQovxMAAoJELSic+t+oim9XCAP/iXVSbJxuOlG5825N81Wl6X9
Cs+c+AMo29Mf9KSneRo6T7PvS0ly+dnjM652rJM1Tn0LVdABuV51CgNhe1xcWAmo
3O7gpKIam0fQmeokkEJIKv7CLw49pOzCmS7gbeXucZLUQDRqp+xSxwlFOvnkrNv0
Ny8AF9w95jgyRycMTb8wDuJOaBE5ZzFR6vmxP6DRS+bqYDXKWgoZaEjgR9XiUJKe
QZib5X2pHReqxRw4Etu9PYaI2ISHMCJMLffYWrOISvG/k1XGZyNwbIe0GQp9GjFO
JXYUiTFFx4/UE70su5apdVsQ5VkLzgpEqacukRpUV8L62aWs9fquslwIPrfzkNrQ
IlJj6CVntmpY2NPBpR4SgusYSEp3Za2fqPUkKhB/mTokhSA2gvT+ZNY09DH3ybsW
1jWSTzYFLkLGpeoqeELzlQes8rlUw7B9mDSRK3fDhQAJjH5V3v2Ofhyqlx3C+hQp
XUgN6WuNrvLbZhF6vbfiPuIYFZc3sNe+sv5xVj/ICl4qAS+mw1pV8oCPNXx9+r13
xBh94BgLdjx4Rq0/dl3Pplv0Tm+hUfFfBJqVjD/RXJaeYKCjfIsxxkwnp7iuumaD
yNaI/uCnfNnzgtl7WuWrIif4q6yvTM1l7UAlsd8GWtrNzCNG3fne0rOxdSRpX/gS
gpWvkBcQoQBsItwU8WMA
=Orq+
-----END PGP SIGNATURE-----

--nO3oAMapP4dBpMZi--
