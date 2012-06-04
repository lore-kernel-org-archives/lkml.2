Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2FDSFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:05:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44607 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754248Ab2FDSFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:05:24 -0400
Date: Mon, 4 Jun 2012 19:05:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] gpiolib: wm8994: Use irq_domain mappings for gpios
Message-ID: <20120604180521.GC23408@opensource.wolfsonmicro.com>
References: <1338727219-24141-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdZJPH__FzsUmKnQhTOtJ1EstJ8K5LzhTXGUO_VSzrjLew@mail.gmail.com>
 <20120604113017.585830e5@tpl.lwn.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Content-Disposition: inline
In-Reply-To: <20120604113017.585830e5@tpl.lwn.net>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 04, 2012 at 11:30:17AM -0600, Jonathan Corbet wrote:

> That's actually on my list of things to do (by way of LWN, of course).
> I just need to get my hands dirty first, probably by converting the
> ov7670 driver.  Unfortunately, I have some serious distractions in my
> life at the moment, so I can't make any promises as to when this will
> happen...

Actually I was thinking about mailing you about a LWN article at some
point but that'd be a different (more tutorialish) thing to what it
seemed like Linus was asking for.

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzPjOAAoJEBus8iNuMP3djY4P/0t+Ji7K3XEpk6K459EwiD1/
pQGCt+zR19zu1eocIJdnZSaKf3WeYRVWuODuqz3FjmFx1JoHsJ1XmdhsAcJeEQvo
5IPa0Mm7YVVtVE/WDHbycSkHcfG/14fE6D+3atUOTngxvsQb0o/QFBalbPnYjK43
qzPx1M8WM9VZspJpPHkBBDvZIpMeFJYWKR/8Y4B6fllSIhgR10lo48AuUEfQiwGu
Qs8gwQ+K68tKObmVgFA5d+ILz7nPHSc/agp+T7OZr3DDZ9miB4mgwbJx3/j9olnw
0ZvdeDmI9bGrfOfjcvXytL57YgZ83SD7VccjjVYoBhNnhhXBJ6CHr1ccz1O+p+hN
u8VeGE9bpuOwsK8Ardi0scb7XI1ENXr0Bldi+OobDP1uYJXOYkyl1UvsR5qtru7+
eRJkwq1wwSH1X3cU6tZP+HsTG/svGnayuJuMLCYmfMfBlQaRBEQxxdM3C42dqEKw
JHe2gq+m+4YARmyFo38bN1CjA/HorLVrfRQrQIKFU3/M/SO6UYrHOT5na0GD4ckx
xqWgW/HWqlPaIaJcUgeldmGVdYzznruAQn1ShUYrkyFLnJXKvRIe/rhtKwT17bBH
nc5WADpITxT5sF0rNw2TktGJwfrZBEn3k8wsc0STJ/XyBxQ/+8m9eA5kFmE+WRj6
YNhw7l7+r83Le9rMrxGK
=fkx8
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
