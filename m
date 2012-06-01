Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab2FAO2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:28:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37148 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932185Ab2FAO2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:28:54 -0400
Date: Fri, 1 Jun 2012 15:28:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] regulator: MAX77686: Add Maxim 77686 regulator driver
Message-ID: <20120601142852.GR24139@opensource.wolfsonmicro.com>
References: <1338524234-12165-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fu8LepSeDvpxVgv6"
Content-Disposition: inline
In-Reply-To: <1338524234-12165-1-git-send-email-jonghwa3.lee@samsung.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fu8LepSeDvpxVgv6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 01, 2012 at 01:17:14PM +0900, Jonghwa Lee wrote:
> Add driver for support max77686 regulator.
> MAX77686 provides LDOs[1~26] and BUCKs[1~9]. It support to set or get the
> volatege of regulator on max77686 chip with using regmap.

Applied, thanks,

--fu8LepSeDvpxVgv6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPyNGcAAoJEBus8iNuMP3dnq0QAIy5HWY8Y9wS9M5LKXD8Drdg
TIwwM3/xj1Hyutc1a46jxI1jMHiB/RM5gGa2MWqT8mP8A2PuqLbCCn5YGp2XKKKe
BPetF6beT8bGvbnUtRDwJvCk014oYflBgNA6OqFOZiKHLbxv1wpaO5VPrrX2Syxe
jiQwtp7Eq4hN4uA2DkcVK4snptmTF824+CpYuqp9QnOEiVx2xudMk1xY8UmadpI6
Ts5uES6dzPsNFlhiwC2YB88hHG/Zu5zKUJ/WDzHGMrikRCH5uv3JWROaOK/gTf6e
RoWvzMRvzzRotb4IxwGyWHnPtoo/HQnPTPBEKBbEZ28OrPdXS/Yf/xRalSJL210b
Tvgzmfpvd8pbol/wySQSlIsKwpvhOAY7sRbedI3QXCDt/JqX4oiXhV1IPKlWqpAy
6Ls6kGn9D9AqD99yZdswdaqelnjwcig6gcmIHp7EoAH7nDmTBhQrRoL8aqZby0om
QXOLRdqM8CvSAwrhS5swvg+HUSws7aups348eIouGpl4jhnS5ciUmQKSAM6j5oVb
qKdwK1IOIfk3AwOt29KthMjya3Ejp4k9MXWl3FGLRI0a9WEKK5XtTAgTe5aq1wjw
EUanqRUIMaijhMwq15cI525MJ5i6swouKfFkWr34hLNvJJvsfWESG1tBkFavHvtM
R8BIZo0/vRLnkbL6ncE9
=eZal
-----END PGP SIGNATURE-----

--fu8LepSeDvpxVgv6--
