Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2E3Ql4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 12:41:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50086 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708Ab2E3Qlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 12:41:55 -0400
Date: Wed, 30 May 2012 17:41:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
Message-ID: <20120530164152.GP9947@opensource.wolfsonmicro.com>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
 <1338353260-10097-9-git-send-email-lee.jones@linaro.org>
 <CACRpkdbQv8Q07iRAmG3UQRm7UNDi_Y+s_vvACDKKxR9tg+1iqg@mail.gmail.com>
 <20120530100302.GD9947@opensource.wolfsonmicro.com>
 <CAF2Aj3gZMF9ev9B46rBM+aY-srwthef09ad2CWfuXXFHmqqAjA@mail.gmail.com>
 <20120530121547.GJ9947@opensource.wolfsonmicro.com>
 <4FC63632.4030504@linaro.org>
 <20120530151119.GN9947@opensource.wolfsonmicro.com>
 <4FC63B39.6040905@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H83aLI5Lttn3Hg7B"
Content-Disposition: inline
In-Reply-To: <4FC63B39.6040905@linaro.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H83aLI5Lttn3Hg7B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 30, 2012 at 11:22:33PM +0800, Lee Jones wrote:
> On 30/05/12 23:11, Mark Brown wrote:

> >>	vin-supply =<&db8500_vape_reg>;
> >>	vmmc-supply =<&ab8500_ldo_aux2_reg>;

> >Oh, oops.  This is going to be fun when someone puts down two of the
> >same PMIC on a system...

> What does that mean sorry?

Lots of regulators are using this mechanism for identifying child nodes.
If the node name is also used as a handle by other things to reference
the regulator then if you have two PMICs of the same type DTC isn't
going to be able to figure out which node you mean.

--H83aLI5Lttn3Hg7B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPxk2sAAoJEBus8iNuMP3dVE4P+gPJAjvEzk/a5f1mQOiym7l8
Lrr21C8QC1H8VkI72pEofHTF+ZGj8cx8+CcQabtHtrk1III7Y4Y8PUCn+5Z9BH16
EVL/Jx5E7ocw208qr8UBEIudtjVpwG2cJt3Q59jMq3Pxwsl31dKMN9XDaNhefnMA
3yM+4pFFrI/vSXnjHk4JLz/LJ+jR9kfTRSAOEMRTtxhvaE3dh+aNbRBonGuNWen5
9LNVcWGM0S6WUinVxGDFSKkFemVPgOzPljKE6B4FR+IxVAtyDt+onGZkfCFJz4GC
Pf1MQNoK2mOPcdBY2uyVbaNkWC7SUaeCBXi80brpILCaWpW9b+26gmi2DOn2pBsh
0FfZTbsQuY6smgyvqQeYNg8F1RrRuNt097him7YOA+KLV2p17dYo3x1gk+Jzwhve
VDWzA+zK4+8sVSykasJpTw7lb30kyTO+dLfyuXZsFgSF7rSHOoJJf9y71E79o9RJ
/Nqj5CpiXf931RCshX3Aiuj2HRlTPe+6QaAWUMhzVq6vy3W1ZJWGQyDVEPVg4oh5
/sGLwjMpsdPN3Q2nQLR6XuxnEXA0AlMEmO3+f0IYPnuMh4xxzdB9wyZmT1iV+kqC
qVLu0dxunqQDZflbRPM6YCiJF3Qyq/BS/fBqykrTrzhdCHtEO1naHA11J/uy0E3M
7Y50++ULv/dB2gHn1e97
=ohW9
-----END PGP SIGNATURE-----

--H83aLI5Lttn3Hg7B--
