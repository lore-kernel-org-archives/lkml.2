Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab2DPJUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:20:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60046 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179Ab2DPJUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:20:44 -0400
Date: Mon, 16 Apr 2012 10:20:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC/RFT] regulator: core: Support setting
 suspend_[mode|voltage] if set_suspend_[en|dis]able is NULL
Message-ID: <20120416092038.GE3238@opensource.wolfsonmicro.com>
References: <1334366074.2694.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u5E4XgoOPWr4PD9E"
Content-Disposition: inline
In-Reply-To: <1334366074.2694.3.camel@phoenix>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u5E4XgoOPWr4PD9E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 14, 2012 at 09:14:34AM +0800, Axel Lin wrote:
> In current implementation, to support set_suspend_voltage and set_suspend_mode
> the regulator code needs the regulator driver to implement both
> set_suspend_enable and set_suspend_disable callbacks.

Applied, thanks.

--u5E4XgoOPWr4PD9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPi+RbAAoJEBus8iNuMP3dPtIP/3cIvUl2AeesjNZR+OF03T6Y
zV8cto5s/ZE6EIoamKtx6qTA14Bo9B/0AAQw2nUOtQmQBERcTd6XmTci7+Oc2Z+E
psqBRkwm7Gx4bR+CaEb4lROWMEYeMddm0ZM9z5rzM/El7V6sSfKC3qjsKDgEWnz0
Ph5MLozJzDrJBZKAhIjlEFV3s67/OGa8tZ90iG5KBM1hviaesBgqa3XoGIPtebRF
mPc0K/kY9sioTNeS9bDKZiKjZm3Yts669TQxvG/Fg3qx0z6tz2NqrUig9GFs5/On
u4ETFdDqFRi2Yyc1s6bCrddAtu7R+BXqo2tfbiayG70inJ32tG5DUc/Lseaf0xl3
6JeqHhjBopmmEtcYTvZpHIEfNUvMOdhjZDZEkDkIJWlWJCicEFdSlthQ/PUzAVIN
5arkydTF5RwlDGEcVUyGzvlenebGpYQ2QcbhQ1oj8MqhlSrWlgW/hBL+p4GqQ+oz
p6CtB1onWitsBXlBoQF7N79sb2qNIo4z+AqMmjiq5YVsF4VyIpEjENtARsi10GiJ
YnqseYKh+FMZ0FM3N8IMTmCgL7Z23vIG7y4dRktwmigV2xaGivEcHMT5kvOJsM9/
pcmk7YS0KmwL1B5swIPMHiB6k/0xP9A06YvV3DiO8LJPEnE3FJt5JzSfTxb54fIO
zxqWQMhm8AWdHqpxzWH0
=Zj6r
-----END PGP SIGNATURE-----

--u5E4XgoOPWr4PD9E--
