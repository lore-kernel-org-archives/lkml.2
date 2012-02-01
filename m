Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2BAKDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 05:03:39 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47708 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab2BAKDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 05:03:37 -0500
Date: Wed, 1 Feb 2012 11:03:27 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Barry Song <21cnbao@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Barry Song <Barry.Song@csr.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Erik Gilling <konkers@google.com>,
        linux-mtd@lists.infradead.org, Barry Song <Baohua.Song@csr.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH 1/3] platform: add common resource requesting and
 mapping helper
Message-ID: <20120201100327.GB2524@pengutronix.de>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
 <1328004002-24646-2-git-send-email-Barry.Song@csr.com>
 <20120131101734.GE2471@pengutronix.de>
 <CAGsJ_4wyJ6Wymy4AWoW1eHubZX=W7GT_Fbow9ofXoY1RrcHzgA@mail.gmail.com>
 <20120131113358.GM2471@pengutronix.de>
 <20120131203455.GG22611@ponder.secretlab.ca>
 <20120131211554.GA28105@pengutronix.de>
 <CAGsJ_4yJZYHUzr9YerdM5o8grGd6iP51ra4nJkMuOo5Khn95RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <CAGsJ_4yJZYHUzr9YerdM5o8grGd6iP51ra4nJkMuOo5Khn95RQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> i think it makes sense for us to have platform_devm_request_irq() and
> similar things. i'll take care.

I'll try, too. Then we can compare and learn from that.

> PS:  as the man maintaining embedded systems of the i2c subsystem,
> would you comment the CSR i2c driver which has been there waiting for
> a long time?
> http://www.spinics.net/lists/linux-i2c/msg07081.html

Relax, you sent that only two days ago.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8pDe8ACgkQD27XaX1/VRvw2gCdHZsoxHOENXRnF0AjptSIFbUy
3iMAn18Qzz8rSr8wgtknQgE4seaErJ4E
=4dBO
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
