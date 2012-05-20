Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2ETPuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 11:50:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50213 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451Ab2ETPun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 11:50:43 -0400
Date: Sun, 20 May 2012 16:50:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Oritz <sameo@linux.intel.com>, Liam Girdwood <trg@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>
Subject: Re: [PATCH 1/3] mfd: MAX77686: Add Maxim 77686 mfd driver
Message-ID: <20120520155039.GA9337@opensource.wolfsonmicro.com>
References: <1337333539-18371-1-git-send-email-jonghwa3.lee@samsung.com>
 <1337333539-18371-2-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <1337333539-18371-2-git-send-email-jonghwa3.lee@samsung.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 18, 2012 at 06:32:17PM +0900, Jonghwa Lee wrote:
> This patch is device driver for MAX77686 chip.
> MAX77686 is PMIC and includes regulator and rtc on it.
> This driver is core of MAX77686 chip, so provides common support for accessing
> on-chip devices. It uses irq_domain to manage irq and regmap to read/write data
> to its register with i2c bus.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

I think I prefer this to the other version of the core driver, if only
because it's smaller.

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuRLIAAoJEBus8iNuMP3d+G4P/jKC0jr6VnQ5FCtVLXvLhTkU
Y/+LbQNivPGPUWEdG/ULYVCo0lVXtQhgMwPgpq5v6QM3j2ND90i4+9V6heugHsV8
gAUuBdiwbiiulV4agrqiCk3wLKfRC/iRKHd85i76BsdKgvM+PKovmVGNZswp45BQ
XMG+SaWsQune4PgvWfSyBpCP/MfcjhL4+LQ9233yWlgG4oHu9kSXuCgQygxIEiWT
TXANqEM6lzT8qNbSr83k+Mre52O1ATrsV5FOJRdNqfONPCV86nu0Qp0fsaOOE8P9
HJQHWDANuw/VVD2ftJKaOPy8HrjPfXLckFKEB97zeDQt/2LFEuxSPcz/bDuk8Oh1
t8chDHdIaBM/u3RfLy5oDUBW3XEiCaefXgp9LHezCTypzM4n69+zK+Fiw607REQ5
4kJM2vgNxz0BgkKc7uqh8B7TSmGSE7ayyvTScB6180fEFrAikIBujps7RAgObIdg
O77KYuonjY1bn5tuMyEbY9JibgkalTQ0eVndp8L5gy2/CKUvfxQiuxnNB3YAhODe
rftb57dSrcZoc+fipNZNmUTB9vl1uzUnRukUgcguVEl10ZwfeBRnI4OJkS7e5Ppg
tfZOYIJ5VhGCPYF6utvRnJIl3Pwmhuq1SStTcd2566AKN/wSebywxzMdD4URznkk
Q42xjgcJ1I7g/xq19l0T
=/8L4
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
