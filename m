Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab2KVVEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:04:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53816 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab2KVVEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:04:13 -0500
Date: Thu, 22 Nov 2012 22:03:47 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v4 06/11] pwm: pwm-tiehrpwm: Add device-tree binding
 support for EHRPWM driver
Message-ID: <20121122210347.GD16716@avionic-0098.adnet.avionic-design.de>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-7-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
Content-Disposition: inline
In-Reply-To: <1353503469-18634-7-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3vTi74oqdK/gqZUe7kbFobo2rgNzq5Byc2OfOETRB19
 q032stmOYFaeTeCQZMcAc1bIgLDSIalimf6MVf8uO/jx4KCZuw
 9bcuV5c2gcUnGSV33c5hIA0hCKR0hhIBiAhVm4ZcxsY4xIxp9N
 AkVgvpKsmNYu4XdDm5uJuRJF64JiFWjpHNL4yXNhQE6eETKJeu
 G44ieffgNIcmdwh+w5a+ae+/MNw6gQjqSdMe5l+nT+qpxSBIBc
 dHiHkhIeq5hrYrtZWwrVBExxsgtfUF8wV/PwCujPen+reL1YyE
 NNhEKoQXbjAdsSv2w4udVFaXk0ATAeluugf3rCOyo4lALePiiZ
 2ddKzuiIZI/VRyV/e/gGph+XMHrBOxtkB9pKhJUz1h3YmV5Z6x
 1ADCvmlO5Cz1WyCGqkKzh/YLuEX6PUV3hGr/TZhP4bv9Zkuns/
 HDA4z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 21, 2012 at 06:41:03PM +0530, Philip, Avinash wrote:
[...]
> +static const struct of_device_id ehrpwm_of_match[] = {
> +	{
> +		.compatible	= "ti,am33xx-ehrpwm",
> +	},

Same comment as for patch 4.

> @@ -437,16 +451,41 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
>  		return ret;
>  	}
> -

I think this blank line actually improves readability so it can stay in.

Thierry

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQrpMzAAoJEN0jrNd/PrOhl3oP/2Jx3yD88Exbso/HABJVePgr
nGF9Jfft8ZAUDlDXMbbLmoB/SHD6EgqwiMoDXqlbTnzDaJJK57TX175k1rdUZuYV
aiJhdD6P2E+ED1t0l9OBwBZ3xGnfW7kMlg7ERySvEMyH/tsvAt1IskbfeDkrEKUu
n6uTlG0xxdMZyHYgIMP8xAAHjKTni0O/yh4Hi6FX4DEcEJ0W2bKa4tcTEBG/bmav
lKRvOxwR0uCro5I+wLabtDgFOwEeZ8PoK6wOrw53CsLE//t46n1oev/yD4l1E9//
/g0S42M2UTJ1jzCP2UrZJedIlUiEsS8A7iArylKHEWQvBgT9AhqmuHeQtHxGvrBW
1ehFGIE/D8nUCtauetVCnqq9xjmEautHyHVLP4xTkxVzgCfboT6+IcKt1ThUecgv
DH/BXGtpwcpUg50h4IPvGyYac85GY1F3ldsBu4U+8fQmYauskn6OUzIpKdIa4GRm
t8XQa3ed5O+Te/ed5kAIh1JXd73yfGDAV2hQhTbo9L5XyRMFRcKhJw31HUkIHJwx
2QpXQo0GyNHZfMd8aznDvdsMA5nZi0pBa34CfjAhbUMSs23+4EltsSL1svVgMXeK
w9VT46ZcSZWdz5s/AvBrq2eGGWbWXPVqvC+NeVFkIKJugIIOThm5U6uFFEeAe3bH
iJLrZc+Xrjc6F7JzXqia
=u8/p
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
