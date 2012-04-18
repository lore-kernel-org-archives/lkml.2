Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab2DRKdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:33:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49658 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2DRKdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:33:37 -0400
Date: Wed, 18 Apr 2012 12:33:34 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Li Yang-R58472 <r58472@freescale.com>
Cc: Zhao Chenhui-B35336 <B35336@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-mpc: avoid I2C abnormal after resuming from deep
 sleep
Message-ID: <20120418103334.GD2232@pengutronix.de>
References: <1330511961-22498-1-git-send-email-chenhui.zhao@freescale.com>
 <20120229183436.GA30545@pengutronix.de>
 <20120417142105.GA21802@pengutronix.de>
 <94F013E7935FF44C83EBE7784D62AD3F092D1DC7@039-SN2MPN1-022.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
In-Reply-To: <94F013E7935FF44C83EBE7784D62AD3F092D1DC7@039-SN2MPN1-022.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> We certainly don't want the policy to be against the common practice
> of the community.  If it is we can consider changing our policy.

Nice, thanks for being open to discussion!

> However I can't find a clear message stating the consensus of what the
> Linux kernel community think of adding copyright claims.  I even found

Well, what I know, the consensus is "common sense". What is obviously
not "clear" in a way you could write it down. At least, Ben agrees.

> some message that encourage adding copyright to maintain the GPL
> license.

I am interested. Do you have a link?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+OmH4ACgkQD27XaX1/VRubswCfWX0Qu6/PjR7yzGUDfHwBiw05
DAgAoLlVGb8xLugS8oGhajd5dFYBn2jO
=eGmZ
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
