Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2A3Nm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:42:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39657 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601Ab2A3Nm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:42:26 -0500
Date: Mon, 30 Jan 2012 13:42:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Regulator update for 3.3
Message-ID: <20120130134223.GG4882@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jt0yj30bxbg11sci"
Content-Disposition: inline
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jt0yj30bxbg11sci
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-linus

for you to fetch changes up to 8a093049c604ab32d94bcc5baa24f7939d5e3f7b:

  regulator: Set apply_uV only when min and max voltages are defined (2012-01-26 11:01:21 +0000)

----------------------------------------------------------------
This fixes an integration issue with the regulator device tree bindings
which shook out in -rc.  The bindings were overly enthusiatic when
deciding to set a voltage on a regulator and would try to set zero volts
on an unconfigured regulator which isn't supported.
----------------------------------------------------------------

Karol Lewandowski (1):
      regulator: Set apply_uV only when min and max voltages are defined

 drivers/regulator/of_regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

--jt0yj30bxbg11sci
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJp43AAoJEBus8iNuMP3dWGAP/jPyfYsj2sAlZnHaQigao7EK
DCmAMlwl7MRDi4TsamHhGDKRrp98hXSw2h0vL5b6M4pgXm3riRuNr1o7G0UhbQoY
252nMlpL/2XFHk2GzNSFYPM1+0gerp77PtJ4Jtzio/NsQg2ZmMAF899ceGVc0jU6
uWduye9JU4g6dhVlVwP5qlFrK33pZQFtAaFW+j7BqKmGmoz3ePdwQOozNU+8V0h5
KbYAeVeoHBgeqKJjdoxUGAUGEFk/WEvWh0wcBCym1FKQpUlJ7WYWYrbuAtavCsRm
jIlQifgByoA+X0Fo/MhQPY9+iOxVFe1LaXOjgF1PBogUPSwM15U1oWdInLOxYfeu
8vf7Be/m+wXAZ8JFeOXs7Yf1hZNuH45/7Ua9mNx+IF7/mxhTqNuSuNL1QBWu7bVB
9Yl9hvQ+gSFV4FmL0T/QP75uvh/KrX2BJgGhnwDDx8YHUmgxlpQfNP5gbbst89+3
w7iLQ2idQxo8TUDzx+dSGvFiCZFaLgwuaSxmULsQLlAyj3knyihXh1HaJ6xoMh+5
i8A1uuU684x9Niwu63BO2Eqpsajuyf07CFZ9XxNBFCSnhYhepvAPO0cs5NRxzLUC
t0NG24fazNJx7fJ1ewLG0vaFvkRoneHTfX1LNItYeGZTixzX6SMcuDWZRHOtdJni
xUUlJho3BzZT5HzfUGQK
=juGP
-----END PGP SIGNATURE-----

--jt0yj30bxbg11sci--
